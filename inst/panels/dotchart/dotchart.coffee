# dotchart: reuseable dot plot (like a scatter plot where one dimension is categorical)

dotchart = () ->
  width = 400
  height = 500
  margin = {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = 20
  xcategories = null
  xcatlabels = null
  xjitter = null
  yNA = {handle:true, force:false, width:15, gap:10}
  ylim = null
  nyticks = 5
  yticks = null
  rectcolor = d3.rgb(230, 230, 230)
  pointcolor = "slateblue"
  pointstroke = "black"
  pointsize = 3 # default = no visible points at markers
  title = ""
  xlab = "Group"
  ylab = "Response"
  xscale = d3.scale.ordinal()
  yscale = d3.scale.linear()
  xvar = 0
  yvar = 1
  pointsSelect = null
  dataByInd = true

  ## the main function
  chart = (selection) ->
    selection.each (data) ->

      # grab indID if it's there
      indID = data?.indID ? null

      if dataByInd
        x = data.map (d) -> d[xvar]
        y = data.map (d) -> d[yvar]
      else # reorganize data
        x = data[xvar]
        y = data[yvar]
        data = ([x[i],y[i]] for i of x)

      # if no indID, create a vector of them
      indID = indID ? [1..x.length].map (d) -> "ind #{d}"

      # if all y not null
      yNA.handle = false if y.every (v) -> (v?) and !yNA.force
      if yNA.handle
        panelheight = height - (yNA.width + yNA.gap)
      else
        panelheight = height

      xcategories = xcategories ? unique(x)
      xcatlabels = xcatlabels ? xcategories
      throw "xcatlabels.length != xcategories.length" if xcatlabels.length != xcategories.length

      ylim = ylim ? [d3.min(y), d3.max(y)]

      # I'll replace missing values something smaller than what's observed
      na_value = d3.min(y) - 100

      # Select the svg element, if it exists.
      svg = d3.select(this).selectAll("svg").data([data])

      # Otherwise, create the skeletal chart.
      gEnter = svg.enter().append("svg").append("g")

      # Update the outer dimensions.
      svg.attr("width", width+margin.left+margin.right)
         .attr("height", height+margin.top+margin.bottom);

      g = svg.select("g")

      # box
      g.append("rect")
       .attr("x", margin.left)
       .attr("y", margin.top)
       .attr("height", panelheight)
       .attr("width", width)
       .attr("fill", rectcolor)
       .attr("stroke", "none")
      if yNA.handle
        g.append("rect")
         .attr("x", margin.left)
         .attr("y", margin.top+height-yNA.width)
         .attr("height", yNA.width)
         .attr("width", width)
         .attr("fill", rectcolor)
         .attr("stroke", "none")

      # simple scales (ignore NA business)
      xrange = [margin.left+margin.inner, margin.left+width-margin.inner]
      xscale.domain(xcategories).rangePoints(xrange, 1)
  
      # jitter x-axis
      if xjitter == null
        w = (xrange[1]-xrange[0])/xcategories.length
        xjitter = ((Math.random()-0.5)*w*0.2 for v in d3.range(x.length))
      else
        xjitter = [xjitter] if typeof(xjitter) == 'number'
        xjitter = (xjitter[0] for v in d3.range(x.length)) if xjitter.length == 1
        
      if xjitter.length != x.length
        throw "xjitter.length != x.length"

      yrange = [margin.top+panelheight-margin.inner, margin.top+margin.inner]
      yscale.domain(ylim).range(yrange)
      ys = d3.scale.linear().domain(ylim).range(yrange)

      # "polylinear" scales to handle missing values
      if yNA.handle
        yscale.domain([na_value].concat ylim)
              .range([height+margin.top-yNA.width/2].concat yrange)
        y = y.map (e) -> if e? then e else na_value

      # if yticks not provided, use nyticks to choose pretty ones
      yticks = ys.ticks(nyticks) if !(yticks?)

      # title
      titlegrp = g.append("g").attr("class", "title")
       .append("text")
       .attr("x", margin.left + width/2)
       .attr("y", margin.top - titlepos)
       .text(title)

      # x-axis
      xaxis = g.append("g").attr("class", "x axis")
      xaxis.selectAll("empty")
           .data(xcategories)
           .enter()
           .append("line")
           .attr("x1", (d) -> xscale(d))
           .attr("x2", (d) -> xscale(d))
           .attr("y1", margin.top)
           .attr("y2", margin.top+height)
           .attr("class", "x axis grid") 
      xaxis.selectAll("empty")
           .data(xcategories)
           .enter()
           .append("text")
           .attr("x", (d) -> xscale(d))
           .attr("y", margin.top+height+axispos.xlabel)
           .text((d,i) -> xcatlabels[i])
      xaxis.append("text").attr("class", "title")
           .attr("x", margin.left+width/2)
           .attr("y", margin.top+height+axispos.xtitle)
           .text(xlab)

      # y-axis
      yaxis = g.append("g").attr("class", "y axis")
      yaxis.selectAll("empty")
           .data(yticks)
           .enter()
           .append("line")
           .attr("y1", (d) -> yscale(d))
           .attr("y2", (d) -> yscale(d))
           .attr("x1", margin.left)
           .attr("x2", margin.left+width)
           .attr("class", "y axis grid") 
      yaxis.selectAll("empty")
           .data(yticks)
           .enter()
           .append("text")
           .attr("y", (d) -> yscale(d))
           .attr("x", margin.left-axispos.ylabel)
           .text((d) -> formatAxis(yticks)(d))
      yaxis.append("text").attr("class", "title")
           .attr("y", margin.top+height/2)
           .attr("x", margin.left-axispos.ytitle)
           .text(ylab)
           .attr("transform", "rotate(270,#{margin.left-axispos.ytitle},#{margin.top+height/2})")
      if yNA.handle
        yaxis.append("text")
            .attr("x", margin.left-axispos.ylabel)
            .attr("y", margin.top+height-yNA.width/2)
            .text("N/A")

      indtip = d3.tip()
                 .attr('class', 'd3-tip')
                 .html((d,i) -> indID[i])
                 .direction('e')
                 .offset([0,10])
      svg.call(indtip)

      points = g.append("g").attr("id", "points")
      pointsSelect =
        points.selectAll("empty")
              .data(data)
              .enter()
              .append("circle")
              .attr("cx", (d,i) -> xscale(x[i])+xjitter[i])
              .attr("cy", (d,i) -> yscale(y[i]))
              .attr("class", (d,i) -> "pt#{i}")
              .attr("r", pointsize)
              .attr("fill", pointcolor)
              .attr("stroke", pointstroke)
              .attr("stroke-width", "1")
              .attr("opacity", (d,i) ->
                   return 1 if (y[i]? or yNA.handle) and x[i] in xcategories
                   return 0)
              .on("mouseover.tip", indtip.show)
              .on("mouseout.tip", indtip.hide)

      # box
      g.append("rect")
             .attr("x", margin.left)
             .attr("y", margin.top)
             .attr("height", panelheight)
             .attr("width", width)
             .attr("fill", "none")
             .attr("stroke", "black")
             .attr("stroke-width", "none")
      if yNA.handle
        g.append("rect")
         .attr("x", margin.left)
         .attr("y", margin.top+height-yNA.width)
         .attr("height", yNA.width)
         .attr("width", width)
         .attr("fill", "none")
         .attr("stroke", "black")
         .attr("stroke-width", "none")

  ## configuration parameters
  chart.width = (value) ->
    return width if !arguments.length
    width = value
    chart

  chart.height = (value) ->
    return height if !arguments.length
    height = value
    chart

  chart.margin = (value) ->
    return margin if !arguments.length
    margin = value
    chart

  chart.axispos = (value) ->
    return axispos if !arguments.length
    axispos = value
    chart

  chart.titlepos = (value) ->
    return titlepos if !arguments.length
    titlepos
    chart

  chart.xcategories = (value) ->
    return xcategories if !arguments.length
    xcategories = value
    chart

  chart.xcatlabels = (value) ->
    return xcatlabels if !arguments.length
    xcatlabels = value
    chart

  chart.xjitter = (value) ->
    return xjitter if !arguments.length
    xjitter = value
    chart

  chart.ylim = (value) ->
    return ylim if !arguments.length
    ylim = value
    chart

  chart.nyticks = (value) ->
    return nyticks if !arguments.length
    nyticks = value
    chart

  chart.yticks = (value) ->
    return yticks if !arguments.length
    yticks = value
    chart

  chart.rectcolor = (value) ->
    return rectcolor if !arguments.length
    rectcolor = value
    chart

  chart.pointcolor = (value) ->
    return pointcolor if !arguments.length
    pointcolor = value
    chart

  chart.pointsize = (value) ->
    return pointsize if !arguments.length
    pointsize = value
    chart

  chart.pointstroke = (value) ->
    return pointstroke if !arguments.length
    pointstroke = value
    chart

  chart.dataByInd = (value) ->
    return dataByInd if !arguments.length
    dataByInd = value
    chart

  chart.title = (value) ->
    return title if !arguments.length
    title = value
    chart

  chart.xlab = (value) ->
    return xlab if !arguments.length
    xlab = value
    chart

  chart.ylab = (value) ->
    return ylab if !arguments.length
    ylab = value
    chart

  chart.xvar = (value) ->
    return xvar if !arguments.length
    xvar = value
    chart

  chart.yvar = (value) ->
    return yvar if !arguments.length
    yvar = value
    chart

  chart.yNA = (value) ->
    return yNA if !arguments.length
    yNA = value
    chart

  chart.yscale = () ->
    return yscale

  chart.xscale = () ->
    return xscale

  chart.pointsSelect = () ->
    return pointsSelect

  # return the chart function
  chart

# function to determine rounding of axis labels
formatAxis = (d) ->
  d = d[1] - d[0]
  ndig = Math.floor( Math.log(d % 10) / Math.log(10) )
  ndig = 0 if ndig > 0
  ndig = Math.abs(ndig)
  d3.format(".#{ndig}f")

# unique values of array (ignore nulls)
unique = (x) ->
  output = {}
  output[v] = v for v in x when v
  output[v] for v of output

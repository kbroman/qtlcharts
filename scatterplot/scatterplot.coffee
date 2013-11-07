# scatterplot: reuseable scatterplot

scatterplot = () ->
  width = 800
  height = 500
  margin = {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  xNA = {handle:true, force:false, width:15, gap:10}
  yNA = {handle:true, force:false, width:15, gap:10}
  xlim = null
  ylim = null
  nxticks = 5
  xticks = null
  nyticks = 5
  yticks = null
  rectcolor = d3.rgb(230, 230, 230)
  pointcolor = "slateblue"
  pointstroke = "black"
  pointsize = 3 # default = no visible points at markers
  xlab = "X"
  ylab = "Y score"
  yscale = d3.scale.linear()
  xscale = d3.scale.linear()
  xvar = 0
  yvar = 1
  pointsSelect = null

  ## the main function
  chart = (selection) ->
    selection.each (data) ->
      x = data.map (d) -> d[xvar]
      y = data.map (d) -> d[yvar]

      # if all (x,y) not null
      xNA.handle = false if x.every (v) -> (v?) and !xNA.force
      yNA.handle = false if y.every (v) -> (v?) and !yNA.force
      if xNA.handle
        paneloffset = xNA.width + xNA.gap
        panelwidth = width - paneloffset
      else
        paneloffset = 0
        panelwidth = width
      if yNA.handle
        panelheight = height - (yNA.width + yNA.gap)
      else
        panelheight = height

      xlim = [d3.min(x), d3.max(x)] if !(xlim?)
      ylim = [d3.min(y), d3.max(y)] if !(ylim?)

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
       .attr("x", paneloffset+margin.left)
       .attr("y", margin.top)
       .attr("height", panelheight)
       .attr("width", panelwidth)
       .attr("fill", rectcolor)
       .attr("stroke", "none")
      if xNA.handle
        g.append("rect")
         .attr("x", margin.left)
         .attr("y", margin.top)
         .attr("height", panelheight)
         .attr("width", xNA.width)
         .attr("fill", rectcolor)
         .attr("stroke", "none")
      if xNA.handle and yNA.handle
        g.append("rect")
         .attr("x", margin.left)
         .attr("y", margin.top+height - yNA.width)
         .attr("height", yNA.width)
         .attr("width", xNA.width)
         .attr("fill", rectcolor)
         .attr("stroke", "none")
      if yNA.handle
        g.append("rect")
         .attr("x", margin.left+paneloffset)
         .attr("y", margin.top+height-yNA.width)
         .attr("height", yNA.width)
         .attr("width", panelwidth)
         .attr("fill", rectcolor)
         .attr("stroke", "none")

      xscale.domain(xlim)
            .range([margin.left+paneloffset+margin.inner, margin.left+paneloffset+panelwidth-margin.inner])
      yscale.domain(ylim)
            .range([margin.top+panelheight-margin.inner, margin.top+margin.inner])

      # if yticks not provided, use nyticks to choose pretty ones
      yticks = yscale.ticks(nyticks) if !(yticks?)
      xticks = xscale.ticks(nxticks) if !(xticks?)

      # x-axis
      xaxis = g.append("g").attr("class", "x axis")
      xaxis.selectAll("empty")
           .data(xticks)
           .enter()
           .append("line")
           .attr("x1", (d) -> xscale(d))
           .attr("x2", (d) -> xscale(d))
           .attr("y1", margin.top)
           .attr("y2", margin.top+height)
           .attr("fill", "none")
           .attr("stroke", "white")
           .attr("stroke-width", 1)
           .style("pointer-events", "none")
      xaxis.selectAll("empty")
           .data(xticks)
           .enter()
           .append("text")
           .attr("x", (d) -> xscale(d))
           .attr("y", margin.top+height+axispos.xlabel)
           .text((d) -> formatAxis(xticks)(d))
      xaxis.append("text").attr("class", "title")
           .attr("x", margin.left+width/2)
           .attr("y", margin.top+height+axispos.xtitle)
           .text(xlab)
      if xNA.handle
        xaxis.append("text")
            .attr("x", margin.left+xNA.width/2)
            .attr("y", margin.top+height+axispos.xlabel)
            .text("N/A")

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
           .attr("fill", "none")
           .attr("stroke", "white")
           .attr("stroke-width", 1)
           .style("pointer-events", "none")
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

      # scales to handle missing data
      if xNA.handle
        xs = (x) ->
          return xscale(x) if x?
          margin.left+xNA.width/2
      else
        xs = xscale

      if yNA.handle
        ys = (y) ->
          return yscale(y) if y?
          margin.top+height - yNA.width/2
      else
        ys = yscale

      points = g.append("g").attr("id", "points")
      pointsSelect =
        points.selectAll("empty")
              .data(data)
              .enter()
              .append("circle")
              .attr("cx", (d,i) -> xs(x[i]))
              .attr("cy", (d,i) -> ys(y[i]))
              .attr("class", (d,i) -> "pt#{i}")
              .attr("r", pointsize)
              .attr("fill", pointcolor)
              .attr("stroke", pointstroke)
              .attr("stroke", "black")
              .attr("stroke-width", "1")
              .attr("opacity", (d,i) ->
                   return 1 if (x[i]? or xNA.handle) and (y[i]? or yNA.handle)
                   return 0)

      # box
      g.append("rect")
             .attr("x", margin.left+paneloffset)
             .attr("y", margin.top)
             .attr("height", panelheight)
             .attr("width", panelwidth)
             .attr("fill", "none")
             .attr("stroke", "black")
             .attr("stroke-width", "none")
      if xNA.handle
        g.append("rect")
         .attr("x", margin.left)
         .attr("y", margin.top)
         .attr("height", panelheight)
         .attr("width", xNA.width)
         .attr("fill", "none")
         .attr("stroke", "black")
         .attr("stroke-width", "none")
      if xNA.handle and yNA.handle
        g.append("rect")
         .attr("x", margin.left)
         .attr("y", margin.top+height - yNA.width)
         .attr("height", yNA.width)
         .attr("width", xNA.width)
         .attr("fill", "none")
         .attr("stroke", "black")
         .attr("stroke-width", "none")
      if yNA.handle
        g.append("rect")
         .attr("x", margin.left+paneloffset)
         .attr("y", margin.top+height-yNA.width)
         .attr("height", yNA.width)
         .attr("width", panelwidth)
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

  chart.xlim = (value) ->
    return xlim if !arguments.length
    xlim = value
    chart

  chart.nxticks = (value) ->
    return nxticks if !arguments.length
    nxticks = value
    chart

  chart.xticks = (value) ->
    return xticks if !arguments.length
    xticks = value
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

  chart.xNA = (value) ->
    return xNA if !arguments.length
    xNA = value
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

# lodchart: reuseable LOD score chart

lodchart = () ->
  width = 800
  height = 500
  margin = {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = 20
  ylim = null
  nyticks = 5
  yticks = null
  chrGap = 8
  darkrect = d3.rgb(200, 200, 200)
  lightrect = d3.rgb(230, 230, 230)
  linecolor = "darkslateblue"
  linewidth = 2
  pointcolor = "#E9CFEC" # pink
  pointsize = 0 # default = no visible points at markers
  title = ""
  xlab = "Chromosome"
  ylab = "LOD score"
  yscale = d3.scale.linear()
  xscale = null
  pad4heatmap = false
  lodcurve = null
  lodvarname = null
  markerSelect = null
  chrSelect = null
  pointsAtMarkers = true

  ## the main function
  chart = (selection) ->
    selection.each (data) ->
      lodvarname = lodvarname ? data.lodnames[0]
      ylim = ylim ? [0, d3.max(data[lodvarname])]
      lodvarnum = data.lodnames.indexOf(lodvarname)

      # Select the svg element, if it exists.
      svg = d3.select(this).selectAll("svg").data([data])

      # Otherwise, create the skeletal chart.
      gEnter = svg.enter().append("svg").append("g")

      # Update the outer dimensions.
      svg.attr("width", width+margin.left+margin.right)
         .attr("height", height+margin.top+margin.bottom)

      # Update the inner dimensions.
      g = svg.select("g")
          .attr("transform", "translate(#{margin.left},#{margin.top})")

      # box
      g.append("rect")
       .attr("x", 0)
       .attr("y", 0)
       .attr("height", height)
       .attr("width", width)
       .attr("fill", darkrect)
       .attr("stroke", "none")

      yscale.domain(ylim)
            .range([height, margin.inner])

      # if yticks not provided, use nyticks to choose pretty ones
      yticks = yticks ? yscale.ticks(nyticks)

      # reorganize lod,pos by chromosomes
      data = reorgLodData(data, lodvarname)

      # add chromosome scales (for x-axis)
      data = chrscales(data, width, chrGap, 0, pad4heatmap)
      xscale = data.xscale

      # chr rectangles
      chrSelect =
                g.append("g").attr("class", "chrRect")
                 .selectAll("empty")
                 .data(data.chrnames)
                 .enter()
                 .append("rect")
                 .attr("id", (d) -> "chrrect#{d}")
                 .attr("x", (d,i) -> data.chrStart[i]-chrGap/2)
                 .attr("width", (d,i) -> data.chrEnd[i] - data.chrStart[i]+chrGap)
                 .attr("y", 0)
                 .attr("height", height)
                 .attr("fill", (d,i) ->
                    return darkrect if i % 2
                    lightrect)
                 .attr("stroke", "none")

      # x-axis labels
      xaxis = g.append("g").attr("class", "x axis")
      xaxis.selectAll("empty")
           .data(data.chrnames)
           .enter()
           .append("text")
           .text((d) -> d)
           .attr("x", (d,i) -> (data.chrStart[i]+data.chrEnd[i])/2)
           .attr("y", height+axispos.xlabel)
      xaxis.append("text").attr("class", "title")
           .attr("y", height+axispos.xtitle)
           .attr("x", width/2)
           .text(xlab)

      # y-axis
      yaxis = g.append("g").attr("class", "y axis")
      yaxis.selectAll("empty")
           .data(yticks)
           .enter()
           .append("line")
           .attr("y1", (d) -> yscale(d))
           .attr("y2", (d) -> yscale(d))
           .attr("x1", 0)
           .attr("x2", width)
           .attr("fill", "none")
           .attr("stroke", "white")
           .attr("stroke-width", 1)
           .style("pointer-events", "none")
      yaxis.selectAll("empty")
           .data(yticks)
           .enter()
           .append("text")
           .attr("y", (d) -> yscale(d))
           .attr("x", -axispos.ylabel)
           .text((d) -> formatAxis(yticks)(d))
      yaxis.append("text").attr("class", "title")
           .attr("y", height/2)
           .attr("x", -axispos.ytitle)
           .text(ylab)
           .attr("transform", "rotate(270,#{-axispos.ytitle},#{height/2})")

      # lod curves by chr
      lodcurve = (chr, lodcolumn) ->
          d3.svg.line()
            .x((d) -> xscale[chr](d))
            .y((d,i) -> yscale(data.lodByChr[chr][i][lodcolumn]))

      curves = g.append("g").attr("id", "curves")

      for chr in data.chrnames
        curves.append("path")
              .datum(data.posByChr[chr])
              .attr("d", lodcurve(chr, lodvarnum))
              .attr("stroke", linecolor)
              .attr("fill", "none")
              .attr("stroke-width", linewidth)
              .style("pointer-events", "none")

      # points at markers
      if pointsize > 0
        markerpoints = g.append("g").attr("id", "markerpoints_visible")
        markerpoints.selectAll("empty")
                    .data(data.markers)
                    .enter()
                    .append("circle")
                    .attr("cx", (d) -> xscale[d.chr](d.pos))
                    .attr("cy", (d) -> yscale(d.lod))
                    .attr("r", pointsize)
                    .attr("fill", pointcolor)
                    .attr("pointer-events", "hidden")

      if pointsAtMarkers
        # these hidden points are what gets selected...a bit larger
        hiddenpoints = g.append("g").attr("id", "markerpoints_hidden")

        markertip = d3.tip()
                      .attr('class', 'd3-tip')
                      .html((d) ->
                        [d.name, " LOD = #{d3.format('.2f')(d.lod)}"])
                      .direction("e")
                      .offset([0,10])
        svg.call(markertip)

        markerSelect =
          hiddenpoints.selectAll("empty")
                      .data(data.markers)
                      .enter()
                      .append("circle")
                      .attr("cx", (d) -> xscale[d.chr](d.pos))
                      .attr("cy", (d) -> yscale(d.lod))
                      .attr("id", (d) -> d.name)
                      .attr("r", d3.max([pointsize*2, 3]))
                      .attr("opacity", 0)
                      .attr("fill", pointcolor)
                      .attr("stroke", "black")
                      .attr("stroke-width", "1")
                      .on "mouseover.paneltip", (d) ->
                         d3.select(this).attr("opacity", 1)
                         markertip.show(d)
                      .on "mouseout.paneltip", ->
                         d3.select(this).attr("opacity", 0)
                                        .call(markertip.hide)

      # title
      titlegrp = g.append("g").attr("class", "title")
       .append("text")
       .attr("x", width/2)
       .attr("y", -titlepos)
       .text(title)

      # another box around edge
      g.append("rect")
       .attr("x", 0)
       .attr("y", 0)
       .attr("height", height)
       .attr("width", width)
       .attr("fill", "none")
       .attr("stroke", "black")
       .attr("stroke-width", "none")

  ## configuration parameters
  chart.width = (value) ->
    return width unless arguments.length
    width = value
    chart

  chart.height = (value) ->
    return height unless arguments.length
    height = value
    chart

  chart.margin = (value) ->
    return margin unless arguments.length
    margin = value
    chart

  chart.titlepos = (value) ->
    return titlepos unless arguments.length
    titlepos
    chart

  chart.axispos = (value) ->
    return axispos unless arguments.length
    axispos = value
    chart

  chart.ylim = (value) ->
    return ylim unless arguments.length
    ylim = value
    chart

  chart.nyticks = (value) ->
    return nyticks unless arguments.length
    nyticks = value
    chart

  chart.yticks = (value) ->
    return yticks unless arguments.length
    yticks = value
    chart

  chart.chrGap = (value) ->
    return chrGap unless arguments.length
    chrGap = value
    chart

  chart.darkrect = (value) ->
    return darkrect unless arguments.length
    darkrect = value
    chart

  chart.lightrect = (value) ->
    return lightrect unless arguments.length
    lightrect = value
    chart

  chart.linecolor = (value) ->
    return linecolor unless arguments.length
    linecolor = value
    chart

  chart.linewidth = (value) ->
    return linewidth unless arguments.length
    linewidth = value
    chart

  chart.pointcolor = (value) ->
    return pointcolor unless arguments.length
    pointcolor = value
    chart

  chart.pointsize = (value) ->
    return pointsize unless arguments.length
    pointsize = value
    chart

  chart.title = (value) ->
    return title unless arguments.length
    title = value
    chart

  chart.xlab = (value) ->
    return xlab unless arguments.length
    xlab = value
    chart

  chart.ylab = (value) ->
    return ylab unless arguments.length
    ylab = value
    chart

  chart.lodvarname = (value) ->
    return lodvarname unless arguments.length
    lodvarname = value
    chart

  chart.pad4heatmap = (value) ->
    return pad4heatmap unless arguments.length
    pad4heatmap = value
    chart

  chart.pointsAtMarkers = (value) ->
    return pointsAtMarkers unless arguments.length
    pointsAtMarkers = value
    chart

  chart.yscale = () ->
    return yscale

  chart.xscale = () ->
    return xscale

  chart.lodcurve = () ->
    return lodcurve

  chart.markerSelect = () ->
    return markerSelect

  chart.chrSelect = () ->
    return chrSelect

  # return the chart function
  chart

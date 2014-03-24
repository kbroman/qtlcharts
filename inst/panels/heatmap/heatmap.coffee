# heatmap: reuseable heat map panel

heatmap = () ->
  width = 400
  height = 500
  margin = {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = 20
  xlim = null
  nxticks = 5
  xticks = null
  ylim = null
  nyticks = 5
  yticks = null
  rectcolor = d3.rgb(230, 230, 230)
  colors = ["slateblue", "white", "Orchid"]
  title = ""
  xlab = "Group"
  ylab = "Response"
  zthresh = null
  xscale = d3.scale.linear()
  yscale = d3.scale.linear()
  cellSelect = null
  dataByCell = false

  ## the main function
  chart = (selection) ->
    selection.each (data) ->

      if dataByCell
        data.x = (cell.x for cell in data.cells)
        data.y = (cell.y for cell in data.cells)
        data.allz = (cell.z for cell in data.cells)
      else
        nx = data.x.length
        ny = data.y.length
        if(nx != data.z.length)
          console.log("data.x.length (#{data.x.length}) != data.z.length (#{data.z.length})")
        if(ny != data.z[0].length)
          console.log("data.y.length (#{data.y.length}) != data.z[0].length (#{data.z[0].length})")
        data.cells = []
        for i of data.z
          for j of data.z[i]
            data.cells.push({x:data.x[i], y:data.y[j], z:data.z[i][j]})
        data.allz = (cell.z for cell in data.cells)

      xlim = xlim ? d3.extent(data.x)
      ylim = ylim ? d3.extent(data.y)
      zlim = zlim ? d3.extent(data.allz)

      # Select the svg element, if it exists.
      svg = d3.select(this).selectAll("svg").data([data])

      # Otherwise, create the skeletal chart.
      gEnter = svg.enter().append("svg").append("g")

      # Update the outer dimensions.
      svg.attr("width", width+margin.left+margin.right)
         .attr("height", height+margin.top+margin.bottom)

      g = svg.select("g")

      # box
      g.append("rect")
       .attr("x", margin.left)
       .attr("y", margin.top)
       .attr("height", height)
       .attr("width", width)
       .attr("fill", rectcolor)
       .attr("stroke", "none")

      xrange = [margin.left+margin.inner, margin.left+width-margin.inner]
      xscale.domain(xlim).range(xrange)

      yrange = [margin.top+height-margin.inner, margin.top+margin.inner]
      yscale.domain(ylim).range(yrange)

      # if xticks not provided, use nxticks to choose pretty ones
      xticks = xticks ? xscale.ticks(nxticks)
      yticks = yticks ? yscale.ticks(nyticks)

      # title
      titlegrp = g.append("g").attr("class", "title")
       .append("text")
       .attr("x", margin.left + width/2)
       .attr("y", margin.top - titlepos)
       .text(title)

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
           .attr("class", "y axis grid") 
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

      celltip = d3.tip()
                 .attr('class', 'd3-tip')
                 .html((d) ->
                    x = formatAxis(data.x)(d.x)
                    y = formatAxis(data.y)(d.y)
                    z = formatAxis(data.allz)(d.z)
                    "#{x} #{y} #{z}")
                 .direction('e')
                 .offset([0,10])
      svg.call(celltip)

      cells = g.append("g").attr("id", "cells")
#      cellSelect =
#        cells.selectAll("empty")
#              .data(data.data)
#              .enter()
#              .append("circle")
#              .attr("cx", (d,i) -> xscale(x[i])+xjitter[i])
#              .attr("cy", (d,i) -> yscale(y[i]))
#              .attr("class", (d,i) -> "pt#{i}")
#              .attr("r", pointsize)
#              .attr("fill", pointcolor)
#              .attr("stroke", pointstroke)
#              .attr("stroke-width", "1")
#              .attr("opacity", (d,i) ->
#                   return 1 if (y[i]? or yNA.handle) and x[i] in xcategories
#                   return 0)
#              .on("mouseover.paneltip", indtip.show)
#              .on("mouseout.paneltip", indtip.hide)

      # box
      g.append("rect")
             .attr("x", margin.left)
             .attr("y", margin.top)
             .attr("height", height)
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

  chart.colors = (value) ->
    return colors if !arguments.length
    colors = value
    chart

  chart.dataByCell = (value) ->
    return dataByCell if !arguments.length
    dataByCell = value
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

  chart.yscale = () ->
    return yscale

  chart.xscale = () ->
    return xscale

  chart.cellSelect = () ->
    return cellSelect

  # return the chart function
  chart

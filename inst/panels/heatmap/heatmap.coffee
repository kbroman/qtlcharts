# heatmap: reuseable heat map panel

heatmap = () ->
  width = 400
  height = 500
  margin = {left:60, top:40, right:40, bottom: 40}
  axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = 20
  xlim = null
  nxticks = 5
  xticks = null
  ylim = null
  nyticks = 5
  yticks = null
  rectcolor = d3.rgb(230, 230, 230)
  colors = ["slateblue", "white", "crimson"]
  title = ""
  xlab = "X"
  ylab = "Y"
  zthresh = null
  xscale = d3.scale.linear()
  yscale = d3.scale.linear()
  zscale = d3.scale.linear()
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

      # sort the x and y values
      data.x.sort((a,b) -> a-b)
      data.y.sort((a,b) -> a-b)

      # x values to left and right of each value
      xLR = getLeftRight(data.x)
      yLR = getLeftRight(data.y)

      # insert info about left, right, top, bottom points of cell rectangles
      for cell in data.cells
        cell.recLeft = (xLR[cell.x].left+cell.x)/2
        cell.recRight = (xLR[cell.x].right+cell.x)/2
        cell.recTop = (yLR[cell.y].right+cell.y)/2
        cell.recBottom = (yLR[cell.y].left+cell.y)/2

      # x and y axis limits
      xlim = xlim ? xLR.extent
      ylim = ylim ? yLR.extent

      # z-axis (color) limits; if not provided, make symmetric about 0
      zmin = d3.min(data.allz)
      zmax = d3.max(data.allz)
      zmax = -zmin if -zmin > zmax
      zlim = zlim ? [-zmax, 0, zmax]
      zscale.domain(zlim).range(colors)

      zthresh = zthresh ? zmin - 1
      data.cells = (cell for cell in data.cells when cell.z >= zthresh or cell.z <= -zthresh)

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

      xrange = [margin.left, margin.left+width]
      xscale.domain(xlim).range(xrange)

      yrange = [margin.top+height, margin.top]
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
                    "(#{x} #{y}) &rarr; #{z}")
                 .direction('e')
                 .offset([0,10])
      svg.call(celltip)

      cells = g.append("g").attr("id", "cells")
      cellSelect =
       cells.selectAll("empty")
              .data(data.cells)
              .enter()
              .append("rect")
              .attr("x", (d) -> xscale(d.recLeft))
              .attr("y", (d) -> yscale(d.recTop))
              .attr("width", (d) -> xscale(d.recRight)-xscale(d.recLeft))
              .attr("height", (d) -> yscale(d.recBottom) - yscale(d.recTop))
              .attr("class", (d,i) -> "cell#{i}")
              .attr("fill", (d) -> zscale(d.z))
              .attr("stroke", "none")
              .attr("stroke-width", "1")
              .on("mouseover.paneltip", (d) ->
                  d3.select(this).attr("stroke", "black")
                  celltip.show(d))
              .on("mouseout.paneltip", () ->
                  d3.select(this).attr("stroke", "none")
                  celltip.hide())

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

  chart.zthresh = (value) ->
    return zthresh if !arguments.length
    zthresh = value
    chart

  chart.xscale = () ->
    return xscale

  chart.yscale = () ->
    return yscale

  chart.zscale = () ->
    return zscale

  chart.cellSelect = () ->
    return cellSelect

  # return the chart function
  chart

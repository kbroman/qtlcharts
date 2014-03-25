# lodheatmap: reuseable panel with heat map of LOD curves

lodheatmap = () ->
  width = 1200
  height = 600
  margin = {left:60, top:40, right:40, bottom: 40}
  axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  chrGap = 5
  titlepos = 20
  rectcolor = d3.rgb(230, 230, 230)
  colors = ["slateblue", "white", "crimson"]
  title = ""
  xlab = "Chromosome"
  ylab = ""
  zthresh = null
  xscale = d3.scale.linear()
  yscale = d3.scale.linear()
  zscale = d3.scale.linear()
  cellSelect = null
  dataByCell = false

  ## the main function
  chart = (selection) ->
    selection.each (data) ->

      data = reorgLodData2(data)
      data = chrscales2(data, width, chrGap, margin.left)
      xscale = data.xscale

      nlod = data.lodnames.length
      yscale.domain([-0.5, nlod+0.5]).range([height, 0])

      xLR = {}
      for chr in data.chrnames
        xLR[chr] = getLeftRight(data.posByChr[chr])
      
      # z-axis (color) limits; if not provided, make symmetric about 0
      zmin = 0
      zmax = 0
      for lodcol in data.lodnames
        extent = d3.extent(data[lodcol])
        zmin = extent[0] if extent[0] < zmin
        zmax = extent[1] if extent[1] > zmin
      console.log(zmin, zmax)
      zmax = -zmin if -zmin > zmax
      zlim = zlim ? [-zmax, 0, zmax]
      if zlim.length != colors.length
        console.log("zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
      zscale.domain(zlim).range(colors)

      zthresh = zthresh ? zmin - 1

      data.cells = []
      for chr in data.chrnames
        for pos, i in data.posByChr[chr]
          for lod,j in data.lodByChr[chr][i]
            if lod >= zthresh or lod <= -zthresh
              data.cells.push({z: lod, left:  (xscale[chr](pos) + xscale[chr](xLR[chr][pos].left) )/2,
              right: (xscale[chr](pos) + xscale[chr](xLR[chr][pos].right) )/2,
              top:yscale(j+0.5), height:yscale(j-0.5)-yscale(j+0.5), lodindex:j, chr:chr, pos:pos})

      # Select the svg element, if it exists.
      svg = d3.select(this).selectAll("svg").data([data])

      # Otherwise, create the skeletal chart.
      gEnter = svg.enter().append("svg").append("g")

      # Update the outer dimensions.
      svg.attr("width", width+margin.left+margin.right)
         .attr("height", height+margin.top+margin.bottom)

      g = svg.select("g")

      # boxes
      g.append("g").attr("id", "boxes").selectAll("empty")
       .data(data.chrnames)
       .enter()
       .append("rect")
       .attr("id", (d) -> "box#{d}")
       .attr("x", (d,i) -> data.chrStart[i])
       .attr("y", (d) -> margin.top)
       .attr("height", height)
       .attr("width", (d,i) -> data.chrEnd[i] - data.chrStart[i])
       .attr("fill", rectcolor)
       .attr("stroke", "none")

      # title
      titlegrp = g.append("g").attr("class", "title")
       .append("text")
       .attr("x", margin.left + width/2)
       .attr("y", margin.top - titlepos)
       .text(title)

      # x-axis
      xaxis = g.append("g").attr("class", "x axis")
      xaxis.selectAll("empty")
           .data(data.chrnames)
           .enter()
           .append("text")
           .attr("x", (d,i) -> (data.chrStart[i] + data.chrEnd[i])/2)
           .attr("y", margin.top+height+axispos.xlabel)
           .text((d) -> d)
      xaxis.append("text").attr("class", "title")
           .attr("x", margin.left+width/2)
           .attr("y", margin.top+height+axispos.xtitle)
           .text(xlab)

      # y-axis
      yaxis = g.append("g").attr("class", "y axis")
      yaxis.append("text").attr("class", "title")
           .attr("y", margin.top+height/2)
           .attr("x", margin.left-axispos.ytitle)
           .text(ylab)
           .attr("transform", "rotate(270,#{margin.left-axispos.ytitle},#{margin.top+height/2})")

      celltip = d3.tip()
                 .attr('class', 'd3-tip')
                 .html((d) -> "LOD = " + d3.format(".2f")(d.z))
                 .direction('e')
                 .offset([0,10])
      svg.call(celltip)

      cells = g.append("g").attr("id", "cells")
      cellSelect =
       cells.selectAll("empty")
              .data(data.cells)
              .enter()
              .append("rect")
              .attr("x", (d) -> d.left)
              .attr("y", (d) -> d.top)
              .attr("width", (d) -> d.right - d.left)
              .attr("height", (d) -> d.height)
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

      # boxes
      g.append("g").attr("id", "boxes").selectAll("empty")
       .data(data.chrnames)
       .enter()
       .append("rect")
       .attr("id", (d) -> "box#{d}")
       .attr("x", (d,i) -> data.chrStart[i])
       .attr("y", (d) -> margin.top)
       .attr("height", height)
       .attr("width", (d,i) -> data.chrEnd[i] - data.chrStart[i])
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

  chart.zlim = (value) ->
    return zlim if !arguments.length
    zlim = value
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

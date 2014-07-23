# chrheatmap: reuseable heat map panel, broken into chromosomes

chrheatmap = () ->
    pixelPerCell = 3
    chrGap = 4
    margin = {left:60, top:40, right:40, bottom: 40}
    axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
    titlepos = 20
    rectcolor = "#e6e6e6"
    nullcolor = "#e6e6e6"
    bordercolor = "black"
    colors = ["slateblue", "white", "crimson"]
    title = ""
    xlab = ""
    ylab = ""
    rotate_ylab = null
    zlim = null
    zthresh = null
    zscale = d3.scale.linear()
    oneAtTop = false
    hover = true
    cellSelect = null
  
    ## the main function
    chart = (selection) ->
        selection.each (data) ->

            ny = data.z.length
            nx = (x.length for x in data.z)
            for i of nx
                if nx[i] != ny
                    console.log("Row #{i+1} of data.z is not the write length: #{nx[i]} != #{ny}")
            nchr = data.nmar.length
            totmar = sumArray(data.nmar)
            if totmar != ny
                console.log("sum(data.nmar) != data.z.length")
            if data.chr.length != nchr
                console.log("data.nmar.length != data.chr.length")
            if data.labels.length != totmar
                console.log("data.labels.length != sum(data.nmar)")         
            if chrGap < 2
                chrGap = 2
                console.log("chrGap should be >= 1")

            # determine start of each cell (leave 1 pixel border around each chromosome)
            xChrBorder = [0]
            xCellStart = []
            cur = chrGap/2
            for nm in data.nmar
                for j in [0...nm]
                    xCellStart.push(cur+1)
                    cur = cur+pixelPerCell
                xChrBorder.push(cur+1+chrGap/2)
                cur = cur+chrGap

            width = cur-chrGap/2
            height = width # always square

            if oneAtTop
                yChrBorder = (val for val in xChrBorder)
                yCellStart = (val for val in xCellStart)
            else
                yChrBorder = (height - val+1 for val in xChrBorder)
                yCellStart = (height-val-pixelPerCell for val in xCellStart)

            data.cells = []
            for i of data.z
                for j of data.z[i]
                    data.cells.push({i:i, j:j, z:data.z[i][j], x:xCellStart[i]+margin.left, y:yCellStart[j]+margin.top})
            data.allz = (cell.z for cell in data.cells)

            # z-axis (color) limits; if not provided, make symmetric about 0
            zmin = d3.min(data.allz)
            zmax = d3.max(data.allz)
            zmax = -zmin if -zmin > zmax
            zlim = zlim ? [-zmax, 0, zmax]
            if zlim.length != colors.length
                console.log("zlim.length (#{zlim.length}) != colors.length (#{colors.length})")
            zscale.domain(zlim).range(colors)
    
            # discard cells with |z| < zthresh
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
             .attr("stroke", null)
             .attr("stroke-width", "0")
    
            # chromosome borders
            chrborders = g.append("g").attr("id", "chrBorders")
            chrborders.selectAll("empty")
                      .data(xChrBorder)
                      .enter()
                      .append("line")
                      .attr("x1", (d) -> d + margin.left)
                      .attr("x2", (d) -> d + margin.left)
                      .attr("y1", margin.top)
                      .attr("y2", margin.top + height)
                      .attr("stroke", bordercolor)
                      .attr("stroke-width", "1")

            chrborders.selectAll("empty")
                      .data(yChrBorder)
                      .enter()
                      .append("line")
                      .attr("y1", (d) -> d + margin.top)
                      .attr("y2", (d) -> d + margin.top)
                      .attr("x1", margin.left)
                      .attr("x2", margin.left + width)
                      .attr("stroke", bordercolor)
                      .attr("stroke-width", "1")

            # title
            titlegrp = g.append("g").attr("class", "title")
                        .append("text")
                        .attr("x", margin.left + width/2)
                        .attr("y", margin.top - titlepos)
                        .text(title)
    
            # x-axis
            xaxis = g.append("g").attr("class", "x axis")
            xaxis.append("text").attr("class", "title")
                 .attr("x", margin.left+width/2)
                 .attr("y", margin.top+height+axispos.xtitle)
                 .text(xlab)
            xaxis.selectAll("empty")
                 .data(data.chr)
                 .enter()
                 .append("text")
                 .attr("x", (d,i) -> margin.left + (xChrBorder[i]+xChrBorder[i+1])/2)
                 .attr("y", if oneAtTop then margin.top - 2*axispos.xlabel else margin.top+height+axispos.xlabel)
                 .text((d) -> d)
                 .style("dominant-baseline", if oneAtTop then "middle" else "hanging")

            # y-axis
            rotate_ylab = rotate_ylab ? (ylab.length > 1)
            yaxis = g.append("g").attr("class", "y axis")
            yaxis.append("text").attr("class", "title")
                 .attr("y", margin.top+height/2)
                 .attr("x", margin.left-axispos.ytitle)
                 .text(ylab)
                 .attr("transform", if rotate_ylab then "rotate(270,#{margin.left-axispos.ytitle},#{margin.top+height/2})" else "")
            yaxis.selectAll("empty")
                 .data(data.chr)
                 .enter()
                 .append("text")
                 .attr("y", (d,i) -> margin.top + (yChrBorder[i]+yChrBorder[i+1])/2)
                 .attr("x", margin.left-axispos.ylabel)
                 .text((d) -> d)

            celltip = d3.tip()
                        .attr('class', 'd3-tip')
                        .html((d) ->
                                "#{data.labels[d.i]}, #{data.labels[d.j]} &rarr; #{formatAxis(data.allz)(d.z)}")
                        .direction('e')
                        .offset([0,10])
            svg.call(celltip)
    
            cells = g.append("g").attr("id", "cells")
            cellSelect =
                cells.selectAll("empty")
                     .data(data.cells)
                     .enter()
                     .append("rect")
                     .attr("x", (d) -> d.x)
                     .attr("y", (d) -> d.y)
                     .attr("width", pixelPerCell)
                     .attr("height", pixelPerCell)
                     .attr("class", (d,i) -> "cell#{i}")
                     .attr("fill", (d) -> if d.z? then zscale(d.z) else nullcolor)
                     .attr("stroke", "none")
                     .attr("stroke-width", "1")
                     .on("mouseover.paneltip", (d) ->
                                                   d3.select(this).attr("stroke", "black")
                                                   celltip.show(d) if hover)
                     .on("mouseout.paneltip", () ->
                                                   d3.select(this).attr("stroke", "none")
                                                   celltip.hide() if hover)

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
    chart.pixelPerCell = (value) ->
                      return pixelPerCell if !arguments.length
                      pixelPerCell = value
                      chart

    chart.chrGap = (value) ->
                      return chrGap if !arguments.length
                      chrGap = value
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

    chart.rectcolor = (value) ->
                      return rectcolor if !arguments.length
                      rectcolor = value
                      chart

    chart.nullcolor = (value) ->
                      return nullcolor if !arguments.length
                      nullcolor = value
                      chart

    chart.bordercolor = (value) ->
                      return bordercolor if !arguments.length
                      bordercolor = value
                      chart

    chart.colors = (value) ->
                      return colors if !arguments.length
                      colors = value
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

    chart.rotate_ylab = (value) ->
                      return rotate_ylab if !arguments.length
                      rotate_ylab = value
                      chart

    chart.zthresh = (value) ->
                      return zthresh if !arguments.length
                      zthresh = value
                      chart

    chart.zlim = (value) ->
                      return zlim if !arguments.length
                      zlim = value
                      chart

    chart.oneAtTop = (value) ->
                      return oneAtTop if !arguments.length
                      oneAtTop = value
                      chart

    chart.hover = (value) ->
                      return hover if !arguments.length
                      hover = value
                      chart

    chart.zscale = () ->
                      return zscale
                  
    chart.cellSelect = () ->
                      return cellSelect
                  
    # return the chart function
    chart

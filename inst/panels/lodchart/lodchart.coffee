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
    darkrect = "#c8c8c8"
    lightrect = "#e6e6e6"
    linecolor = "darkslateblue"
    linewidth = 2
    pointcolor = "#E9CFEC" # pink
    pointsize = 0 # default = no visible points at markers
    pointstroke = "black"
    title = ""
    xlab = "Chromosome"
    ylab = "LOD score"
    rotate_ylab = null
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
            data[lodvarname] = (abs(x) for x in data[lodvarname]) # take absolute values
            ylim = ylim ? [0, d3.max(data[lodvarname])]
            lodvarnum = data.lodnames.indexOf(lodvarname)

            if data.chr.length != data.pos.length
                displayError("chr.length (#{data.chr.length}) != pos.length (#{data.pos.length})")
            if data.chr.length != data.markernames.length
                displayError("chr.length (#{data.chr.length}) != markernames.length (#{data.markernames.length})")

            # Select the svg element, if it exists.
            svg = d3.select(this).selectAll("svg").data([data])

            # Otherwise, create the skeletal chart.
            gEnter = svg.enter().append("svg").append("g")

            # Update the outer dimensions.
            svg.attr("width", width+margin.left+margin.right)
               .attr("height", height+margin.top+margin.bottom)

            # Update the inner dimensions.
            g = svg.select("g")

            # box
            g.append("rect")
             .attr("x", margin.left)
             .attr("y", margin.top)
             .attr("height", height)
             .attr("width", width)
             .attr("fill", darkrect)
             .attr("stroke", "none")

            margin.inner = margin?.inner ? 0
            yscale.domain(ylim)
                  .range([height+margin.top, margin.top+margin.inner])

            # if yticks not provided, use nyticks to choose pretty ones
            yticks = yticks ? yscale.ticks(nyticks)

            # reorganize lod,pos by chromosomes
            data = reorgLodData(data, lodvarname)

            # add chromosome scales (for x-axis)
            data = chrscales(data, width, chrGap, margin.left, pad4heatmap)
            xscale = data.xscale

            # chr rectangles
            chrSelect =
                g.append("g").attr("class", "chrRect")
                 .selectAll("empty")
                 .data(data.chrnames)
                 .enter()
                 .append("rect")
                 .attr("id", (d) -> "chrrect#{d}")
                 .attr("x", (d,i) ->
                                return data.chrStart[i] if i==0 and pad4heatmap
                                data.chrStart[i]-chrGap/2)
                 .attr("width", (d,i) ->
                                 return data.chrEnd[i] - data.chrStart[i]+chrGap/2 if (i==0 or i+1 == data.chrnames.length) and pad4heatmap
                                 data.chrEnd[i] - data.chrStart[i]+chrGap)
                 .attr("y", margin.top)
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
                 .attr("y", margin.top+height+axispos.xlabel)
            xaxis.append("text").attr("class", "title")
                 .attr("y", margin.top+height+axispos.xtitle)
                 .attr("x", margin.left+width/2)
                 .text(xlab)

            # y-axis
            rotate_ylab = rotate_ylab ? (ylab.length > 1)
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
                 .attr("transform", if rotate_ylab then "rotate(270,#{margin.left-axispos.ytitle},#{margin.top+height/2})" else "")

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
                            .attr("r", (d) -> if d.lod? then pointsize else null)
                            .attr("fill", pointcolor)
                            .attr("stroke", pointstroke)
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

                bigpointsize = d3.max([2*pointsize, 3])

                markerSelect =
                    hiddenpoints.selectAll("empty")
                                .data(data.markers)
                                .enter()
                                .append("circle")
                                .attr("cx", (d) -> xscale[d.chr](d.pos))
                                .attr("cy", (d) -> yscale(d.lod))
                                .attr("id", (d) -> d.name)
                                .attr("r", (d) -> if d.lod? then bigpointsize else null)
                                .attr("opacity", 0)
                                .attr("fill", pointcolor)
                                .attr("stroke", pointstroke)
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
                          .attr("x", margin.left+width/2)
                          .attr("y", margin.top-titlepos)
                          .text(title)

              # another box around edge
              g.append("rect")
               .attr("x", margin.left)
               .attr("y", margin.top)
               .attr("height", height)
               .attr("width", () ->
                                  return(data.chrEnd[-1..][0]-margin.left) if pad4heatmap
                                  data.chrEnd[-1..][0]-margin.left+chrGap/2)
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

    chart.pointstroke = (value) ->
                      return pointstroke unless arguments.length
                      pointstroke = value
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

    chart.rotate_ylab = (value) ->
                      return rotate_ylab if !arguments.length
                      rotate_ylab = value
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

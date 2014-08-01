# mapchart: reuseable marker map plot

mapchart = () ->
    width = 1000
    height = 600
    margin = {left:60, top:40, right:40, bottom: 40, inner:10}
    axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
    titlepos = 20
    ylim = null
    nyticks = 5
    yticks = null
    tickwidth = 10
    rectcolor = "#e6e6e6"
    linecolor = "slateblue"
    linecolorhilit = "Orchid"
    linewidth = 3
    title = ""
    xlab = "Chromosome"
    ylab = "Position (cM)"
    rotate_ylab = null
    xscale = d3.scale.ordinal()
    yscale = d3.scale.linear()
    markerSelect = null

    ## the main function
    chart = (selection) ->
        selection.each (data) ->

            # find min and max position on each chromosome
            yextentByChr = {}
            for chr in data.chr
                pos = (data.map[chr][marker] for marker of data.map[chr])
                yextentByChr[chr] = d3.extent(pos)
            ymin = (yextentByChr[chr][0] for chr in data.chr)
            ymax = (yextentByChr[chr][1] for chr in data.chr)

            ylim = ylim ? d3.extent(ymin.concat ymax)

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

            # simple scales (ignore NA business)
            xrange = [margin.left + margin.inner, margin.left + width - margin.inner]
            xscale.domain(data.chr).rangePoints(xrange, 1)

            yrange = [margin.top + margin.inner, margin.top + height - margin.inner]
            yscale.domain(ylim).range(yrange)

            # if yticks not provided, use nyticks to choose pretty ones
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
                 .data(data.chr)
                 .enter()
                 .append("line")
                 .attr("x1", (d) -> xscale(d))
                 .attr("x2", (d) -> xscale(d))
                 .attr("y1", margin.top)
                 .attr("y2", margin.top+height)
                 .attr("class", "x axis grid") 
            xaxis.selectAll("empty")
                 .data(data.chr)
                 .enter()
                 .append("text")
                 .attr("x", (d) -> xscale(d))
                 .attr("y", margin.top+height+axispos.xlabel)
                 .text((d) -> d)
            xaxis.append("text").attr("class", "title")
                 .attr("x", margin.left+width/2)
                 .attr("y", margin.top+height+axispos.xtitle)
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
                 .attr("transform", if rotate_ylab then "rotate(270,#{margin.left-axispos.ytitle},#{margin.top+height/2})" else "")

            # vertical lines for each chromosome
            g.append("g").attr("id", "chromosomes").selectAll("empty")
             .data(data.chr)
             .enter()
             .append("line")
             .attr("x1", (d) -> xscale(d))
             .attr("x2", (d) -> xscale(d))
             .attr("y1", (d) -> yscale(yextentByChr[d][0]))
             .attr("y2", (d) -> yscale(yextentByChr[d][1]))
             .attr("fill", "none")
             .attr("stroke", linecolor)
             .attr("stroke-width", linewidth)
             .style("pointer-events", "none")

            martip = d3.tip()
                       .attr('class', 'd3-tip')
                       .html((d) ->
                          pos = d3.format(".1f")(markerpos[d].pos)
                          "#{d} (#{pos})")
                       .direction('e')
                       .offset([0,10])
            svg.call(martip)

            # reorganize map information by marker
            markerpos = {}
            for chr in data.chr
                for marker of data.map[chr]
                    markerpos[marker] = {chr:chr, pos:data.map[chr][marker]}
            markernames = (mar for mar of markerpos)

            markers = g.append("g").attr("id", "points")
            markSelect =
                markers.selectAll("empty")
                       .data(markernames)
                       .enter()
                       .append("line")
                       .attr("x1", (d) -> xscale(markerpos[d].chr)-tickwidth)
                       .attr("x2", (d) -> xscale(markerpos[d].chr)+tickwidth)
                       .attr("y1", (d) -> yscale(markerpos[d].pos))
                       .attr("y2", (d) -> yscale(markerpos[d].pos))
                       .attr("id", (d) -> d)
                       .attr("fill", "none")
                       .attr("stroke", linecolor)
                       .attr("stroke-width", linewidth)
                       .on "mouseover.paneltip", (d) ->
                                                     d3.select(this).attr("stroke", linecolorhilit)
                                                     martip.show(d)
                       .on "mouseout.paneltip", () ->
                                                     d3.select(this).attr("stroke", linecolor)
                                                     martip.hide()

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

    chart.tickwidth = (value) ->
                      return tickwidth if !arguments.length
                      tickwidth = value
                      chart

    chart.rectcolor = (value) ->
                      return rectcolor if !arguments.length
                      rectcolor = value
                      chart

    chart.linecolor = (value) ->
                      return linecolor if !arguments.length
                      linecolor = value
                      chart

    chart.linecolorhilit = (value) ->
                      return linecolorhilit if !arguments.length
                      linecolorhilit = value
                      chart

    chart.linewidth = (value) ->
                      return linewidth if !arguments.length
                      linewidth = value
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

    chart.yscale = () ->
                      return yscale

    chart.xscale = () ->
                      return xscale

    chart.markerSelect = () ->
                      return markerSelect

    # return the chart function
    chart

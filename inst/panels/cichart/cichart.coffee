# cichart: reuseable CI chart (plot of estimates and confidence intervals for a set of categories)

cichart = () ->
    width = 400
    height = 500
    margin = {left:60, top:40, right:40, bottom: 40, inner:5}
    axispos = {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
    titlepos = 20
    xcatlabels = null
    segwidth = null
    ylim = null
    nyticks = 5
    yticks = null
    rectcolor = "#e6e6e6"
    segcolor = "slateblue"
    segstrokewidth = "3"
    vertsegcolor = "slateblue"
    title = ""
    xlab = "Group"
    ylab = "Response"
    rotate_ylab = null
    xscale = d3.scale.ordinal()
    yscale = d3.scale.linear()

    ## the main function
    chart = (selection) ->
        selection.each (data) ->

            # input:
            means = data.means
            low = data.low
            high = data.high
            categories = data.categories
            displayError("means.length != low.length") if means.length != low.length
            displayError("means.length != high.length") if means.length != high.length
            displayError("means.length != categories.length") if means.length != categories.length

            xcatlabels = xcatlabels ? categories
            displayError("xcatlabels.length != categories.length") if xcatlabels.length != categories.length

            ylim = ylim ? [d3.min(low), d3.max(high)]

            # Select the svg element, if it exists.
            svg = d3.select(this).selectAll("svg").data([data])

            # Otherwise, create the skeletal chart.
            gEnter = svg.enter().append("svg").append("g")

            # Update the outer dimensions.
            svg.attr("width", width+margin.left+margin.right)
               .attr("height", height+margin.top+margin.bottom)

            # expand segcolor and vertsegcolor to length of means
            if segcolor.length == 1
                segcolor = (segcolor for i in means)
            else if segcolor.length < means.length
                displayError("segcolor.length > 1 but != means.length")
            if vertsegcolor.length == 1
                vertsegcolor = (vertsegcolor for i in means)
            else if vertsegcolor.length < means.length
                displayError("vertsegcolor.length > 1 but != means.length")

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
            xrange = [margin.left+margin.inner, margin.left+width-margin.inner]
            xscale.domain(categories).rangePoints(xrange, 1)

            # width of segments
            segwidth = segwidth ? (xrange[1]-xrange[0])/categories.length*0.2

            yrange = [margin.top+height-margin.inner, margin.top+margin.inner]
            yscale.domain(ylim).range(yrange)
            ys = d3.scale.linear().domain(ylim).range(yrange)

            # if yticks not provided, use nyticks to choose pretty ones
            yticks = yticks ? ys.ticks(nyticks)

            # title
            titlegrp = g.append("g").attr("class", "title")
             .append("text")
             .attr("x", margin.left + width/2)
             .attr("y", margin.top - titlepos)
             .text(title)

            # x-axis
            xaxis = g.append("g").attr("class", "x axis")
            xaxis.selectAll("empty")
                 .data(categories)
                 .enter()
                 .append("line")
                 .attr("x1", (d) -> xscale(d))
                 .attr("x2", (d) -> xscale(d))
                 .attr("y1", margin.top)
                 .attr("y2", margin.top+height)
                 .attr("class", "x axis grid")
            xaxis.selectAll("empty")
                 .data(categories)
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

            tip = d3.tip()
                       .attr('class', 'd3-tip')
                       .html((d,i) ->
                          index = i % means.length
                          f = formatAxis([low[index],means[index]], 1)
                          "#{f(means[index])} (#{f(low[index])} - #{f(high[index])})")
                       .direction('e')
                       .offset([0,10])
            svg.call(tip)

            segments = g.append("g").attr("id", "segments")
            segments.selectAll("empty")
                    .data(low)
                    .enter()
                    .append("line")
                    .attr("x1", (d,i) -> xscale(categories[i]))
                    .attr("x2", (d,i) -> xscale(categories[i]))
                    .attr("y1", (d) -> yscale(d))
                    .attr("y2", (d,i) -> yscale(high[i]))
                    .attr("fill", "none")
                    .attr("stroke", (d,i) -> vertsegcolor[i])
                    .attr("stroke-width", segstrokewidth)
            segments.selectAll("empty")
                    .data(means.concat(low, high))
                    .enter()
                    .append("line")
                    .attr("x1", (d,i) ->
                               x = xscale(categories[i % means.length])
                               return x - segwidth/2 if i < means.length
                               x - segwidth/3)
                    .attr("x2", (d,i) ->
                               x = xscale(categories[i % means.length])
                               return x + segwidth/2 if i < means.length
                               x + segwidth/3)
                    .attr("y1", (d) -> yscale(d))
                    .attr("y2", (d) -> yscale(d))
                    .attr("fill", "none")
                    .attr("stroke", (d,i) -> segcolor[i])
                    .attr("stroke-width", segstrokewidth)
                    .on("mouseover.paneltip", tip.show)
                    .on("mouseout.paneltip", tip.hide)
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
                       titlepos = value
                       chart

    chart.xcatlabels = (value) ->
                       return xcatlabels if !arguments.length
                       xcatlabels = value
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

    chart.segcolor = (value) ->
                       return segcolor if !arguments.length
                       segcolor = value
                       chart

    chart.segstrokewidth = (value) ->
                       return segstrokewidth if !arguments.length
                       segstrokewidth = value
                       chart

    chart.segwidth = (value) ->
                       return segwidth if !arguments.length
                       segwidth = value
                       chart

    chart.vertsegcolor = (value) ->
                       return vertsegcolor if !arguments.length
                       vertsegcolor = value
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

    # return the chart function
    chart

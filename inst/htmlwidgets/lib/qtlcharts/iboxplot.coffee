# iboxplot.coffee
#
# Top panel is like a set of n box plots:
#   lines are drawn at the 0.1, 1, 10, 25, 50, 75, 90, 99, 99.9 percentiles
#   for each of n distributions
# Hover over a column in the top panel and the corresponding distribution
#   is show below; click for it to persist; click again to make it go away.
#

iboxplot = (widgetdiv, data, chartOpts) ->

    # chartOpts start
    width = chartOpts?.width ? 1000              # width of image in pixels
    height = chartOpts?.height ? 900             # total height of image in pixels
    margin = chartOpts?.margin ? {left:60, top:20, right:60, bottom: 40} # margins in pixels (left, top, right, bottom)
    ylab = chartOpts?.ylab ? "Response"          # y-axis label
    xlab = chartOpts?.xlab ? "Individuals"       # x-axis label
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
    qucolors = chartOpts?.qucolors ? null        # vector of colors for the quantile curves
    histcolors = chartOpts?.histcolors ? ["#0074D9", "#FF4136", "#3D9970", "MediumVioletRed", "black"] # vector of colors for selected histograms
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:20, right:60, bottom: 40})

    # make sure histcolors and qucolors are arrays
    histcolors = d3panels.forceAsArray(histcolors)
    qucolors = d3panels.forceAsArray(qucolors)

    halfheight = height/2

    # y-axis limits for top figure
    topylim = [data.quant[0][0], data.quant[0][0]]
    for i of data.quant
        r = d3.extent(data.quant[i])
        topylim[0] = r[0] if r[0] < topylim[0]
        topylim[1] = r[1] if r[1] > topylim[1]
    topylim[0] = Math.floor(topylim[0])
    topylim[1] = Math.ceil(topylim[1])

    # y-axis limits for bottom figure
    botylim = [0, data.counts[0][0]]
    for i of data.counts
        m = d3.max(data.counts[i])
        botylim[1] = m if m > botylim[1]

    indindex = d3.range(data.ind.length)

    # adjust counts object to make proper histogram
    br2 = []
    for i in data.breaks
        br2.push(i)
        br2.push(i)

    fix4hist = (d) ->
        x = [0]
        for i in d
             x.push(i)
             x.push(i)
        x.push(0)
        x

    for i of data.counts
        data.counts[i] = fix4hist(data.counts[i])

    # number of quantiles
    nQuant = data.quant.length
    midQuant = (nQuant+1)/2 - 1

    # x and y scales for top figure
    xScale = d3.scaleLinear()
               .domain([-1, data.ind.length])
               .range([margin.left, width-margin.right])

    # width of rectangles in top panel
    recWidth = xScale(1) - xScale(0)

    yScale = d3.scaleLinear()
               .domain(topylim)
               .range([halfheight-margin.bottom, margin.top])

    # function to create quantile lines
    quline = (j) ->
        d3.line()
            .x((d) -> xScale(d))
            .y((d) -> yScale(data.quant[j][d]))

    svg=d3.select(widgetdiv).select("svg")
             .append("svg")
             .attr("width", width)
             .attr("height", halfheight)
             .attr("class", "qtlcharts")

    # gray background
    svg.append("rect")
       .attr("x", margin.left)
       .attr("y", margin.top)
       .attr("height", halfheight-margin.top-margin.bottom)
       .attr("width", width-margin.left-margin.right)
       .attr("stroke", "none")
       .attr("fill", rectcolor)
       .attr("pointer-events", "none")

    # axis on left
    LaxisData = yScale.ticks(6)
    Laxis = svg.append("g").attr("id", "Laxis")

    # axis: white lines
    Laxis.append("g").selectAll("empty")
       .data(LaxisData)
       .enter()
       .append("line")
       .attr("class", "line")
       .attr("class", "axis")
       .attr("x1", margin.left)
       .attr("x2", width-margin.right)
       .attr("y1", (d) -> yScale(d))
       .attr("y2", (d) -> yScale(d))
       .attr("stroke", "white")
       .attr("pointer-events", "none")

    # axis: labels
    Laxis.append("g").selectAll("empty")
       .data(LaxisData)
       .enter()
       .append("text")
       .attr("class", "axis")
       .text((d) -> d3panels.formatAxis(LaxisData)(d))
       .attr("x", margin.left*0.9)
       .attr("y", (d) -> yScale(d))
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "end")

    # axis on bottom
    BaxisData = xScale.ticks(10)
    Baxis = svg.append("g").attr("id", "Baxis")

    # axis: white lines
    Baxis.append("g").selectAll("empty")
       .data(BaxisData)
       .enter()
       .append("line")
       .attr("class", "line")
       .attr("class", "axis")
       .attr("y1", margin.top)
       .attr("y2", halfheight-margin.bottom)
       .attr("x1", (d) -> xScale(d-1))
       .attr("x2", (d) -> xScale(d-1))
       .attr("stroke", "white")
       .attr("pointer-events", "none")

    # axis: labels
    Baxis.append("g").selectAll("empty")
       .data(BaxisData)
       .enter()
       .append("text")
       .attr("class", "axis")
       .text((d) -> d)
       .attr("y", halfheight-margin.bottom*0.75)
       .attr("x", (d) -> xScale(d-1))
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "middle")

    # colors for quantile curves
    if qucolors? and qucolors.length < (nQuant-1)/2+1
        displayError("Not enough quantile colors: #{qucolors.length} but need #{(nQuant-1)/2+1}",
                     "error_#{chartdivid}")
        qucolors = null
    unless qucolors?
        tmp = d3.schemeCategory10
        qucolors = ["black"]
        for j in d3.range((nQuant-1)/2)
            qucolors.push(tmp[j])
    qucolors = qucolors[0...(nQuant-1)/2+1] if qucolors.length > (nQuant-1)/2+1
    qucolors = qucolors.reverse()
    for color in qucolors[...-1].reverse()
        qucolors.push(color)

    # curves for quantiles
    curves = svg.append("g").attr("id", "curves")

    for j in [0...nQuant]
        curves.append("path")
           .datum(indindex)
           .attr("d", quline(j))
           .attr("class", "line")
           .attr("stroke", qucolors[j])
           .attr("pointer-events", "none")
           .attr("fill", "none")

    indtip = d3.tip()
               .attr('class', "d3-tip #{widgetdivid}")
               .html((d) -> d)
               .direction('e')
               .offset([0,10])
    svg.call(indtip)

    # vertical rectangles representing each array
    indRectGrp = svg.append("g").attr("id", "indRect")

    indRect = indRectGrp.selectAll("empty")
                       .data(indindex)
                       .enter()
                       .append("rect")
                       .attr("x", (d) -> xScale(d) - recWidth/2)
                       .attr("y", (d) -> yScale(data.quant[nQuant-1][d]))
                       .attr("id", (d) -> "rect#{data.ind[d]}")
                       .attr("width", recWidth)
                       .attr("height", (d) ->
                              yScale(data.quant[0][d]) - yScale(data.quant[nQuant-1][d]))
                       .attr("fill", "purple")
                       .attr("stroke", "none")
                       .attr("opacity", "0")
                       .attr("pointer-events", "none")

    circles = svg.selectAll("empty")
                 .data(indindex)
                 .enter()
                 .append("circle")
                 .attr("cx", (d) -> xScale(d) - recWidth/2)
                 .attr("cy", (d) -> yScale(data.quant[(nQuant-1)/2][d]))
                 .attr("id", (d,i) -> "hiddenpoint#{i}")
                 .attr("r", 1)
                 .attr("opacity", 0)
                 .attr("pointer-events", "none")

    # vertical rectangles representing each array
    longRectGrp = svg.append("g").attr("id", "longRect")

    longRect = indRectGrp.selectAll("empty")
                         .data(indindex)
                         .enter()
                         .append("rect")
                         .attr("x", (d) -> xScale(d) - recWidth/2)
                         .attr("y", margin.top)
                         .attr("width", recWidth)
                         .attr("height", halfheight - margin.top - margin.bottom)
                         .attr("fill", "purple")
                         .attr("stroke", "none")
                         .attr("opacity", "0")

    # label quantiles on right
    rightAxis = svg.append("g").attr("id", "rightAxis")

    rightAxis.selectAll("empty")
             .data(data.qu)
             .enter()
             .append("text")
             .attr("class", "qu")
             .text( (d) -> "#{d*100}%")
             .attr("x", width)
             .attr("y", (d,i) -> yScale(((i+0.5)/nQuant/2 + 0.25) * (topylim[1] - topylim[0]) + topylim[0]))
             .attr("fill", (d,i) -> qucolors[i])
             .attr("text-anchor", "end")
             .attr("dominant-baseline", "middle")

    # box around the outside
    svg.append("rect")
       .attr("x", margin.left)
       .attr("y", margin.top)
       .attr("height", halfheight-margin.top-margin.bottom)
       .attr("width", width-margin.left-margin.right)
       .attr("stroke", "black")
       .attr("stroke-width", 2)
       .attr("fill", "none")

    # lower svg
    lowsvg = d3.select(widgetdiv).select("svg")
               .append("g")
                   .attr("id", "lower_svg")
                   .attr("transform", "translate(0,#{halfheight})")
               .append("svg")
               .attr("height", halfheight)
               .attr("width", width)
               .attr("class", "qtlcharts")

    lo = data.breaks[0] - (data.breaks[1] - data.breaks[0])
    hi = data.breaks[data.breaks.length-1] + (data.breaks[1] - data.breaks[0])

    lowxScale = d3.scaleLinear()
                  .domain([lo, hi])
                  .range([margin.left, width-margin.right])

    lowyScale = d3.scaleLinear()
                  .domain([0, botylim[1]+1])
                  .range([halfheight-margin.bottom, margin.top])

    # gray background
    lowsvg.append("rect")
          .attr("x", margin.left)
          .attr("y", margin.top)
          .attr("height", halfheight-margin.top-margin.bottom)
          .attr("width", width-margin.left-margin.right)
          .attr("stroke", "none")
          .attr("fill", rectcolor)

    # axis on left
    lowBaxisData = lowxScale.ticks(8)
    lowBaxis = lowsvg.append("g").attr("id", "lowBaxis")

    # axis: white lines
    lowBaxis.append("g").selectAll("empty")
            .data(lowBaxisData)
            .enter()
            .append("line")
            .attr("class", "line")
            .attr("class", "axis")
            .attr("y1", margin.top)
            .attr("y2", halfheight-margin.bottom)
            .attr("x1", (d) -> lowxScale(d))
            .attr("x2", (d) -> lowxScale(d))
            .attr("stroke", "white")

    # axis: labels
    lowBaxis.append("g").selectAll("empty")
            .data(lowBaxisData)
            .enter()
            .append("text")
            .attr("class", "axis")
            .text((d) -> d3panels.formatAxis(lowBaxisData)(d))
            .attr("y", halfheight-margin.bottom*0.75)
            .attr("x", (d) -> lowxScale(d))
            .attr("dominant-baseline", "middle")
            .attr("text-anchor", "middle")

    grp4BkgdHist = lowsvg.append("g").attr("id", "bkgdHist")

    histline = d3.line()
                 .x((d,i) -> lowxScale(br2[i]))
                 .y((d) -> lowyScale(d))

    randomInd = indindex[Math.floor(Math.random()*data.ind.length)]

    hist = lowsvg.append("path")
                 .datum(data.counts[randomInd])
                 .attr("d", histline)
                 .attr("id", "histline")
                 .attr("fill", "none")
                 .attr("stroke", "purple")
                 .attr("stroke-width", "2")


    clickStatus = []
    for d in indindex
        clickStatus.push(0)

    longRect.on "mouseover", (d,i) ->
                     d3.select("rect#rect#{data.ind[d]}")
                       .attr("opacity", "1")
                     d3.select("#histline")
                       .datum(data.counts[d])
                       .attr("d", histline)
                     circle = d3.select("circle#hiddenpoint#{i}")
                     indtip.show(data.ind[i], circle.node())
            .on "mouseout", (d) ->
                     indtip.hide()
                     if !clickStatus[d]
                         d3.select("rect#rect#{data.ind[d]}").attr("opacity", "0")

            .on "click", (d) ->
                     clickStatus[d] = 1 - clickStatus[d]
                     d3.select("rect#rect#{data.ind[d]}").attr("opacity", clickStatus[d])
                     if clickStatus[d]
                         curcolor = histcolors.shift()
                         histcolors.push(curcolor)

                         d3.select("rect#rect#{data.ind[d]}").attr("fill", curcolor)

                         grp4BkgdHist.append("path")
                                     .datum(data.counts[d])
                                     .attr("d", histline)
                                     .attr("id", "path#{data.ind[d]}")
                                     .attr("fill", "none")
                                     .attr("stroke", curcolor)
                                     .attr("stroke-width", "2")
                     else
                         d3.select("path#path#{data.ind[d]}").remove()

    # box around the outside
    lowsvg.append("rect")
          .attr("x", margin.left)
          .attr("y", margin.top)
          .attr("height", halfheight-margin.bottom-margin.top)
          .attr("width", width-margin.left-margin.right)
          .attr("stroke", "black")
          .attr("stroke-width", 2)
          .attr("fill", "none")

    svg.append("text")
       .text(ylab)
       .attr("x", margin.left*0.2)
       .attr("y", halfheight/2)
       .attr("fill", "slateblue")
       .attr("transform", "rotate(270 #{margin.left*0.2} #{halfheight/2})")
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "middle")

    lowsvg.append("text")
          .text(ylab)
          .attr("x", (width-margin.left-margin.bottom)/2+margin.left)
          .attr("y", halfheight-margin.bottom*0.2)
          .attr("fill", "slateblue")
          .attr("dominant-baseline", "middle")
          .attr("text-anchor", "middle")

    svg.append("text")
       .text(xlab)
       .attr("x", (width-margin.left-margin.bottom)/2+margin.left)
       .attr("y", halfheight-margin.bottom*0.2)
       .attr("fill", "slateblue")
       .attr("dominant-baseline", "middle")
       .attr("text-anchor", "middle")

    if chartOpts.heading?
        d3.select("div#htmlwidget_container")
          .insert("h2", ":first-child")
          .html(chartOpts.heading)
          .style("font-family", "sans-serif")

    if chartOpts.caption?
        d3.select("body")
          .append("p")
          .attr("class", "caption")
          .html(chartOpts.caption)

    if chartOpts.footer?
        d3.select("body")
          .append("div")
          .html(chartOpts.footer)
          .style("font-family", "sans-serif")

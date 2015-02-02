# iheatmap: Interactive heatmap, linked to curves with the horizontal and vertical slices
# Karl W Broman

iheatmap = (el, data, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 800 # total height of chart
    width  = chartOpts?.width  ? 800 # total width of chart
    htop = chartOpts?.htop ? height/2 # height of top charts in pixels
    wleft = chartOpts?.wleft ? width/2 # width of left charts in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
    nullcolor = chartOpts?.nullcolor ? "#E6E6E6" # color of pixels with null values
    strokecolor = chartOpts?.strokecolor ? "slateblue" # line color
    strokewidth = chartOpts?.strokewidth ? 2 # line width
    xlim = chartOpts?.xlim ? null # x-axis limits
    ylim = chartOpts?.ylim ? null # y-axis limits
    nxticks = chartOpts?.nxticks ? 5 # no. ticks on x-axis
    xticks = chartOpts?.xticks ? null # vector of tick positions on x-axis
    nyticks = chartOpts?.nyticks ? 5 # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
    nzticks = chartOpts?.nzticks ? 5 # no. ticks on z-axis
    zticks = chartOpts?.zticks ? null # vector of tick positions on z-axis
    title = chartOpts?.title ? "" # title for chart
    xlab = chartOpts?.xlab ? "X" # x-axis label
    ylab = chartOpts?.ylab ? "Y" # y-axis label
    zlab = chartOpts?.zlab ? "Z" # z-axis label
    zthresh = chartOpts?.zthresh ? null # lower threshold for plotting in heat map: only values with |z| > zthresh are shown
    zlim = chartOpts?.zlim ? [-matrixMaxAbs(data.z), 0, matrixMaxAbs(data.z)] # z-axis limits
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # heat map colors (same length as `zlim`)
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'

    hbot = height - htop
    wright = width - wleft

    # Select the svg element
    svg = d3.select(el).select("svg")

    unless xlim?
        xlim = d3.extent(data.x)
        xdif = (data.x[1] - data.x[0])/2
        xlim[0] -= xdif
        xlim[1] += xdif
    unless ylim?
        ylim = d3.extent(data.y)
        ydif = (data.y[1] - data.y[0])/2
        ylim[0] -= ydif
        ylim[1] += ydif

    ## configure the three charts
    myheatmap = heatmap().width(wleft-margin.left-margin.right)
                         .height(htop-margin.top-margin.bottom)
                         .margin(margin)
                         .axispos(axispos)
                         .titlepos(titlepos)
                         .rectcolor(rectcolor)
                         .xlim(xlim)
                         .ylim(ylim)
                         .nxticks(nxticks)
                         .xticks(xticks)
                         .nyticks(nyticks)
                         .yticks(yticks)
                         .xlab(xlab)
                         .ylab(ylab)
                         .zlim(zlim)
                         .zthresh(zthresh)
                         .colors(colors)
                         .nullcolor(nullcolor)

    horslice = curvechart().width(wleft-margin.left-margin.right)
                           .height(hbot-margin.top-margin.bottom)
                           .margin(margin)
                           .axispos(axispos)
                           .titlepos(titlepos)
                           .rectcolor(rectcolor)
                           .xlim(xlim)
                           .ylim(d3.extent(zlim))
                           .nxticks(nxticks)
                           .xticks(xticks)
                           .nyticks(nzticks)
                           .yticks(zticks)
                           .xlab(xlab)
                           .ylab(zlab)
                           .strokecolor("")
                           .commonX(true)

    verslice = curvechart().width(wright-margin.left-margin.right)
                           .height(htop-margin.top-margin.bottom)
                           .margin(margin)
                           .axispos(axispos)
                           .titlepos(titlepos)
                           .rectcolor(rectcolor)
                           .xlim(ylim)
                           .ylim(d3.extent(zlim))
                           .nxticks(nyticks)
                           .xticks(yticks)
                           .nyticks(nzticks)
                           .yticks(zticks)
                           .xlab(ylab)
                           .ylab(zlab)
                           .strokecolor("")
                           .commonX(true)

    ## now make the actual charts
    g_heatmap = svg.append("g")
                   .attr("id", "heatmap")
                   .datum(data)
                   .call(myheatmap)

    formatX = formatAxis(data.x)
    formatY = formatAxis(data.y)

    cells = myheatmap.cellSelect()
                     .on "mouseover", (d,i) ->
                             g_verslice.select("g.title text").text("X = #{formatX(d.x)}")
                             g_horslice.select("g.title text").text("Y = #{formatY(d.y)}")
                             plotVer(d.i)
                             plotHor(d.j)
                     .on "mouseout", (d,i) ->
                             g_verslice.select("g.title text").text("")
                             g_horslice.select("g.title text").text("")
                             removeVer()
                             removeHor()

    g_horslice = svg.append("g")
                    .attr("id", "horslice")
                    .attr("transform", "translate(0,#{htop})")
                    .datum({x:data.x, data:[pullVarAsArray(data.z, 0)]})
                    .call(horslice)

    g_verslice = svg.append("g")
                    .attr("id", "verslice")
                    .attr("transform", "translate(#{wleft},0)")
                    .datum({x:data.y, data:[data.z[0]]})
                    .call(verslice)

    # functions for paths
    horcurvefunc = (j) ->
            d3.svg.line()
              .x((d) -> horslice.xscale()(d))
              .y((d,i) -> horslice.yscale()(data.z[i][j]))
    vercurvefunc = (i) ->
            d3.svg.line()
              .x((d) -> verslice.xscale()(d))
              .y((d,j) -> verslice.yscale()(data.z[i][j]))


    plotHor = (j) ->
        g_horslice.append("g").attr("id", "horcurve")
                  .append("path")
                  .datum(data.x)
                  .attr("d", horcurvefunc(j))
                  .attr("stroke", strokecolor)
                  .attr("fill", "none")
                  .attr("stroke-width", strokewidth)
                  .attr("style", "pointer-events", "none")

    removeHor = () ->
        g_horslice.selectAll("g#horcurve").remove()

    plotVer = (i) ->
        g_verslice.append("g").attr("id", "vercurve")
                  .append("path")
                  .datum(data.y)
                  .attr("d", vercurvefunc(i))
                  .attr("stroke", strokecolor)
                  .attr("fill", "none")
                  .attr("stroke-width", strokewidth)
                  .attr("style", "pointer-events", "none")

    removeVer = () ->
        g_verslice.selectAll("g#vercurve").remove()

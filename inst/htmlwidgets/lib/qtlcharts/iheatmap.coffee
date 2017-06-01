# iheatmap: Interactive heatmap, linked to curves with the horizontal and vertical slices
# Karl W Broman

iheatmap = (widgetdiv, data, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 800               # total height of chart
    width  = chartOpts?.width  ? 800               # total width of chart
    htop = chartOpts?.htop ? height/2              # height of top charts in pixels
    wleft = chartOpts?.wleft ? width/2             # width of left charts in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:0} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}     # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20            # position of chart title in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"   # color of background rectangle
    nullcolor = chartOpts?.nullcolor ? "#E6E6E6"   # color of pixels with null values
    linecolor = chartOpts?.linecolor ? "slateblue" # line color
    linewidth = chartOpts?.linewidth ? 2           # line width
    xlim = chartOpts?.xlim ? null                  # x-axis limits
    ylim = chartOpts?.ylim ? null                  # y-axis limits
    nxticks = chartOpts?.nxticks ? 5               # no. ticks on x-axis
    xticks = chartOpts?.xticks ? null              # vector of tick positions on x-axis
    nyticks = chartOpts?.nyticks ? 5               # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null              # vector of tick positions on y-axis
    nzticks = chartOpts?.nzticks ? 5               # no. ticks on z-axis
    zticks = chartOpts?.zticks ? null              # vector of tick positions on z-axis
    title = chartOpts?.title ? ""                  # title for chart
    xlab = chartOpts?.xlab ? "X"                   # x-axis label
    ylab = chartOpts?.ylab ? "Y"                   # y-axis label
    zlab = chartOpts?.zlab ? "Z"                   # z-axis label
    zthresh = chartOpts?.zthresh ? null            # lower threshold for plotting in heat map: only values with |z| > zthresh are shown
    zlim = chartOpts?.zlim ? [-d3panels.matrixMaxAbs(data.z), 0, d3panels.matrixMaxAbs(data.z)] # z-axis limits
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # heat map colors (same length as `zlim`)
    flip_vert_slice = chartOpts?.flip_vert_slice ? false            # if true, flip the y- and z- axes in the vertical slice
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 40, inner:0})
    axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})

    hbot = height - htop
    wright = width - wleft

    # Select the svg element
    svg = d3.select(widgetdiv).select("svg")

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

    # transpose of z matrix
    z_transpose = d3panels.transpose(data.z)

    ## configure the three charts
    myheatmap = d3panels.heatmap({
        width:wleft
        height:htop
        margin:margin
        axispos:axispos
        titlepos:titlepos
        rectcolor:rectcolor
        xlim:xlim
        ylim:ylim
        nxticks:nxticks
        xticks:xticks
        nyticks:nyticks
        yticks:yticks
        xlab:xlab
        ylab:ylab
        zlim:zlim
        zthresh:zthresh
        colors:colors
        nullcolor:nullcolor
        tipclass:widgetdivid})

    horslice = d3panels.panelframe({
        width:wleft
        height:hbot
        margin:margin
        axispos:axispos
        titlepos:titlepos
        rectcolor:rectcolor
        xlim:xlim
        ylim:d3.extent(zlim)
        nxticks:nxticks
        xticks:xticks
        nyticks:nzticks
        yticks:zticks
        xlab:xlab
        ylab:zlab})

    ver_opts = {
        width:wright
        height:htop
        margin:margin
        axispos:axispos
        titlepos:titlepos
        rectcolor:rectcolor
        xlim:ylim
        ylim:d3.extent(zlim)
        nxticks:nyticks
        xticks:yticks
        nyticks:nzticks
        yticks:zticks
        xlab:ylab
        ylab:zlab}
    if flip_vert_slice # flip the vertical slice (top-right panel)
        [ver_opts.xlab, ver_opts.ylab] = [ver_opts.ylab, ver_opts.xlab]
        [ver_opts.xlim, ver_opts.ylim] = [ver_opts.ylim, ver_opts.xlim]
        [ver_opts.xticks, ver_opts.yticks] = [ver_opts.yticks, ver_opts.xticks]
        [ver_opts.nxticks, ver_opts.nyticks] = [ver_opts.nyticks, ver_opts.nxticks]
    verslice = d3panels.panelframe(ver_opts)

    ## now make the actual charts
    # heatmap
    g_heatmap = svg.append("g")
                   .attr("id", "heatmap")
    myheatmap(g_heatmap, data)

    # horizontal slice (below)
    g_horslice = svg.append("g")
                    .attr("id", "horslice")
                    .attr("transform", "translate(0,#{htop})")
    horslice(g_horslice)

    # vertical slice (to the right)
    g_verslice = svg.append("g")
                    .attr("id", "verslice")
                    .attr("transform", "translate(#{wleft},0)")
    verslice(g_verslice)

    formatX = d3panels.formatAxis(data.x)
    formatY = d3panels.formatAxis(data.y)

    cells = myheatmap.cells()
                     .on "mouseover", (d,i) ->
                             g_verslice.select("g.title text").text("X = #{formatX(d.x)}")
                             g_horslice.select("g.title text").text("Y = #{formatY(d.y)}")
                             plotVer(d.xindex)
                             plotHor(d.yindex)
                     .on "mouseout", (d,i) ->
                             g_verslice.select("g.title text").text("")
                             g_horslice.select("g.title text").text("")

    vercurve = null
    horcurve = null

    plotHor = (j) ->
        horcurve.remove() if horcurve?
        horcurve = d3panels.add_curves({
            linecolor: linecolor
            linewidth: linewidth})
        horcurve(horslice, {x:[data.x], y:[z_transpose[j]]})

    plotVer = (i) ->
        vercurve.remove() if vercurve?
        vercurve = d3panels.add_curves({
            linecolor: linecolor
            linewidth: linewidth})
        if flip_vert_slice
            vercurve(verslice, {y:[data.y], x:[data.z[i]]})
        else
            vercurve(verslice, {x:[data.y], y:[data.z[i]]})

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

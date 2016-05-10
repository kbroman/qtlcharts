# iplotMScanone_noeff: image of lod curves linked to plot of lod curves
# Karl W Broman

iplotMScanone_noeff = (widgetdiv, lod_data, times, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 700 # height of chart in pixels
    width = chartOpts?.width ? 1000 # width of chart in pixels
    wleft = chartOpts?.wleft ? width*0.65 # width of left panels in pixels
    htop = chartOpts?.htop ? height/2 # height of top panels in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:0} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    chrGap = chartOpts?.chrGap ? 8 # gap between chromosomes in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of lighter background rectangle
    altrectcolor = chartOpts?.altrectcolor ? "#C8C8C8" # color of darker background rectangle
    nullcolor = chartOpts?.nullcolor ? "#E6E6E6" # color for pixels with null values
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # heat map colors
    zlim = chartOpts?.zlim ? null # z-axis limits
    zthresh = chartOpts?.zthresh ? null # lower z-axis threshold for display in heat map
    lod_ylab = chartOpts?.lod_ylab ? "" # y-axis label for LOD heatmap (also used as x-axis label on effect plot)
    linecolor = chartOpts?.linecolor ? "darkslateblue" # color of lines
    linewidth = chartOpts?.linewidth ? 2 # width of lines
    pointcolor = chartOpts?.pointcolor ? "slateblue" # color of points in at markers in LOD curves
    pointsize = chartOpts?.pointsize ? 0 # size of points in LOD curves (default = 0 corresponding to no visible points at markers)
    pointstroke = chartOpts?.pointstroke ? "black" # color of outer circle for points at markers
    nxticks = chartOpts?.nxticks ? 5 # no. ticks in x-axis on right-hand panel, if quantitative scale
    xticks = chartOpts?.xticks ? null # tick positions in x-axis on right-hand panel, if quantitative scale
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    wright = width - wleft
    hbot = height - htop

    # fill in zlim
    zmax = d3panels.matrixMaxAbs(lod_data.lod)
    zlim = zlim ? [-zmax, 0, zmax]

    # a bit more data set up
    if times?
        lod_data.y = times
    else
        lod_data.ycat = lod_data.lodnames

    # set up heatmap
    mylodheatmap = d3panels.lodheatmap({
        height:htop
        width:wleft
        margin:margin
        axispos:axispos
        titlepos:titlepos
        chrGap:chrGap
        rectcolor:rectcolor
        altrectcolor:altrectcolor
        colors:colors
        zlim:zlim
        zthresh:zthresh
        ylab:lod_ylab
        nullcolor:nullcolor
        tipclass:widgetdivid})

    svg = d3.select(widgetdiv).select("svg")

    g_heatmap = svg.append("g")
                   .attr("id", "heatmap")
    mylodheatmap(g_heatmap, lod_data)

    # lod vs position panel
    mylodchart = d3panels.lodchart({
        height:hbot
        width:wleft
        margin:margin
        axispos:axispos
        titlepos:titlepos
        chrGap:chrGap
        pad4heatmap:true
        altrectcolor:altrectcolor
        rectcolor:rectcolor
        linecolor: ""
        ylim:[0, zlim[2]*1.05]
        pointsAtMarkers:false
        tipclass:widgetdivid})

    g_lodchart = svg.append("g")
                    .attr("transform", "translate(0,#{htop})")
                    .attr("id", "lodchart")
    mylodchart(g_lodchart, {
        chr:lod_data.chr
        pos:lod_data.pos
        lod:(lod_data.lod[i][0] for i of lod_data.pos)
        marker:lod_data.marker
        chrname:lod_data.chrname})

    # plot lod curves for selected lod column
    lodchart_curve = null
    plotLodCurve = (lodcolumn) ->
        lodchart_curve.remove() if lodchart_curve?

        lodchart_curve = d3panels.add_lodcurve({
            linecolor: linecolor
            linewidth: linewidth
            pointsize: pointsize
            pointcolor: pointcolor
            pointstroke: pointstroke})
        lodchart_curve(mylodchart, {
            chr:lod_data.chr
            pos:lod_data.pos
            marker:lod_data.marker
            lod:(lod_data.lod[i][lodcolumn] for i of lod_data.pos)
            chrname:lod_data.chrname})

    # lod versus phenotype panel
    x = if times? then times else (i for i of lod_data.lod[0])
    xlim = if times? then d3.extent(times) else [-0.5, x.length-0.5]
    nxticks = if times? then nxticks else 0
    lodvphe = d3panels.panelframe({
        height:htop
        width:wright
        margin:margin
        axispos:axispos
        titlepos:titlepos
        xlab:lod_ylab
        ylab:"LOD score"
        rectcolor:rectcolor
        xlim: xlim
        ylim:[0, zlim[2]*1.05]
        nxticks:nxticks
        tipclass:widgetdivid})

    g_lodvphe = svg.append("g")
                      .attr("transform", "translate(#{wleft},0)")
                      .attr("id", "curvechart")
    lodvphe(g_lodvphe)

    # plot lod versus phenotype curve
    lodvphe_curve = null
    plot_lodvphe = (posindex) ->
        lodvphe_curve.remove() if lodvphe_curve?
        lodvphe_curve = d3panels.add_curves({
            linecolor:linecolor
            linewidth:linewidth})
        lodvphe_curve(lodvphe, {
            x:[x]
            y:[(lod_data.lod[posindex][i] for i of lod_data.lod[posindex])]})

    # hash for [chr][pos] -> posindex
    lod_data.posIndexByChr = d3panels.reorgByChr(lod_data.chrname, lod_data.chr, (i for i of lod_data.pos))

    mylodheatmap.cells()
                .on "mouseover", (d) ->
                         plotLodCurve(d.lodindex)
                         g_lodchart.select("g.title text").text("#{lod_data.lodnames[d.lodindex]}")
                         plot_lodvphe(lod_data.posIndexByChr[d.chr][d.posindex])
                         p = d3.format(".1f")(d.pos)
                         g_lodvphe.select("g.title text").text("#{d.chr}@#{p}")
                         g_lodvphe.select("text#xaxis#{d.lodindex}").attr("opacity", 1) unless times?
                .on "mouseout", (d) ->
                         g_lodchart.select("g.title text").text("")
                         g_lodvphe.select("g.title text").text("")
                         g_lodvphe.select("text#xaxis#{d.lodindex}").attr("opacity", 0) unless times?

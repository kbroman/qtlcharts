# iplotMScanone_noeff: image of lod curves linked to plot of lod curves
# Karl W Broman

iplotMScanone_noeff = (widgetdiv, lod_data, times, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 700                               # height of chart in pixels
    width = chartOpts?.width ? 1000                                # width of chart in pixels
    title = chartOpts?.title ? ""                                  # title for chart
    wleft = chartOpts?.wleft ? width*0.65                          # width of left panels in pixels
    htop = chartOpts?.htop ? height/2                              # height of top panels in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:0} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}     # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20                            # position of chart title in pixels
    chrGap = chartOpts?.chrGap ? 6                                 # gap between chromosomes in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"                   # color of lighter background rectangle
    altrectcolor = chartOpts?.altrectcolor ? "#C8C8C8"             # color of darker background rectangle
    nullcolor = chartOpts?.nullcolor ? "#E6E6E6"                   # color for pixels with null values
    chrlinecolor = chartOpts?.chrlinecolor ? ""                    # color of lines between chromosomes (if "", leave off)
    chrlinewidth = chartOpts?.chrlinewidth ? 2                     # width of lines between chromosomes
    colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # heat map colors
    zlim = chartOpts?.zlim ? null                                  # z-axis limits
    zthresh = chartOpts?.zthresh ? null                            # lower z-axis threshold for display in heat map
    xlab = chartOpts?.xlab ? null                                  # x-axis label for LOD heatmap)
    ylab = chartOpts?.ylab ? ""                                    # y-axis label for LOD heatmap (also used as x-axis label on effect plot)
    zlab = chartOpts?.zlab ? "LOD score"                           # z-axis label for LOD heatmap (really just used as y-axis label in the two slices)
    linecolor = chartOpts?.linecolor ? "darkslateblue"             # color of LOD curves
    linewidth = chartOpts?.linewidth ? 2                           # width of LOD curves
    pointsize = chartOpts?.pointsize ? 0                           # size of points in vertical slice (default = 0 corresponds plotting curves rather than points)
    pointcolor = chartOpts?.pointcolor ? "slateblue"               # color of points in vertical slice
    pointcolorhilit = chartOpts?.pointcolorhilit ? "crimson"       # color of highlighted point in vertical slice
    pointstroke = chartOpts?.pointstroke ? "black"                 # color of outer circle for points in vertical slice
    nxticks = chartOpts?.nxticks ? 5     # no. ticks in x-axis on right-hand panel, if quantitative scale
    xticks = chartOpts?.xticks ? null    # tick positions in x-axis on right-hand panel, if quantitative scale
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 40, inner:5})
    axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})

    wright = width - wleft
    hbot = height - htop

    # fill in zlim
    zmax = d3panels.matrixMaxAbs(lod_data.lod)
    zlim = zlim ? [-zmax, 0, zmax]

    # a bit more data set up
    if times?
        lod_data.y = times
    else
        lod_data.ycat = lod_data.lodname

    # hash for [chr][pos] -> posindex
    lod_data.posIndexByChr = d3panels.reorgByChr(lod_data.chrname, lod_data.chr, (i for i of lod_data.pos))

    # use the lod labels for the lod names
    lod_data.lodname = lod_labels if lod_labels?

    # create chrname, chrstart, chrend if missing
    lod_data.chrname = d3panels.unique(lod_data.chr) unless lod_data.chrname?
    unless lod_data.chrstart?
        lod_data.chrstart = []
        for c in lod_data.chrname
            these_pos = (lod_data.pos[i] for i of lod_data.chr when lod_data.chr[i] == c)
            lod_data.chrstart.push(d3.min(these_pos))
    unless lod_data.chrend?
        lod_data.chrend = []
        for c in lod_data.chrname
            these_pos = (lod_data.pos[i] for i of lod_data.chr when lod_data.chr[i] == c)
            lod_data.chrend.push(d3.max(these_pos))

    # phenotype x-axis
    x = if times? then times else (i for i of lod_data.lod[0])
    xlim = if times? then d3.extent(times) else [-0.5, x.length-0.5]
    nxticks = if times? then nxticks else 0
    xticks = if times? then xticks else null

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
        chrlinecolor:chrlinecolor
        chrlinewidth:chrlinewidth
        colors:colors
        title: title
        zlim:zlim
        zthresh:zthresh
        ylab:ylab
        yticks:xticks
        nyticks:nxticks
        nullcolor:nullcolor
        tipclass:widgetdivid})

    # add the heatmap
    svg = d3.select(widgetdiv).select("svg")
    g_heatmap = svg.append("g")
                   .attr("id", "heatmap")
    mylodheatmap(g_heatmap, lod_data)

    # lod vs position (horizontal) panel
    horpanel = d3panels.chrpanelframe({
        height:hbot
        width:wleft
        margin:margin
        axispos:axispos
        titlepos:titlepos
        chrGap:chrGap
        rectcolor:rectcolor
        altrectcolor:altrectcolor
        chrlinecolor:chrlinecolor
        chrlinewidth:chrlinewidth
        xlab:xlab
        ylab:zlab
        ylim:[0, zlim[2]*1.05]
        tipclass:widgetdivid})

    # create empty panel
    g_horpanel = svg.append("g")
                    .attr("transform", "translate(0,#{htop})")
                    .attr("id", "lodchart")
    horpanel(g_horpanel, {chr:lod_data.chrname, start:lod_data.chrstart, end:lod_data.chrend})

    # plot lod curves for selected lod column
    horslice = null
    plotHorSlice = (lodcolumn) ->
        horslice = d3panels.add_lodcurve({
            linecolor: linecolor
            linewidth: linewidth
            pointsize: 0
            pointcolor: ""
            pointstroke: ""})
        horslice(horpanel, {
            chr:lod_data.chr
            pos:lod_data.pos
            marker:lod_data.marker
            lod:(d3panels.abs(lod_data.lod[i][lodcolumn]) for i of lod_data.pos)
            chrname:lod_data.chrname})

    # lod versus phenotype (vertical) panel
    verpanel = d3panels.panelframe({
        height:htop
        width:wright
        margin:margin
        axispos:axispos
        titlepos:titlepos
        xlab:ylab
        ylab:zlab
        rectcolor:rectcolor
        xlim: xlim
        ylim:[0, zlim[2]*1.05]
        nxticks:nxticks
        xticks:xticks
        tipclass:widgetdivid})

    g_verpanel = svg.append("g")
                      .attr("transform", "translate(#{wleft},0)")
                      .attr("id", "curvechart")
    verpanel(g_verpanel)

    # add x-axis test if qualitative x-axis scale
    unless times?
        verpanel_axis_text = g_verpanel.append("g")
                                       .attr("class", "x axis")
                                       .append("text")
                                       .text("")
                                       .attr("y", htop-margin.bottom+axispos.xlabel)
        verpanel_xscale = verpanel.xscale()


    # plot lod versus phenotype curve
    verslice = null
    plotVerSlice = (posindex) ->
        if pointsize > 0 # plot points rather than curves
            verslice = d3panels.add_points({
                pointsize:pointsize
                pointcolor:pointcolor
                pointstroke:pointstroke})
            verslice(verpanel, {
                x:x
                y:(lod_data.lod[posindex][i] for i of lod_data.lod[posindex])})
        else             # plot curves rather than points
            verslice = d3panels.add_curves({
                linecolor:linecolor
                linewidth:linewidth})
            verslice(verpanel, {
                x:[x]
                y:[(lod_data.lod[posindex][i] for i of lod_data.lod[posindex])]})

    mylodheatmap.cells()
                .on "mouseover", (event, d) ->
                         plotHorSlice(d.lodindex)
                         g_horpanel.select("g.title text").text("#{lod_data.lodname[d.lodindex]}")
                         plotVerSlice(lod_data.posIndexByChr[d.chr][d.posindex])
                         p = d3.format(".1f")(d.pos)
                         g_verpanel.select("g.title text").text("#{d.chr}@#{p}")
                         unless times?
                             verpanel_axis_text.text("#{lod_data.lodname[d.lodindex]}")
                                               .attr("x", verpanel_xscale(d.lodindex))
                         if pointsize > 0
                             verslice.points()
                                     .attr("fill", (z,i) ->
                                         return pointcolorhilit if i==d.lodindex
                                         pointcolor)
                .on "mouseout", () ->
                         horslice.remove() if horslice?
                         verslice.remove() if verslice?
                         g_horpanel.select("g.title text").text("")
                         g_verpanel.select("g.title text").text("")
                         verpanel_axis_text.text("") unless times?
                         if pointsize > 0
                             verslice.points().attr("fill", pointcolor)

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

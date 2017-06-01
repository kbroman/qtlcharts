# iplotScanone_noeff: LOD curves (nothing else)
# Karl W Broman

iplotScanone_noeff = (widgetdiv, data, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 450                            # height of image in pixels
    width = chartOpts?.width ? 900                              # width of image in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}     # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20                         # position of chart title in pixels
    ylim = chartOpts?.ylim ? chartOpts?.lod_ylim ? null         # y-axis limits
    nyticks = chartOpts?.nyticks ? chartOpts?.lod_nyticks ? 5   # number of ticks in y-axis
    yticks = chartOpts?.yticks ? chartOpts?.lod_yticks ? null   # vector of tick positions for y-axis
    chrGap = chartOpts?.chrGap ? 6                              # gap between chromosomes in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"                # color of background rectangle
    altrectcolor = chartOpts?.altrectcolor ? "#C8C8C8"          # color of alternate background rectangle
    linecolor = chartOpts?.linecolor ? chartOpts?.lod_linecolor ? "darkslateblue" # line color for LOD curves
    linewidth = chartOpts?.linewidth ? chartOpts?.lod_linewidth ? 2               # line width for LOD curves
    pointcolor = chartOpts?.pointcolor ? chartOpts?.lod_pointcolor ? "#E9CFEC"    # color for points at markers
    pointsize = chartOpts?.pointsize ? chartOpts?.lod_pointsize ? 0               # size of points at markers (default = 0 corresponding to no visible points at markers)
    pointstroke = chartOpts?.pointstroke ? chartOpts?.lod_pointstroke ? "black"   # color of outer circle for points at markers
    title = chartOpts?.title ? chartOpts?.lod_title ? ""        # title of chart
    xlab = chartOpts?.xlab ? chartOpts?.lod_xlab ? null         # x-axis label
    ylab = chartOpts?.ylab ? chartOpts?.lod_ylab ? "LOD score"  # y-axis label
    rotate_ylab = chartOpts?.rotate_ylab ? chartOpts?.lod_rotate_ylab ? null      # indicates whether to rotate the y-axis label 90 degrees
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 40, inner:5})
    axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})

    mylodchart = d3panels.lodchart({
        height:height
        width:width
        margin:margin
        axispos:axispos
        titlepos:titlepos
        ylim:ylim
        nyticks:nyticks
        yticks:yticks
        chrGap:chrGap
        rectcolor:rectcolor
        altrectcolor:altrectcolor
        linecolor:linecolor
        linewidth:linewidth
        pointcolor:pointcolor
        pointsize:pointsize
        pointstroke:pointstroke
        title:title
        xlab:xlab
        ylab:ylab
        rotate_ylab:rotate_ylab
        tipclass:widgetdivid})

    mylodchart(d3.select(widgetdiv).select("svg"), data)

    # animate points at markers on click
    mylodchart.markerSelect()
              .on "click", (d) ->
                    r = d3.select(this).attr("r")
                    d3.select(this)
                      .transition().duration(500).attr("r", r*3)
                      .transition().duration(500).attr("r", r)

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

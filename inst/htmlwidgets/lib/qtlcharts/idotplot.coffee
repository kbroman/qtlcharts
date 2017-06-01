# idotplot: plot of response by category (scatterplot with categorical x)
# Karl W Broman

idotplot = (widgetdiv, data, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 550                 # height of chart in pixels
    width = chartOpts?.width ? 400                   # width of chart in pixels
    title = chartOpts?.title ? ""                    # title for chart
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    xlab = chartOpts?.xlab ? "group"                 # x-axis label
    ylab = chartOpts?.ylab ? "response"              # y-axis label
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}     # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20              # position of chart title in pixels
    jitter = chartOpts?.jitter ? "beeswarm"          # method for jittering points (beeswarm|random|none)
    ylim = chartOpts?.ylim ? null                    # y-axis limits
    yticks = chartOpts?.yticks ? null                # vector of tick positions on y-axis
    nyticks = chartOpts?.nyticks ? 5                 # no. ticks on y-axis
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"     # color of background rectangle
    pointcolor = chartOpts?.pointcolor ? null        # color for points
    pointsize = chartOpts?.pointsize ? 3             # size of points in pixels
    pointstroke = chartOpts?.pointstroke ? "black"   # color of outer circle for points
    yNA = chartOpts?.yNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values (handle=T/F, force=T/F, width, gap)
    xcategories = chartOpts?.xcategories ? null      # group categories
    xcatlabels = chartOpts?.xcatlabels ? null        # labels for group categories
    horizontal = chartOpts?.horizontal ? false       # If true, have genotypes on vertical axis and phenotype on horizontal axis
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 40, inner:5})
    axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})
    yNA = d3panels.check_listarg_v_default(yNA, {handle:true, force:false, width:15, gap:10})

    mychart = d3panels.dotchart({
        height:height
        width:width
        margin:margin
        xcategories:xcategories
        xcatlabels:xcatlabels
        xlab:xlab
        ylab:ylab
        xNA:{handle:false, force:false}
        yNA:{handle:yNA.handle, force:yNA.force}
        yNA_size:{width:yNA.width, gap:yNA.gap}
        title:title
        axispos:axispos
        titlepos:titlepos
        jitter:jitter
        ylim:ylim
        yticks:yticks
        nyticks:nyticks
        rectcolor:rectcolor
        pointcolor:pointcolor
        pointstroke:pointstroke
        pointsize:pointsize
        horizontal:horizontal
        tipclass:widgetdivid})

    mychart(d3.select(widgetdiv).select("svg"), data)

    # increase size of point on mouseover
    mychart.points()
                .on "mouseover", (d) ->
                    d3.select(this).attr("r", pointsize*3)
                .on "mouseout", (d) ->
                    d3.select(this).attr("r", pointsize)

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

# iplot: interactive scatterplot
# Karl W Broman

iplot = (widgetdiv, data, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 500               # height of chart in pixels
    width = chartOpts?.width ? 800                 # width of chart in pixels
    title = chartOpts?.title ? ""                  # title for chart
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}     # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20            # position of chart title in pixels
    xlab = chartOpts?.xlab ? "X"                   # x-axis label
    ylab = chartOpts?.ylab ? "Y"                   # y-axis label
    xlim = chartOpts?.xlim ? null                  # x-axis limits
    xticks = chartOpts?.xticks ? null              # vector of tick positions on x-axis
    nxticks = chartOpts?.nxticks ? 5               # no. ticks on x-axis
    ylim = chartOpts?.ylim ? null                  # y-axis limits
    yticks = chartOpts?.yticks ? null              # vector of tick positions on y-axis
    nyticks = chartOpts?.nyticks ? 5               # no. ticks on y-axis
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"   # color of background rectangle
    pointcolor = chartOpts?.pointcolor ? null      # colors for points
    pointsize = chartOpts?.pointsize ? 3           # size of points in pixels
    pointstroke = chartOpts?.pointstroke ? "black" # color of outer circle for points
    rotate_ylab = chartOpts?.rotate_ylab ? null    # whether to rotate the y-axis label
    xNA = chartOpts?.xNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values (handle=T/F, force=T/F, width, gap)
    yNA = chartOpts?.yNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values (handle=T/F, force=T/F, width, gap)
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:40, bottom: 40, inner:5})
    axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})
    xNA = d3panels.check_listarg_v_default(xNA, {handle:true, force:false, width:15, gap:10})
    yNA = d3panels.check_listarg_v_default(yNA, {handle:true, force:false, width:15, gap:10})

    mychart = d3panels.scatterplot({
        height:height
        width:width
        margin:margin
        axispos:axispos
        titlepos:titlepos
        xlab:xlab
        ylab:ylab
        title:title
        ylim:ylim
        xlim:xlim
        xticks:xticks
        nxticks:nxticks
        yticks:yticks
        nyticks:nyticks
        rectcolor:rectcolor
        pointcolor:pointcolor
        pointsize:pointsize
        pointstroke:pointstroke
        rotate_ylab:rotate_ylab
        xNA:{handle:xNA.handle, force:xNA.force}
        xNA_size:{width:xNA.width, gap:xNA.gap}
        yNA:{handle:yNA.handle, force:yNA.force}
        yNA_size:{width:yNA.width, gap:yNA.gap}
        tipclass:widgetdivid})

    mychart(d3.select(widgetdiv).select("svg"), data)

    # increase size of point on mouseover
    mychart.points()
           .on "mouseover", (d) ->
                    d3.select(this).attr("r", pointsize*2)
                                   .raise()
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

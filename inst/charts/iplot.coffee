# iplot: interactive scatterplot
# Karl W Broman

iplot = (data, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 500 # height of chart in pixels
    width = chartOpts?.width ? 800 # width of chart in pixels
    title = chartOpts?.title ? "" # title for chart
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    xlab = chartOpts?.xlab ? "X" # x-axis label
    ylab = chartOpts?.ylab ? "Y" # y-axis label
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    xlim = chartOpts?.xlim ? null # x-axis limits
    xticks = chartOpts?.xticks ? null # vector of tick positions on x-axis
    nxticks = chartOpts?.nxticks ? 5 # no. ticks on x-axis
    ylim = chartOpts?.ylim ? null # y-axis limits
    yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
    nyticks = chartOpts?.nyticks ? 5 # no. ticks on y-axis
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
    pointcolor = chartOpts?.pointcolor ? null # colors for points
    pointsize = chartOpts?.pointsize ? 3 # size of points in pixels
    pointstroke = chartOpts?.pointstroke ? "black" # color of outer circle for points
    rotate_ylab = chartOpts?.rotate_ylab ? null # whether to rotate the y-axis label
    xNA = chartOpts?.xNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values (handle=T/F, force=T/F, width, gap)
    yNA = chartOpts?.yNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values (handle=T/F, force=T/F, width, gap)
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'

    mychart = scatterplot().height(height)
                           .width(width)
                           .margin(margin)
                           .axispos(axispos)
                           .titlepos(titlepos)
                           .xlab(xlab)
                           .ylab(ylab)
                           .title(title)
                           .ylim(ylim)
                           .xlim(xlim)
                           .xticks(xticks)
                           .nxticks(nxticks)
                           .yticks(yticks)
                           .nyticks(nyticks)
                           .rectcolor(rectcolor)
                           .pointcolor(pointcolor)
                           .pointsize(pointsize)
                           .pointstroke(pointstroke)
                           .rotate_ylab(rotate_ylab)
                           .xNA(xNA)
                           .yNA(yNA)
                           .xvar('x')
                           .yvar('y')
                           .dataByInd(false)

    d3.select("div##{chartdivid}")
      .datum({data:{x:data.x, y:data.y}, group:data.group, indID:data.indID})
      .call(mychart)

    # increase size of point on mouseover
    mychart.pointsSelect()
                .on "mouseover", (d) ->
                    d3.select(this).attr("r", pointsize*2)
                .on "mouseout", (d) ->
                    d3.select(this).attr("r", pointsize)

# iplotMap: interactive plot of a genetic marker map
# Karl W Broman

iplotMap = (data, chartOpts) ->

    # chartOpts start
    width = chartOpts?.width ? 1000 # width of chart in pixels
    height = chartOpts?.height ? 600 # height of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:10} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
    ylim = chartOpts?.ylim ? null # y-axis limits
    nyticks = chartOpts?.nyticks ? 5 # no. ticks on y-axis
    yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
    tickwidth = chartOpts?.tickwidth ? 10 # width of tick marks at markers, in pixels
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
    linecolor = chartOpts?.linecolor ? "slateblue" # color of lines
    linecolorhilit = chartOpts?.linecolorhilit ? "Orchid" # color of lines, when highlighted
    linewidth = chartOpts?.linewidth ? 3 # width of lines
    title = chartOpts?.title ? "" # title for chart
    xlab = chartOpts?.xlab ? "Chromosome" # x-axis label
    ylab = chartOpts?.ylab ? "Position (cM)" # y-axis label
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
  
    mychart = mapchart().height(height)
                        .width(width)
                        .margin(margin)
                        .axispos(axispos)
                        .titlepos(titlepos)
                        .ylim(ylim)
                        .yticks(yticks)
                        .nyticks(nyticks)
                        .tickwidth(tickwidth)
                        .rectcolor(rectcolor)
                        .linecolor(linecolor)
                        .linecolorhilit(linecolorhilit)
                        .linewidth(linewidth)
                        .title(title)
                        .xlab(xlab)
                        .ylab(ylab)
  
    d3.select("div##{chartdivid}")
      .datum(data)
      .call(mychart)

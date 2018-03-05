# scat2scat: scatterplot driving another scatterplot
# Karl W Broman

scat2scat = (widgetdiv, scat1data, scat2data, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 500                 # height of chart in pixels
    width = chartOpts?.width ? 800                   # width of chart in pixels
    title1 = chartOpts?.title1 ? chartOpts?.title ? ""  # title for left panel
    margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}     # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
    titlepos = chartOpts?.titlepos ? 20              # position of chart title in pixels
    xlab1 = chartOpts?.xlab1 ? "X"                   # x-axis label for left panel
    ylab1 = chartOpts?.ylab1 ? "Y"                   # y-axis label for left panel
    xlab2 = chartOpts?.xlab2 ? "X"                   # x-axis label for right panel (can be a vector, with separate values for each dataset in `scat2data`)
    ylab2 = chartOpts?.ylab2 ? "Y"                   # y-axis label for right panel (can be a vector, with separate values for each dataset in `scat2data`)
    xlim1 = chartOpts?.xlim1 ? null                  # x-axis limits for left panel
    xticks1 = chartOpts?.xticks1 ? null              # vector of tick positions on x-axis for left panel
    nxticks1 = chartOpts?.nxticks1 ? 5               # no. ticks on x-axis for left panel
    ylim1 = chartOpts?.ylim1 ? null                  # y-axis limits for left panel
    yticks1 = chartOpts?.yticks1 ? null              # vector of tick positions on y-axis for left panel
    nyticks1 = chartOpts?.nyticks1 ? 5               # no. ticks on y-axis for left panel
    xlim2 = chartOpts?.xlim2 ? null                  # x-axis limits for right panel
    xticks2 = chartOpts?.xticks2 ? null              # vector of tick positions on x-axis for right panel
    nxticks2 = chartOpts?.nxticks2 ? 5               # no. ticks on x-axis for right panel
    ylim2 = chartOpts?.ylim2 ? null                  # y-axis limits for right panel
    yticks2 = chartOpts?.yticks2 ? null              # vector of tick positions on y-axis for right panel
    nyticks2 = chartOpts?.nyticks2 ? 5               # no. ticks on y-axis for right panel
    rectcolor = chartOpts?.rectcolor ? "#E6E6E6"     # color of background rectangle
    pointcolor1 = chartOpts?.pointcolor1 ? null      # colors for points for left panel
    pointsize1 = chartOpts?.pointsize1 ? 3           # size of points in pixels for left panel
    pointstroke1 = chartOpts?.pointstroke1 ? "black" # color of outer circle for points for left panel
    pointcolor2 = chartOpts?.pointcolor2 ? null      # colors for points for right panel
    pointsize2 = chartOpts?.pointsize2 ? 3           # size of points in pixels for right panel
    pointstroke2 = chartOpts?.pointstroke2 ? "black" # color of outer circle for points for right panel
    rotate_ylab1 = chartOpts?.rotate_ylab1 ? null    # whether to rotate the y-axis label in left panel
    rotate_ylab2 = chartOpts?.rotate_ylab2 ? null    # whether to rotate the y-axis label in right panel
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

    # force xlab2, ylab2 to be arrays of character strings of length scat2data
    xlab2 = d3panels.expand2vector(xlab2, scat2data.length)
    ylab2 = d3panels.expand2vector(ylab2, scat2data.length)

    leftchart = d3panels.scatterplot({
        height:height
        width:width/2
        margin:margin
        axispos:axispos
        titlepos:titlepos
        xlab:xlab1
        ylab:ylab1
        title:title1
        ylim:ylim1
        xlim:xlim1
        xticks:xticks1
        nxticks:nxticks1
        yticks:yticks1
        nyticks:nyticks1
        rectcolor:rectcolor
        pointcolor:pointcolor1
        pointsize:pointsize1
        pointstroke:pointstroke1
        rotate_ylab:rotate_ylab1
        xNA:{handle:xNA.handle, force:xNA.force}
        xNA_size:{width:xNA.width, gap:xNA.gap}
        yNA:{handle:yNA.handle, force:yNA.force}
        yNA_size:{width:yNA.width, gap:yNA.gap}
        tipclass:widgetdivid})

    svg = d3.select(widgetdiv).select("svg")
    g_left = svg.append("g").attr("id", "scat1")
    leftchart(g_left, scat1data)

    # increase size of point on mouseover
    leftchart.points()
           .on "mouseover", (d) ->
                    d3.select(this).attr("r", pointsize1*2)
           .on "mouseout", (d) ->
                    d3.select(this).attr("r", pointsize1)
           .on "click", (d,i) ->
                    rightchart.remove() if rightchart?
                    make_right_chart(i)

    rightchart = null

    g_right = svg.append("g").attr("id", "scat2")
                 .attr("transform", "translate(#{width/2},0)")

    make_right_chart = (index) ->

        rightchart = d3panels.scatterplot({
            height:height
            width:width/2
            margin:margin
            axispos:axispos
            titlepos:titlepos
            xlab:xlab2[index]
            ylab:ylab2[index]
            title:scat1data.indID[index]
            ylim:ylim2
            xlim:xlim2
            xticks:xticks2
            nxticks:nxticks2
            yticks:yticks2
            nyticks:nyticks2
            rectcolor:rectcolor
            pointcolor:pointcolor2
            pointsize:pointsize2
            pointstroke:pointstroke2
            rotate_ylab:rotate_ylab2
            xNA:{handle:xNA.handle, force:xNA.force}
            xNA_size:{width:xNA.width, gap:xNA.gap}
            yNA:{handle:yNA.handle, force:yNA.force}
            yNA_size:{width:yNA.width, gap:yNA.gap}
            tipclass:widgetdivid})

        rightchart(g_right, scat2data[index])

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

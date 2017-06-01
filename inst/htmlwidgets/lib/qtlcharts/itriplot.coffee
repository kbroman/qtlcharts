# itriplot: interactive plot of trinomial probabilities
# Karl W Broman

itriplot = (widgetdiv, data, chartOpts) ->

    # chartOpts start
    width = chartOpts?.width ? 600                      # overall width of chart in pixels
    height = chartOpts?.height ? 520                    # overall height of chart in pixels
    margin = chartOpts?.margin ? {left:60, top:40, right:60, bottom: 10} # margins in pixels (left, top, right, bottom)
    labelpos = chartOpts?.labelpos ? 10                 # pixels between vertex and vertex label (horizontally)
    titlepos = chartOpts?.titlepos ? 20                 # position of chart title in pixels
    title = chartOpts?.title ? ""                       # chart title
    labels = chartOpts?.labels ? ["(1,0,0)", "(0,1,0)", "(0,0,1)"] # labels on the corners
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6"        # color of background rectangle
    boxcolor = chartOpts?.boxcolor ? "black"            # color of outer rectangle box
    boxwidth = chartOpts?.boxwidth ? 2                  # width of outer box in pixels
    pointcolor = chartOpts?.pointcolor ? null           # fill color of points
    pointstroke = chartOpts?.pointstroke ? "black"      # color of points' outer circle
    pointsize = chartOpts?.pointsize ? 3                # color of points
    tipclass = chartOpts?.tipclass ? "tooltip"          # class name for tool tips
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'
    widgetdivid = d3.select(widgetdiv).attr('id')

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:40, right:60, bottom: 10})

    mychart = d3panels.trichart({
        height:height
        width:width
        margin:margin
        labelpos:labelpos
        titlepos:titlepos
        title:title
        labels:labels
        rectcolor:rectcolor
        boxcolor:boxcolor
        boxwidth:boxwidth
        pointcolor:pointcolor
        pointsize:pointsize
        pointstroke:pointstroke
        tipclass:widgetdivid})

    mychart(d3.select(widgetdiv).select("svg"), data)

    # increase size of point on mouseover
    mychart.points()
           .on "mouseover", (d) ->
                    d3.select(this).attr("r", pointsize*2)
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

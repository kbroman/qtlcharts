# iplotScantwo: interactive plot of scantwo results (2-dim, 2-QTL genome scan)
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotScantwo",
    type: "output",

    initialize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).append("svg")
          .attr("class", "qtlcharts")
          .attr("width", width)
          .attr("height", height-24) # 24 = form div height

    renderValue: (widgetdiv, x) ->
        svg = d3.select(widgetdiv).select("svg")

        # clear svg and remove tool tips
        svg.selectAll("*").remove()
        widgetid = d3.select(widgetdiv).attr('id')
        d3.selectAll("g.d3panels-tooltip.#{widgetid}").remove()

        chartOpts = x.chartOpts ? {}
        chartOpts.width = chartOpts?.width ? svg.attr("width")
        chartOpts.height = chartOpts?.height ? +svg.attr("height")+24 # 24 = form height
        chartOpts.height -= 24 # 24 = form height

        svg.attr("width", chartOpts.width)
        svg.attr("height", chartOpts.height)

        iplotScantwo(widgetdiv, x.scantwo_data, x.phenogeno_data, chartOpts)

    resize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).select("svg")
          .attr("width", width)
          .attr("height", height)

})

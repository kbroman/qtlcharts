# iplotMap: interactive plot of a genetic marker map
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotMap",
    type: "output",

    initialize: (widgetdiv, width, height) ->
        add_search_box(widgetdiv)

        d3.select(widgetdiv).append("svg")
          .attr("width", width)
          .attr("height", height-19) # adjustment for marker search box
          .attr("class", "qtlcharts")

    renderValue: (widgetdiv, x) ->

        svg = d3.select(widgetdiv).select("svg")

        # clear svg and remove tool tips
        svg.selectAll("*").remove()
        widgetid = d3.select(widgetdiv).attr('id')
        d3.selectAll("g.d3panels-tooltip.#{widgetid}").remove()

        chartOpts = x.chartOpts ? [ ]
        chartOpts.width = chartOpts?.width ? svg.attr("width")
        chartOpts.height = chartOpts?.height ? svg.attr("height")

        svg.attr("width", chartOpts.width)
        svg.attr("height", chartOpts.height)

        iplotMap(widgetdiv, x.data, chartOpts)

    resize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).select("svg")
          .attr("width", width)
          .attr("height", height)

})

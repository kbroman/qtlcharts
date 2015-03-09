# iplotRF: interactive plot of pairwise recombination fractions
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotRF",
    type: "output",

    initialize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).append("svg")
          .attr("class", "qtlcharts")
          .attr("width", width)
          .attr("height", height)

    renderValue: (widgetdiv, x) ->
        svg = d3.select(widgetdiv).select("svg")

        chartOpts = x.chartOpts ? {}
        chartOpts.width = chartOpts?.width ? svg.attr("width")
        chartOpts.height = chartOpts?.height ? svg.attr("height")

        svg.attr("width", chartOpts.width)
        svg.attr("height", chartOpts.height)

        iplotRF(widgetdiv, x.rfdata, x.genodata, x.chartOpts)

    resize: (widgetdiv, width, height) -> null

})

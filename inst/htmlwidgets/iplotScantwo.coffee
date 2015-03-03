# iplotScantwo: interactive plot of scantwo results (2-dim, 2-QTL genome scan)
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotScantwo",
    type: "output",

    initialize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).append("svg")
          .attr("class", "qtlcharts")

    renderValue: (widgetdiv, x) ->
        iplotScantwo(widgetdiv, x.scantwo_data, x.phenogeno_data, x.chartOpts)

    resize: (widgetdiv, width, height) -> null

})

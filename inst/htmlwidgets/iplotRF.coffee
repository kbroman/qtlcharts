# iplotRF: interactive plot of pairwise recombination fractions
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotRF",
    type: "output",

    initialize: (widgetdiv, width, height) ->
        # note that width and height are ignored
        d3.select(widgetdiv).append("svg")
          .attr("class", "qtlcharts")

    renderValue: (widgetdiv, x) ->
        iplotRF(widgetdiv, x.rfdata, x.genodata, x.chartOpts)

    resize: (widgetdiv, width, height) -> null

})

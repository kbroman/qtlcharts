# iplotRF: interactive plot of pairwise recombination fractions
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotRF",
    type: "output",

    initialize: (el, width, height) ->
        # note that width and height are ignored
        d3.select(el).append("svg")
          .attr("class", "qtlcharts")

    renderValue: (el, x) ->
        iplotRF(el, x.rfdata, x.genodata, x.chartOpts)

    resize: (el, width, height) -> null

})

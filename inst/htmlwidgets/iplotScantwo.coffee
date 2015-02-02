# iplotScantwo: interactive plot of scantwo results (2-dim, 2-QTL genome scan)
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotScantwo",
    type: "output",

    initialize: (el, width, height) ->
        d3.select(el).append("svg")
          .attr("class", "qtlcharts")

    renderValue: (el, x) ->
        iplotScantwo(el, x.scantwo_data, x.phenogeno_data, x.chartOpts)

    resize: (el, width, height) -> null

})

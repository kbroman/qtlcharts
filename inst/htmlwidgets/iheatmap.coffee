# iheatmap: Interactive heatmap, linked to curves with the horizontal and vertical slices
# Karl W Broman

HTMLWidgets.widget({

    name: "iheatmap",
    type: "output",

    initialize: (el, width, height) ->
        d3.select(el).append("svg")
          .attr("width", width)
          .attr("height", height)
          .attr("class", "qtlcharts")

    renderValue: (el, x) ->

        svg = d3.select(el).select("svg")

        chartOpts = x.chartOpts ? [ ]
        chartOpts.width = chartOpts?.width ? svg.attr("width")
        chartOpts.height = chartOpts?.height ? svg.attr("height")

        svg.attr("width", chartOpts.width)
        svg.attr("height", chartOpts.height)

        iheatmap(el, x.data, chartOpts)

    resize: (el, width, height) ->
        d3.select(el).select("svg")
          .attr("width", width)
          .attr("height", height)

})

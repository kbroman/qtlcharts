# iplotCurves: Plot of a bunch of curves, linked to points in 0, 1, or 2 scatterplots
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotCurves",
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

        iplotCurves(el, x.data.curve_data, x.data.scatter1_data, x.data.scatter2_data, chartOpts)

    resize: (el, width, height) ->
        d3.select(el).select("svg")
          .attr("width", width)
          .attr("height", height)

})

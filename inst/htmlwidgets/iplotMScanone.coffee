# iplotMScanone: image of lod curves linked to plot of lod curves
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotMScanone",
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

        if x.show_effects
            iplotMScanone_eff(el, x.lod_data, x.eff_data, x.times, chartOpts)
        else
            iplotMScanone_noeff(el, x.lod_data, x.times, chartOpts)

    resize: (el, width, height) ->
        d3.select(el).select("svg")
          .attr("width", width)
          .attr("height", height)

})

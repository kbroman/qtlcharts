# iplotScanone: lod curves + (possibly) QTL effects
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotScanone",
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

        console.log(x.pxg_type)

        if x.pxg_type == "ci"
            iplotScanone_ci(el, x.scanone_data, x.pxg_data, chartOpts)
        else if x.pxg_type == "raw"
            iplotScanone_pxg(el, x.scanone_data, x.pxg_data, chartOpts)
        else
            iplotScanone_noeff(el, x.scanone_data, chartOpts)

    resize: (el, width, height) ->
        d3.select(el).select("svg")
          .attr("width", width)
          .attr("height", height)

})

# iplotScanone: lod curves + (possibly) QTL effects
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotScanone",
    type: "output",

    initialize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).append("svg")
          .attr("width", width)
          .attr("height", height)
          .attr("class", "qtlcharts")

    renderValue: (widgetdiv, x) ->

        svg = d3.select(widgetdiv).select("svg")

        # clear svg and remove tool tips
        svg.selectAll("*").remove()
        widgetid = d3.select(widgetdiv).attr('id')
        d3.selectAll("div.d3-tip.#{widgetid}").remove()

        chartOpts = x.chartOpts ? [ ]
        chartOpts.width = chartOpts?.width ? svg.attr("width")
        chartOpts.height = chartOpts?.height ? svg.attr("height")

        svg.attr("width", chartOpts.width)
        svg.attr("height", chartOpts.height)

        if x.pxg_type == "ci"
            iplotScanone_ci(widgetdiv, x.scanone_data, x.pxg_data, chartOpts)
        else if x.pxg_type == "raw"
            iplotScanone_pxg(widgetdiv, x.scanone_data, x.pxg_data, chartOpts)
        else
            iplotScanone_noeff(widgetdiv, x.scanone_data, chartOpts)

    resize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).select("svg")
          .attr("width", width)
          .attr("height", height)

})

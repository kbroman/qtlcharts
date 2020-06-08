# iplotMScanone: image of lod curves linked to plot of lod curves
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotMScanone",
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
        d3.selectAll("div.d3panels-tooltip.#{widgetid}").remove()
        d3.selectAll("div.d3panels-tooltip-tri.#{widgetid}").remove()

        chartOpts = x.chartOpts ? [ ]
        chartOpts.width = chartOpts?.width ? svg.attr("width")
        chartOpts.height = chartOpts?.height ? svg.attr("height")

        svg.attr("width", chartOpts.width)
        svg.attr("height", chartOpts.height)

        if x.show_effects
            iplotMScanone_eff(widgetdiv, x.lod_data, x.eff_data, x.times, chartOpts)
        else
            iplotMScanone_noeff(widgetdiv, x.lod_data, x.times, chartOpts)

    resize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).select("svg")
          .attr("width", width)
          .attr("height", height)

})

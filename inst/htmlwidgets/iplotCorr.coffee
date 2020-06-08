# iplotCorr: heatmap of correlation matrix linked to scatterplots
# Karl W Broman

HTMLWidgets.widget({

    name: "iplotCorr",
    type: "output",

    initialize: (widgetdiv, width, height) ->
        # prefer aspect ratio width/height = 2
        height = width/2 if height > width/2
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

        # revise size of svg and div container
        svg.attr("width", chartOpts.width)
        svg.attr("height", chartOpts.height)
        d3.select(widgetdiv).attr("style", "width:#{chartOpts.width}px;height:#{chartOpts.height}px;")

        if x.data.scatterplots
            iplotCorr(widgetdiv, x.data, chartOpts)
        else
            iplotCorr_noscat(widgetdiv, x.data, chartOpts)

    resize: (widgetdiv, width, height) ->
        d3.select(widgetdiv).select("svg")
          .attr("width", width)
          .attr("height", height)

})

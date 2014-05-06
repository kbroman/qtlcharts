# iplotScanone_noeff: LOD curves (nothing else)
# Karl W Broman

iplotScanone_noeff = (data, chartOpts) ->

  # chartOpts start
  height = chartOpts?.height ? 450
  width = chartOpts?.width ? 900
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  # chartOpts end
  chartdivid = chartOpts?.chartdivid ? 'chart'

  halfh = (height+margin.top+margin.bottom)
  totalh = halfh*2
  totalw = (width+margin.left+margin.right)

  mylodchart = lodchart().lodvarname("lod")
                         .height(height)
                         .width(width)
                         .margin(margin)

  d3.select("div##{chartdivid}")
    .datum(data)
    .call(mylodchart)

  # animate points at markers on click
  mylodchart.markerSelect()
            .on "click", (d) ->
                  r = d3.select(this).attr("r")
                  d3.select(this)
                    .transition().duration(500).attr("r", r*3)
                    .transition().duration(500).attr("r", r)

# iplotScanone_noeff: LOD curves (nothing else)
# Karl W Broman

iplotScanone_noeff = (data) ->

  h = 450
  w = 900
  margin = {left:60, top:40, right:40, bottom: 40, inner:5}
  halfh = (h+margin.top+margin.bottom)
  totalh = halfh*2
  totalw = (w+margin.left+margin.right)

  mylodchart = lodchart().lodvarname("lod")
                         .height(h)
                         .width(w)
                         .margin(margin)

  d3.select("div#chart")
    .datum(data)
    .call(mylodchart)

  # animate points at markers on click
  mylodchart.markerSelect()
            .on "click", (d) ->
                  r = d3.select(this).attr("r")
                  d3.select(this)
                    .transition().duration(500).attr("r", r*3)
                    .transition().duration(500).attr("r", r)

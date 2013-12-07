# iplotScanone
# Karl W Broman

h = 450
w = 900
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
totalw = (w+margin.left+margin.right)

iplotScanone = (data) ->
  mychart = lodchart().lodvarname("lod")
                      .height(h)
                      .width(w)
                      .margin(margin)

  d3.select("div#chart")
    .datum(data)
    .call(mychart)

  # grab chromosome rectangles; color pink on hover
  chrrect = mychart.chrSelect()
  chrrect.on "mouseover", ->
              d3.select(this).attr("fill", "#E9CFEC")
         .on "mouseout", (d,i) ->
              d3.select(this).attr("fill", ->
                    return d3.rgb(200,200,200) if i % 2
                    d3.rgb(230,230,230))

  # animate points at markers on click
  mychart.markerSelect()
            .on "click", (d) ->
                  r = d3.select(this).attr("r")
                  d3.select(this)
                    .transition().duration(500).attr("r", r*3)
                    .transition().duration(500).attr("r", r)

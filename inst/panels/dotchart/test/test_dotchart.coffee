# illustration of use of the dotchart function

h = 300
w = 400
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example 1: simplest use
d3.json "data.json", (data) ->
  mychart = dotchart().xvar(0)
                      .yvar(1)
                      .xlab("X1")
                      .ylab("X2")
                      .height(h)
                      .width(w)
                      .margin(margin)

  d3.select("div#chart1")
    .datum(data)
    .call(mychart)

  # animate points
  mychart.pointsSelect()
            .on "mouseover", (d) ->
               d3.select(this).attr("r", mychart.pointsize()*3).on "click", (d) ->
                  d3.select(this).attr("fill", "Orchid").on "mouseout", (d) ->
                    d3.select(this).attr("fill", mychart.pointcolor()).attr("r", mychart.pointsize())
            .on "mouseout", (d) -> d3.select(this).attr("fill", mychart.pointcolor()).attr("r", mychart.pointsize())

# Example 2: no horizontal jittering
d3.json "data.json", (data) ->
  mychart = dotchart().xvar(0)
                      .yvar(1)
                      .xlab("X1")
                      .ylab("X2")
                      .height(h)
                      .width(w)
                      .margin(margin)
                      .xjitter(0)

  d3.select("div#chart2")
    .datum(data)
    .call(mychart)

  # animate points
  mychart.pointsSelect()
            .on "mouseover", (d) ->
               d3.select(this).attr("r", mychart.pointsize()*3).on "click", (d) ->
                  d3.select(this).attr("fill", "Orchid").on "mouseout", (d) ->
                    d3.select(this).attr("fill", mychart.pointcolor()).attr("r", mychart.pointsize())
            .on "mouseout", (d) -> d3.select(this).attr("fill", mychart.pointcolor()).attr("r", mychart.pointsize())


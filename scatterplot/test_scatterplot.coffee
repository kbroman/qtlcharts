# illustration of use of the scatterplot function

h = 300
w = 600
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# simplest use
d3.json "data.json", (data) ->
  mychart = scatterplot().xvar(0)
                         .yvar(1)
                         .xlab("X1")
                         .ylab("X2")
                         .height(h)
                         .width(w)
                         .margin(margin)

  d3.select("div#topchart")
    .datum(data)
    .call(mychart)

  # animate points
  mychart.pointsSelect()
            .on "mouseover", (d) ->
               d3.select(this).attr("r", mychart.pointsize()*3).on "click", (d) ->
                  d3.select(this).attr("fill", "Orchid").on "mouseout", (d) ->
                    d3.select(this).attr("fill", mychart.pointcolor()).attr("r", mychart.pointsize())
            .on "mouseout", (d) -> d3.select(this).attr("fill", mychart.pointcolor()).attr("r", mychart.pointsize())


# three scatterplots within one SVG
d3.json "data.json", (data) ->
  mychart01 = scatterplot().xvar(1)
                           .yvar(0)
                           .height(h)
                           .width(w)
                           .margin(margin)
                           .xlab("X2")
                           .ylab("X1")
  mychart02 = scatterplot().xvar(2)
                           .yvar(0)
                           .height(h)
                           .width(w)
                           .margin(margin)
                           .xlab("X3")
                           .ylab("X1")
  mychart12 = scatterplot().xvar(2)
                           .yvar(1)
                           .height(h)
                           .width(w)
                           .margin(margin)
                           .xlab("X3")
                           .ylab("X2")

  svg = d3.select("div#bottomchart")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  chart01 = svg.append("g").attr("id", "chart01")

  chart02 = svg.append("g").attr("id", "chart02")
               .attr("transform", "translate(#{halfw}, 0)")

  chart12 = svg.append("g").attr("id", "chart12")
               .attr("transform", "translate(#{halfw}, #{halfh})")

  chart01.datum(data)
    .call(mychart01)

  chart02.datum(data)
    .call(mychart02)

  chart12.datum(data)
    .call(mychart12)

  [mychart01, mychart02, mychart12].forEach (chart) ->
    chart.pointsSelect()
             .on "mouseover", (d,i) ->
                svg.selectAll("circle.pt#{i}").attr("r", chart.pointsize()*3).attr("fill", "Orchid")
             .on "mouseout", (d,i) ->
                svg.selectAll("circle.pt#{i}").attr("r", chart.pointsize()).attr("fill", chart.pointcolor())

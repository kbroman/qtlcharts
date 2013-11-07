# illustration of use of the scatterplot function

h = 300
w = 600
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example 1: simplest use
d3.json "data.json", (data) ->
  mychart = scatterplot().xvar(0)
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


# Example 2: three scatterplots within one SVG, with brushing
d3.json "data.json", (data) ->
  xvar = [1, 2, 2]
  yvar = [0, 0, 1]
  xshift = [0, halfw, halfw]
  yshift = [0, 0, halfh]

  svg = d3.select("div#chart2")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  mychart = []
  chart = []
  for i in [0..2]
    mychart[i] = scatterplot().xvar(xvar[i])
                              .yvar(yvar[i])
                              .nxticks(6)
                              .height(h)
                              .width(w)
                              .margin(margin)
                              .pointsize(4)
                              .xlab("X#{xvar[i]+1}")
                              .ylab("X#{yvar[i]+1}")

    chart[i] = svg.append("g").attr("id", "chart#{i}")
                  .attr("transform", "translate(#{xshift[i]},#{yshift[i]})")
    chart[i].datum(data).call(mychart[i])

  brush = []
  brushstart = (i) ->
    () ->
     for j in [0..2]
       chart[j].call(brush[j].clear()) if j != i
     d3.selectAll("circle").attr("opacity", 0.6).classed("selected", false)

  brushmove = (i) ->
    () ->
      d3.selectAll("circle").classed("selected", false)
      e = brush[i].extent()
      chart[i].selectAll("circle")
         .classed("selected", (d,j) ->
                            circ = d3.select(this)
                            cx = circ.attr("cx")
                            cy = circ.attr("cy")
                            selected =   e[0][0] <= cx and cx <= e[1][0] and
                                         e[0][1] <= cy and cy <= e[1][1]
                            svg.selectAll("circle.pt#{j}").classed("selected", true) if selected
                            selected)

  brushend = () ->
    svg.selectAll("circle").attr("opacity", 1)

  xscale = d3.scale.linear().domain([margin.left,margin.left+w]).range([margin.left,margin.left+w])
  yscale = d3.scale.linear().domain([margin.top,margin.top+h]).range([margin.top,margin.top+h])

  for i in [0..2]
    brush[i] = d3.svg.brush().x(xscale).y(yscale)
                    .on("brushstart", brushstart(i))
                    .on("brush", brushmove(i))
                    .on("brushend", brushend)

    chart[i].call(brush[i])



# Example 3: different options regarding treatment of missing values
d3.json "data.json", (data) ->
  mychart01 = scatterplot().xvar(1)
                           .yvar(0)
                           .height(h)
                           .width(w)
                           .margin(margin)
                           .xlab("X2")
                           .ylab("X1")
                           .xNA({handle:true, force:true, width:15, gap:10})
                           .yNA({handle:true, force:true, width:15, gap:10})
  mychart02 = scatterplot().xvar(2)
                           .yvar(0)
                           .height(h)
                           .width(w)
                           .margin(margin)
                           .xlab("X3")
                           .ylab("X1")
                           .yNA({handle:true, force:true, width:15, gap:10})
  mychart12 = scatterplot().xvar(2)
                           .yvar(1)
                           .height(h)
                           .width(w)
                           .margin(margin)
                           .xlab("X3")
                           .ylab("X2")
                           .xNA({handle:false, force:false, width:15, gap:10})

  svg = d3.select("div#chart3")
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




# iheatmap: Interactive heatmap, linked to curves with the horizontal and vertical slices
# Karl W Broman

iheatmap = (data, chartOpts) ->

  # chartOpts start
  htop = chartOpts?.htop ? 500 # height of top charts
  hbot = chartOpts?.hbot ? 500 # height of bottom chart
  wleft = chartOpts?.wleft ? 500 # width of left charts
  wright = chartOpts?.wright ? 500 # width of right chart
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = chartOpts?.titlepos ? 20
  rectcolor = chartOpts?.rectcolor ? d3.rgb(230, 230, 230)
  strokecolor = chartOpts?.strokecolor ? null
  strokewidth = chartOpts?.strokewidth ? 2
  xlim = chartOpts?xlim ? d3.range(data.x)
  ylim = chartOpts?xlim ? d3.range(data.y)
  nxticks = chartOpts?.nxticks ? 5
  xticks = chartOpts?.xticks ? null
  nyticks = chartOpts?.nyticks ? 5
  yticks = chartOpts?.yticks ? null
  nzticks = chartOpts?.nzticks ? 5
  zticks = chartOpts?.zticks ? null
  title = chartOpts?.title ? ""
  xlab = chartOpts?.xlab ? "X"
  ylab = chartOpts?.ylab ? "Y"
  zlab = chartOpts?.zlab ? "Z"
  zthresh = chartOpts?.zthresh ? null
  zlim = chartOpts?.zlim ? [-matrixMaxAbs(data.z), 0, matrixMaxAbs(data.z)]
  colors = chartOpts?.colors ? ["slateblue", "white", "crimson"]
  # chartOpts end

  totalh = htop + hbot + 2*(margin.top + margin.bottom)
  totalw = wleft + wright + 2*(margin.left + margin.right)

  # Select the svg element, if it exists.
  svg = d3.select("div#chart")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  ## configure the three charts
  myheatmap = heatmap().width(wleft)
                       .height(htop)
                       .margin(margin)
                       .axispos(axispos)
                       .titlepos(titlepos)
                       .rectcolor(rectcolor)
                       .xlim(xlim)
                       .ylim(ylim)
                       .nxticks(nxticks)
                       .xticks(xticks)
                       .nyticks(nyticks)
                       .yticks(yticks)
                       .xlab(xlab)
                       .ylab(ylab)
                       .zlim(zlim)
                       .zthresh(zthresh)
                       .colors(colors)

  horslice = curvechart().width(wleft)
                         .height(hbot)
                         .margin(margin)
                         .axispos(axispos)
                         .titlepos(titlepos)
                         .rectcolor(rectcolor)
                         .xlim(xlim)
                         .ylim([zlim[0], zlim[2]])
                         .nxticks(nxticks)
                         .xticks(xticks)
                         .nyticks(nzticks)
                         .yticks(zticks)
                         .xlab(xlab)
                         .ylab(zlab)
                         .strokecolor("")
                         .commonX(true)

  verslice = curvechart().width(wright)
                         .height(htop)
                         .margin(margin)
                         .axispos(axispos)
                         .titlepos(titlepos)
                         .rectcolor(rectcolor)
                         .xlim(ylim)
                         .ylim([zlim[0], zlim[2]])
                         .nxticks(nyticks)
                         .xticks(yticks)
                         .nyticks(nzticks)
                         .yticks(zticks)
                         .xlab(ylab)
                         .ylab(zlab)
                         .strokecolor("")
                         .commonX(true)

  ## now make the actual charts
  g_heatmap = svg.append("g")
                 .attr("id", "heatmap")
                 .datum(data)
                 .call(myheatmap)

  formatX = formatAxis(data.x)
  formatY = formatAxis(data.y)

  cells = myheatmap.cellSelect()
                   .on "mouseover", (d,i) ->
                           g_horslice.select("g.title text").text("X = #{formatX(d.x)}")
                           g_verslice.select("g.title text").text("Y = #{formatY(d.y)}")
                   .on "mouseout", (d,i) ->
                           g_horslice.select("g.title text").text("")
                           g_verslice.select("g.title text").text("")

  shiftdown = htop+margin.top+margin.bottom
  g_horslice = svg.append("g")
                  .attr("id", "horslice")
                  .attr("transform", "translate(0,#{shiftdown})")
                  .datum({x:data.x, data:pullVarAsArray(data.z, 0)})
                  .call(horslice)

  shiftright = wleft+margin.left+margin.right
  g_verslice = svg.append("g")
                  .attr("id", "verslice")
                  .attr("transform", "translate(#{shiftright},0)")
                  .datum({x:data.y, data:data.z[0]})
                  .call(verslice)

# iheatmap: Interactive heatmap, linked to curves with the horizontal and vertical slices
# Karl W Broman

iheatmap = (data, chartOpts) ->

  # chartOpts start
  htop = chartOpts?.htop ? 500 # height of top charts
  hbot = chartOpts?.hbot ? 500 # height of bottom chart
  wleft = chartOpts?.wleft ? 500 # width of left charts
  wright = chartOpts?.wright ? 500 # width of right chart
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
  titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
  rectcolor = chartOpts?.rectcolor ? d3.rgb(230, 230, 230) # color of background rectangle
  strokecolor = chartOpts?.strokecolor ? "slateblue" # line color
  strokewidth = chartOpts?.strokewidth ? 2 # line width
  xlim = chartOpts?xlim ? d3.range(data.x) # x-axis limits
  ylim = chartOpts?xlim ? d3.range(data.y) # y-axis limits
  nxticks = chartOpts?.nxticks ? 5 # no. ticks on x-axis
  xticks = chartOpts?.xticks ? null # vector of tick positions on x-axis
  nyticks = chartOpts?.nyticks ? 5 # no. ticks on y-axis
  yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
  nzticks = chartOpts?.nzticks ? 5 # no. ticks on z-axis
  zticks = chartOpts?.zticks ? null # vector of tick positions on z-axis
  title = chartOpts?.title ? "" # title for chart
  xlab = chartOpts?.xlab ? "X" # x-axis label
  ylab = chartOpts?.ylab ? "Y" # y-axis label
  zlab = chartOpts?.zlab ? "Z" # z-axis label
  zthresh = chartOpts?.zthresh ? null # lower threshold for z-axis for plotting in heat map
  zlim = chartOpts?.zlim ? [-matrixMaxAbs(data.z), 0, matrixMaxAbs(data.z)] # z-axis limits
  colors = chartOpts?.colors ? ["slateblue", "white", "crimson"] # heat map colors (same length as `zlim`)
  # chartOpts end
  chartdivid = chartOpts?.chartdivid ? 'chart'

  totalh = htop + hbot + 2*(margin.top + margin.bottom)
  totalw = wleft + wright + 2*(margin.left + margin.right)

  # Select the svg element, if it exists.
  svg = d3.select("div##{chartdivid}")
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
                           g_verslice.select("g.title text").text("X = #{formatX(d.x)}")
                           g_horslice.select("g.title text").text("Y = #{formatY(d.y)}")
                           plotVer(d.i)
                           plotHor(d.j)
                   .on "mouseout", (d,i) ->
                           g_verslice.select("g.title text").text("")
                           g_horslice.select("g.title text").text("")
                           removeVer()
                           removeHor()

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

  # functions for paths
  horcurvefunc = (j) ->
          d3.svg.line()
            .x((d) -> horslice.xscale()(d))
            .y((d,i) -> horslice.yscale()(data.z[i][j]))
  vercurvefunc = (i) ->
          d3.svg.line()
            .x((d) -> verslice.xscale()(d))
            .y((d,j) -> verslice.yscale()(data.z[i][j]))


  plotHor = (j) ->
    g_horslice.append("g").attr("id", "horcurve")
              .append("path")
              .datum(data.x)
              .attr("d", horcurvefunc(j))
              .attr("stroke", strokecolor)
              .attr("fill", "none")
              .attr("stroke-width", strokewidth)
              .attr("style", "pointer-events", "none")

  removeHor = () ->
    g_horslice.selectAll("g#horcurve").remove()

  plotVer = (i) ->
    g_verslice.append("g").attr("id", "vercurve")
              .append("path")
              .datum(data.y)
              .attr("d", vercurvefunc(i))
              .attr("stroke", strokecolor)
              .attr("fill", "none")
              .attr("stroke-width", strokewidth)
              .attr("style", "pointer-events", "none")

  removeVer = () ->
    g_verslice.selectAll("g#vercurve").remove()

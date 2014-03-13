# curves_w_2scatter: Plot of a bunch of curves, linked to points in two scatterplots
# Karl W Broman

curves_w_2scatter = (curve_data, scatter1_data, scatter2_data, chartOpts) ->

  # chartOpts start
  htop = chartOpts?.htop ? 500
  hbot = chartOpts?.hbot ? 500
  width = chartOpts?.width ? 1000
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = chartOpts?.titlepos ? 20
  rectcolor = chartOpts?.rectcolor ? d3.rgb(230, 230, 230)
  pointcolor = chartOpts?.pointcolor ? "slateblue"
  pointstroke = chartOpts?.pointstroke ? "black"
  pointsize = chartOpts?.pointsize ? 3
  strokecolor = chartOpts?.strokecolor ? d3.rgb(190, 190, 190)
  strokecolorhilit = chartOpts?.strokecolorhilit ? "slateblue"
  strokewidth = chartOpts?.strokewidth ? 2
  strokewidthhilit = chartOpts?.strokewidthhilit ? 2

  scat1_xlim = chartOpts?.scat1_xlim ? null
  scat1_ylim = chartOpts?.scat1_ylim ? null
  scat1_xNA = chartOpts?.scat1_xNA ? {handle:true, force:false, width:15, gap:10}
  scat1_yNA = chartOpts?.scat1_yNA ? {handle:true, force:false, width:15, gap:10}
  scat1_nxticks = chartOpts?.scat1_nxticks ? 5
  scat1_xticks = chartOpts?.scat1_xticks ? null
  scat1_nyticks = chartOpts?.scat1_nyticks ? 5
  scat1_yticks = chartOpts?.scat1_yticks ? null
  scat1_title = chartOpts?.scat1_title ? ""
  scat1_xlab = chartOpts?.scat1_xlab ? "X"
  scat1_ylab = chartOpts?.scat1_ylab ? "Y"

  scat2_xlim = chartOpts?.scat2_xlim ? null
  scat2_ylim = chartOpts?.scat2_ylim ? null
  scat2_xNA = chartOpts?.scat2_xNA ? {handle:true, force:false, width:15, gap:10}
  scat2_yNA = chartOpts?.scat2_yNA ? {handle:true, force:false, width:15, gap:10}
  scat2_nxticks = chartOpts?.scat2_nxticks ? 5
  scat2_xticks = chartOpts?.scat2_xticks ? null
  scat2_nyticks = chartOpts?.scat2_nyticks ? 5
  scat2_yticks = chartOpts?.scat2_yticks ? null
  scat2_title = chartOpts?.scat2_title ? ""
  scat2_xlab = chartOpts?.scat2_xlab ? "X"
  scat2_ylab = chartOpts?.scat2_ylab ? "Y"

  curves_xlim = chartOpts?.curves_xlim ? null
  curves_ylim = chartOpts?.curves_ylim ? null
  curves_nxticks = chartOpts?.curves_nxticks ? 5
  curves_xticks = chartOpts?.curves_xticks ? null
  curves_nyticks = chartOpts?.curves_nyticks ? 5
  curves_yticks = chartOpts?.curves_yticks ? null
  curves_title = chartOpts?.curves_title ? ""
  curves_xlab = chartOpts?.curves_xlab ? "X"
  curves_ylab = chartOpts?.curves_ylab ? "Y"
  # chartOpts end

  totalh = htop + hbot + 2*(margin.top + margin.bottom)
  totalw = width + margin.left + margin.right
  wtop = (width - margin.left - margin.right)/2

  # Select the svg element, if it exists.
  svg = d3.select("div#chart")
          .attr("height", totalh)
          .attr("width", totalw)

  ## configure the three charts
  myscatterplot1 = scatterplot().width(wtop)
                                .height(htop)
                                .margin(margin)
                                .axispos(axispos)
                                .titlepos(titlepos)
                                .rectcolor(rectcolor)
                                .pointcolor(pointcolor)
                                .pointstroke(pointstroke)
                                .pointsize(pointsize)
                                .xlim(scat1_xlim)
                                .ylim(scat1_ylim)
                                .xNA(scat1_xNA)
                                .yNA(scat1_yNA)
                                .nxticks(scat1_nxticks)
                                .xticks(scat1_xticks)
                                .nyticks(scat1_nyticks)
                                .yticks(scat1_yticks)
                                .title(scat1_title)
                                .xlab(scat1_xlab)
                                .ylab(scat1_ylab)

  myscatterplot2 = scatterplot().width(wtop)
                                .height(htop)
                                .margin(margin)
                                .axispos(axispos)
                                .titlepos(titlepos)
                                .rectcolor(rectcolor)
                                .pointcolor(pointcolor)
                                .pointstroke(pointstroke)
                                .pointsize(pointsize)
                                .xlim(scat2_xlim)
                                .ylim(scat2_ylim)
                                .xNA(scat2_xNA)
                                .yNA(scat2_yNA)
                                .nxticks(scat2_nxticks)
                                .xticks(scat2_xticks)
                                .nyticks(scat2_nyticks)
                                .yticks(scat2_yticks)
                                .title(scat2_title)
                                .xlab(scat2_xlab)
                                .ylab(scat2_ylab)

  mycurvechart = curvechart().width(width)
                             .height(hbot)
                             .margin(margin)
                             .axispos(axispos)
                             .titlepos(titlepos)
                             .rectcolor(rectcolor)
                             .strokecolor(strokecolor)
                             .strokecolorhilit(strokecolorhilit)
                             .strokewidth(strokewidth)
                             .strokewidthhilit(strokewidthhilit)
                             .xlim(curves_xlim)
                             .ylim(curves_ylim)
                             .nxticks(curves_nxticks)
                             .xticks(curves_xticks)
                             .nyticks(curves_nyticks)
                             .yticks(curves_yticks)
                             .title(curves_title)
                             .xlab(curves_xlab)
                             .ylab(curves_ylab)

  ## now make the actual charts
  g_scat1 = svg.append("g")
               .attr("id", "scatterplot1")
               .datum(scatter1_data)
               .call(myscatterplot1)

  g_scat2 = svg.append("g")
               .attr("id", "scatterplot2")
               .attr("transform", "translate(#{wtop+margin.left+margin.right},0)")
               .datum(scatter2_data)
               .call(myscatterplot2)

  g_curves = svg.append("g")
                .attr("id", "curvechart")
                .attr("transform", "translate(0,#{htop+margin.top+margin.bottom})")
                .datum(curve_data)
                .call(mycurvechart)

  points1 = myscatterplot1.pointsSelect()
  points2 = myscatterplot2.pointsSelect()
  curves = mycurvechart.curvesSelect()

  curves.on "mouseover", (d,i) ->
                           d3.select(this).attr("opacity", 1)
                           d3.selectAll("circle.pt#{i}").attr("fill", "Orchid").attr("r", pointsize*2)
        .on "mouseout", (d,i) ->
                           d3.select(this).attr("opacity", 0)
                           d3.selectAll("circle.pt#{i}").attr("fill", pointcolor).attr("r", pointsize)

  [points1, points2].forEach (points) ->
    points.on "mouseover", (d,i) ->
                             d3.selectAll("circle.pt#{i}").attr("fill", "Orchid").attr("r", pointsize*2)
                             d3.selectAll("path.path#{i}").attr("opacity", 1)
          .on "mouseout", (d,i) ->
                             d3.selectAll("circle.pt#{i}").attr("fill", pointcolor).attr("r", pointsize)
                             d3.selectAll("path.path#{i}").attr("opacity", 0)

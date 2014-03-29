# iplotMScanone_noeff: image of lod curves linked to plot of lod curves
# Karl W Broman

iplotMScanone_noeff = (lod_data, chartOpts) ->

  # chartOpts start
  width = chartOpts?.width ? 1200
  htop = chartOpts?.htop ? 600
  hbot = chartOpts?.hbot ? 600
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = chartOpts?.titlepos ? 20
  chrGap = chartOpts?.chrGap ? 5
  darkrect = chartOpts?.darkrect ? d3.rgb(200, 200, 200)
  lightrect = chartOpts?.lightrect ? d3.rgb(230, 230, 230)
  colors = chartOpts?.colors ? ["slateblue", "white", "crimson"]
  zlim = chartOpts?.zlim ? null
  zthresh = chartOpts?.zthresh ? null
  linecolor = chartOpts?.linecolor ? d3.rgb(100,100,100)
  linecolorhilit = chartOpts?.linecolor ? "darkslateblue"
  linewidth = chartOpts?.linewidth ? 2
  # chartOpts end

  totalh = htop + hbot + 2*(margin.top + margin.bottom)
  totalw = width + margin.left + margin.right

  mylodheatmap = lodheatmap().height(htop)
                             .width(width)
                             .margin(margin)
                             .axispos(axispos)
                             .titlepos(titlepos)
                             .chrGap(chrGap)
                             .rectcolor(lightrect)
                             .colors(colors)
                             .zlim(zlim)
                             .zthresh(zthresh)

  mylodchart = lodchart().height(hbot)
                         .width(width)
                         .margin(margin)
                         .axispos(axispos)
                         .titlepos(titlepos)
                         .chrGap(chrGap)
                         .linecolor(linecolor)
                         .linewidth(linewidth)
                         .pad4heatmap(true)
                         .darkrect(darkrect)
                         .lightrect(lightrect)

  svg = d3.select("div#chart")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  g_heatmap = svg.append("g")
                 .attr("id", "heatmap")
                 .datum(lod_data)
                 .call(mylodheatmap)
  g_lodchart = svg.append("g")
                  .attr("transform", "translate(0,#{htop+margin.top+margin.bottom})")
                  .attr("id", "lodchart")
                  .datum(lod_data)
                  .call(mylodchart)

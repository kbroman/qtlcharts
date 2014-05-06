# iplotMap: interactive plot of a genetic marker map
# Karl W Broman

iplotMap = (data, chartOpts) ->

  # chartOpts start
  width = chartOpts?.height ? 1000
  height = chartOpts?.width ? 600
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:10}
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = chartOpts?.titlepos ? 20
  ylim = chartOpts?.ylim ? null
  nyticks = chartOpts?.nyticks ? 5
  yticks = chartOpts?.yticks ? null
  tickwidth = chartOpts?.tickwidth ? 10
  rectcolor = chartOpts?.rectcolor ? d3.rgb(230, 230, 230)
  linecolor = chartOpts?.linecolor ? "slateblue"
  linecolorhilit = chartOpts?.linecolorhilit ? "Orchid"
  linewidth = chartOpts?.linewidth ? 3
  title = chartOpts?.title ? ""
  xlab = chartOpts?.xlab ? "Chromosome"
  ylab = chartOpts?.ylab ? "Position (cM)"
  # chartOpts end
  chartdivid = chartOpts?.chartdivid ? 'chart'

  mychart = mapchart().height(height)
                      .width(width)
                      .margin(margin)
                      .axispos(axispos)
                      .titlepos(titlepos)
                      .ylim(ylim)
                      .yticks(yticks)
                      .nyticks(nyticks)
                      .tickwidth(tickwidth)
                      .rectcolor(rectcolor)
                      .linecolor(linecolor)
                      .linecolorhilit(linecolorhilit)
                      .linewidth(linewidth)
                      .title(title)
                      .xlab(xlab)
                      .ylab(ylab)

  d3.select("div##{chartdivid}")
    .datum(data)
    .call(mychart)

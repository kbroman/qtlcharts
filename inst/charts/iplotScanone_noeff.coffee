# iplotScanone_noeff: LOD curves (nothing else)
# Karl W Broman

iplotScanone_noeff = (data, chartOpts) ->

  # chartOpts start
  height = chartOpts?.height ? 450
  width = chartOpts?.width ? 900
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = chartOpts?.titlepos ? 20
  ylim = chartOpts?.ylim ? null
  nyticks = chartOpts?.nyticks ? 5
  yticks = chartOpts?.yticks ? null
  chrGap = chartOpts?.chrGap ? 8
  darkrect = chartOpts?.darkrect ? d3.rgb(200, 200, 200)
  lightrect = chartOpts?.lightrect ? d3.rgb(230, 230, 230)
  linecolor = chartOpts?.linecolor ? "darkslateblue"
  linewidth = chartOpts?.linewidth ? 2
  pointcolor = chartOpts?.pointcolor ? "#E9CFEC" # pink
  pointsize = chartOpts?.pointsize ? 0 # default = no visible points at markers
  title = chartOpts?.title ? ""
  xlab = chartOpts?.xlab ? "Chromosome"
  ylab = chartOpts?.ylab ? "LOD score"
  rotate_ylab = chartOpts?.rotate_ylab ? null
  # chartOpts end
  chartdivid = chartOpts?.chartdivid ? 'chart'

  halfh = (height+margin.top+margin.bottom)
  totalh = halfh*2
  totalw = (width+margin.left+margin.right)

  mylodchart = lodchart().lodvarname("lod")
                         .height(height)
                         .width(width)
                         .margin(margin)
                         .axispos(axispos)
                         .titlepos(titlepos)
                         .ylim(ylim)
                         .nyticks(nyticks)
                         .yticks(yticks)
                         .chrGap(chrGap)
                         .darkrect(darkrect)
                         .lightrect(lightrect)
                         .linecolor(linecolor)
                         .linewidth(linewidth)
                         .pointcolor(pointcolor)
                         .pointsize(pointsize)
                         .title(title)
                         .xlab(xlab)
                         .ylab(ylab)
                         .rotate_ylab(rotate_ylab)

  d3.select("div##{chartdivid}")
    .datum(data)
    .call(mylodchart)

  # animate points at markers on click
  mylodchart.markerSelect()
            .on "click", (d) ->
                  r = d3.select(this).attr("r")
                  d3.select(this)
                    .transition().duration(500).attr("r", r*3)
                    .transition().duration(500).attr("r", r)

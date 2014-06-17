# iplotPXG: (just barely) interactive plot of phenotype vs genotype
# Karl W Broman

iplotPXG = (data, chartOpts) ->

  gen = (Math.abs(x) for x in data.geno[0])
  inferred = (x < 0 for x in data.geno[0])
  phe = data.pheno
  gnames = (data.genonames[y] for y of data.genonames)[0]

  # chartOpts start
  height = chartOpts?.height ? 450 # height of chart in pixels
  width = chartOpts?.width ? 300 # width of chart in pixels
  title = chartOpts?.title ? "" # title for chart
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5} # margins in pixels (left, top, right, bottom, inner)
  xlab = chartOpts?.xlab ? "Genotype" # x-axis label
  ylab = chartOpts?.ylab ? "Phenotype" # y-axis label
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # position of axis labels in pixels (xtitle, ytitle, xlabel, ylabel)
  titlepos = chartOpts?.titlepos ? 20 # position of chart title in pixels
  xjitter = chartOpts?.xjitter ? null # amount of horizontal jittering in pixels
  ylim = chartOpts?.ylim ? null # y-axis limits
  yticks = chartOpts?.yticks ? null # vector of tick positions on y-axis
  nyticks = chartOpts?.nyticks ? 5 # no. ticks on y-axis
  rectcolor = chartOpts?.rectcolor ? "#E6E6E6" # color of background rectangle
  pointcolor = chartOpts?.pointcolor ? "slateblue" # color for points
  pointsize = chartOpts?.pointsize ? 3 # size of points in pixels
  pointstroke = chartOpts?.pointstroke ? "black" # color of outer circle for points
  yNA = chartOpts?.yNA ? {handle:true, force:false, width:15, gap:10} # treatment of missing values (handle=T/F, force=T/F, width, gap)
  # chartOpts end
  chartdivid = chartOpts?.chartdivid ? 'chart'

  mychart = dotchart().height(height)
                      .width(width)
                      .margin(margin)
                      .xcategories([1..gnames.length])
                      .xcatlabels(gnames)
                      .dataByInd(false)
                      .xlab(xlab)
                      .ylab(ylab)
                      .xvar('geno')
                      .yvar('pheno')
                      .title(title)
                      .axispos(axispos)
                      .titlepos(titlepos)
                      .xjitter(xjitter)
                      .ylim(ylim)
                      .yticks(yticks)
                      .nyticks(nyticks)
                      .rectcolor(rectcolor)
                      .pointcolor(pointcolor)
                      .pointsize(pointsize)
                      .pointstroke(pointstroke)
                      .yNA(yNA)

  d3.select("div##{chartdivid}")
    .datum({geno:gen, pheno:phe, indID:data.indID})
    .call(mychart)

  # animate points at markers on click
  mychart.pointsSelect()
              .attr("fill", (d,i) ->
                    return "Orchid" if inferred[i]
                    "slateblue")
              .on "click", (d) ->
                  r = d3.select(this).attr("r")
                  d3.select(this)
                    .transition().duration(500).attr("r", r*3)
                    .transition().duration(500).attr("r", r)

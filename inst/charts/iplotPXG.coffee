# iplotPXG: (just barely) interactive plot of phenotype vs genotype
# Karl W Broman

iplotPXG = (data, chartOpts) ->

  gen = (Math.abs(x) for x in data.geno[0])
  inferred = (x < 0 for x in data.geno[0])
  phe = data.pheno
  gnames = (data.genonames[y] for y of data.genonames)[0]

  # chartOpts start
  height = chartOpts?.height ? 450
  width = chartOpts?.width ? 300
  title = chartOpts?.title ? ""
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  xlab = chartOpts?.xlab ? "Genotype"
  ylab = chartOpts?.ylab ? "Phenotype"
  axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  titlepos = chartOpts?.titlepos ? 20
  xjitter = chartOpts?.xjitter ? null
  ylim = chartOpts?.ylim ? null
  yticks = chartOpts?.yticks ? null
  nyticks = chartOpts?.nyticks ? 5
  rectcolor = chartOpts?.rectcolor ? d3.rgb(230, 230, 230)
  pointcolor = chartOpts?.pointcolor ? "slateblue"
  pointsize = chartOpts?.pointsize ? 3
  pointstroke = chartOpts?.pointstroke ? "black"
  yNA = chartOpts?.yNA ? {handle:true, force:false, width:15, gap:10}
  # chartOpts end

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

  d3.select("div#chart")
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

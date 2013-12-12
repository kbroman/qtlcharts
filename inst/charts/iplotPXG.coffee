# iplotPXG: (just barely) interactive plot of phenotype vs genotype
# Karl W Broman

iplotPXG = (data, jsOpts) ->

  gen = (Math.abs(x) for x in data.geno[0])
  inferred = (x < 0 for x in data.geno[0])
  phe = data.pheno
  gnames = (data.genonames[y] for y of data.genonames)[0]

  # handle possible options
  h = jsOpts?.height ? 450
  w = jsOpts?.width ? 300
  title = jsOpts?.title ? ""
  margin = jsOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  xlab = jsOpts?.xlab ? "Genotype"
  ylab = jsOpts?.ylab ? "Phenotype"

  mychart = dotchart().height(h)
                      .width(w)
                      .margin(margin)
                      .xcategories([1..gnames.length])
                      .xcatlabels(gnames)
                      .dataByInd(false)
                      .xlab(xlab)
                      .ylab(ylab)
                      .xvar('geno')
                      .yvar('pheno')
                      .title(title)

  d3.select("div#chart")
    .datum({"geno":gen, "pheno":phe, "indID":data.indID})
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

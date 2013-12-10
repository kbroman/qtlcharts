# iplotPXG
# Karl W Broman

iplotPXG = (data) ->

  gen = (Math.abs(x) for x in data.geno[0])
  inferred = (x < 0 for x in data.geno[0])
  phe = data.pheno
  gnames = (data.genonames[y] for y of data.genonames)[0]

  h = 450
  w = 900
  margin = {left:60, top:40, right:40, bottom: 40, inner:5}

  mychart = dotchart().height(h)
                      .width(w)
                      .margin(margin)
                      .xcategories([1..gnames.length])
                      .xcatlabels(gnames)
                      .dataByInd(false)
                      .xlab("Genotype")
                      .ylab("Phenotype")

  d3.select("div#chart")
    .datum([gen, phe])
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

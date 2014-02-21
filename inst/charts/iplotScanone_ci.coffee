# iplotScanone_ci: lod curves + phe x gen (as mean +/- 2 SE) plot
# Karl W Broman

iplotScanone_ci = (lod_data, pxg_data) ->

  markers = (x for x of pxg_data.chrByMarkers)

  h = 450
  wleft = 700
  wright = 300
  margin = {left:60, top:40, right:40, bottom: 40, inner:5}
  totalh = h + margin.top + margin.bottom
  totalw = wleft + wright + (margin.left + margin.right)*2


  mychart = lodchart().lodvarname("lod")
                      .height(h)
                      .width(wleft)
                      .margin(margin)

  mylodchart = lodchart().lodvarname("lod")
                         .height(h)
                         .width(wleft)
                         .margin(margin)

  svg = d3.select("div#chart")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  g_lod = svg.append("g")
             .attr("id", "lodchart")
             .datum(lod_data)
             .call(mychart)

  plotCI = (markername, markerindex) ->
    svg.select("g#cichart").remove()
    
    g = pxg_data.geno[markerindex]
    gabs = (Math.abs(x) for x in g)

    chr = pxg_data.chrByMarkers[markername]
    chrtype = pxg_data.chrtype[chr]
    genonames = pxg_data.genonames[chrtype]

    means = []
    se = []
    for j in [1..genonames.length]
      phesub = (p for p,i in pxg_data.pheno when gabs[i] == j)

      if phesub.length>0
        ave = (phesub.reduce (a,b) -> a+b)/phesub.length
        means.push(ave)
      else means.push(null)

      if phesub.length>1
        variance = (phesub.reduce (a,b) -> a+Math.pow(b-ave, 2))/(phesub.length-1)
        se.push((Math.sqrt(variance/phesub.length)))
      else
        se.push(null)

    low = (means[i]-2*se[i] for i of means)
    high = (means[i]+2*se[i] for i of means)

    mycichart = cichart().height(h)
                         .width(wright)
                         .margin(margin)
                         .title(markername)
                         .xlab("Genotype")
                         .ylab("Phenotype")
  
    svg.append("g")
       .attr("id", "cichart")
       .attr("transform", "translate(#{wleft+margin.left+margin.right},0)")
       .datum({'means':means, 'low':low, 'high':high, 'categories':genonames})
       .call(mycichart)

  # animate points at markers on click
  mychart.markerSelect()
            .on "click", (d,i) ->
                  plotCI(markers[i], i)

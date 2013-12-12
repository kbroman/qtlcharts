# iplotScanone_pxg: lod curves + phe x gen plot
# Karl W Broman

iplotScanone_pxg = (lod_data, pxg_data) ->

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

  plotPXG = (markername, markerindex) ->
    svg.select("g#pxgchart").remove()
    
    g = pxg_data.geno[markerindex]
    gabs = (Math.abs(x) for x in g)
    inferred = (x < 0 for x in g)

    chr = pxg_data.chrByMarkers[markername]
    chrtype = pxg_data.chrtype[chr]
    genonames = pxg_data.genonames[chrtype]

    mypxgchart = dotchart().height(h)
                           .width(wright)
                           .margin(margin)
                           .xcategories([1..genonames.length])
                           .xcatlabels(genonames)
                           .dataByInd(false)
                           .xlab(markername)
                           .ylab("Phenotype")
                           .xvar('geno')
                           .yvar('pheno')
  
    svg.append("g")
       .attr("id", "pxgchart")
       .attr("transform", "translate(#{wleft+margin.left+margin.right},0)")
       .datum({'geno':gabs, 'pheno':pxg_data.pheno, 'indID':pxg_data.indID})
       .call(mypxgchart)

    mypxgchart.pointsSelect()
              .attr("fill", (d,i) ->
                    return "Orchid" if inferred[i]
                    "slateblue")

  # animate points at markers on click
  mychart.markerSelect()
            .on "click", (d,i) ->
                  plotPXG(markers[i], i)

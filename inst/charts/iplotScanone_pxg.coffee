# iplotScanone_pxg: lod curves + phe x gen plot
# Karl W Broman

iplotScanone_pxg = (lod_data, pxg_data, chartOpts) ->

  markers = (x for x of pxg_data.chrByMarkers)

  # chartOpts start
  height = chartOpts?.height ? 450
  wleft = chartOpts?.wleft ? 700
  wright = chartOpts?.wright ? 300
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  pointcolor = chartOpts?.pointcolor ? "slateblue"
  pointcolorhilit = chartOpts?.pointcolorhilit ? "Orchid"
  # chartOpts end

  totalh = height + margin.top + margin.bottom
  totalw = wleft + wright + (margin.left + margin.right)*2


  mylodchart = lodchart().lodvarname("lod")
                         .height(height)
                         .width(wleft)
                         .margin(margin)

  svg = d3.select("div#chart")
          .append("svg")
          .attr("height", totalh)
          .attr("width", totalw)

  g_lod = svg.append("g")
             .attr("id", "lodchart")
             .datum(lod_data)
             .call(mylodchart)

  plotPXG = (markername, markerindex) ->
    svg.select("g#pxgchart").remove()
    
    g = pxg_data.geno[markerindex]
    gabs = (Math.abs(x) for x in g)
    inferred = (x < 0 for x in g)

    chr = pxg_data.chrByMarkers[markername]
    chrtype = pxg_data.chrtype[chr]
    genonames = pxg_data.genonames[chrtype]

    mypxgchart = dotchart().height(height)
                           .width(wright)
                           .margin(margin)
                           .xcategories([1..genonames.length])
                           .xcatlabels(genonames)
                           .dataByInd(false)
                           .title(markername)
                           .xlab("Genotype")
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
                    return pointcolorhilit if inferred[i]
                    pointcolor)

  # animate points at markers on click
  mylodchart.markerSelect()
            .on "click", (d,i) ->
                  plotPXG(markers[i], i)

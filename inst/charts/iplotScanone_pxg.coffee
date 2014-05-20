# iplotScanone_pxg: lod curves + phe x gen plot
# Karl W Broman

iplotScanone_pxg = (lod_data, pxg_data, chartOpts) ->

  markers = (x for x of pxg_data.chrByMarkers)

  # chartOpts start
  height = chartOpts?.height ? 450
  wleft = chartOpts?.wleft ? 700
  wright = chartOpts?.wright ? 300
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  lod_axispos = chartOpts?.lod_axispos ? chartOpts?.axispos ? 20
  lod_titlepos = chartOpts?.lod_titlepos ? chartOpts?.titlepos ? 20
  chrGap = chartOpts?.chrGap ? 8
  darkrect = chartOpts?.darkrect ? d3.rgb(200, 200, 200)
  lightrect = chartOpts?.lightrect ? d3.rgb(230, 230, 230)
  lod_ylim = chartOpts?.lod_ylim ? null
  lod_nyticks = chartOpts?.lod_nyticks ? 5
  lod_yticks = chartOpts?.lod_yticks ? null
  lod_linecolor = chartOpts?.lod_linecolor ? "darkslateblue"
  lod_linewidth = chartOpts?.lod_linewidth ? 2
  lod_pointcolor = chartOpts?.lod_pointcolor ? "#E9CFEC" # pink
  lod_pointsize = chartOpts?.lod_pointsize ? 0 # default = no visible points at markers
  lod_pointstroke = chartOpts?.lod_pointstroke ? "black"
  lod_title = chartOpts?.lod_title ? ""
  lod_xlab = chartOpts?.lod_xlab ? "Chromosome"
  lod_ylab = chartOpts?.lod_ylab ? "LOD score"
  lod_rotate_ylab = chartOpts?.lod_rotate_ylab ? null
  eff_pointcolor = chartOpts?.eff_pointcolor ? chartOpts?.pointcolor ? "slateblue"
  eff_pointcolorhilit = chartOpts?.eff_pointcolorhilit ? chartOpts?.pointcolorhilit ? "Orchid"
  eff_pointstroke = chartOpts?.eff_pointstroke ? chartOpts?.pointstroke ? "black"
  eff_pointsize = chartOpts?eff_pointsize ? chartOpts?pointsize ? 3
  eff_ylim = chartOpts?.eff_ylim ? null
  eff_nyticks = chartOpts?.eff_nyticks ? null
  eff_yticks = chartOpts?.eff_yticks ? null
  eff_xlab = chartOpts?.eff_xlab ? "Genotype"
  eff_ylab = chartOpts?.eff_ylab ? "Phenotype"
  eff_rotate_ylab = chartOpts?.eff_rotate_ylab ? null
  eff_xjitter = chartOpts?.xjitter ? null
  eff_axispos = chartOpts?.eff_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  eff_titlepos = chartOpts?.eff_titlepos ? chartOpts?.titlepos ? 20
  eff_yNA = chartOpts?.eff_yNA ? {handle:true, force:false, width:15, gap:10}
  # chartOpts end
  chartdivid = chartOpts?.chartdivid ? 'chart'

  totalh = height + margin.top + margin.bottom
  totalw = wleft + wright + (margin.left + margin.right)*2


  mylodchart = lodchart().lodvarname("lod")
                         .height(height)
                         .width(wleft)
                         .margin(margin)
                         .axispos(lod_axispos)
                         .titlepos(lod_titlepos)
                         .chrGap(chrGap)
                         .darkrect(darkrect)
                         .lightrect(lightrect)
                         .ylim(lod_ylim)
                         .nyticks(lod_nyticks)
                         .yticks(lod_yticks)
                         .linecolor(lod_linecolor)
                         .linewidth(lod_linewidth)
                         .pointcolor(lod_pointcolor)
                         .pointsize(lod_pointsize)
                         .pointstroke(lod_pointstroke)
                         .title(lod_title)
                         .xlab(lod_xlab)
                         .ylab(lod_ylab)
                         .rotate_ylab(lod_rotate_ylab)

  svg = d3.select("div##{chartdivid}")
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
                           .xvar('geno')
                           .yvar('pheno')
                           .axispos(eff_axispos)
                           .titlepos(eff_titlepos)
                           .xlab(eff_xlab)
                           .ylab(eff_ylab)
                           .rotate_ylab(eff_rotate_ylab)
                           .ylim(eff_ylim)
                           .nyticks(eff_nyticks)
                           .yticks(eff_yticks)
                           .pointcolor(eff_pointcolor)
                           .pointstroke(eff_pointstroke)
                           .pointsize(eff_pointsize)
                           .rectcolor(lightrect)
                           .xjitter(eff_xjitter)
                           .yNA(eff_yNA)
  
    svg.append("g")
       .attr("id", "pxgchart")
       .attr("transform", "translate(#{wleft+margin.left+margin.right},0)")
       .datum({'geno':gabs, 'pheno':pxg_data.pheno, 'indID':pxg_data.indID})
       .call(mypxgchart)

    mypxgchart.pointsSelect()
              .attr("fill", (d,i) ->
                    return eff_pointcolorhilit if inferred[i]
                    eff_pointcolor)

  # animate points at markers on click
  mylodchart.markerSelect()
            .on "click", (d,i) ->
                  plotPXG(markers[i], i)

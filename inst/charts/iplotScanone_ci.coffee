# iplotScanone_ci: lod curves + phe x gen (as mean +/- 2 SE) plot
# Karl W Broman

iplotScanone_ci = (lod_data, pxg_data, chartOpts) ->

  markers = (x for x of pxg_data.chrByMarkers)

  # chartOpts start
  height = chartOpts?.height ? 450
  wleft = chartOpts?.wleft ? 700
  wright = chartOpts?.wright ? 300
  margin = chartOpts?.margin ? {left:60, top:40, right:40, bottom: 40, inner:5}
  lod_axispos = chartOpts?.lod_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
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
  eff_ylim = chartOpts?.eff_ylim ? null
  eff_nyticks = chartOpts?.eff_nyticks ? 5
  eff_yticks = chartOpts?.eff_yticks ? null
  eff_linecolor = chartOpts?.eff_linecolor ? "slateblue"
  eff_linewidth = chartOpts?.eff_linewidth ? "3"
  eff_xlab = chartOpts?.eff_xlab ? "Genotype"
  eff_ylab = chartOpts?.eff_ylab ? "Phenotype"
  eff_rotate_ylab = chartOpts?.eff_rotate_ylab ? null
  eff_segwidth = chartOpts?.eff_segwidth ? null
  eff_axispos = chartOpts?.eff_axispos ? chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}
  eff_titlepos = chartOpts?.eff_titlepos ? chartOpts?.titlepos ? 20
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

    range = [d3.min(low), d3.max(high)]
    if eff_ylim?
      eff_ylim = [d3.min([range[0],eff_ylim[0]]), d3.max([range[1],eff_ylim[1]])]
    else
      eff_ylim = range

    mycichart = cichart().height(height)
                         .width(wright)
                         .margin(margin)
                         .axispos(eff_axispos)
                         .titlepos(eff_titlepos)
                         .title(markername)
                         .xlab(eff_xlab)
                         .ylab(eff_ylab)
                         .rotate_ylab(eff_rotate_ylab)
                         .ylim(eff_ylim)
                         .nyticks(eff_nyticks)
                         .yticks(eff_yticks)
                         .segcolor(eff_linecolor)
                         .vertsegcolor(eff_linecolor)
                         .segstrokewidth(eff_linewidth)
                         .segwidth(eff_segwidth)
                         .rectcolor(lightrect)
  
    svg.append("g")
       .attr("id", "cichart")
       .attr("transform", "translate(#{wleft+margin.left+margin.right},0)")
       .datum({'means':means, 'low':low, 'high':high, 'categories':genonames})
       .call(mycichart)

  # animate points at markers on click
  mylodchart.markerSelect()
            .on "click", (d,i) ->
                  plotCI(markers[i], i)

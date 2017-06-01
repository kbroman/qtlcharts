# iplotScantwo: interactive plot of scantwo results (2-dim, 2-QTL genome scan)
# Karl W Broman

iplotScantwo = (widgetdiv, scantwo_data, pheno_and_geno, chartOpts) ->

    # chartOpts start
    height = chartOpts?.height ? 1200                  # total height of chart in pixels
    width = chartOpts?.width ? 1100                    # total width of chart in pixels
    chrGap = chartOpts?.chrGap ? 2                     # gaps between chr in heat map
    wright = chartOpts?.wright ? width/2               # width (in pixels) of right panels
    hbot = chartOpts?.hbot ? height/5                  # height (in pixels) of each of the lower panels
    margin = chartOpts?.margin ? {left:60, top:50, right:10, bottom: 40, inner: 5} # margins in each panel
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5}      # axis positions in heatmap
    titlepos = chartOpts?.titlepos ? 20                # position of chart title in pixels
    rectcolor = chartOpts?.rectcolor ? "#e6e6e6"       # color for background rectangle
    altrectcolor = chartOpts?.altrectcolor ? "#c8c8c8" # alternate rectangle in lower panels
    chrlinecolor = chartOpts?.chrlinecolor ? ""        # color of lines between chromosomes (if "", leave off)
    chrlinewidth = chartOpts?.chrlinewidth ? 2         # width of lines between chromosomes
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6"       # color of null pixels in heat map
    boxcolor = chartOpts?.boxcolor ? "black"           # color of box around each panel
    boxwidth = chartOpts?.boxwidth ? 2                 # width of box around each panel
    linecolor = chartOpts?.linecolor ? "slateblue"     # line color in lower panels
    linewidth = chartOpts?.linewidth ? 2               # line width in lower panels
    pointsize = chartOpts?.pointsize ? 2               # point size in right panels
    pointstroke = chartOpts?.pointstroke ? "black"     # color of outer circle in right panels
    cicolors = chartOpts?.cicolors ? null              # colors for CIs in QTL effect plot; also used for points in phe x gen plot
    segwidth = chartOpts?.segwidth ? 0.4               # segment width in CI chart as proportion of distance between categories
    segstrokewidth = chartOpts?.segstrokewidth ? 3     # stroke width for segments in CI chart
    color = chartOpts?.color ? "slateblue"             # color for heat map
    oneAtTop = chartOpts?.oneAtTop ? false             # whether to put chr 1 at top of heatmap
    zthresh = chartOpts?.zthresh ? 0                   # LOD values below this threshold aren't shown (on LOD_full scale)
    ylab_eff = chartOpts?.ylab_eff ? "Phenotype"       # y-axis label in dot and ci charts
    xlab_lod = chartOpts?.xlab_lod ? "Chromosome"      # x-axis label in lod charts
    ylab_lod = chartOpts?.ylab_lod ? "LOD score"       # y-axis label in lod charts
    nyticks_lod = chartOpts?.nyticks_lod ? 5           # no. ticks on y-axis in LOD curve panels
    yticks_lod = chartOpts?.yticks_lod ? null          # vector of tick positions on y-axis in LOD curve panels
    nyticks_ci = chartOpts?.nyticks_ci ? 5             # no. ticks on y-axis in CI panel
    yticks_ci = chartOpts?.yticks_ci ? null            # vector of tick positions on y-axis in CI panel
    nyticks_pxg = chartOpts?.nyticks_pxg ? 5           # no. ticks on y-axis in dot chart of phenotype x genotype
    yticks_pxg = chartOpts?.yticks_pxg ? null          # vector of tick positions on y-axis in dot chart of phenotype x genotype
    # chartOpts end

    # make sure list args have all necessary bits
    margin = d3panels.check_listarg_v_default(margin, {left:60, top:50, right:10, bottom: 40, inner: 5})
    axispos = d3panels.check_listarg_v_default(axispos, {xtitle:25, ytitle:30, xlabel:5, ylabel:5})

    # htmlwidget div element containing the chart, and its ID
    div = d3.select(widgetdiv)
    widgetdivid = div.attr("id")
    svg = div.select("svg")

    # force chrnames to be a list
    scantwo_data.chrnames = d3panels.forceAsArray(scantwo_data.chrnames)
    scantwo_data.nmar = d3panels.forceAsArray(scantwo_data.nmar)

    # size of heatmap region
    w = d3.min([height-hbot*2, width-wright])
    heatmap_width =  w
    heatmap_height = w

    hright = heatmap_height/2
    width = heatmap_width + wright
    height = heatmap_height + hbot*2
    wbot = width/2

    # selected LODs on left and right
    leftvalue = "int"
    rightvalue = "fv1"

    # keep track of chromosome heatmap selections
    cur_chr1 = cur_chr2 = ''

    # cicolors: check they're the right length or construct them
    if pheno_and_geno?
        gn = pheno_and_geno.genonames
        ncat = d3.max(gn[x].length for x of gn)
        if cicolors? # cicolors provided; expand to ncat
            cicolors = d3panels.expand2vector(cicolors, ncat)
            n = cicolors.length
            if n < ncat # not enough, display error
                d3panels.displayError("length(cicolors) (#{n}) < maximum no. genotypes (#{ncat})")
                cicolors = (cicolors[i % n] for i in [0...ncat])
        else # not provided; select them
            cicolors = d3panels.selectGroupColors(ncat, "dark")

    # drop-down menus
    options = ["full", "fv1", "int", "add", "av1"]
    form = div.insert("div", ":first-child")
              .attr("id", "form")
              .attr("class", "qtlcharts")
              .attr("height", "24px")
    left = form.append("div")
              .text(if oneAtTop then "bottom-left: " else "top-left: ")
              .style("float", "left")
              .style("margin-left", "50px")
    leftsel = left.append("select")
                  .attr("id", "leftselect_#{widgetdivid}")
                  .attr("name", "left")
    leftsel.selectAll("empty")
           .data(options)
           .enter()
           .append("option")
           .attr("value", (d) -> d)
           .text((d) -> d)
           .attr("selected", (d) ->
               return "selected" if d==leftvalue
               null)
    right = form.append("div")
                .text(if oneAtTop then "top-right: " else "bottom-right: ")
                .style("float", "left")
                .style("margin-left", "50px")
    rightsel = right.append("select")
                    .attr("id", "rightselect_#{widgetdivid}")
                    .attr("name", "right")
    rightsel.selectAll("empty")
            .data(options)
            .enter()
            .append("option")
            .attr("value", (d) -> d)
            .text((d) -> d)
            .attr("selected", (d) ->
                return "selected" if d==rightvalue
                null)
    submit = form.append("div")
                 .style("float", "left")
                 .style("margin-left", "50px")
                 .append("button")
                 .attr("name", "refresh")
                 .text("Refresh")
                 .on "click", () ->
                     cur_chr1 = cur_chr2 = ''
                     leftsel = document.getElementById("leftselect_#{widgetdivid}")
                     leftvalue = leftsel.options[leftsel.selectedIndex].value
                     rightsel = document.getElementById("rightselect_#{widgetdivid}")
                     rightvalue = rightsel.options[rightsel.selectedIndex].value

                     scantwo_data.lod = lod_for_heatmap(scantwo_data, leftvalue, rightvalue)
                     mylod2dheatmap.remove()
                     mylod2dheatmap(div.select("g#chrheatmap"), scantwo_data)
                     add_cell_tooltips()

    # add the full,add,int,fv1,av1 lod matrices to scantwo_data
    # (and remove the non-symmetric ones)
    scantwo_data = add_symmetric_lod(scantwo_data)

    scantwo_data.lod = lod_for_heatmap(scantwo_data, leftvalue, rightvalue)

    mylod2dheatmap = d3panels.lod2dheatmap({
        height:heatmap_height
        width:heatmap_width
        margin:margin
        axispos:axispos
        chrGap:chrGap
        chrlinecolor:chrlinecolor
        chrlinewidth:chrlinewidth
        xlab: xlab_lod
        ylab: ylab_lod
        rectcolor:"white"
        nullcolor:nullcolor
        boxcolor:boxcolor
        boxwidth:boxwidth
        colors:["white",color]
        zlim:[0, scantwo_data.max.full]
        zthresh:zthresh
        oneAtTop:oneAtTop
        tipclass:widgetdivid})

    g_heatmap = svg.append("g")
                   .attr("id", "chrheatmap")
    mylod2dheatmap(g_heatmap, scantwo_data)

    # function to add tool tips and handle clicking
    add_cell_tooltips = () ->
        mylod2dheatmap.celltip()
                      .html((d) ->
                            mari = scantwo_data.marker[d.xindex]
                            marj = scantwo_data.marker[d.yindex]
                            if +d.xindex > +d.yindex                # +'s ensure number not string
                                leftlod = d3.format(".1f")(scantwo_data[leftvalue][d.xindex][d.yindex])
                                rightlod = d3.format(".1f")(scantwo_data[rightvalue][d.yindex][d.xindex])
                                return "(#{marj} #{mari}) #{rightvalue} = #{rightlod}, #{leftvalue} = #{leftlod}"
                            else if +d.yindex > +d.xindex
                                leftlod = d3.format(".1f")(scantwo_data[leftvalue][d.yindex][d.xindex])
                                rightlod = d3.format(".1f")(scantwo_data[rightvalue][d.xindex][d.yindex])
                                return "(#{marj} #{mari}) #{leftvalue} = #{leftlod}, #{rightvalue} = #{rightlod}"
                            else
                                return mari
                            )

        mylod2dheatmap.cells()
                      .on "click", (d) ->
                                 mari = scantwo_data.marker[d.xindex]
                                 marj = scantwo_data.marker[d.yindex]
                                 return null if d.xindex == d.yindex # skip the diagonal case
                                 # plot the cross-sections as genome scans, below
                                 plot_scan(d.xindex, 0, 0, leftvalue)
                                 plot_scan(d.xindex, 1, 0, rightvalue)
                                 plot_scan(d.yindex, 0, 1, leftvalue)
                                 plot_scan(d.yindex, 1, 1, rightvalue)
                                 # plot the effect plot and phe x gen plot to right
                                 if pheno_and_geno?
                                     plot_effects(d.xindex, d.yindex)

    add_cell_tooltips()

    # to hold groups and positions of scan and effect plots
    mylodchart = [[null,null], [null,null]]
    scans_hpos = [0, wbot]
    scans_vpos = [heatmap_height, heatmap_height+hbot]

    mydotchart = null
    mycichart = null
    eff_hpos = [heatmap_width, heatmap_width]
    eff_vpos = [0, heatmap_height/2]

    g_scans = [[null,null],[null,null]]
    plot_scan = (markerindex, panelrow, panelcol, lod) ->
        data =
            chrname: scantwo_data.chrnames
            chr: scantwo_data.chr
            pos: scantwo_data.pos
            lod: (x for x in scantwo_data[lod][markerindex])
            marker: scantwo_data.marker

        mylodchart[panelrow][panelcol].remove() if mylodchart[panelrow][panelcol]?

        mylodchart[panelrow][panelcol] = d3panels.lodchart({
            height:hbot
            width:wbot
            margin:margin
            axispos:axispos
            ylim:[0.0, scantwo_data.max[lod]*1.05]
            nyticks:nyticks_lod
            yticks:yticks_lod
            rectcolor:rectcolor
            altrectcolor:altrectcolor
            chrlinecolor:chrlinecolor
            chrlinewidth:chrlinewidth
            boxcolor:boxcolor
            boxwidth:boxwidth
            linewidth:linewidth
            linecolor:linecolor
            pointsize:0
            pointcolor:""
            pointstroke:""
            lodvarname:"lod"
            chrGap:chrGap
            xlab:xlab_lod
            ylab:ylab_lod
            title:"#{data.marker[markerindex]} : #{lod}"
            titlepos:titlepos
            tipclass:widgetdivid})

        unless g_scans[panelrow][panelcol]? # only create it once
            g_scans[panelrow][panelcol] = svg.append("g")
                         .attr("id", "scan_#{panelrow+1}_#{panelcol+1}")
                         .attr("transform", "translate(#{scans_hpos[panelcol]}, #{scans_vpos[panelrow]})")
        mylodchart[panelrow][panelcol](g_scans[panelrow][panelcol], data)

    g_eff = [null, null]
    plot_effects = (markerindex1, markerindex2) ->
        mar1 = scantwo_data.marker[markerindex1]
        mar2 = scantwo_data.marker[markerindex2]
        g1 = pheno_and_geno.geno[mar1]
        g2 = pheno_and_geno.geno[mar2]
        chr1 = pheno_and_geno.chr[mar1]
        chr2 = pheno_and_geno.chr[mar2]
        chrtype1 = pheno_and_geno.chrtype[chr1]
        chrtype2 = pheno_and_geno.chrtype[chr2]

        g = []
        gn1 = []
        gn2 = []
        cicolors_expanded = []

        # need to deal separately with X chr
        # [this mess is because if females are AA/AB/BB and males AY/BY
        #  we want to just show 3x3 + 2x2 = 13 possible two-locus genotypes,
        #  not all (3+2)x(3+2) = 25]
        if chr1 == chr2 and chrtype1=="X" and pheno_and_geno.X_geno_by_sex?
            fgnames = pheno_and_geno.X_geno_by_sex[0]
            mgnames = pheno_and_geno.X_geno_by_sex[1]
            ngf = fgnames.length
            ngm = mgnames.length
            tmp = [0...(ngf+ngm)]
            m = ((-1 for i of tmp) for j of tmp)
            k = 0
            for i in [0...ngf]
                for j in [0...ngf]
                    gn1.push(fgnames[j])
                    gn2.push(fgnames[i])
                    cicolors_expanded.push(cicolors[i])
                    m[i][j] = k
                    k++
            for i in [0...ngm]
                for j in [0...ngm]
                    gn1.push(mgnames[j])
                    gn2.push(mgnames[i])
                    cicolors_expanded.push(cicolors[i])
                    m[i+ngf][j+ngf] = k
                    k++
            g = (m[g1[i]-1][g2[i]-1]+1 for i of g1)
        else
            gnames1 = pheno_and_geno.genonames[chr1]
            gnames2 = pheno_and_geno.genonames[chr2]
            ng1 = gnames1.length
            ng2 = gnames2.length

            g = (g1[i] + (g2[i]-1)*ng1 for i of g1)
            for i in [0...ng2]
                for j in [0...ng1]
                    gn1.push(gnames1[j])
                    gn2.push(gnames2[i])
                    cicolors_expanded.push(cicolors[i])

        pxg_data =
            x:g
            y:pheno_and_geno.pheno
            indID:pheno_and_geno.indID

        # remove the CI chart no matter what
        mycichart.remove() if mycichart?

        if cur_chr1 != chr1 or cur_chr2 != chr2
            mydotchart.remove() if mydotchart?

            mydotchart = d3panels.dotchart({
                height:hright
                width:wright
                margin:margin
                axispos:axispos
                rectcolor:rectcolor
                boxcolor:boxcolor
                boxwidth:boxwidth
                pointsize:pointsize
                pointstroke:pointstroke
                xcategories:[1..gn1.length]
                xcatlabels:gn1
                xlab:""
                ylab:ylab_eff
                nyticks:nyticks_pxg
                yticks:yticks_pxg
                dataByInd:false
                title:"#{mar1} : #{mar2}"
                titlepos:titlepos
                tipclass:widgetdivid})

            unless g_eff[1]? # only create it once
                g_eff[1] = svg.append("g")
                              .attr("id", "eff_1")
                              .attr("transform", "translate(#{eff_hpos[1]}, #{eff_vpos[1]})")
            mydotchart(g_eff[1], pxg_data)

            # revise point colors
            mydotchart.points()
                      .attr("fill", (d,i) ->
                              cicolors_expanded[g[i]-1])

        else # same chr pair as before: animate points
            # remove marker text
            d3.select("#markerlab1").remove()
            d3.select("#xaxislab1").remove()

            # grab scale and get info to take inverse
            xscale = mydotchart.xscale()
            pos1 = xscale(1)
            dpos = xscale(2) - xscale(1)
            point_jitter = (d) ->
                u = (d - pos1)/dpos
                u - Math.round(u)

            # move points to new x-axis position
            points = mydotchart.points()
                      .transition().duration(1000)
                      .attr("cx", (d,i) ->
                          cx = d3.select(this).attr("cx")
                          u = point_jitter(cx)
                          xscale(g[i] + u))
                      .attr("fill", (d,i) -> cicolors_expanded[g[i]-1])

            # use force to move them apart again
            scaledPoints = []
            points.each((d,i) -> scaledPoints.push({
                x: +d3.select(this).attr("cx")
                y: +d3.select(this).attr("cy")
                fy: +d3.select(this).attr("cy")
                truex: xscale(g[i])}))

            force = d3.forceSimulation(scaledPoints)
                      .force("x", d3.forceX((d) -> d.truex))
                      .force("collide", d3.forceCollide(pointsize*1.1))
                      .stop()
            [0..30].map((d) ->
                force.tick()
                points.attr("cx", (d,i) -> scaledPoints[i].x))

        cur_chr1 = chr1
        cur_chr2 = chr2

        cis = d3panels.ci_by_group(g, pheno_and_geno.pheno, 2)
        ci_data =
            mean: (cis[x]?.mean ? null for x in [1..gn1.length])
            low:  (cis[x]?.low ? null for x in [1..gn1.length])
            high: (cis[x]?.high ? null for x in [1..gn1.length])
            categories: [1..gn1.length]

        mycichart = d3panels.cichart({
            height:hright
            width:wright
            margin:margin
            axispos:axispos
            rectcolor:rectcolor
            boxcolor:boxcolor
            boxwidth:boxwidth
            segcolor:cicolors_expanded
            segwidth:segwidth
            segstrokewidth:segstrokewidth
            vertsegcolor:cicolors_expanded
            segstrokewidth:linewidth
            xlab:""
            ylab:ylab_eff
            nyticks:nyticks_ci
            yticks:yticks_ci
            xcatlabels:gn1
            title:"#{mar1} : #{mar2}"
            titlepos:titlepos
            tipclass:widgetdivid})

        unless g_eff[0]? # only create it once
            g_eff[0] = svg.append("g")
                          .attr("id", "eff_0")
                          .attr("transform", "translate(#{eff_hpos[0]}, #{eff_vpos[0]})")
        mycichart(g_eff[0], ci_data)
        effcharts = [mycichart, mydotchart]

        # add second row of labels
        for p in [0..1]
            effcharts[p].svg() # second row of genotypes
                    .append("g").attr("class", "x axis").attr("id", "xaxislab#{p}")
                    .selectAll("empty")
                    .data(gn2)
                    .enter()
                    .append("text")
                    .attr("x", (d,i) -> mydotchart.xscale()(i+1))
                    .attr("y", hright-margin.bottom/2+axispos.xlabel)
                    .text((d) -> d)
            effcharts[p].svg() # marker name labels
                    .append("g").attr("class", "x axis").attr("id", "markerlab#{p}")
                    .selectAll("empty")
                    .data([mar1, mar2])
                    .enter()
                    .append("text")
                    .attr("x", (margin.left + mydotchart.xscale()(1))/2.0)
                    .attr("y", (d,i) ->
                        hright - margin.bottom/(i+1) + axispos.xlabel)
                    .style("text-anchor", "end")
                    .text((d) -> d + ":")

    if chartOpts.heading?
        d3.select("div#htmlwidget_container")
          .insert("h2", ":first-child")
          .html(chartOpts.heading)
          .style("font-family", "sans-serif")

    if chartOpts.caption?
        d3.select("body")
          .append("p")
          .attr("class", "caption")
          .html(chartOpts.caption)

    if chartOpts.footer?
        d3.select("body")
          .append("div")
          .html(chartOpts.footer)
          .style("font-family", "sans-serif")

# add full,add,int,av1,fv1 lod scores to scantwo_data
add_symmetric_lod = (scantwo_data) ->
    scantwo_data.full = scantwo_data.lod.map (d) -> d.map (dd) -> dd
    scantwo_data.add  = scantwo_data.lod.map (d) -> d.map (dd) -> dd
    scantwo_data.fv1  = scantwo_data.lodv1.map (d) -> d.map (dd) -> dd
    scantwo_data.av1  = scantwo_data.lodv1.map (d) -> d.map (dd) -> dd
    scantwo_data.int  = scantwo_data.lod.map (d) -> d.map (dd) -> dd

    for i in [0...(scantwo_data.lod.length-1)]
        for j in [i...scantwo_data.lod[i].length]
            scantwo_data.full[i][j] = scantwo_data.lod[j][i]
            scantwo_data.add[j][i]  = scantwo_data.lod[i][j]
            scantwo_data.fv1[i][j]  = scantwo_data.lodv1[j][i]
            scantwo_data.av1[j][i]  = scantwo_data.lodv1[i][j]

    scantwo_data.one = []
    for i in [0...scantwo_data.lod.length]
        scantwo_data.one.push(scantwo_data.lod[i])
        for j in [0...scantwo_data.lod.length]
            scantwo_data.int[i][j] = scantwo_data.full[i][j] - scantwo_data.add[i][j]

    # delete the non-symmetric versions
    scantwo_data.lod = null
    scantwo_data.lodv1 = null

    scantwo_data.max = {}
    for i in ["full", "add", "fv1", "av1", "int"]
        scantwo_data.max[i] = d3panels.matrixMax(scantwo_data[i])

    scantwo_data

lod_for_heatmap = (scantwo_data, left, right) ->
    # make copy of lod
    z = scantwo_data.full.map (d) -> d.map (dd) -> dd

    for i in [0...z.length]
        for j in [0...z.length]
            thelod = if j < i then right else left
            z[i][j] = scantwo_data[thelod][i][j]/scantwo_data.max[thelod]*scantwo_data.max["full"]

    z # return the matrix we created

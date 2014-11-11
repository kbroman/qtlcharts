# iplotScantwo: interactive plot of scantwo results (2-dim, 2-QTL genome scan)
# Karl W Broman

iplotScantwo = (scantwo_data, pheno_and_geno, chartOpts) ->

    # chartOpts start
    pixelPerCell = chartOpts?.pixelPerCell ? null # pixels per cell in heat map
    chrGap = chartOpts?.chrGap ? 2 # gaps between chr in heat map
    wright = chartOpts?.wright ? 500 # width (in pixels) of right panels
    hbot = chartOpts?.hbot ? 200 # height (in pixels) of each of the lower panels
    margin = chartOpts?.margin ? {left:60, top:30, right:10, bottom: 40, inner: 5} # margins in each panel
    axispos = chartOpts?.axispos ? {xtitle:25, ytitle:30, xlabel:5, ylabel:5} # axis positions in heatmap
    lightrect = chartOpts?.lightrect ? "#e6e6e6" # color for light rect in lower panels
    darkrect = chartOpts?.darkrect ? "#c8c8c8" # dark rectangle in lower panels
    nullcolor = chartOpts?.nullcolor ? "#e6e6e6" # color of null pixels in heat map
    bordercolor = chartOpts?.bordercolor ? "black" # border color in heat map
    linecolor = chartOpts?.linecolor ? "slateblue" # line color in lower panels
    linewidth = chartOpts?.linewidth ? 2 # line width in lower panels
    color = chartOpts?.color ? "slateblue" # color for heat map
    oneAtTop = chartOpts?.oneAtTop ? false # whether to put chr 1 at top of heatmap
    zthresh = chartOpts?.zthresh ? 0 # LOD values below this threshold aren't shown (on LOD_full scale)
    # chartOpts end
    chartdivid = chartOpts?.chartdivid ? 'chart'

    # size of heatmap region
    totmar = sumArray(scantwo_data.nmar)
    pixelPerCell = d3.max([2, Math.floor(600/totmar)]) unless pixelPerCell?
    w = chrGap*scantwo_data.chrnames.length + pixelPerCell*totmar
    heatmap_width =  w + margin.left + margin.right
    heatmap_height = w + margin.top + margin.bottom

    hright = heatmap_height/2 - margin.top - margin.bottom
    totalw = heatmap_width + wright + margin.left + margin.right
    totalh = heatmap_height + (hbot + margin.top + margin.bottom)*2

    # width of lower panels
    wbot = (totalw/2 - margin.left - margin.right)

    # selected LODs on left and right
    leftvalue = "int"
    rightvalue = "fv1"

    # drop-down menus
    options = ["full", "fv1", "int", "add", "av1"]
    div = d3.select("div##{chartdivid}")
    form = div.append("g").attr("id", "form")
    left = form.append("div")
              .text(if oneAtTop then "bottom-left: " else "top-left: ")
              .style("float", "left")
              .style("margin-left", "50px")
    leftsel = left.append("select")
                  .attr("id", "leftselect")
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
                    .attr("id", "rightselect")
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
                     leftsel = document.getElementById('leftselect')
                     leftvalue = leftsel.options[leftsel.selectedIndex].value
                     rightsel = document.getElementById('rightselect')
                     rightvalue = rightsel.options[rightsel.selectedIndex].value
                     console.log("left: #{leftvalue}, right: #{rightvalue}")

                     scantwo_data.z = lod_for_heatmap(scantwo_data, leftvalue, rightvalue)
                     d3.select("g#chrheatmap svg").remove()
                     d3.select("g#chrheatmap").datum(scantwo_data).call(mychrheatmap)
                     add_cell_tooltips()

    # create SVG
    svg = d3.select("div##{chartdivid}")
            .append("svg")
            .attr("height", totalh)
            .attr("width", totalw)

    # add the full,add,int,fv1,av1 lod matrices to scantwo_data
    # (and remove the non-symmetric ones)
    console.log("add symmetric lod")
    scantwo_data = add_symmetric_lod(scantwo_data)

    console.log("lod for heatmap")
    scantwo_data.z = lod_for_heatmap(scantwo_data, leftvalue, rightvalue)

    mychrheatmap = chrheatmap().pixelPerCell(pixelPerCell)
                               .chrGap(chrGap)
                               .axispos(axispos)
                               .rectcolor("white")
                               .nullcolor(nullcolor)
                               .bordercolor(bordercolor)
                               .colors(["white",color])
                               .zlim([0, scantwo_data.max.full])
                               .zthresh(zthresh)
                               .oneAtTop(oneAtTop)
                               .hover(false)

    console.log("create heatmap")
    g_heatmap = svg.append("g")
                   .attr("id", "chrheatmap")
                   .datum(scantwo_data)
                   .call(mychrheatmap)

    # function to add tool tips and handle clicking
    add_cell_tooltips = () ->
        d3.selectAll(".d3-tip").remove()
        celltip = d3.tip()
                    .attr('class', 'd3-tip')
                    .html((d) ->
                            mari = scantwo_data.labels[d.i]
                            marj = scantwo_data.labels[d.j]
                            if +d.i > +d.j                # +'s ensure number not string
                                leftlod = d3.format(".1f")(scantwo_data[leftvalue][d.i][d.j])
                                rightlod = d3.format(".1f")(scantwo_data[rightvalue][d.j][d.i])
                                return "(#{marj} #{mari}) #{rightvalue} = #{rightlod}, #{leftvalue} = #{leftlod}"
                            else if +d.j > +d.i
                                leftlod = d3.format(".1f")(scantwo_data[leftvalue][d.j][d.i])
                                rightlod = d3.format(".1f")(scantwo_data[rightvalue][d.i][d.j])
                                return "(#{marj} #{mari}) #{leftvalue} = #{leftlod}, #{rightvalue} = #{rightlod}"
                            else
                                return mari
                            )
                    .direction('e')
                    .offset([0,10])
        svg.call(celltip)

        cells = mychrheatmap.cellSelect()
        cells.on("mouseover", (d) ->
                         celltip.show(d))
             .on("mouseout", () ->
                         celltip.hide())
             .on "click", (d) ->
                    mari = scantwo_data.labels[d.i]
                    marj = scantwo_data.labels[d.j]
                    console.log("click! #{mari} (#{d.i}), #{marj} (#{d.j})")
                    return null if d.i == d.j # skip the diagonal case
                    # plot the cross-sections as genome scans, below
                    plot_scan(d.i, 0, 0, leftvalue)
                    plot_scan(d.i, 1, 0, rightvalue)
                    plot_scan(d.j, 0, 1, leftvalue)
                    plot_scan(d.j, 1, 1, rightvalue)
                    # plot the effect plot and phe x gen plot to right

    add_cell_tooltips()

    g_scans = [[null,null], [null,null]]
    scans_hpos = [0, wbot+margin.left+margin.right]
    scans_vpos = [heatmap_height, heatmap_height+hbot+margin.top+margin.bottom]

    plot_scan = (markerindex, panelrow, panelcol, lod) ->
        data =
            chrnames: scantwo_data.chrnames
            lodnames: ["lod"]
            chr: scantwo_data.chr
            pos: scantwo_data.pos
            lod: (x for x in scantwo_data[lod][markerindex])
            markernames: scantwo_data.labels

        g_scans[panelrow][panelcol].remove() if g_scans[panelrow][panelcol]?

        mylodchart = lodchart().height(hbot)
                               .width(wbot)
                               .margin(margin)
                               .axispos(axispos)
                               .ylim([0.0, scantwo_data.max[lod]])
                               .lightrect(lightrect)
                               .darkrect(darkrect)
                               .linewidth(linewidth)
                               .linecolor(linecolor)
                               .pointsize(0)
                               .pointcolor("")
                               .pointstroke("")
                               .lodvarname("lod")
                               .title(data.markernames[markerindex])

        g_scans[panelrow][panelcol] = svg.append("g")
                                 .attr("id", "scan_#{panelrow+1}_#{panelcol+1}")
                                 .attr("transform", "translate(#{scans_hpos[panelcol]}, #{scans_vpos[panelrow]})")
                                 .datum(data)
                                 .call(mylodchart)

# add full,add,int,av1,fv1 lod scores to scantwo_data
add_symmetric_lod = (scantwo_data) ->
    scantwo_data.full = scantwo_data.lod.map (d) -> d.map (dd) -> dd
    scantwo_data.add  = scantwo_data.lod.map (d) -> d.map (dd) -> dd
    scantwo_data.fv1  = scantwo_data.lodv1.map (d) -> d.map (dd) -> dd
    scantwo_data.av1  = scantwo_data.lodv1.map (d) -> d.map (dd) -> dd
    scantwo_data.int  = scantwo_data.lod.map (d) -> d.map (dd) -> dd

    for i in [0...(scantwo_data.lod.length-1)]
        for j in [(i+1)...scantwo_data.lod[i].length]
            scantwo_data.full[i][j] = scantwo_data.lod[j][i]
            scantwo_data.add[j][i]  = scantwo_data.lod[i][j]
            scantwo_data.fv1[i][j]  = scantwo_data.lodv1[j][i]
            scantwo_data.av1[j][i]  = scantwo_data.lodv1[i][j]

    scantwo_data.one = []
    for i in [0...scantwo_data.lod.length]
        scantwo_data.full[i][i] = 0
        scantwo_data.add[i][i] = 0
        scantwo_data.fv1[i][i] = 0
        scantwo_data.av1[i][i] = 0
        scantwo_data.one.push(scantwo_data.lod[i])
        for j in [0...scantwo_data.lod.length]
            scantwo_data.int[i][j] = scantwo_data.full[i][j] - scantwo_data.add[i][j]

    # delete the non-symmetric versions
    scantwo_data.lod = null
    scantwo_data.lodv1 = null

    scantwo_data.max = {}
    for i in ["full", "add", "fv1", "av1", "int"]
        scantwo_data.max[i] = matrixMax(scantwo_data[i])

    scantwo_data

lod_for_heatmap = (scantwo_data, left, right) ->
    # make copy of lod
    z = scantwo_data.full.map (d) -> d.map (dd) -> dd

    for i in [0...z.length]
        for j in [0...z.length]
            thelod = if j < i then right else left
            z[i][j] = scantwo_data[thelod][i][j]/scantwo_data.max[thelod]*scantwo_data.max["full"]

    z # return the matrix we created

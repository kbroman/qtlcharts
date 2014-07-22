## To Do list for R/qtlcharts

### Bugs

- Something seems wrong with the x- and y-axis scales in iheatmap
  (rectangles not taken into account; need to pad xlim and ylim)


### General things

- errors in coffeescript printed to browser
  (insert before svg?)

- Edits to user guide; is it missing anything?

- Revise developer's guide
  - a bit more detail about how the panels and charts work?
  

### Enhancements to current charts

- iplotCorr: use heatmap and scatterplot functions

- Allow separate inner margins on top and bottom (and left and right?)
  also make `inner_top`, `inner_left`, `inner_right` functions

  ```
  inner_bottom = (margin, value=5) -> margin?.inner_bottom ? margin?.inner ? value
  margin.inner_bottom = inner_bottom(margin)
  margin.inner_bottom = inner_bottom(margin, 0)
  ```

- lodchart: optional inclusion of ticks at markers

- iplotScanone_pxg: same jitter values throughout; animate transitions
  if same chromosome class (same x-axis): need a redraw function

- iplotCurves
  - allow either brush or mouseover


### Panels

- panel of inferred QTL (like a scatterplot) (for cis/trans plot)
- lod curve for one chromosome (argument to current panel?)
- classic boxchart (format like cichart)
- Bang Wong's barcode plot
- histogram (or function to make path for curvechart)
- dotchart with beeswarm-type dots; look at underlying code in
  beeswarm: is it easy to grab or re-write? How is the package licensed?
- dotchart with force-directed placement of dots


### Charts

- Set of QTL intervals on a genetic map plot, linked to the LOD curves
- cis/trans figure, with slider for selecting a band of LOD scores
- Interactive 2d scan plot (iplotScantwo)
- interactive rec frac plot (iplotRF)
- iheatmapCurves: heatmap of multiple curves linked to curvechart
- iplotCorr: also include plots with slices of the correlation matrix?


### Interactive versions of all R/qtl charts

- panel: colorscale for a heatmap (allow horiz/vert; allow scale on
  top, right, bottom, or left)
- iplotRF
- iplotScantwo
- plot.qtl
- comparison of two maps
- effectscan
- plot.geno (with zoom and pan)
- geno.image (again, with zoon and pan)


### Annoyances

- lodchart: selecting chromosome, don't want hovering over
  lodcurve/marker to disturb things

<!-- the following to make it look nicer -->
<link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>
<link href="http://www.biostat.wisc.edu/~kbroman/markdown_modified.css" rel="stylesheet"></link>

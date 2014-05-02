## To Do list for R/qtlcharts

### General things

- standard ways to give axis labels
  (draw axis labels from data?)

- move colors etc to CSS

- function to write CSS styles

- write a guide to the use of chartOpts
  (How to use the options, and what they are, and fill out the
  comments)

    ```
    # start of chartOpts
    option = chartOpts?.option? ? default # explanation here
    # end of chartOpts
    ```

- write a user guide

- write a developer's guide
  - the panels: what, where, how
  - the basic method I'm using for creating a chart



### Enhancements to current charts

- iplotMScanone w/ effects: label effect curves (in right margin?)

- iplotMScanone: qualitative vs quantitative axes

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
- histogram (or function to make path for curvechart)
- dotchart with beeswarm-type dots; look at underlying code in
  beeswarm: is it easy to grab or re-write? How is the package licensed?
- dotchart with force-directed placement of dots



### Charts

- Set of QTL intervals on a genetic map plot, linked to the LOD curves
- cis/trans figure, with slider for selecting a band of LOD scores
- Interactive 2d scan plot
- iheatmapCurves: heatmap of multiple curves linked to curvechart
- iplotCorr: also include plots with slices of the correlation matrix?



### Annoyances

- lodchart: selecting chromosome, don't want hovering over
  lodcurve/marker to disturb things

<!-- the following to make it look nicer -->
<link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>
<link href="http://www.biostat.wisc.edu/~kbroman/markdown_modified.css" rel="stylesheet"></link>

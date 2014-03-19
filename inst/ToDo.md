## To Do list for R/qtlcharts

### Bugs

- iplotPXG behaves badly if the chosen phenotype is non-numeric
  (e.g., a factor)

### General things

- pointcolor for panels should end up being a vector of length =
  no. individuals and there should be a related pointcolorhilit
  All panels should handle group, pointcolor, and pointcolorhilit in a
  standard way

- standard ways to give axis labels
  (draw axis labels from data?)

- move colors etc to CSS

- function to write CSS styles

- write a guide to the use of chartOpts
  - How to use the options, and what they are, and fill out the
    comments

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

- lodchart: optional inclusion of ticks at markers

- iplotScanone_pxg: same jitter values throughout; animate transitions
  if same chromosome class (same x-axis): need a redraw function

- Add d3-tip to manyboxplot for individual IDs
- Add individual IDs to curves_w_scatter

- curvechart: include individual IDs with d3-tip (maybe add points at
  last observed time?, and have tip from there?)

- curves_w_scatter
  - allow grouping by color
  - individual IDs via d3-tip
  - allow either brush or mouseover



### Panels

- panel of inferred QTL (like a scatterplot) (for cis/trans plot)

- mapchart panel

- lod curve for one chromosome (argument to current panel?)

- general image/heat map panel

- heat map split up into chromosomes (for multiple LOD curves)



### Charts

- genetic/physical map of markers; ability to indicate QTL intervals
- heat map of LOD curves for 10-100 curves
- heat map for functional traits
- cis/trans figure, with slider for selecting a band of LOD scores
- Interactive 2d scan plot
- curves_w_heatmap: heatmap of multiple curves linked to curvechart


### Annoyances

- lodchart: selecting chromosome, don't want hovering over
  lodcurve/marker to disturb things

<!-- the following to make it look nicer -->
<link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>
<link href="http://www.biostat.wisc.edu/~kbroman/markdown_modified.css" rel="stylesheet"></link>

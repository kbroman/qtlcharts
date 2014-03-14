## To Do list for R/qtlcharts

### General things

- make charts adjustable, as for plotPXG but more completely

- move colors etc to CSS

- function to write CSS styles



### Enhancements to current charts

- lodchart: optional inclusion of ticks at markers

- use d3-tip in lodchart:
  - marker name + LOD score
  - also include point at overall chromosome peak?

- iplotScanone_pxg: same jitter values throughout; animate transitions
  if same chromosome class (same x-axis): need a redraw function

- Add d3-tip to manyboxplot for individual IDs

- iplotPXG: are the d3-tip IDs taken from the cross object?

- scatterplot: allow groupings by color

- curves_w_2scatter
  - make it just curves_w_scatter, and allow use of one or two
    scatterplots (or none?)
  - allow grouping by color
  - allow either brush or mouseover

- curvechart: selection of color as a separate function
  (takes number + pastel/dark)



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

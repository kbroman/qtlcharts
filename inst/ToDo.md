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



### Panels

- panel of inferred QTL (like a scatterplot) (for cis/trans plot)

- mapchart panel; indicating QTL intervals

- lod curve for one chromosome (argument to current panel?)

- general image/heat map panel

- heat map split up into chromosomes



### Charts

- heat map of LOD curves for 10-100 curves

- heat map for functional traits

- cis/trans figure, with slider for selecting a band of LOD scores

- Interactive 2d scan plot



### Annoyances

- lodchart: selecting chromosome, don't want hovering over
  lodcurve/marker to disturb things

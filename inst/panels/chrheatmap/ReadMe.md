### chrheatmap (Reusable heatmap panel, broken into chromosomes)

A reusable chart for making a heat map image with each dimension
broken into chromosomes,
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_chrheatmap.coffee](https://github.com/kbroman/qtlcharts/blob/master/inst/panels/chrheatmap/test/test_chrheatmap.coffee).

Add see it in action
[here](http://kbroman.org/qtlcharts/assets/panels/chrheatmap/test).

Here are all of the options:

```coffeescript
mychart = chrheatmap().pixelPerCell(3)                                         # number of pixels per cell, both width and height
                      .margin({left:60, top:40, right:40, bottom:40})          # margins
                      .axispos({xtitle:25, ytitle:30, xlabel:5, ylabel:5})     # spacing for axis titles and labels
                      .titlepos(20)                                            # spacing for panel title
                      .rectcolor(d3.rgb(230,230,230))                          # background rectangle color
                      .colors(["slateblue", "white", "crimson"]                # colors
                      .zlim(null)                                              # z-axis limits
                      .title("")                                               # panel title
                      .xlab("X")                                               # x-axis label
                      .ylab("Y")                                               # y-axis label
                      .rotate_ylab(null)                                       # rotate y-axis label
                      .zthresh(null)                                           # plot cells with z >= zthresh or <= -zthresh
                      .oneAtTop(false)                                         # whether chromosome 1 should be at top (and left) vs bottom (and left)
                      .hover(true)                                             # whether to include mouseover/mouseout with default info
```

#### Organization of data

  The data should be of the form `{z: z:[[z11, ..., z1n], ...,
  [zn1, ..., znn]], nmar: [n1, n2, ..., nC], chr: [c1, c2, c3, ..., cC], labels:
  [lab1, lab2, ..., labn]}` where `z` gives the values to be plotted,
  `nmar` contains the number of markers on each of the `C` chromosomes,
  `chr` contains the chromosome names for the `C` chromosomes, `labels` are labels for
  each cell (same on x- and y-axis).

  Here's an example dataset: [`data.json`](http://kbroman.org/qtlcharts/assets/panels/chrheatmap/test/data.json).


#### Additional accessors

```coffeescript
# z-axis scale
zscale = mychart.zscale()
zscale(z)

# selection of cells within image, to add .on("click", ...)
cellSelect = mychart.cellSelect()
```

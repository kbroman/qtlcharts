### Reusable marker map chart

A reusable chart for making a genetic marker map,
following
[Mike Bostock](http://bost.ocks.org/mike)'s
[Towards Reuseable Charts](http://bost.ocks.org/mike/chart/).

For an illustration of its use, see [test_mapchart.coffee](https://github.com/kbroman/qtlcharts/blob/master/inst/panels/dotchart/test/test_dotchart.coffee).

Add see it in action
[here](http://www.biostat.wisc.edu/~kbroman/D3/panels/mapchart/test).

Here are all of the options:

```coffeescript
mychart = mapchart().width(400)                                              # internal width of chart
                    .height(500)                                             # internal height
                    .margin({left:60, top:40, right:40, bottom:40, inner:5}) # margins
                    .axispos({xtitle:25, ytitle:30, xlabel:5, ylabel:5})     # spacing for axis titles and labels
                    .titlepos(20)                                            # spacing for panel title
                    .ylim(null)                                              # y-axis limits
                    .nyticks(5)                                              # no. y-axis ticks
                    .yticks(null)                                            # locations of y-axis ticks
                    .tickwidth(null)                                         # width of tick markers at markers, in pixels
                    .rectcolor(d3.rgb(230,230,230))                          # background rectangle color
                    .linecolor("slateblue")                                  # color for lines
                    .linecolorhilit("Orchid)                                 # color for lines when highlighted
                    .linewidth(3)                                            # line width
                    .title("")                                               # panel title
                    .xlab("Chromosome")                                      # x-axis label
                    .ylab("Position (cM)")                                   # y-axis label
```

Additional accessors:

```coffeescript
# x-axis scale
xscale = mychart.xscale()
xscale(x)

# y-axis scale
yscale = mychart.yscale()
yscale(y)

# selection of ticks at markers, to add .on("click", ...)
markerSelect = mychart.markerSelect()
```

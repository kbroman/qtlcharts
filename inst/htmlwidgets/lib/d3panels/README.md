### [d3panels](https://kbroman.org/d3panels): D3-based graphic panels

[![NPM badge](https://img.shields.io/npm/v/d3panels.svg)](https://npmjs.org/package/d3panels)
[![zenodo DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5418277.svg)](https://doi.org/10.5281/zenodo.5418277)

[Karl W Broman](https://kbroman.org)

This is a set of [D3](https://d3js.org)-based graphic panels, to
be combined into larger multi-panel charts.  They were developed for
the [R/qtlcharts](https://kbroman.org/qtlcharts) package.

Note that d3panels uses
[D3 version 7](https://github.com/d3/d3/blob/main/API.md).
(It should also work with version 6.)

There are other libraries with similar goals that are of more general
use (e.g., [C3.js](https://c3js.org)); see
[this list of javascript chart libraries](https://blog.webkid.io/javascript-chart-libraries/)),
but I wanted charts that were a bit _less_ general and flexible, but
rather more specific to my particular applications (and style).

For snapshots and live tests, see <https://kbroman.org/d3panels>.

#### Documentation

For documentation, see <https://github.com/kbroman/d3panels/tree/main/doc>.

#### Usage

All of the functions are called as `d3panels.blah()`.  And for each
chart, you first call the chart function with a set of options, like
this:

```coffeescript
mychart = d3panels.lodchart({height:600, width:800})
```

And then you call the function that's created with some selection and
the data:

```coffeescript
mychart(d3.select("div#chart"), mydata)
```

There are three exceptions to this:
[`add_lodcurve`](add_lodcurve.md), [`add_curves`](add_curves.md), and [`add_points`](add_points.md).
For these functions, you first need to call another function that
creates a panel
(for example, [`lodchart`](lodchart.md) or [`chrpanelframe`](chrpanelframe.md) in
the case of [`add_lodcurve`](add_lodcurve.md), or
[`panelframe`](panelframe.md) in the case of
[`add_curves`](add_curves.md) or [`add_points`](add_points.md)).  You
then use the chart function created by
that first call in place of a selection. For example:

```coffeescript
myframe = d3panels.panelframe({xlim:[0,100],ylim:[0,100]})
myframe(d3.select("body"))

addpts = d3panels.add_points()
addpts(myframe, {x:[5,10,25,50,75,90], y:[8,12,50,30,80,90], group:[1,1,1,2,2,3]})
```


#### Links

You'll need to link to the `d3panels.js` and `d3panels.css` files (or
to `d3panels.min.js` and `d3panels.min.css`):

```html
<script type="text/javascript" src="https://rawgit.com/kbroman/d3panels/main/d3panels.js"></script>
<link rel=stylesheet type="text/css" href="https://rawgit.com/kbroman/d3panels/main/d3panels.css">
```

You'll also want to link to [D3.js](https://d3js.org):

```html
<script charset="utf-8" type="text/javascript" src="https://d3js.org/d3.v5.min.js"></script>
```


#### Build

To build the javascript (and CSS) files from the coffeescript source,
you first need to install [npm](https://www.npmjs.com/get-npm).

Then use npm to install [yarn](https://yarnpkg.com/en/), [coffeescript](https://coffeescript.org), [uglify-js](https://github.com/mishoo/UglifyJS2)
[uglifycss](https://github.com/fmarcia/UglifyCSS), and [babel-core](https://github.com/babel/babel/tree/main/packages/babel-core)

```script
npm install -g yarn coffeescript uglifycss uglify-js babel-core
```

Then install the dependency, [d3](https://d3js.org):

```script
yarn install
```

Finally, run make to create the compiled javascript code.

```script
make
```


#### License

Licensed under the
[MIT license](LICENSE.md). ([More information here](https://en.wikipedia.org/wiki/MIT_License).)

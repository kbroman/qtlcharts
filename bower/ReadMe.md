## Bower to grab javascript libraries

I use [bower](http://bower.io/) (a packaging system for javascript) to
grab d3, colorbrewer, jquery, jquery-ui, d3-tip, and d3panels. The
[`bower/bower.json`](https://github.com/kbroman/qtlcharts/tree/master/bower/bower.json)
file indicates the libraries (and minimal versions) to get.

In the package
[Makefile](https://github.com/kbroman/qtlcharts/tree/master/Makefile),
I pull out just the individual files I want, rather than include
everything that bower pulls down as part of the package.


- To install bower

      npm install -g bower

- Install these packages (indicated within the `bower.json` file)

      bower install

- To update the packages

      bower update

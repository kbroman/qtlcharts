## Bower to grab javascript libraries

I use [yarn](https://yarnpkg.com) (a packaging system for javascript) to
grab d3, jquery, jquery-ui, and d3panels. The
[`js_deps/package.json`](https://github.com/kbroman/qtlcharts/tree/main/js_deps/package.json)
file indicates the libraries (and minimal versions) to get.

In the package
[Makefile](https://github.com/kbroman/qtlcharts/tree/main/Makefile),
I pull out just the individual files I want, rather than include
everything that bower pulls down as part of the package.


- To install yarn

      npm install -g yarn

- Install (or update) the dependent packages (indicated within the `package.json` file)

      yarn install

For the d3-tip library, I use
[UglifyJs](https://github.com/mishoo/UglifyJS2) to make it smaller.
You can install UglifyJs with npm (as with bower):

    npm install -g uglify-js

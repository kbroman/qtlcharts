// Generated by CoffeeScript 1.6.3
(function() {
  var h, halfh, halfw, margin, totalh, totalw, w;

  h = 600;

  w = 900;

  margin = {
    left: 60,
    top: 40,
    right: 40,
    bottom: 40,
    inner: 5
  };

  halfh = h + margin.top + margin.bottom;

  totalh = halfh * 2;

  halfw = w + margin.left + margin.right;

  totalw = halfw * 2;

  d3.json("data.json", function(data) {
    var mychart;
    mychart = curvechart().xlab("Age (weeks)").ylab("Body weight").height(h).width(w).margin(margin).strokewidthhilit(4).strokecolor(["lightpink", "lightblue"]).strokecolorhilit(["Orchid", "slateblue"]).commonX(true);
    return d3.select("div#chart").datum(data).call(mychart);
  });

}).call(this);

// Generated by CoffeeScript 1.8.0
var iplotMap;

iplotMap = function(data, chartOpts) {
  var axispos, chartdivid, chr, height, linecolor, linecolorhilit, linewidth, margin, marker, markerSelect, markerpos, martip, mychart, nyticks, rectcolor, selectedMarker, tickwidth, title, titlepos, width, xlab, ylab, ylim, yticks, _i, _len, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref16, _ref17, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
  width = (_ref = chartOpts != null ? chartOpts.width : void 0) != null ? _ref : 1000;
  height = (_ref1 = chartOpts != null ? chartOpts.height : void 0) != null ? _ref1 : 600;
  margin = (_ref2 = chartOpts != null ? chartOpts.margin : void 0) != null ? _ref2 : {
    left: 60,
    top: 40,
    right: 40,
    bottom: 40,
    inner: 10
  };
  axispos = (_ref3 = chartOpts != null ? chartOpts.axispos : void 0) != null ? _ref3 : {
    xtitle: 25,
    ytitle: 30,
    xlabel: 5,
    ylabel: 5
  };
  titlepos = (_ref4 = chartOpts != null ? chartOpts.titlepos : void 0) != null ? _ref4 : 20;
  ylim = (_ref5 = chartOpts != null ? chartOpts.ylim : void 0) != null ? _ref5 : null;
  nyticks = (_ref6 = chartOpts != null ? chartOpts.nyticks : void 0) != null ? _ref6 : 5;
  yticks = (_ref7 = chartOpts != null ? chartOpts.yticks : void 0) != null ? _ref7 : null;
  tickwidth = (_ref8 = chartOpts != null ? chartOpts.tickwidth : void 0) != null ? _ref8 : 10;
  rectcolor = (_ref9 = chartOpts != null ? chartOpts.rectcolor : void 0) != null ? _ref9 : "#E6E6E6";
  linecolor = (_ref10 = chartOpts != null ? chartOpts.linecolor : void 0) != null ? _ref10 : "slateblue";
  linecolorhilit = (_ref11 = chartOpts != null ? chartOpts.linecolorhilit : void 0) != null ? _ref11 : "Orchid";
  linewidth = (_ref12 = chartOpts != null ? chartOpts.linewidth : void 0) != null ? _ref12 : 3;
  title = (_ref13 = chartOpts != null ? chartOpts.title : void 0) != null ? _ref13 : "";
  xlab = (_ref14 = chartOpts != null ? chartOpts.xlab : void 0) != null ? _ref14 : "Chromosome";
  ylab = (_ref15 = chartOpts != null ? chartOpts.ylab : void 0) != null ? _ref15 : "Position (cM)";
  chartdivid = (_ref16 = chartOpts != null ? chartOpts.chartdivid : void 0) != null ? _ref16 : 'chart';
  mychart = mapchart().height(height).width(width).margin(margin).axispos(axispos).titlepos(titlepos).ylim(ylim).yticks(yticks).nyticks(nyticks).tickwidth(tickwidth).rectcolor(rectcolor).linecolor(linecolor).linecolorhilit(linecolorhilit).linewidth(linewidth).title(title).xlab(xlab).ylab(ylab);
  d3.select("div#" + chartdivid).datum(data).call(mychart);
  markerpos = {};
  _ref17 = data.chr;
  for (_i = 0, _len = _ref17.length; _i < _len; _i++) {
    chr = _ref17[_i];
    for (marker in data.map[chr]) {
      markerpos[marker] = {
        chr: chr,
        pos: data.map[chr][marker]
      };
    }
  }
  martip = d3.tip().attr('class', 'd3-tip').html(function(d) {
    var pos;
    pos = d3.format(".1f")(markerpos[d].pos);
    return "" + d + " (" + pos + ")";
  }).direction('e').offset([0, 10]);
  d3.select("div#" + chartdivid + " svg").call(martip);
  selectedMarker = "";
  $("#markerinput").submit(function() {
    var line, newSelection;
    newSelection = document.getElementById("marker").value;
    event.preventDefault();
    if (selectedMarker !== "") {
      d3.select("line#" + selectedMarker).attr("stroke", linecolor);
      martip.hide();
    }
    if (newSelection !== "") {
      if (data.markernames.indexOf(newSelection) >= 0) {
        selectedMarker = newSelection;
        line = d3.select("line#" + selectedMarker).attr("stroke", linecolorhilit);
        martip.show(line.datum(), line.node());
        d3.select("a#currentmarker").text("");
        return true;
      } else {
        d3.select("a#currentmarker").text("Marker \"" + newSelection + "\" not found");
      }
    }
    return false;
  });
  $('input#marker').autocomplete({
    autoFocus: true,
    source: function(request, response) {
      var matches;
      matches = $.map(data.markernames, function(tag) {
        if (tag.toUpperCase().indexOf(request.term.toUpperCase()) === 0) {
          return tag;
        }
      });
      return response(matches);
    },
    select: function(event, ui) {
      $('input#marker').val(ui.item.label);
      return $('input#submit').submit();
    }
  });
  $('input#marker').each(function() {
    return $(this).data('default', $(this).val()).addClass('inactive').focus(function() {
      $(this).removeClass('inactive');
      if ($(this).val() === $(this).data('default') || $(this).val() === '') {
        return $(this).val('');
      }
    }).blur(function() {
      if ($(this).val() === '') {
        return $(this).addClass('inactive').val($(this).data('default'));
      }
    });
  });
  markerSelect = mychart.markerSelect();
  return markerSelect.on("mouseover", martip.hide);
};

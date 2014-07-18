# illustration of use of the lodheatmap panel

h = 700
w = 1000

# Example: simplest use
d3.json "data.json", (data) ->
    mychart = lodheatmap().height(h)
                          .width(w)
                          .zthresh(1.0)

    d3.select("div#chart1")
      .datum(data)
      .call(mychart)

# Example with use of quantitative y-axis scale
d3.json "data.json", (data) ->

    times = (x/6 for x of data.lodnames)
    lod_labels = (formatAxis(times, 1)(x) for x in times)

    mychart = lodheatmap().height(h)
                          .width(w)
                          .zthresh(1.0)
                          .quantScale(times)
                          .lod_labels(lod_labels)

    d3.select("div#chart2")
      .datum(data)
      .call(mychart)

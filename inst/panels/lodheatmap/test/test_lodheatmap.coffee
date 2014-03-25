# illustration of use of the lodheatmap panel

h = 600
w = 600

# Example: simplest use
d3.json "data.json", (data) ->
  mychart = lodheatmap().height(h)
                        .width(w)
                        .zthresh(0.5)

  d3.select("div#chart")
    .datum(data)
    .call(mychart)

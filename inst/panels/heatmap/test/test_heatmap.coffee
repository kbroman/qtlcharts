# illustration of use of the heatmap function

h = 600
w = 600

# Example: simplest use
d3.json "data.json", (data) ->
  mychart = heatmap().height(h)
                     .width(w)
                     .zthresh(1) 

  d3.select("div#chart")
    .datum(data)
    .call(mychart)

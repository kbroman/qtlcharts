# illustration of use of the curvechart function

h = 600
w = 900
margin = {left:60, top:40, right:40, bottom: 40, inner:5}
halfh = (h+margin.top+margin.bottom)
totalh = halfh*2
halfw = (w+margin.left+margin.right)
totalw = halfw*2

# Example : simplest use
d3.json "data.json", (data) ->
  mychart = curvechart().xlab("Age (weeks)")
                        .ylab("Body weight")
                        .height(h)
                        .width(w)
                        .margin(margin)
                        .strokewidthhilit(4)
                        .commonX(true)

  d3.select("div#chart")
    .datum(data)
    .call(mychart)

class EnviroChart {
  static run(params, duration=1000){
    var chart = new EnviroChart(params, duration);
    chart.init();

    setInterval(() => {
      let xhr = new XMLHttpRequest();
      xhr.onreadystatechange = () => {
        if (this.readyState == 4 && this.status == 200) {
          var json = JSON.parse(this.responseText);
          chart.update(json);
        }
      }
      xhr.open("GET", "/tick", true);
      xhr.send();
    }, duration);
  }

  constructor(params, duration=1000, limit=60, elem='#chart'){
    this.elem = elem;
    this.params = params;
    this.data = params.map((key) => {
      return {
        id: key,
        values: [],
        max: null,
        min: null
      }
    });
    this.duration = duration; //how quickly to move (will look jerky if less that data input rate)
    this.limit = limit; // how many datapoints, total points = (duration * limit)
  }

  init(){
    let svg = d3.select(this.elem),
      margin = {
        top: 5,
        right: 5,
        bottom: 50,
        left: 30
      },
      width = Math.floor(window.innerWidth - margin.left - margin.right),
      height = Math.floor(window.innerHeight - margin.top - margin.bottom);

    svg.attr('width', width).attr('height', height + 50);

    let g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    g.append("defs").append("clipPath")
      .attr("id", "clip2")
      .append("rect")
      .attr("x", 0)
      .attr("y", 0)
      .attr("width", width)
      .attr("height", height);

    this.x = d3.scaleTime().range([0, width]);
    this.y = d3.scaleLinear().range([height, 0])
    this.z = d3.scaleOrdinal(d3.schemeCategory10);

    this.y.domain([0, 50]);

    this.line = d3.line()
      .curve(d3.curveBasis)
      .x((d) => {
        return x(d.date);
      })
      .y((d) => {
        return y(d.value);
      });

    this.z.domain(this.params);

    this.x_axis = d3.axisBottom().scale(this.x);

    this.x_axis_svg = g.append("g")
      .attr("class", "axis axis--x")
      .attr("transform", "translate(0," + height + ")");

    this.x_axis_svg.call(this.x_axis);

    this.pathsG = g.append("g").attr("id", "paths")
      .attr("class", "paths")
      .attr("clip-path", "url(#clip2)");
  }

  updateChartData(json, now){
    this.data.forEach((e) => {
      let value = json[e.id];
      let min = e.min === null ? value : (min < e.min ? min : e.min);
      let max = e.max === null ? value : (max > e.max ? max : e.max);

      e.values.push({
        date: now,
        value: value,
      });
      if (e.values.length > 1000) {
        e.values.shift();
      }
      e.max = max;
      e.min = min;
    });
  }

  update(json){
    let now = new Date(json.time * 1000);
    this.updateChartData(json, now);

    let yMin = 0;
    let yMax = 0;
    let scale = 1.2;
    this.data.forEach((e) => {
      yMin = e.min > yMin ? e.min : yMin;
      yMax = e.max > yMax ? e.max : yMax;
    });
    this.y.domain([yMin * scale, yDom * scale]);

    this.x.domain([now - ((this.limit - 2) * this.duration), now - this.duration])
    // Slide x-axis left
    this.x_axis_svg.transition().duration(this.duration).ease(d3.easeLinear, 2).call(x_axis);

    //Join
    let g = pathsG.selectAll(".minerLine").data(dta);
    let gEnter = g.enter()
      //Enter
      .append("g")
      .attr("class", "minerLine")
      .merge(g);

    let svg = g.selectAll("path").data(function (d) {
      return [d];
    });
    svg.enter()
      //Enter
      .append("path").attr("class", "line")
      .style("stroke", (d) => {
        return z(d.id);
      })
      .merge(svg)
      //Update
      .transition()
      .duration(duration)
      .ease(d3.easeLinear, 2)
      .attr("d", (d) => {
        return line(d.values)
      })
      .attr("transform", null);

    let text = d3.select("#legend").selectAll("div").data(dta);
    text.enter()
      .append("div")
      .attr("class", "legenditem")
      .style("color", (d) => {
        return z(d.id);
      })
      .merge(text)
      .text((d) => {
        return d.id + ": " + d.values[d.values.length - 1].value;
      });
  }
}


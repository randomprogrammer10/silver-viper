function initChart (params, yDom) {
    var svg = d3.select("#chart"),
        margin = {
            top: 5,
            right: 5,
            bottom: 50,
            left: 30
        },
        width = Math.floor(window.innerWidth - margin.left - margin.right),
        height = Math.floor(window.innerHeight - margin.top - margin.bottom);

    svg
        .attr('width', width)
        .attr('height', height + 50);

    var g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    g.append("defs").append("clipPath")
        .attr("id", "clip2")
        .append("rect")
        .attr("x", 0)
        .attr("y", 0)
        .attr("width", width)
        .attr("height", height);

    var x = d3.scaleTime().range([0, width]),
        y = d3.scaleLinear().range([height, 0]),
        z = d3.scaleOrdinal(d3.schemeCategory10);

    y.domain([0, yDom]);

    var line = d3.line()
        .curve(d3.curveBasis)
        .x(function (d) {
            return x(d.date);
        })
        .y(function (d) {
            return y(d.value);
        });

    //TODO: edit to match incoming data
    let dta = [];
    params.forEach(key => {
        dta.push({
            id: key,
            values: [],
        });
    });

    z.domain(params);

    var x_axis = d3.axisBottom()
        .scale(x);
    var x_axis_svg = g.append("g")
        .attr("class", "axis axis--x")
        .attr("transform", "translate(0," + height + ")");

    x_axis_svg.call(x_axis);

    let pathsG = g.append("g").attr("id", "paths").attr("class", "paths")
        .attr("clip-path", "url(#clip2)");

    let globalX = 0;
    let duration = 1000; //how quickly to move (will look jerky if less that data input rate)
    let limit = 60; // how many datapoints, total points = (duration * limit)

    function updateChart(json) {

        //TODO: comment out block of code
        let now = new Date(json.time);
        dta.forEach((e) => {
            e.values.push({
                date: now,
                value: e.id,
            });
        });
        //end comment block

        // Shift domain
        x.domain([now - ((limit - 2) * duration), now - duration])
        // Slide x-axis left
        x_axis_svg.transition().duration(duration).ease(d3.easeLinear, 2).call(x_axis);

        //Join
        var g = pathsG.selectAll(".minerLine").data(dta);
        var gEnter = g.enter()
            //Enter
            .append("g")
            .attr("class", "minerLine")
            .merge(g);

        //Join
        var svg = g.selectAll("path").data(function (d) {
            return [d];
        });
        svg.enter()
            //Enter
            .append("path").attr("class", "line")
            .style("stroke", function (d) {
                return z(d.id);
            })
            .merge(svg)
            //Update
            .transition()
            .duration(duration)
            .ease(d3.easeLinear, 2)
            .attr("d", function (d) {
                return line(d.values)
            })
            .attr("transform", null)

        var text = d3.select("#legend").selectAll("div").data(dta)
        text.enter()
            .append("div")
            .attr("class", "legenditem")
            .style("color", function (d) {
                return z(d.id);
            })
            .merge(text)
            .text(function (d) {
                return d.id + ": " + d.values[d.values.length - 1].value;
            })

    }

    var d = setInterval(function () {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                var json = JSON.parse(this.responseText);  
                updateChart(json);
            }
        }
        xhr.open("GET", "/tick", true);
        xhr.send();
    }, 5000);
}
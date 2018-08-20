// HELPER FUNCTIONS
function toHex(v) {
    var str = "00" + Math.floor(Math.max(0, Math.min(255, v))).toString(16);
    return str.substr(str.length-2);
}

function rgb(r, g, b) {
    return "#" + toHex(r * 255) + toHex(g * 255) + toHex(b * 255);
}

function color(count) {
    var amount = (2500 - count) / 2500 * 255;
    var s = toHex(amount), s2 = toHex(amount / 2 + 127), s3 = toHex(amount / 2 + 127);
    return "#" + s + s2 + s3;
}


// scatterplot_1
var WIDTH = 500;
var HEIGHT = 500;
var MARGIN = 10;

var cxScale = d3.scaleLinear()
	.domain([0,800])
	.range([MARGIN,WIDTH - MARGIN]);

var cyScale = d3.scaleLinear()
	.domain([0,800])
	.range([HEIGHT - MARGIN, MARGIN]);

var colorScale = d3.scaleLinear()
	.domain([1,4])
	.range([0,1]);

var rScale = d3.scaleSqrt()
	.domain([15,35])
	.range([10,20]);

var scatterplot_1 = d3.select("#scatterplot_1").append("svg")
		.attr("width", WIDTH + 2*MARGIN)
		.attr("height", HEIGHT + 2*MARGIN);

var circles = scatterplot_1.selectAll(".circles")
	.data(scores)
	.enter()
	.append("circle");

circles
	.attr("cx", s => cxScale(s.SATM))
	.attr("cy", s => cyScale(s.SATV))
	.attr("r", s => rScale(s.ACT))
	.attr("fill", s => rgb(0,0,colorScale(s.GPA)))
	.attr("stroke", "black");

// labels
scatterplot_1.append("g")
      .attr("transform", "translate(0," + HEIGHT  + ")")
      .call(d3.axisBottom(cxScale))

scatterplot_1.append("g")
      .attr("transform", "translate(25," + 0 + ")")
      .call(d3.axisLeft(cyScale))

// Buttons
function scheme1(){
	var min = Math.min.apply(null, scores.map(function(s){return s.SATV;}))
	var max = Math.max.apply(null, scores.map(function(s){return s.SATV;}))

	var redScale = d3.scaleLinear()
		.domain([min,max])
		.range([1,0]);

	var greenScale = d3.scaleLinear()
		.domain([min,max])
		.range([0,1]);

	circles.attr("fill", s => rgb(redScale(s.SATV),greenScale(s.SATV),0.2));
}
function scheme2(){
	var min = Math.min.apply(null, scores.map(function(s){return s.SATV;}))
	var avg = scores.reduce(function(a,b) { return a + b.SATV},0) / (scores.length-1);
	var max = Math.max.apply(null, scores.map(function(s){return s.SATV;}))

	var colorScale = d3.scaleLinear()
		.domain([min,avg,max])
		.range(["#d7191c"," #ffffbf","#1a9641"]);

	circles.attr("fill", s => colorScale(s.SATV));
}

function scheme3(){
	var min = Math.min.apply(null, scores.map(function(s){return s.SATV;}))
	var max = Math.max.apply(null, scores.map(function(s){return s.SATV;}))

	var colorScale = d3.scaleQuantize()
		.domain([min,max])
		.range(["#d7191c","#fdae61", "#ffffbf","#a6d96a","#1a9641"]);

	circles.attr("fill", s => colorScale(s.SATV));
}

var buttonList = [
    {
        name: "colormap-button-1",
        text: "Color Scheme 1",
        click: scheme1
    },
    {
        name: "colormap-button-2",
        text: "Color Scheme 2",
        click: scheme2
    },
    {
        name: "colormap-button-3",
        text: "Color Scheme 3",
        click: scheme3
    },
    

];

d3.select("#scatterplot_1")
    .selectAll("button")
    .data(buttonList)
    .enter()
    .append("button")
    .attr("id", function(d) { return d.name; })
    .text(function(d) { return d.text; })
    .on("click", function(d) {
        return d.click();
    });

//////////////////////////////////////////////////////////////////////////////
// Global variables, preliminaries

var svgSize = 500;
var bands = 50;

var xScale = d3.scaleLinear().domain([0, bands]).  range([0, svgSize]);
var yScale = d3.scaleLinear().domain([-1,bands-1]).range([svgSize, 0]);

function createSvg(sel)
{
    return sel
        .append("svg")
        .attr("width", svgSize)
        .attr("height", svgSize);
}

function createRects(sel)
{
    return sel
        .append("g")
        .selectAll("rect")
        .data(data)
        .enter()
        .append("rect")
        .attr("x", function(d) { return xScale(d.Col); })
        .attr("y", function(d) { return yScale(d.Row); })
        .attr("width", 10)
        .attr("height", 10);
}

function createPaths(sel)
{
    return sel
        .append("g")
        .selectAll("g")
        .data(data)
        .enter()
        .append("g")
        .attr("transform", function(d) {
            return "translate(" + xScale(d.Col) + "," + yScale(d.Row) + ")";
        })
        .append("path");
}

d3.selection.prototype.callReturn = function(callable)
{
    return callable(this);
};
// Helper Functions
//////////////////////////////////////////////////////////////////////////////
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
// The logistic function 1/(1+100e^(-x))
function logistic(n){
	mag = Math.abs(n);
	return 1/(1+100*Math.exp(-mag));
}
// Main Functions
//////////////////////////////////////////////////////////////////////////////

function glyphD(d) {
	var half = "M 2 5 l 6 0 ",
		hbar = "M 0 5 l 10 0 ",
		vbar = "M 5 0 l 0 10 ",
		diag1 = "M 10 0 l -10 10 ",
		diag2 = "M 10 10 l -10 -10 ";

	// Glyphs, in order from lightest to heaviest.
	var g1 = half,
		g2 = hbar,
		g3 = g2 + vbar,
		g4 = g3 + diag1,
		g5 = g4 + diag2;

	var glyphs = [g1,g2,g3,g4,g5];

	var scaleLow = d3.scaleQuantile()
		.domain([0,-300])
		.range(glyphs); 

	var scaleHigh = d3.scaleQuantile()
		.domain([0,180])
		.range(glyphs); 

	return (d.P > 0) ? scaleHigh(d.P) : scaleLow(d.P);
}

function glyphGolf(d){
	var g1 = "M 2 5 l 6 0 ",
		g2 = "M 0 5 l 10 0 ",
		g3 = g2 + "M 5 0 l 0 10 ",
		g4 = g3 + "M 10 0 l -10 10 ",
		g5 = g4 + "M 10 10 l -10 -10 ";

	var scaleLow = d3.scaleQuantile()
		.domain([0,-300])
		.range([g1,g2,g3,g4,g5]); 

	var scaleHigh = d3.scaleQuantile()
		.domain([0,180])
		.range([g1,g2,g3,g4,g5]); 

	return (d.P > 0) ? scaleHigh(d.P) : scaleLow(d.P);
}

function glyphStroke(d) {
	return (d.P > 0) ? rgb(1,1,1) : rgb(0,0,0);
}	

function colorT1(d) {
	 var scale = d3.scaleSqrt()
                .domain([-60,-65,-70])
                .range(["#d7191c"," #ffffdf","#1a9641"])
		.interpolate(d3.interpolateLab);

	return scale(d.T);
}

function colorP1(d) {
	 var scale = d3.scaleLinear()
                .domain([-500,0,200])
                .range(["#d7191c"," #ffffdf","#1a9641"])
		.interpolate(d3.interpolateLab);

	return scale(d.P);
}

function colorPT(d) {
		
	 var scaleP = d3.scaleLinear()
                .domain([-500,0,200])
                .range(["#d7191c"," #ffffdf","#1a9641"])
                //.range(["#00ff00","#ffffff","#0000ff"])
		.interpolate(d3.interpolateLab);

	 var scaleT = d3.scaleLinear()
                .domain([-60,-70])
                .range(["#ffffff","#0000ff"])
		.interpolate(d3.interpolateLab);

	
	var lab = d3.interpolateLab(scaleT(d.T),scaleP(d.P));
	//return scaleP(
	return lab(0.5);

	var pressureLow = d3.scaleSqrt()
		.domain([0,-500])
		.range([0,1]); 

	var tempHi = d3.scaleLinear()
		.domain([-65,-60])
		.range([0,1]); 

	var tempLow = d3.scaleLinear()
		.domain([-65,-70])
		.range([0,1]); 

	var green = 0.2;

	if (d.T > -65 && d.P > 0){
		return rgb(pressureHi(d.P),0.5-pressureHi(d.T) - tempHi(d.T),tempHi(d.T));
	} 
	else if (d.T < -65 && d.P > 0){
		return rgb(pressureHi(d.P),0.5-pressureHi(d.T) - tempLow(d.T),tempLow(d.T));
	}
	else if (d.T > -65 && d.P < 0){
		return rgb(pressureLow(d.P),0.5-pressureLow(d.T) - tempHi(d.T),tempHi(d.T));
	}
	else {
		return rgb(pressureLow(d.P),0.5-pressureLow(d.T) - tempLow(d.T),tempLow(d.T));
	}
}

function colorT2(d) {
	 var scale = d3.scaleSqrt()
                .domain([-60,-65,-70])
                .range(["#28e6e3", "#000020","#e569be"])
		.interpolate(d3.interpolateLab);

	return scale(d.T);
}

//////////////////////////////////////////////////////////////////////////////

d3.select("#plot1-temperature")
    .callReturn(createSvg)
    .callReturn(createRects)
    .attr("fill", colorT1);

d3.select("#plot1-pressure")
    .callReturn(createSvg)
    .callReturn(createRects)
    .attr("fill", colorP1);

d3.select("#plot2-bivariate-color")
    .callReturn(createSvg)
    .callReturn(createRects)
    .attr("fill", colorPT);

var bivariateSvg = d3.select("#plot3-bivariate-glyph")
        .callReturn(createSvg);

bivariateSvg
    .callReturn(createRects)
    .attr("fill", colorT2);

bivariateSvg
    .callReturn(createPaths)
    .attr("d", glyphD)
    .attr("stroke", glyphStroke)
    .attr("stroke-width", 1);


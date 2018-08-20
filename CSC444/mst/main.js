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

function createGroups(data) {
    return function(sel) {
        return sel
            .append("g")
            .selectAll("*")
            .data(data)
            .enter()
            .append("g")
            .attr("transform", function(d) {
                return "translate(" + xScale(d.Col) + "," + yScale(d.Row) + ")";
            });
    };
}

d3.selection.prototype.callReturn = function(callable)
{
    return callable(this);
};

//////////////////////////////////////////////////////////////////////////////
// PART 1

var colorScale = d3.scaleLinear().domain([0, 2]).range(["white", "red"]);
var magColor = d3.select("#plot1-color")
        .callReturn(createSvg)
        .callReturn(createGroups(data));

function magnitude(d){
	return Math.sqrt(d.vx*d.vx + d.vy*d.vy);
}

magColor.append("rect")
	.attr("height",10)
	.attr("width",10)
	.attr("fill", function(d){
		return colorScale(magnitude(d));
	});


//////////////////////////////////////////////////////////////////////////////
// PART 2

var hedgehog = d3.select("#plot1-hedgehog")
        .callReturn(createSvg)
        .callReturn(createGroups(data));

var maxMag = Math.max(...data.map(magnitude));

var magScale = d3.scaleLinear()
		.domain([0,maxMag])
		.range([0,10]);

hedgehog.append("line")
		.attr("stroke","black")
		.attr("x1",0)
		.attr("y1",0)
		.attr("x2", function(d){
			var dir = Math.atan2(d.vx,d.vy);
			var mag = magScale(magnitude(d));
			return Math.abs(Math.cos(dir))*mag;
		})
		.attr("y2", function(d){
			var dir = Math.atan2(d.vx,d.vy);
			var mag = magScale(magnitude(d));
			return Math.abs(Math.sin(dir))*mag;
		});

//////////////////////////////////////////////////////////////////////////////
// PART 3
function getRotation(d){
	return (Math.atan2(d.vx,d.vy) * (180/Math.PI) - 180) % 360;
}

var unifGlyph = d3.select("#plot1-uniform")
        .callReturn(createSvg)
        .callReturn(createGroups(data));

unifGlyph.append("g")
   .attr("transform", function(d) {
	   return "rotate(" + getRotation(d) + " 5 5)"
   }).append("path")
		.attr("d","M3,3 L3,7 L6,5 z")

unifGlyph.append("g")
   .attr("transform", function(d) {
	   return "rotate(" + getRotation(d) + " 5 5)"
   }).append("line")
		.attr("stroke","black")
		.attr("stroke-width",1)
		.attr("x1", function(d) { return 3 - magScale(magnitude(d));})  
		.attr("y1",5)  
		.attr("x2",5)  
		.attr("y2",5)  

//////////////////////////////////////////////////////////////////////////////
// PART 4

var randomGlyph = d3.select("#plot1-random")
        .callReturn(createSvg)
        .callReturn(createGroups(data));

var rt = randomGlyph.append("g")
   .attr("transform", function(d) {
	   return "translate("+ Math.random() * 10 + "," + Math.random() * 10 + ") rotate(" + getRotation(d) + " 5 5)"
   })
rt.append("line")
		.attr("stroke","black")
		.attr("stroke-width",1)
		.attr("x1", function(d) { return 3 - magScale(magnitude(d));})  
		.attr("y1",5)  
		.attr("x2",5)  
		.attr("y2",5)
		rt.append("path")
		.attr("d","M3,3 L3,7 L6,5 z")

//randomGlyph.append("g")
    //.attr("transform", function(d) {
        //// WRITE THIS PART
    //}).append("path"); // WRITE THIS PART

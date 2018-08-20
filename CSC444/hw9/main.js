
function gridExtent(d) {
    return [Math.min(d.NW, d.NE, d.SW, d.SE),
            Math.max(d.NW, d.NE, d.SW, d.SE)];
}

//////////////////////////////////////////////////////////////////////////////
// Global variables, preliminaries

var svgSize = 490;
var bands = 49;

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
            .selectAll("rect")
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

function polarity(d, value) {
    var result = {
        NW: d.NW < value ? 0 : 1,
        NE: d.NE < value ? 0 : 1,
        SW: d.SW < value ? 0 : 1,
        SE: d.SE < value ? 0 : 1
    };
    result.case = result.SW + result.SE * 2 + result.NE * 4 + result.NW * 8;
    return result;
}
function reversePolarity(d, value) {
    var result = {
        NW: d.NW >= value ? 0 : 1,
        NE: d.NE >= value ? 0 : 1,
        SW: d.SW >= value ? 0 : 1,
        SE: d.SE >= value ? 0 : 1
    };
    result.case = result.SW + result.SE * 2 + result.NE * 4 + result.NW * 8;
    return result;
}

// currentContour is a global variable which stores the value
// of the contour we are currently extracting

var currentContour;
function includesOutlineContour(d) {
    var extent = gridExtent(d);
    return currentContour >= extent[0] && currentContour <= extent[1];
}

function includesFilledContour(d) {
    var extent = gridExtent(d);
	return true;
}

function generateOutlineContour(d) {
	
    var west = d3.scaleLinear()
		.domain([d.SW, d.NW])
		.range([0,10])(currentContour);

    var east = d3.scaleLinear()
		.domain([d.SE, d.NE])
		.range([0,10])(currentContour);

    var north = d3.scaleLinear()
		.domain([d.NW, d.NE])
		.range([0,10])(currentContour);
	
    var south = d3.scaleLinear()
		.domain([d.SW, d.SE])
		.range([0,10])(currentContour);

	var westP = {x:0, y:west},
		northP = {x:north, y:10},
		eastP = {x:10, y:east},
		southP = {x:south, y:0};
	
	function makePath(p1,p2,casenum =-1){
		if(p1.x <= 10 && p2.x <= 10 && p1.y <= 10 && p2.y <= 10 &&
		p1.x >= 0 && p2.x >= 0 && p1.y >= 0 && p2.y >= 0)
			return "M " + p1.x + " " + p1.y + " L " + p2.x + " " + p2.y;
		console.log("Wrong case",casenum)
		return ""
	}


    switch (polarity(d, currentContour).case) {
		case 0:
			return "";
		case 1:
			return makePath(westP,southP,1);
		case 2:
			return makePath(southP,eastP,2);
		case 3:
			return makePath(westP,eastP,3);
		case 4:
			return makePath(northP,eastP,4);
		case 5:
			return makePath(northP,westP) + makePath(southP,eastP);
		case 6:
			return makePath(northP,southP,6);
		case 7:
			return makePath(northP,westP,7);
		case 8:
			return makePath(northP,westP,8);
		case 9:
			return makePath(northP,southP,9);
		case 10:
			return makePath(southP,westP) + makePath(northP,eastP);
		case 11:
			return makePath(northP, eastP,11);
		case 12:
			return makePath(eastP, westP,12);
		case 13:
			return makePath(southP, eastP,13);
		case 14:
			return makePath(westP, southP,14);
		default:
			return "";
    }
}

function generateFilledContour(d) {
    // HINT: you should set up scales which, given a contour value, go
    // along positions in the boundary of the square
    var west = d3.scaleLinear()
		.domain([d.SW, d.NW])
		.range([0,10])(currentContour);

    var east = d3.scaleLinear()
		.domain([d.SE, d.NE])
		.range([0,10])(currentContour);

    var north = d3.scaleLinear()
		.domain([d.NW, d.NE])
		.range([0,10])(currentContour);
	
    var south = d3.scaleLinear()
		.domain([d.SW, d.SE])
		.range([0,10])(currentContour);

	var westP = {x:0, y:west},
		northP = {x:north, y:10},
		eastP = {x:10, y:east},
		southP = {x:south, y:0};
	
	var NEP = {x:10,y:10},
		NWP = {x:0,y:10},
		SEP = {x:10,y:0},
		SWP = {x:0,y:0};
	
	function makePath(){
		var p1 = arguments[0],
			p2 = arguments[1];
		if(!(p1.x <= 10 && p2.x <= 10 && p1.y <= 10 && p2.y <= 10 &&
		p1.x >= 0 && p2.x >= 0 && p1.y >= 0 && p2.y >= 0))
			console.log("Wrong case")

		var result = "M " + p1.x + " " + p1.y;
		for(i = 1; i < arguments.length; i++){
			result += " L " + arguments[i].x + " " + arguments[i].y;
		}
		return result.concat(" Z");
	}



    switch (reversePolarity(d, currentContour).case) {
		case 0:
			return "";
		case 1:
			return makePath(westP,southP,SWP);
		case 2:
			return makePath(southP,eastP,SEP);
		case 3:
			return makePath(westP,eastP,SEP,SWP);
		case 4:
			return makePath(northP,eastP,NEP);
		case 5:
			return makePath(northP,westP,SWP,southP,eastP,NEP);
		case 6:
			return makePath(northP,southP,SEP,NEP);
		case 7:
			return makePath(northP,westP,SWP,SEP,NEP);
		case 8:
			return makePath(northP,westP,NWP);
		case 9:
			return makePath(northP,southP,SWP,NWP);
		case 10:
			return makePath(southP,westP,NWP,northP,eastP,SEP);
		case 11:
			return makePath(northP,eastP,SEP,SWP,NWP);
		case 12:
			return makePath(eastP,westP,NWP,NEP);
		case 13:
			return makePath(southP,eastP,NEP,NWP,SWP);
		case 14:
			return makePath(westP,southP,SEP,NEP,NWP);
		case 15:
			return makePath(SWP,SEP,NEP,NWP);
		default:
			return "";
	}
}

function createOutlinePlot(minValue, maxValue, steps, sel)
{
    var contourScale = d3.scaleLinear().domain([1, steps]).range([minValue, maxValue]);
    for (var i=1; i<=steps; ++i) {
        currentContour = contourScale(i);
        sel.filter(includesOutlineContour).append("path")
            .attr("transform", "translate(0, 10) scale(1, -1)") 
			// ensures that positive y points up
            .attr("d", generateOutlineContour)
            .attr("fill", "none")
            .attr("stroke", "black");
    }
}

function createFilledPlot(minValue, maxValue, steps, sel, colorScale)
{
    var contourScale = d3.scaleLinear().domain([1, steps]).range([minValue, maxValue]);
    for (var i=steps; i>=1; --i) {
        currentContour = contourScale(i);
        sel.filter(includesFilledContour).append("path")
            .attr("transform", "translate(0, 10) scale(1, -1)") 
			// ensures that positive y points up
            .attr("d", generateFilledContour)
            .attr("fill", function(d) { return colorScale(currentContour); });
    }
}

var plot1T = d3.select("#plot1-temperature")
        .callReturn(createSvg)
        .callReturn(createGroups(temperatureCells));
var plot1P = d3.select("#plot1-pressure")
        .callReturn(createSvg)
        .callReturn(createGroups(pressureCells));

createOutlinePlot(-70, -60, 10, plot1T);
createOutlinePlot(-500, 200, 10, plot1P);

var plot2T = d3.select("#plot2-temperature")
        .callReturn(createSvg)
        .callReturn(createGroups(temperatureCells));

var plot2P = d3.select("#plot2-pressure")
        .callReturn(createSvg)
        .callReturn(createGroups(pressureCells));

createFilledPlot(-70, -60, 10, plot2T, d3.scaleLinear()
	.domain([-70, -60])
	.range(["blue", "red"]));

createFilledPlot(-500, 200, 10, plot2P, d3.scaleLinear()
	.domain([-500, 0, 500])
	.range(["#ca0020", "#f7f7f7", "#0571b0"]));

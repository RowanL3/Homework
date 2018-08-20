var data   = scores;
var svgSize = 400;


// brush1 and brush2 will store the extents of the brushes,
// if brushes exist respectively on scatterplot 1 and 2.
//
// if either brush does not exist, brush1 and brush2 will
// hold the null value.

var brush1 = null;
var brush2 = null;

function click(d,i) {
	e1 = null;
	e2 = null;

	function selected(x){
		return x.SATV == d.SATV && x.SATM == d.SATM
			&& x.ACT == d.ACT && x.GPA == d.GPA;
	}
	
	plot1.svg.select(".brush").call(plot1.brush.move, null);
	plot2.svg.select(".brush").call(plot2.brush.move, null);

	d3.select("td#table-SATM").text("" + d.SATM);
	d3.select("td#table-SATV").text("" + d.SATV);
	d3.select("td#table-ACT").text("" + d.ACT);
	d3.select("td#table-GPA").text("" + d.GPA);

	d3.selectAll("circle").filter(selected)
		.attr("fill", "orange")
		.attr("r", 7)
}


function makeScatterplot(sel, xAccessor, yAccessor)
{
	var svg = sel
	    .append("svg")
            .attr("width", svgSize).attr("height", svgSize);

	var xMax = Math.max(...scores.map(xAccessor));
	var yMax = Math.max(...scores.map(yAccessor));

	var xScale = d3.scaleLinear().domain([0, xMax]).range([40, svgSize - 40]);
	var yScale = d3.scaleLinear().domain([0, yMax]).range([svgSize - 40, 40]);

	var brush = d3.brush();

	svg.append("g")
		.attr("class", "brush")
		.call(brush);

	var circles = svg.selectAll("circle").data(data).enter()
		.append("circle")
		.attr("cx", function(d){ return xScale(xAccessor(d)); })
		.attr("cy", function(d){ return yScale(yAccessor(d)); })
		.attr("fill", "black")
		.attr("r", 3)
		.attr("pointer-events", "all")
		.on("click", click)


	svg.append("g")
		.attr("transform", "translate(0," + (svgSize - 40) + ")")
		.call(d3.axisBottom().scale(xScale));

	svg.append("g")
		.attr("transform", "translate(40,0)")
		.call(d3.axisLeft().scale(yScale));


	return { svg: svg, brush: brush, xScale: xScale, yScale: yScale };
}

//////////////////////////////////////////////////////////////////////////////


var plot1 = makeScatterplot(d3.select("#scatterplot_1"),
                        function(d) { return d.SATM; },
                        function(d) { return d.SATV; });

var plot2 = makeScatterplot(d3.select("#scatterplot_2"),
                        function(d) { return d.ACT; },
                        function(d) { return d.GPA; });

//////////////////////////////////////////////////////////////////////////////

function onBrush(isSelected) {
	var allCircles = d3.select("body").selectAll("circle");
	if (e1 === null && e2 === null) {
		allCircles.attr("fill","black");
	} else {
		allCircles.attr("fill","red");
	}

	allCircles
		.attr("fill-opacity",1)
		.attr("r",3);


	d3.selectAll("circle").filter(hidden)
		.attr("fill-opacity",0.2)
		.attr("fill","black");
}

function hidden1(d){
	if(e1 === null)
		return false;

	var xInv = plot1.xScale.invert;
	var yInv = plot1.yScale.invert;
	return xInv(e1[0][0]) > d.SATM || d.SATM > xInv(e1[1][0])
	|| yInv(e1[1][1]) > d.SATV || d.SATV > yInv(e1[0][1]);
}

function hidden2(d){
	if(e2 === null)
		return false;

	var xInv = plot2.xScale.invert;
	var yInv = plot2.yScale.invert;
	return xInv(e2[0][0]) > d.ACT || d.ACT > xInv(e2[1][0])
	|| yInv(e2[1][1]) > d.GPA || d.GPA > yInv(e2[0][1]);
}

function hidden(d){
	return hidden1(d) || hidden2(d);
}

//////////////////////////////////////////////////////////////////////////////
//
// d3 brush selection
//
// The "selection" of a brush is the range of values in either of the
// dimensions that an existing brush corresponds to. The brush selection
// is available in the d3.event.selection object.
// 
//   e = d3.event.selection
//   e[0][0] is the minimum value in the x axis of the brush
//   e[1][0] is the maximum value in the x axis of the brush
//   e[0][1] is the minimum value in the y axis of the brush
//   e[1][1] is the maximum value in the y axis of the brush
//
// The most important thing to know about the brush selection is that
// it stores values in *PIXEL UNITS*. Your logic for highlighting
// points, however, is not based on pixel units: it's based on data
// units.
//
// In order to convert between the two of them, remember that you have
// the d3 scales you created with the makeScatterplot function above.
// The final thing you need to know is that d3 scales have a function
// to *invert* a mapping: if you create a scale like this:
//
//  s = d3.scaleLinear().domain([5, 10]).range([0, 100])
//
// then s(7.5) === 50, and s.invert(50) === 7.5. In other words, the
// scale object has a method invert(), which converts a value in the
// range to a value in the domain. This is exactly what you will need
// to use in order to convert pixel units back to data units.

var e1 = null;
function updateBrush1() {
	e1 = d3.event.selection; 
	onBrush();

}

var e2 = null;
function updateBrush2() {
	e2 = d3.event.selection; 
	onBrush();
}

plot1.brush
	.on("brush", updateBrush1)
	.on("end", updateBrush1);

plot2.brush
	.on("brush", updateBrush2)
	.on("end", updateBrush2);

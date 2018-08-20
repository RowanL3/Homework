var data = flare;

function sum(l){
	return l.reduce(function(a,b) { return a + b; },0);
}

function totals(l){
	var t = [0];
	for(i = 0; i<l.length;i++){
		t.push(l[i] + t[t.length-1]);
	}
	return t;
}
//////////////////////////////////////////////////////////////////////////////
function setTreeSize(tree)
{
    if (tree.children !== undefined) {
        var size = 0;
        for (var i=0; i<tree.children.length; ++i) {
            size += setTreeSize(tree.children[i]);
        }
        tree.size = size;
    }
    if (tree.children === undefined) {
        // do nothing, tree.size is already defined for leaves
    }
    return tree.size;
}

function setTreeCount(tree)
{
    if (tree.children !== undefined) {
		var count = 0;
        for (var i=0; i<tree.children.length; ++i) {
            count += setTreeCount(tree.children[i]);
        }
        tree.count = count;
    }
    if (tree.children === undefined) {
        tree.count = 1;
    }
    return tree.count;
}

function setTreeDepth(tree, depth)
{
	tree.depth = depth;
	var maxHeight = 0;

	if (tree.children !== undefined)
		maxHeight = Math.max(...tree.children.map(
			function(child) {return setTreeDepth(child, depth+1);}));
			
	return maxHeight + 1;
}

function addMargins(rect){
	var marginH = Math.max(Math.min(Math.abs(rect.x1 - rect.x2) / 10, 4), 0.3),
	    marginV = Math.max(Math.min(Math.abs(rect.y1 - rect.y2) / 10, 4), 0.3);

	return { x1: rect.x1 + marginH,
		x2: rect.x2 - marginH,
		y1: rect.y1 + marginV,
		y2: rect.y2 - marginV };
}


setTreeSize(data);
setTreeCount(data);
var maxDepth = setTreeDepth(data, 0) - 1;

	//////////////////////////////////////////////////////////////////////////////
	// THIS IS THE MAIN CODE FOR THE TREEMAPPING TECHNIQUE

function setRectangles(rect, tree, attrFun, splitMode = "height")
{
	var i;
	rect = addMargins(rect);
	tree.rect = rect;

	if (tree.children !== undefined ) {

		var cumulativeSizes = [0];
		for (i=0; i<tree.children.length; ++i) {
			cumulativeSizes.push(cumulativeSizes[i] + attrFun(tree.children[i]));
		}
		
		if(splitMode == "squarify"){
			var sizes = tree.children.map(attrFun);
			var max = cumulativeSizes[cumulativeSizes.length-1]
			var splitRect = splitSquarify(sizes, max, rect);

			for (i=0; i<tree.children.length; ++i) 
				setRectangles(splitRect[i], tree.children[i], attrFun, "squarify");

		} else if(splitMode == "best"){
			var splitRect = splitBest(cumulativeSizes, rect);

			for (i=0; i<tree.children.length; ++i) 
				setRectangles(splitRect[i], tree.children[i], attrFun, "best");

		} else if (splitMode == "width") {
			var splitRect = splitWidth(cumulativeSizes, rect);

			for (i=0; i<tree.children.length; ++i) 
				setRectangles(splitRect[i], tree.children[i], attrFun, "height");

		} else {
			var splitRect = splitHeight(cumulativeSizes, rect);

			for (i=0; i<tree.children.length; ++i) 
				setRectangles(splitRect[i], tree.children[i], attrFun, "width");
		}
	}
}

function splitSquarify(sizes, max, rect){
	if (sizes.length == 0)
		return [];

	if (sizes.length == 1)
		return splitBest(totals(sizes), rect);
	
	var i = 1;
	var max = sum(sizes);

	while (i < sizes.length && 
		worstRatio(sizes.slice(0, i), max, rect) >=
		worstRatio(sizes.slice(0, i + 1), max, rect))
		i++;
	
	var thisRow = sizes.slice(0, i),
		leftOver = sizes.slice(i);
	
	var rArea = sum(thisRow),
		lArea = sum(leftOver);
	
	var row = splitBest(totals([rArea, lArea]), rect)[0],
		rest = splitBest(totals([rArea, lArea]), rect)[1];

	return splitBest(totals(thisRow), row).concat(splitSquarify(leftOver, max, rest));
	

}

function worstRatio(sizes, max_size, rect){
	var width = sum(sizes) / max_size; 

	var rects = splitBest(totals(sizes), 
		{x1: rect.x1, x2: rect.x2 / width, y1: rect.y1, y2: rect.y2}
	);

	var r1 = Math.max(...rects.map(function(r)
		{ return Math.abs(r.x2 - r.x1)/Math.abs(r.y2 - r.y1); }
	));

	var r2 = Math.max(...rects.map(function(r) 
		{ return Math.abs(r.y2 - r.y1)/Math.abs(r.x2 - r.x1); }
	));

	return Math.max(r1,r2);

}

function splitBest(cumulativeSizes, rect){
	var height = rect.y2 - rect.y1,
		width = rect.x2 - rect.x1;

	return width < height ?
		splitHeight(cumulativeSizes, rect) : splitWidth(cumulativeSizes, rect);
}


function splitHeight(cumulativeSizes, rect){
	var rects = [];

	var scaleH = d3.scaleLinear()
			.domain([0, cumulativeSizes[cumulativeSizes.length - 1]])
			.range([rect.y1, rect.y2]);
	
	for (i=0; i<cumulativeSizes.length - 1; ++i) {
		rects.push({
			x1: rect.x1,
			x2: rect.x2,
			y1: scaleH(cumulativeSizes[i]),
			y2: scaleH(cumulativeSizes[i+1]),  
		});
	}
	return rects;
}

function splitWidth(cumulativeSizes, rect){
	var rects = [];

	var scaleW = d3.scaleLinear()
			.domain([0, cumulativeSizes[cumulativeSizes.length - 1]])
			.range([rect.x1, rect.x2]);

	for (i=0; i<cumulativeSizes.length - 1; ++i) {
			rects.push({
				x1: scaleW(cumulativeSizes[i]),
				x2: scaleW(cumulativeSizes[i+1]),
				y1: rect.y1,
				y2: rect.y2,
			});
		}
	return rects;
}


var width = window.innerWidth;
var height = window.innerHeight;

setRectangles(
    {x1: 0, x2: width, y1: 0, y2: height}, data,
    function(t) { return t.size; }
);

function makeTreeNodeList(tree, lst)
{
lst.push(tree);
if (tree.children !== undefined) {
	for (var i=0; i<tree.children.length; ++i) {
		makeTreeNodeList(tree.children[i], lst);
        }
    }
}

var treeNodeList = [];
makeTreeNodeList(data, treeNodeList);

var gs = d3.select("#svg")
        .attr("width", width)
        .attr("height", height)
        .selectAll("g")
        .data(treeNodeList)
        .enter()
        .append("g");

var depthColorScale = d3.scaleLinear()
	.domain([0, maxDepth])
	.range([d3.rgb("#B7DFCB"), d3.rgb("#264992")])
	.interpolate(d3.interpolateHcl);

function setAttrs(sel) {
    sel.attr("width", function(treeNode) { 
		return treeNode.rect.x2 - treeNode.rect.x1;
    }).attr("height", function(treeNode) {
		return treeNode.rect.y2 - treeNode.rect.y1;
    }).attr("x", function(treeNode) {
		return treeNode.rect.x1;
    }).attr("y", function(treeNode) {
		return treeNode.rect.y1;
    }).attr("title", function(treeNode) {
        return treeNode.name;
    }).attr("stroke-width", 1
    ).attr("stroke-opacity", 0.30
	).attr("fill", function(treeNode){
		return depthColorScale(treeNode.depth);
	}).attr("stroke", function(treeNode){
		return "black";
	});
}

gs.append("rect").call(setAttrs);

function addListern(id, splitMode, attrFun){
	d3.select(id).on("click", function() {
		setRectangles(
			{x1: 0, x2: width, y1: 0, y2: height},
			data, attrFun, splitMode);
		d3.selectAll("rect").transition().duration(1000).call(setAttrs);
	});
}
function getSize(t) { return t.size; }
function getCount(t) { return t.count; }

addListern("#size", "height", getSize); 
addListern("#count", "height", getCount); 
addListern("#best-size", "best", getSize); 
addListern("#best-count", "best", getCount); 
addListern("#square-size", "squarify", getSize); 
addListern("#square-count", "squarify", getCount); 

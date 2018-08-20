function make(name, attrs){
    var element = document.createElementNS("http://www.w3.org/2000/svg", name);
    if (attrs === undefined) attrs = {};
    for (var key in attrs) {
        if (key === 'text') {
            debugger;
            element.textContent = attrs[key];
        } else {
            element.setAttributeNS(null, key, attrs[key]);
        }
    }
    return element;
}

function plotAll(svg, data, element, attributeGetters)
{
    var obj;
    for (var i=0; i<data.length; ++i) {
        obj = {};
        for (var key in attributeGetters) {
            obj[key] = attributeGetters[key](data[i], i);
        }
        svg.appendChild(make(element, obj));
    }
    return svg;
}

function toHex(v) 
{
    var str = "00" + Math.floor(Math.max(0, Math.min(255, v))).toString(16);
    return str.substr(str.length-2);
}

function rgb(r, g, b)
{
    return "#" + toHex(r * 255) + toHex(g * 255) + toHex(b * 255);
}

function helloWorld() 
{
	document.writeln("Hello World");
}

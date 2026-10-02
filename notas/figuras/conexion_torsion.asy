if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed= true;
settings.toolbar=false;
viewportmargin=(2,2);

settings.prc = true;
defaultfilename=outprefix();

import graph;
size(5cm);

pen difference_pen = rgb("#0e2e95") + 0.8pt + opacity(0.8);
pen lines_pen = rgb("#c3c3c3") + 1pt;
pen axis_pen = rgb("#1e1e1e") + 1pt;
pen arrow_pen = rgb("#922c2c") + 0.8pt + opacity(0.8);
pen dot_pen = rgb("#727272") + 4pt;
pen aid_pen = rgb("#922c2c") + 0.3pt;

// axes
path xAxis = (-1.1,0)--(1.1,0);
path yAxis = (0,-1.1)--(0,1.1);
draw(xAxis, axis_pen);
draw(yAxis, axis_pen);

// S1
int Nlines = 6;
for (int i=0; i<=Nlines; ++i){
    real x = i/Nlines;
    draw((x, -3)--(x, 3), lines_pen);
    real y = i/Nlines;
    draw((-3, y)--(3, y), lines_pen);
}
// connection
pair vs(pair rs, pair vs){
    real vx = exp(rs.y)*(cos(rs.x)*vs.x - sin(rs.x)*vs.y);
    real vy = exp(rs.y)*(sin(rs.x)*vs.x + cos(rs.x)*vs.y);
    return (vx, vy);
}

real[] s = {0.4, 0.3, 0.2, 0.1};
for (int i=0; i<s.length; ++i){

    // initial point
    pair p0 = (0,0);
    // initial vectors
    pair v1 = (s[i], 0);
    pair v2 = (0, s[i]);

    dot(p0, dot_pen);
    draw(p0--p0+v1, arrow_pen, Arrow(4bp));
    draw(p0--p0+v2, arrow_pen, Arrow(4bp));

    // intermediate points
    pair p1 = p0 + v1;
    pair p2 = p0 + v2;
    // transported vectors
    v1 = vs(p2, v1);
    v2 = vs(p1, v2);

    dot(p1, dot_pen);
    dot(p2, dot_pen);
    draw(p1--p1+v2, arrow_pen, Arrow(4bp));
    draw(p2--p2+v1, arrow_pen, Arrow(4bp));
    
    // difference
    draw(p2+v1--p1+v2, difference_pen, Arrow(4bp));

}

path frame = box((-0.1, -0.1), (0.7, 0.5));
clip(currentpicture, frame);






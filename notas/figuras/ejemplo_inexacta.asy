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

pen path_pen = rgb("#3c59b9") + 0.8pt;
pen lines_pen = rgb("#929292") + 1pt;
pen axis_pen = rgb("#353535") + 1pt;
pen arrow_pen = rgb("#922c2c") + 0.8pt + opacity(0.6);
pen dots_pen = rgb("#922c2c") + 2pt;
pen aid_pen = rgb("#922c2c") + 0.3pt;

// axes
path xAxis = (-1.1,0)--(1.1,0);
path yAxis = (0,-1.1)--(0,1.1);
draw(xAxis, axis_pen);
draw(yAxis, axis_pen);

draw(box((-1, -1), (1, 1.)), lines_pen);

// S1
real rCircle = 0.6;
pair circlePoint(real t){
    return rCircle*(cos(t), sin(t));
}
path circle = graph(circlePoint, 2pi-0.05, 0.05);
draw(circle, path_pen, Arrow(3bp));

// vectors
int Num = 15;
real dx = 2/Num, dy = 2/Num;
for (int i=0; i<=Num; ++i){
    for (int j=0; j<=Num; ++j) {
        real x = i*dx - 1, y = j*dy - 1;
        pair p = (x, y);
        pair v = 0.1*(y/sqrt(x^2+y^2), -x/sqrt(x^2+y^2));
        draw(p--p+v, arrow_pen, Arrow(6bp));
    }
}

path frame = box((-1.1, -1.1), (1.1, 1.1));
clip(currentpicture, frame);
// real f(real t){
//     return 1.0 + 0.15*cos(3t) + 0.15*sin(7t) - 0.05*cos(8t);
// }
// pair fPoint(real t){
//     return (f(t)*cos(t), f(t)*sin(t));
// }
// path function = graph(fPoint, 0, 2pi, 140);

// // chart
// real t0 = -0.4;
// real t1 = pi+0.3;
// path chart = graph(circlePoint, t0, t1);

// draw(circle, manifold_pen);
// draw(chart, chart_pen);

// // grid
// int Nt = 10;
// real Dt = (t1 - t0)/Nt;
// for (int i=0; i<=Nt; ++i){
//     real t = t0 + i*Dt;
//     pair p = circlePoint(t);
//     dot(p, dots_pen);
//     // radial helper lines
//     draw((cos(t),sin(t))--(f(t)*cos(t), f(t)*sin(t)), aid_pen);
// }

// draw(function, function_pen);

// // homeomorphism

// // real line
// pair cero = (-1, -1.4);
// draw((-0.2, 0)+cero--(0.2, 0)+cero+(2,0), manifold_pen);
// real scale = 2 / (t1 - t0);

// // chart
// draw(cero--cero+(2,0), chart_pen);

// // grid
// for (int i=0; i<=Nt; ++i){
//     real tp = i*Dt*scale;
//     pair p = cero + (tp, 0);
//     dot(p, dots_pen);
//     // radial helper lines

//     draw(p--p+(0, 0.6(f((tp/scale+t0))-1)), aid_pen);
// }

// // function
// pair fR(real tp){
//     return (tp, 0.6*(f((tp/scale)+t0)-1)) + cero;
// }
// path functionR = graph(fR, -0.2, (t1-t0)*scale+0.2, 100);
// draw(functionR, function_pen + opacity(0.5));
// path functionR = graph(fR, 0*scale, (t1-t0)*scale, 100);
// draw(functionR, function_pen);

// // arrow
// pair origin = 0.95(cos(pi/3), sin(pi/3));
// pair end = (cero + ((pi/3-t0)*scale, 0.05));
// draw(origin..(0,0)..end, Arrow(6bp));

// // labels
// label("$f$", (-0.67, 1), W, fontsize(8pt));
// label("$S^1$", (0.5, -0.85), S, fontsize(8pt));
// label("$U$", (-1.05, -0.15), W, fontsize(8pt));
// label("$\varphi_U(U)$", (0.95, -1.4), N, fontsize(8pt));
// label("$\varphi_U$", (0, 0), W, fontsize(8pt));
// label("$f\circ\varphi_U^{-1}$", (-0.75, -1.28), N, fontsize(8pt));




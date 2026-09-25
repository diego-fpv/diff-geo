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

pen function_pen = rgb("#596fb8") + 0.8pt;
pen manifold_pen = rgb("#929292") + 1pt;
pen chart_pen = rgb("#922c2c") + 0.8pt + opacity(0.6);
pen dots_pen = rgb("#922c2c") + 2pt;
pen aid_pen = rgb("#922c2c") + 0.3pt;

// S1
pair circlePoint(real t){
    real x = cos(t);
    real y = sin(t);
    return (x, y);
}
path circle = graph(circlePoint, 0, 2pi);

// function
real f(real t){
    return 1.0 + 0.15*cos(3t) + 0.15*sin(7t) - 0.05*cos(8t);
}
pair fPoint(real t){
    return (f(t)*cos(t), f(t)*sin(t));
}
path function = graph(fPoint, 0, 2pi, 140);

// chart
real t0 = -0.4;
real t1 = pi+0.3;
path chart = graph(circlePoint, t0, t1);

draw(circle, manifold_pen);
draw(chart, chart_pen);

// grid
int Nt = 10;
real Dt = (t1 - t0)/Nt;
for (int i=0; i<=Nt; ++i){
    real t = t0 + i*Dt;
    pair p = circlePoint(t);
    dot(p, dots_pen);
    // radial helper lines
    draw((cos(t),sin(t))--(f(t)*cos(t), f(t)*sin(t)), aid_pen);
}

draw(function, function_pen);

// homeomorphism

// real line
pair cero = (-1, -1.4);
draw((-0.2, 0)+cero--(0.2, 0)+cero+(2,0), manifold_pen);
real scale = 2 / (t1 - t0);

// chart
draw(cero--cero+(2,0), chart_pen);

// grid
for (int i=0; i<=Nt; ++i){
    real tp = i*Dt*scale;
    pair p = cero + (tp, 0);
    dot(p, dots_pen);
    // radial helper lines

    draw(p--p+(0, 0.6(f((tp/scale+t0))-1)), aid_pen);
}

// function
pair fR(real tp){
    return (tp, 0.6*(f((tp/scale)+t0)-1)) + cero;
}
path functionR = graph(fR, -0.2, (t1-t0)*scale+0.2, 100);
draw(functionR, function_pen + opacity(0.5));
path functionR = graph(fR, 0*scale, (t1-t0)*scale, 100);
draw(functionR, function_pen);

// arrow
pair origin = 0.95(cos(pi/3), sin(pi/3));
pair end = (cero + ((pi/3-t0)*scale, 0.05));
draw(origin..(0,0)..end, Arrow(6bp));

// labels
label("$f$", (-0.67, 1), W, fontsize(8pt));
label("$S^1$", (0.5, -0.85), S, fontsize(8pt));
label("$U$", (-1.05, -0.15), W, fontsize(8pt));
label("$\varphi_U(U)$", (0.95, -1.4), N, fontsize(8pt));
label("$\varphi_U$", (0, 0), W, fontsize(8pt));
label("$f\circ\varphi_U^{-1}$", (-0.75, -1.28), N, fontsize(8pt));





// // camera (nice default view)
// currentprojection = perspective(
//     camera=(5.0*cos(0.7), 5.0*sin(0.7), 0.2),
//     // camera=(0*cos(0), 5.0*sin(0), 5),
//     target=(0,0,0),
//     up=Z,
//     autoadjust=true
// );

// pen[] gridline_pen = {rgb("#d25c5c") + 0.5pt, rgb("#4f71eb") + 0.5pt};
// pen surface_pen = rgb("#ffffff") + opacity(0.4);
// pen axes_pen = black + 1pt;
// pen vector_pen = red + 2pt;
// pen plane_pen = rgb("#a49e9e") + opacity(0.3);
// pen outline_pen = rgb("#3f3f3f") + opacity(0.8);
// light Light = light(diffuse=gray(0.1), (1,1,1));

// // sphere
// draw(unitsphere, surface_pen);

// // U
// real x10 = -0.1;
// real y10 = 0.6;
// pair r1s = (0.55, 0.3);

// triple boundaryPoint(real t){
//     real x = x10 + r1s.x*cos(t);
//     real y = y10 + r1s.y*sin(t);
//     real z = sqrt(1 - x^2 - y^2);
//     return (x, y, z);
// }
// path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
// draw(boundary, rgb("#712222") + linewidth(1pt));

// // gridlines
// int N_lines = 5;
// real dx = r1s.x/(N_lines+1);
// real dy = r1s.y/(N_lines+1);
// for (int i=-N_lines; i<=N_lines; ++i){
//     // constant x
//     real x = x10 + i*dx;
//     real Dy = r1s.y * sqrt(1 - (x-x10)^2/r1s.x^2); 
//     real[] yLims = {y10 - Dy, y10 + Dy};
//     triple xPoints(real y){
//         return (x, y, sqrt(1-x^2-y^2));
//     }
//     path3 xLine = graph(xPoints, yLims[0], yLims[1], n=10);
//     draw(xLine, gridline_pen[0]);

//     // constant y
//     real y = y10 + i*dy;
//     real Dx = r1s.x * sqrt(1 - (y-y10)^2/r1s.y^2); 
//     real[] xLims = {x10 - Dx, x10 + Dx};
//     triple yPoints(real x){
//         return (x, y, sqrt(1-x^2-y^2));
//     }
//     path3 yLine = graph(yPoints, xLims[0], xLims[1], n=10);
//     draw(yLine, gridline_pen[0]);
// }

// // trajectory
// pair rtr = (0.3, 0.5);
// pair ctr = (0.2, 0.2);
// triple trajectoryPoint (real t){
//     real x = ctr.x + rtr.x*cos(t);
//     real y = ctr.y + rtr.y*sin(t);
//     return (x, y, sqrt(1-x^2-y^2));
// }
// path3 trajectory = graph(trajectoryPoint, 0, 2pi, n=30);
// draw(trajectory, rgb("#322271") + linewidth(1pt));

// // function
// triple functionPoint(triple ruv){
//     real x = ruv.x;
//     return (1, 1, 1);
// }

// // homeomorphism
// real s = 1;
// triple r1p = (-1, -1, 0);

// path3 planeOutline = r1p-s*X-s*Y -- r1p+s*X-s*Y -- r1p+s*Y+s*X -- r1p-s*Y+s*X -- cycle;
// draw(surface(planeOutline), plane_pen);
// draw(planeOutline, outline_pen);

// // image boundary
// triple boundaryPoint(real t){
//     real x = r1s.x*cos(t);
//     real y = r1s.y*sin(t);
//     return r1p + (0, x, y);
// }
// path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
// draw(boundary, rgb("#712222") + linewidth(1pt));

// // image gridlines
// N_lines = 5;
// real dx = r1s.x/(N_lines+1);
// real dy = r1s.y/(N_lines+1);
// for (int i=-N_lines; i<=N_lines; ++i){
//     // constant x
//     real x = i*dx;
//     real Dy = r1s.y * sqrt(1 - x^2/r1s.x^2); 
//     real[] yLims = {-Dy, Dy};
//     triple xPoints(real y){
//         return r1p + (0, x, y);
//     }
//     path3 xLine = graph(xPoints, yLims[0], yLims[1], n=2);
//     draw(xLine, gridline_pen[0]);
    
//     // constant x
//     real y = i*dy;
//     real Dx = r1s.x * sqrt(1 - y^2/r1s.y^2); 
//     real[] xLims = {-Dx, Dx};
//     triple yPoints(real x){
//         return r1p + (0, x, y);
//     }
//     path3 yLine = graph(yPoints, xLims[0], xLims[1], n=2);
//     draw(yLine, gridline_pen[0]);
// }

// // image trajectory
// triple trajectoryPoint (real t){
//     real x = ctr.x - x10 + rtr.x*cos(t);
//     real y = ctr.y - y10 + rtr.y*sin(t);
//     return (0, y, x);
// }
// path3 trajectory = graph(trajectoryPoint, 0, 2pi, n=30);
// draw(trajectory, rgb("#322271") + linewidth(1pt));

// // map arrow 
// triple pointSphere = (x10, y10, sqrt(1-x10^2-y10^2)) + 0.1*(1, 1, 1)/sqrt(3) - 0.2X;
// triple pointPlane = r1p + 0.2(X+Y);
// draw(pointSphere..(pointSphere+pointPlane)/2+0.2*(Z+Y)..pointPlane, Arrow3(6bp));


// // labels
// label("$U$", pointSphere, (0,0,1), fontsize(8pt));
// label("$\varphi_U(U)$", pointPlane+0.3*Z, N, fontsize(8pt));
// label("$\varphi_U$", (pointSphere+pointPlane)/2+(0,0.2,0.3), (0,0,1), fontsize(8pt));


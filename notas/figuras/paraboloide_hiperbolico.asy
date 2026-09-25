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

import three;
import graph3;
import tube;
size(5cm);

// camera (nice default view)
currentprojection = perspective(
    camera=(5.0*cos(1.2), 5.0*sin(1.2), 5),
    // camera=(5.0*cos(0.8), 5.0*sin(0.8), 2),
    target=(0,0,0),
    up=Z,
    autoadjust=true
);

pen gridline_pen = rgb("#777777") + 0.5pt;
pen trajectory_pen = rgb("#bf4747") + 1pt;
pen surface_pen = rgb("#f2f2f2") + opacity(0.6);
pen plane_pen = rgb("#949494") + 0.5pt + opacity(0.2);
pen axes_pen = black + 1pt;
pen vector_pen = rgb("#aa3939") + linewidth(1pt);
light Light = light(diffuse=gray(0.1), (1,1,1));

// sphere
triple ph_point(pair uv){
    return (uv.x, uv.y, uv.x^2 - uv.y^2);
}
surface ph = surface(ph_point, (-1, -1), (1, 1), 40, 40);
draw(ph, surface_pen);

// coordinate lines
int Nlines = 3;
for (int i = -Nlines; i <= Nlines; ++i) {
    real x = i/Nlines;
    path3 line = graph(new triple(real y) {return ph_point((x, y));}, -1, 1, n=40);
    draw(line, gridline_pen); 
    real y = i/Nlines;
    path3 line = graph(new triple(real x) {return ph_point((x, y));}, -1, 1, n=40);
    draw(line, gridline_pen); 
}

// trajectories
path3 traj = graph(new triple(real t) {return ph_point((t, t));}, -1, 1, n=40);
draw(traj, trajectory_pen); 

path3 traj = graph(new triple(real t) {return ph_point((t, 0));}, -1, 1, n=40);
draw(traj, trajectory_pen); 

// plane
real s = 1;
triple rp = (0, 0, 0);
path3 planeOutline = rp-s*X-s*Y -- rp+s*X-s*Y -- rp+s*X+s*Y -- rp-s*X+s*Y -- cycle;
draw(surface(planeOutline), plane_pen);

for (int i = -Nlines; i <= Nlines; ++i) {
    real x = i/Nlines;
    path3 line = graph(new triple(real y) {return (x, y, 0);}, -1, 1, n=40);
    draw(line, gridline_pen+opacity(0.4)); 
    real y = i/Nlines;
    path3 line = graph(new triple(real x) {return (x, y, 0);}, -1, 1, n=40);
    draw(line, gridline_pen+opacity(0.4)); 
}

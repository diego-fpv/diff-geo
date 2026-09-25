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
    camera=(2.0, 4.0, 0.6),
    target=(0,0,0),
    up=Z,
    autoadjust=true
);

pen gridline_pen = gray + opacity(0.5) + 0.5pt;
pen axes_pen = black + 1pt;
pen vector_pen = red + 2pt;

// gridlines
for(int i = -2; i <= 2; ++i) {
    for(int j = -1; j <=1; ++j){
        draw((-2.5, i, j)--(2.5, i, j), gridline_pen);
        draw((i, -2.5, j)--(i, 2.5, j), gridline_pen);
    }
}
for(int i = -2; i <= 2; ++i) {
    for(int j = -2; j <=2; ++j){
        draw((i, j, -1.5)--(i, j, 1.5), gridline_pen);
    }
}

// particle
triple rp = (-1, 0, 0); // position
real R = 0.15; // radius
draw(shift(rp)*scale3(R)*unitsphere);
// trajectory
triple v = (1, 1, -0.7);
triple a = (0.4, -0.3, +0.6);
triple j = (0, 0, -0.3);
triple traj(real t) {
    return rp + v*t + a*t^2 + j*t^3; 
}
path3 trajectory = graph(traj, -1.0, 1.9, n=100);
draw(tube(trajectory, scale(0.05)*unitcircle), blue + linewidth(1bp) + opacity(0.3));

// tangent space
draw(rp--rp+(1, 0, 0), arrow=Arrow3(size=6bp), axes_pen);
label('$\mathbf{e}_1$', rp+(1, 0, 0), W, fontsize(8pt));
draw(rp--rp+(0, 1, 0), arrow=Arrow3(size=6bp), axes_pen);
label('$\mathbf{e}_2$', rp+(0, 1, 0), E, fontsize(8pt));
draw(rp--rp+(0, 0, 1), arrow=Arrow3(size=6bp), axes_pen);
label('$\mathbf{e}_3$', rp+(0, 0, 1), E, fontsize(8pt));

// velocity
draw(rp--rp+v, arrow=Arrow3(size=7bp), rgb("EE0000")+2pt);
draw(rp--rp+1.5*a, arrow=Arrow3(size=7bp), rgb("990000")+2pt);
label('$\mathbf{v}$', rp+v, S);
label('$\mathbf{F}$', rp+1.5*a, SW);
// label('$\mathbf{F}$', rp+1.5*a, S);
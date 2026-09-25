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
import tube;
import "rk4" as rk4;

pen gridline_pen = gray + 0.5pt;
pen[] tube_pens = {
	rgb("#0427ee") + linewidth(1.5bp) + opacity(0.3),
	rgb("#ee0404") + linewidth(1.5bp) + opacity(0.3),
	rgb("#05da1a") + linewidth(1.5bp) + opacity(0.3)};
pen surface_pen = rgb("#ffffff") + opacity(0.4);
light Light = light(diffuse=gray(0.1), (1,1,1));

// torus aspect ratio
real R = 1;
real r = 0.2;

// parameter space
// coordinate lines
for (int i = 0; i <= 12; ++i) {
    real phi = i*pi/6;
    draw((0, phi)--(2pi, phi), gridline_pen); 
}
for (int i = 0; i <= 6; ++i){
    real theta = i*pi/3;
    draw((theta, 0)--(theta, 2pi), gridline_pen);
}
// state y = [theta, phi, theta·, phi·]
real[] deriv(real t, real[] y) {
    real[] dydt = new real[4];
    dydt[0] = y[2]; 
    dydt[1] = y[3]; 
    dydt[2] = (R + r*sin(y[0]))*cos(y[0])/r * y[3]^2; 
    dydt[3] = -2*r*cos(y[0])/(R + r*sin(y[0])) * y[2] * y[3];  
    return dydt;
}

real[][] yi = {
	{pi/3, 0, 1/r, 0.3/(R+r*cos(pi/3))},
    {0, 2pi/3, -0.0/r, 1/(R+r*cos(0))},
    {pi/2, 4pi/3, 0/r, 1/(R+r*cos(pi/2))},
};  // initial conditions

real ti = 0;
real tf = 2*pi;
real dt = 0.01;
int N = floor((tf - ti) / dt) + 1;

for (int k = 0; k<yi.length; ++k) {
    write(k);
	real[][] Y = rk4solve(deriv, ti, yi[k], tf, dt);

    pair[] angles = new pair[N+1];

    // initial position
    angles[0] = (yi[k][0] % 2pi, yi[k][1] % 2pi);

    path currentpath;
    bool started = false;
    // trajectories.
    for (int i = 1; i <= N; ++i) {

        angles[i] = ((Y[i][0] % 2pi), (Y[i][1] % 2pi));
        
        if (!started){
            currentpath = angles[0];
            started = true;
        }

        if (abs(angles[i].x-angles[i-1].x) < pi &&
             abs(angles[i].y-angles[i-1].y) < pi){
	        currentpath = currentpath--angles[i];  
        } else {
            draw(currentpath, tube_pens[k]);
            currentpath = angles[i];
        }

    }
    draw(currentpath, tube_pens[k]); // last path, of course, needs to be drawn.

    dot(angles[0], black + linewidth(0.15cm));
}
dot((0, 1.618pi), gray + linewidth(0.15cm) + opacity(0.7));

size(5cm);

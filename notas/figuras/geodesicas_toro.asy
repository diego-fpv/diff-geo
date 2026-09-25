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
import "rk4" as rk4;

size(5cm);

pen gridline_pen = gray + 0.5pt;
pen[] tube_pens = {
	rgb("#0427ee") + linewidth(1bp) + opacity(0.3),
	rgb("#ee0404") + linewidth(1bp) + opacity(0.3),
	rgb("#05da1a") + linewidth(1bp) + opacity(0.3)};
pen surface_pen = rgb("#ffffff") + opacity(0.4);
light Light = light(diffuse=gray(0.1), (1,1,1));

// torus drawing
real R = 1;
real r = 0.2;
triple torus_point(pair t){
    real theta = t.x;
    real phi = t.y;
    return ((R + r*cos(theta))*cos(phi), 
        (R + r*cos(theta))*sin(phi), r*sin(theta));
}
surface torus = surface(torus_point, (0, 0), (2pi, 2pi), 15, 40, Spline);

draw(torus, surface_pen);

// coordinate lines
for (int i = 1; i <= 12; ++i) {
    real theta = i*pi/6;
    triple normal = (-sin(theta), cos(theta), 0);
    triple center = (cos(theta), sin(theta), 0);
    path3 vert = circle(c=center, r=r, normal=normal);
    draw(vert, gridline_pen); 
}
for (int i = 1; i <= 6; ++i){
    real theta = i*pi/3;
    triple center = (0, 0, r*sin(theta));
    real radius = R + r*cos(theta);
    path3[] hor = circle(c=center, r=radius, normal=Z);
    draw(hor, gridline_pen);
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
real dt = 0.02;
int N = floor((tf - ti) / dt) + 1;

for (int k = 0; k<yi.length; ++k) {
    write(k);
	real[][] Y = rk4solve(deriv, ti, yi[k], tf, dt);

    real theta;
    real phi;
	triple[] positions = new triple[N+1];

    // initial position
    positions[0] = ((R + r*sin(yi[k][0]))*cos(yi[k][1]),
                    (R + r*sin(yi[k][0]))*sin(yi[k][1]), 
                    r*cos(yi[k][0]));
	draw(shift(positions[0])*scale3(0.05)*unitsphere);

    // trajectories.
    for (int i = 1; i <= N; ++i) {
		theta = Y[i][0];
		phi = Y[i][1];

        real theta_mod = theta % 2pi;
        real phi_mod = phi % 2pi;

		positions[i] = ((R + r*sin(theta))*cos(phi),
                        (R + r*sin(theta))*sin(phi), 
                        r*cos(theta));

    }
	
    path3 traj = graph(positions);
	draw(tube(traj, scale(0.05/3)*unitcircle), tube_pens[k]);
}

triple position_gray = (
    (R + r*sin(0))*cos(1.618pi),
    (R + r*sin(0))*sin(1.618pi), 
    r*cos(0));
draw(shift(position_gray)*scale3(0.05)*unitsphere, gray+opacity(0.5));

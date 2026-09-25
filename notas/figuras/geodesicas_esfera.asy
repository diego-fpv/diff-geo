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

draw(unitsphere, surface_pen);

// coordinate lines
for (int i = 1; i <= 6; ++i) {
    real theta = i*pi/6;
    real z = cos(theta);
    real r = sin(theta);
    path3 lat = circle(c=(0, 0, z), r=r, normal=Z);
    draw(lat, gridline_pen); 
    triple normal_vec = (cos(theta), sin(theta), 0);
    path3 lat = circle(c=(0,0,0), r=1, normal=normal_vec);
    draw(lat, gridline_pen); 
}

// state y = [theta, phi, theta·, phi·]
real[] deriv(real t, real[] y) {
    real[] dydt = new real[4];
    dydt[0] = y[2]; 
    dydt[1] = y[3]; 
    dydt[2] = sin(y[0])*cos(y[0])*y[3]^2; 
    dydt[3] = -2 * y[2] * y[3] / tan(y[0]);  
    return dydt;
}

real[][] yi = {
	{pi/3, 0, 0, 1/sin(pi/3)},
    {pi/3, 2 pi/3, 0, 1/sin(pi/3)},
    {pi/3, 4 pi/3, 0, 1/sin(pi/3)},
};  // initial

real ti = 0;
real tf = 2*pi;
real dt = 0.01;
int N = floor((tf - ti) / dt) + 1;

for (int k = 0; k<yi.length; ++k) {

	real[][] Y = rk4solve(deriv, ti, yi[k], tf, dt);

	real theta = 0;
	real phi = 0;
	triple[] positions = new triple[N+1];
	for (int i = 0; i <= N; ++i) {
		theta = Y[i][0];
		phi = Y[i][1];
		positions[i] = (cos(phi)*sin(theta), sin(phi)*sin(theta), cos(theta));
	}

	draw(shift(positions[0])*scale3(0.05)*unitsphere);

	path3 traj = graph(positions);
	draw(tube(traj, scale(0.05/3)*unitcircle), tube_pens[k]);
}
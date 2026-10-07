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

// camera (nice default view)
currentprojection = perspective(
    camera=(5.0*cos(0.7), 5.0*sin(0.7), 0.2),
    // camera=(5.0*cos(0.8), 5.0*sin(0.8), 2),
    target=(0,0,0),
    up=Z,
    autoadjust=true
);
size(5cm);

pen gridline_pen = gray + 0.5pt;
pen geo_pen = rgb("#942b2b") + linewidth(1pt);
pen line_pen = rgb("#2b2b2b") + dotted + linewidth(1pt);
pen surface_pen = rgb("#ffffff") + opacity(0.4);
light Light = light(diffuse=gray(0.1), (1,1,1));
pen plane_pen = rgb("#a49e9e") + opacity(0.3);
pen outline_pen = rgb("#3f3f3f") + opacity(0.8);

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

int s = 1;
triple rp = (-2, 0.5, 0);
path3 planeOutline = rp-s*Z-s*Y -- rp+s*Z-s*Y -- rp+s*Z+s*Y -- rp-s*Z+s*Y -- cycle;
draw(surface(planeOutline), plane_pen);
draw(planeOutline, outline_pen);

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
	{pi/4, pi/3, 1, 0.3/sin(pi/3)},
    {pi/4, pi/3, 1, -0.3/sin(pi/3)}
};  // initial

real ti = 0;
real tf = 0.16*2*pi;
real dt = 0.01;
int N = floor((tf - ti) / dt) + 1;

for (int k = 0; k<yi.length; ++k) {

	real[][] Y = rk4solve(deriv, ti, yi[k], tf, dt);

	real theta;
	real phi;
	triple[] positions = new triple[N+1];
	triple[] positions_plane = new triple[N+1];
	for (int i = 0; i <= N; ++i) {
		theta = Y[i][0];
		phi = Y[i][1];
		positions[i] = (cos(phi)*sin(theta), sin(phi)*sin(theta), cos(theta));
		positions_plane[i] = (0, phi, theta) + rp - (0, 1, 1);
	}

	dot(positions[0]);
	dot(positions_plane[0]);

	path3 traj = graph(positions);
	draw(traj, geo_pen);
	path3 traj = graph(positions_plane);
	draw(traj, geo_pen);

    draw(positions_plane[0]--positions_plane[0]+(0,0.3/sin(pi/3),1), line_pen);
    draw(positions_plane[0]--positions_plane[0]+(0,-0.3/sin(pi/3),1), line_pen);

}
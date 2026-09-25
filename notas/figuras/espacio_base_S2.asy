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
    camera=(5.0*cos(0.4), 5.0*sin(0.4), 2),
    // camera=(5.0*cos(0.8), 5.0*sin(0.8), 2),
    target=(0,0,0),
    up=Z,
    autoadjust=true
);

pen gridline_pen = gray + 0.5pt;
pen surface_pen = rgb("#ffffff") + opacity(0.4);
pen axes_pen = black + 1pt;
pen vector_pen = red + 2pt;
pen plane_pen = rgb("#eb5555") + opacity(0.3);
pen outline_pen = rgb("#a01a1a") + opacity(0.8);
light Light = light(diffuse=gray(0.1), (1,1,1));

// sphere
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

// particle
real phi_p = pi/3;
real theta_p = pi/3;
triple rp = (sin(theta_p)*cos(phi_p), sin(theta_p)*sin(phi_p), cos(theta_p)); // position
real R = 0.05; // radius
draw(shift(rp)*scale3(R)*unitsphere);

// trajectory
real[] v = {0.5, -1};
real[] a = {0.5, 1.5};
triple traj(real t) {
    real theta_t = v[0]*t + a[0]/2*t^2;
    real phi_t = v[1]*t + a[1]/2*t^2;
    return (cos(phi_t+phi_p)*sin(theta_t+theta_p), sin(phi_t+phi_p)*sin(theta_t+theta_p), cos(theta_t+theta_p)); 
}
path3 trajectory = graph(traj, -2.1, 2.5, n=100);
draw(tube(trajectory, scale(0.05/3)*unitcircle), blue + linewidth(1bp) + opacity(0.3));

// basis vectors
triple n = 0.3*unit(rp);
triple u_phi = 0.3*unit(cross(Z, n)); 
triple u_theta = 0.3*unit(cross(u_phi, n));
draw(rp--rp+u_theta, arrow=Arrow3(size=6bp), axes_pen);
label("$\mathbf{e}_1$", rp+u_theta, S, fontsize(8));
draw(rp--rp+u_phi, arrow=Arrow3(size=6bp), axes_pen);
label("$\mathbf{e}_2$", rp+u_phi, E, fontsize(8));

// velocity
triple velocity = 0.3*unit(v[0]*u_theta + v[1]*u_phi);
draw(rp--rp+velocity, arrow=Arrow3(size=7bp), vector_pen);
label("$\mathbf{v}$", rp+velocity, W);

// force
triple force = 0.3*unit(a[0]*u_theta + a[1]*u_phi);
draw(rp--rp+force, arrow=Arrow3(size=7bp), vector_pen);
label("$\mathbf{F}$", rp+force, S);




// tangent plane
real s = 1.5;
path3 planeOutline = rp-s*u_phi-s*u_theta -- rp+s*u_phi-s*u_theta -- rp+s*u_phi+s*u_theta -- rp-s*u_phi+s*u_theta -- cycle;
draw(surface(planeOutline), plane_pen);
draw(planeOutline, outline_pen);

// // tangent space
// draw(rp--rp+(1, 0, 0), arrow=Arrow3(size=6bp), axes_pen);
// label('$\mathbf{e}_1$', rp+(1, 0, 0), W, fontsize(8pt));
// draw(rp--rp+(0, 1, 0), arrow=Arrow3(size=6bp), axes_pen);
// label('$\mathbf{e}_2$', rp+(0, 1, 0), E, fontsize(8pt));
// draw(rp--rp+(0, 0, 1), arrow=Arrow3(size=6bp), axes_pen);
// label('$\mathbf{e}_3$', rp+(0, 0, 1), E, fontsize(8pt));

// // velocity
// draw(rp--rp+v, arrow=Arrow3(size=7bp), rgb("EE0000")+2pt);
// draw(rp--rp+1.5*a, arrow=Arrow3(size=7bp), rgb("990000")+2pt);
// label('$\mathbf{v}$', rp+v, S);
// label('$\mathbf{F}$', rp+1.5*a, SW);
// // label('$\mathbf{F}$', rp+1.5*a, S);
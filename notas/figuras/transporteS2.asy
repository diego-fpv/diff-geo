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
pen traj_pen = black + 0.8pt;
pen vector_pen = rgb("#ac1d1d") + 1pt;
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

real eps = 10*pi/180;
path3 segment1 = arc(0Z,1,eps*180/pi,0,90,0);
path3 segment2 = arc(0Z,1,90,0,90,90);
path3 segment3 = arc(0Z,1,eps*180/pi,90,90,90);
path3 segment4 = arc(cos(eps)*Z, sin(eps),90,0,90,90);
draw(segment1, traj_pen);
draw(segment2, traj_pen);
draw(segment3, traj_pen);
draw(segment4, traj_pen);


// vectors1
triple u_1(real t){
    return (cos(t), 0, -sin(t))*0.2;
}
int Nvec1 = 4;
for (int i=0; i<=Nvec1; ++i){
    real t = (eps + (pi/2-eps)*i/Nvec1);
    triple p1 = (sin(t), 0, cos(t));
    draw(p1--p1+u_1(t), vector_pen, Arrow3(6bp));
}
// vectors2
triple u_2(real t){
    return (0, 0, -1)*0.2;
}
int Nvec2 = 4;
for (int i=1; i<=Nvec2; ++i){
    real t = pi/2*i/Nvec2;
    triple p2 = (cos(t), sin(t), 0);
    draw(p2--p2+u_2(t), vector_pen, Arrow3(6bp));
}
// vectors3
triple u_3(real t){
    return (0, cos(t), -sin(t))*0.2;
}
int Nvec3 = 4;
for (int i=0; i<Nvec3; ++i){
    real t = (eps + (pi/2-eps)*i/Nvec3);
    triple p3 = (0, sin(t), cos(t));
    draw(p3--p3+u_3(t), vector_pen, Arrow3(6bp));
}
// vectors4
triple u_4(real t){
    triple u_theta = cos(eps)*(cos(t)*X + sin(t)*Y) - sin(eps)*Z;
    triple u_phi = sin(eps)*(-sin(t)*X + cos(t)*Y);
    return (cos(cos(eps)*(pi/2-t))*u_theta + sin(cos(eps)*(pi/2-t))/sin(eps)*u_phi)*0.2;
}
int Nvec4 = 2;
for (int i=0; i<=Nvec4; ++i){
    real t = pi/2 - pi/2*i/Nvec4;
    write(u_4(t));
    triple p4 = (sin(eps)*cos(t), sin(eps)*sin(t), cos(eps));
    draw(p4--p4+u_4(t), vector_pen, Arrow3(6bp));
}






// // trajectory
// real[] v = {0.5, -1};
// real[] a = {0.5, 1.5};
// triple traj(real t) {
//     real theta_t = v[0]*t + a[0]/2*t^2;
//     real phi_t = v[1]*t + a[1]/2*t^2;
//     return (cos(phi_t+phi_p)*sin(theta_t+theta_p), sin(phi_t+phi_p)*sin(theta_t+theta_p), cos(theta_t+theta_p)); 
// }
// path3 trajectory = graph(traj, -2.1, 2.5, n=100);
// draw(tube(trajectory, scale(0.05/3)*unitcircle), blue + linewidth(1bp) + opacity(0.3));

// // basis vectors
// triple n = 0.3*unit(rp);
// triple u_phi = 0.3*unit(cross(Z, n)); 
// triple u_theta = 0.3*unit(cross(u_phi, n));
// draw(rp--rp+u_theta, arrow=Arrow3(size=6bp), axes_pen);
// label("$\mathbf{e}_1$", rp+u_theta, S, fontsize(8));
// draw(rp--rp+u_phi, arrow=Arrow3(size=6bp), axes_pen);
// label("$\mathbf{e}_2$", rp+u_phi, E, fontsize(8));

// // velocity
// triple velocity = 0.3*unit(v[0]*u_theta + v[1]*u_phi);
// draw(rp--rp+velocity, arrow=Arrow3(size=7bp), vector_pen);
// label("$\mathbf{v}$", rp+velocity, W);

// // force
// triple force = 0.3*unit(a[0]*u_theta + a[1]*u_phi);
// draw(rp--rp+force, arrow=Arrow3(size=7bp), vector_pen);
// label("$\mathbf{F}$", rp+force, S);

// // tangent plane
// real s = 1.5;
// path3 planeOutline = rp-s*u_phi-s*u_theta -- rp+s*u_phi-s*u_theta -- rp+s*u_phi+s*u_theta -- rp-s*u_phi+s*u_theta -- cycle;
// draw(surface(planeOutline), plane_pen);
// draw(planeOutline, outline_pen);


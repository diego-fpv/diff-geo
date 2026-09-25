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
string[] point_names = {"$P$", "$P'$", "$P''$"};
real[] phi_p = {pi/3, 0, 4pi/3};
real[] theta_p = {pi/3, pi/2, pi/3};
real R = 0.05; // radius
// trajectory parameters
real[][][] vs = {{{0.5, -1}, {0.5, 1}},
                 {{0.4, -1.2}, {0.8, 0.7}},
                 {{0.3, -0.8}, {0.8, 0.3}}};
real[][][] as = {{{0.2, -2.5}, {0.0, 2.0}},
                 {{0.1, -1.9}, {0.0, 1.8}},
                 {{0.1, -1.7}, {1.9, 0.5}}};

for (int j = 0; j < phi_p.length; ++j) {

    triple rp = (sin(theta_p[j])*cos(phi_p[j]), sin(theta_p[j])*sin(phi_p[j]), cos(theta_p[j])); // position
    draw(shift(rp)*scale3(R)*unitsphere);
    
    // basis vectors
    triple n = 0.3*unit(rp);
    triple u_phi = 0.3*unit(cross(Z, n)); 
    triple u_theta = 0.3*unit(cross(u_phi, n));

    // draw trajectories and tangent vectors
    for (int i = 0; i < vs[j].length; ++i) {
        triple traj(real t) {
            real theta_t = vs[j][i][0]*t + as[j][i][0]/2*t^2;
            real phi_t = vs[j][i][1]*t + as[j][i][1]/2*t^2;
            return (cos(phi_t+phi_p[j])*sin(theta_t+theta_p[j]), sin(phi_t+phi_p[j])*sin(theta_t+theta_p[j]), cos(theta_t+theta_p[j])); 
        }
        path3 trajectory = graph(traj, -0.4, 0.4, n=100);
        draw(tube(trajectory, scale(0.05/3)*unitcircle), blue + linewidth(1bp) + opacity(0.3));

        triple tangent_vec = 0.3*unit(vs[j][i][0]*u_theta + vs[j][i][1]*u_phi);
        draw(rp--rp+tangent_vec, arrow=Arrow3(size=7bp), vector_pen);
    };
    
    draw(rp--rp+u_theta, arrow=Arrow3(size=6bp), axes_pen);
    label("$\mathbf{e}_1$", rp+u_theta, S, fontsize(8));
    draw(rp--rp+u_phi, arrow=Arrow3(size=6bp), axes_pen);
    label("$\mathbf{e}_2$", rp+u_phi, E, fontsize(8));
    label(point_names[j], rp, N);
    
    // tangent plane
    real s = 1.5;
    path3 planeOutline = rp-s*u_phi-s*u_theta -- rp+s*u_phi-s*u_theta -- rp+s*u_phi+s*u_theta -- rp-s*u_phi+s*u_theta -- cycle;
    draw(surface(planeOutline), plane_pen);
    draw(planeOutline, outline_pen);
}





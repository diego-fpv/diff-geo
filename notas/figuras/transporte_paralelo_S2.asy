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
pen vector_pen = rgb("#aa3939") + linewidth(1pt);
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

// trajectory

triple traj1(real t) {
    real theta_t = t;
    real phi_t = 0;
    return (cos(phi_t)*sin(theta_t), sin(phi_t)*sin(theta_t), cos(theta_t)); 
}
triple traj2(real t) {
    real theta_t = pi/2;
    real phi_t = t;
    return (cos(phi_t)*sin(theta_t), sin(phi_t)*sin(theta_t), cos(theta_t)); 
}
triple traj3(real t) {
    real theta_t = pi/2-t;
    real phi_t = pi/3;
    return (cos(phi_t)*sin(theta_t), sin(phi_t)*sin(theta_t), cos(theta_t)); 
}
path3 trajectory = graph(traj1, 0, pi/2, n=100);
trajectory = trajectory--graph(traj2, 0, pi/3, n=100);
trajectory = trajectory--graph(traj3, 0, pi/2, n=100);

draw(trajectory, rgb("#494949") + linewidth(1pt));

int Narrows = 5;
for (int i=0; i<=Narrows; ++i){
    // down
    real t = i/Narrows * pi/2;
    real theta_t = t, phi_t = 0;
    triple p = traj1(t);
    triple v = 0.2*(cos(phi_t)*cos(theta_t), sin(phi_t)*cos(theta_t), -sin(theta_t));
    draw(p--p+v, vector_pen, Arrow3(4bp));

    // side
    real t = i/Narrows * pi/3;
    real theta_t = pi/2, phi_t = t;
    triple p = traj2(t);
    triple v = 0.2*(cos(phi_t)*cos(theta_t), sin(phi_t)*cos(theta_t), -sin(theta_t));
    draw(p--p+v, vector_pen, Arrow3(4bp));
    
    // up
    real t = i/Narrows * pi/2;
    real theta_t = pi/2-t, phi_t = pi/3;
    triple p = traj3(t);
    triple v = 0.2*(cos(phi_t)*cos(theta_t), sin(phi_t)*cos(theta_t), -sin(theta_t));
    draw(p--p+v, vector_pen, Arrow3(4bp));

}
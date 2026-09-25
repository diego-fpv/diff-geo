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

pen gridline_pen = gray + 0.5pt;
pen vector_pen = rgb("#a34e4e") + linewidth(1pt);
pen surface_pen = rgb("#ffffff") + opacity(0.3);
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

// vector field in coordinate space
pair v(real theta, real phi){
    return ((cos(3phi))/r, 1/R);
}

// vector field in R^3
triple V(pair t){
    real theta = t.x;
    real phi = t.y;

    real vx = v(theta, phi).x * (-r*sin(theta)*cos(phi)) + v(theta, phi).y * (R+r*cos(theta)*sin(phi))*(-sin(phi));
    real vy = v(theta, phi).x * (-r*sin(theta)*sin(phi)) + v(theta, phi).y * (R+r*cos(theta))*(cos(phi));
    real vz = v(theta, phi).x * (r*cos(theta));
    return (vx, vy, vz);
}

// arrows
int Ntheta = 12, Nphi = 30;
for (int i=0; i<Ntheta; ++i){
    real theta = 2pi/Ntheta * i;
    for (int j=0; j<Nphi; ++j){
        real phi = 2pi/Nphi * j;
        triple p = torus_point((theta, phi));
        triple vec = V((theta, phi))*0.15;
        draw(p--p+vec, vector_pen, Arrow3(4bp));
    }
}
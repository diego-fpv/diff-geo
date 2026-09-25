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
    // camera=(0, 0, 2),
    target=(0, 0,0 ),
    up=Z,
    autoadjust=true
);

pen[] gridline_pens = {rgb("#7d7d7d") + 0.5pt, rgb("#ee8383") + 0.5pt};
pen surface_pen = rgb("#ffffff") + opacity(0.4);
pen[] axes_pens = {rgb("#000000") + 1pt, rgb("#9e1818") + 1pt};
pen vector_pen = red + 2pt;
pen plane_pen = rgb("#eb5555") + opacity(0.3);
pen outline_pen = rgb("#a01a1a") + opacity(0.8);
light Light = light(diffuse=gray(0.1), (1,1,1));

// sphere
triple spherePoint(pair t) {
  real theta = t.x;  // longitude
  real phi   = t.y;  // latitude
  return (sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta));
}
surface hemi = surface(spherePoint, (0,0), (pi/2, 2pi), 15, 40, Spline);
draw(hemi, surface_pen);


// spherical coordinate lines
for (int i = 1; i <= 6; ++i) {

    // latitude
    real theta = i*pi/6/2;  
    real z = cos(theta);
    real r = sin(theta);
    path3 lat = circle(c=(0, 0, z), r=r, normal=Z); 
    draw(lat, gridline_pens[1]); 

    // longitude
    real theta1 = 90;
    real theta2 = 90;
    real phi1 = degrees(i*pi/6);
    real phi2 = degrees(pi+i*pi/6);
    triple normal_vec = (sin(i*pi/6), -cos(i*pi/6), 0);
    path3 lon = arc(c=(0,0,0), r=1, theta1=theta1, phi1=phi1, theta2=theta2, phi2=phi2, normal=normal_vec);
    draw(lon, gridline_pens[1]);
}

// projection coordinate lines
for (int i = -3; i <=3; ++i) {

    // x = constant
    real x0 = i/4;
    triple center = (x0, 0, 0);
    triple normal_vec = (-0.3, 0, 0);
    real theta1 = 90;
    real theta2 = 90;
    real phi1 = -90;
    real phi2 = 90;
    real r = sqrt(1-x0^2);
    path3 x_line = arc(c=center, r=r, theta1=theta1, phi1=phi1, theta2=theta2, phi2=phi2, normal=normal_vec);
    draw(x_line, gridline_pens[0]);
    
    // y = constant
    real y0 = i/4;
    triple center = (0, y0, 0);
    triple normal_vec = (0, -0.3, 0);
    real theta1 = 90;
    real theta2 = 90;
    real phi1 = 0;
    real phi2 = 180;
    real r = sqrt(1-y0^2);
    path3 x_line = arc(c=center, r=r, theta1=theta1, phi1=phi1, theta2=theta2, phi2=phi2, normal=normal_vec);
    draw(x_line, gridline_pens[0]);
}

// point coordinates
real theta = 2*pi/6/2;
real phi = pi/6;
triple rp = (sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta));
    
// spherical basis vectors
triple n = 0.3*unit(rp);
triple u_phi = 0.3*unit(cross(Z, n)); 
triple u_theta = 0.3*unit(cross(u_phi, n));
u_phi = sin(theta)*u_phi;
draw(rp--rp+u_theta, arrow=Arrow3(size=6bp), axes_pens[1]);
draw(rp--rp+u_phi, arrow=Arrow3(size=6bp), axes_pens[1]);
label("$\mathbf{e}_{1'}$", rp+u_theta, SE, fontsize(8));
label("$\mathbf{e}_{2'}$", rp+u_phi, NE, fontsize(8));

// projection coordinate basis vectors
triple u_x = rp.x / sqrt((1-rp.x^2-rp.y^2)*(rp.x^2+rp.y^2))*u_theta - rp.y / (rp.x^2 + rp.y^2) * u_phi; 
triple u_y = rp.y / sqrt((1-rp.x^2-rp.y^2)*(rp.x^2+rp.y^2))*u_theta + rp.x / (rp.x^2 + rp.y^2) * u_phi; 
draw(rp--rp+u_x, arrow=Arrow3(size=6bp), axes_pens[0]);
draw(rp--rp+u_y, arrow=Arrow3(size=6bp), axes_pens[0]);
label("$\mathbf{e}_{1}$", rp+u_x, SW, fontsize(8));
label("$\mathbf{e}_{2}$", rp+u_y, E, fontsize(8));

// another point
theta = 4*pi/6/2;
phi = -pi/6;
rp = (sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta));

// spherical basis vectors
triple n = 0.3*unit(rp);
triple u_phi = 0.3*unit(cross(Z, n)); 
triple u_theta = 0.3*unit(cross(u_phi, n));
u_phi = sin(theta)*u_phi;
draw(rp--rp+u_theta, arrow=Arrow3(size=6bp), axes_pens[1]);
draw(rp--rp+u_phi, arrow=Arrow3(size=6bp), axes_pens[1]);
label("$\mathbf{e}_{1'}$", rp+u_theta, SW, fontsize(8));
label("$\mathbf{e}_{2'}$", rp+u_phi, NE, fontsize(8));

// projection coordinate basis vectors
triple u_x = rp.x / sqrt((1-rp.x^2-rp.y^2)*(rp.x^2+rp.y^2))*u_theta - rp.y / (rp.x^2 + rp.y^2) * u_phi; 
triple u_y = rp.y / sqrt((1-rp.x^2-rp.y^2)*(rp.x^2+rp.y^2))*u_theta + rp.x / (rp.x^2 + rp.y^2) * u_phi; 
draw(rp--rp+u_x, arrow=Arrow3(size=6bp), axes_pens[0]);
draw(rp--rp+u_y, arrow=Arrow3(size=6bp), axes_pens[0]);
label("$\mathbf{e}_{1}$", rp+u_x, S, fontsize(8));
label("$\mathbf{e}_{2}$", rp+u_y, NE, fontsize(8));


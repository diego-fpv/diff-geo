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
    camera=(5.0*cos(0.7), 5.0*sin(0.7), 0.2),
    // camera=(5.0*cos(0.8), 5.0*sin(0.8), 2),
    target=(0,0,0),
    up=Z,
    autoadjust=true
);

pen gridline_pen = rgb("#d25c5c") + 0.5pt;
pen surface_pen = rgb("#ffffff") + opacity(0.4);
pen axes_pen = black + 1pt;
pen vector_pen = red + 2pt;
pen plane_pen = rgb("#a49e9e") + opacity(0.3);
pen outline_pen = rgb("#3f3f3f") + opacity(0.8);
light Light = light(diffuse=gray(0.1), (1,1,1));

// sphere
draw(unitsphere, surface_pen);

// // coordinate lines
// for (int i = 1; i <= 6; ++i) {
//     real theta = i*pi/6;
//     real z = cos(theta);
//     real r = sin(theta);
//     path3 lat = circle(c=(0, 0, z), r=r, normal=Z);
//     draw(lat, gridline_pen); 
//     triple normal_vec = (cos(theta), sin(theta), 0);
//     path3 lat = circle(c=(0,0,0), r=1, normal=normal_vec);
//     draw(lat, gridline_pen); 
// }

real x0 = -0.1;
real y0 = 0.6;
pair rs = (0.55, 0.3);
triple boundaryPoint(real t){
    real x = x0 + rs.x*cos(t);
    real y = y0 + rs.y*sin(t);
    real z = sqrt(1 - x^2 - y^2);
    return (x, y, z);
}
path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
draw(boundary, rgb("#712222") + linewidth(1pt));

// gridlines
int N_lines = 5;
real dx = rs.x/(N_lines+1);
real dy = rs.y/(N_lines+1);
for (int i=-N_lines; i<=N_lines; ++i){
    // constant x
    real x = x0 + i*dx;
    real Dy = rs.y * sqrt(1 - (x-x0)^2/rs.x^2); 
    real[] yLims = {y0 - Dy, y0 + Dy};
    triple xPoints(real y){
        return (x, y, sqrt(1-x^2-y^2));
    }
    path3 xLine = graph(xPoints, yLims[0], yLims[1], n=10);
    draw(xLine, gridline_pen);

    // constant y
    real y = y0 + i*dy;
    real Dx = rs.x * sqrt(1 - (y-y0)^2/rs.y^2); 
    real[] xLims = {x0 - Dx, x0 + Dx};
    triple yPoints(real x){
        return (x, y, sqrt(1-x^2-y^2));
    }
    path3 yLine = graph(yPoints, xLims[0], xLims[1], n=10);
    draw(yLine, gridline_pen);
}

// Build a patch by sampling a grid over a theta/phi range
real theta1 = pi/3, theta2 = pi/2;   // polar angle range
real phi1 = 0, phi2 = pi/2;          // azimuthal angle range

// homeomorphism
real s = 1;
triple rp = (-2, 0.5, 0);
path3 planeOutline = rp-s*Z-s*Y -- rp+s*Z-s*Y -- rp+s*Z+s*Y -- rp-s*Z+s*Y -- cycle;
draw(surface(planeOutline), plane_pen);
draw(planeOutline, outline_pen);

// image boundary
triple boundaryPoint(real t){
    real x = rs.x*cos(t);
    real y = rs.y*sin(t);
    return rp + (0, x, y);
}
path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
draw(boundary, rgb("#712222") + linewidth(1pt));

// image gridlines
for (int i=-N_lines; i<=N_lines; ++i){
    // constant x
    real x = i*dx;
    real Dy = rs.y * sqrt(1 - x^2/rs.x^2); 
    real[] yLims = {-Dy, Dy};
    triple xPoints(real y){
        return rp + (0, x, y);
    }
    path3 xLine = graph(xPoints, yLims[0], yLims[1], n=2);
    draw(xLine, gridline_pen);
    
    // constant x
    real y = i*dy;
    real Dx = rs.x * sqrt(1 - y^2/rs.y^2); 
    real[] xLims = {-Dx, Dx};
    triple yPoints(real x){
        return rp + (0, x, y);
    }
    path3 yLine = graph(yPoints, xLims[0], xLims[1], n=2);
    draw(yLine, gridline_pen);
}

// map arrow 
triple pointSphere = (x0, y0, sqrt(1-x0^2-y0^2)) + 0.1*(1, 1, 1)/sqrt(3) - 0.2X;
triple pointPlane = rp + 0.2(X+Y);
draw(pointSphere..(pointSphere+pointPlane)/2+0.2*(Z+Y)..pointPlane, Arrow3(6bp));


// labels
label("$U$", pointSphere, (0,0,1), fontsize(8pt));
label("$\varphi(U)$", pointPlane+0.3*Z, N, fontsize(8pt));
label("$\varphi$", (pointSphere+pointPlane)/2+0.2*(Z+Y), (0,0,1), fontsize(8pt));
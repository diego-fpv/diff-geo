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
size(6cm);

// camera (nice default view)
currentprojection = perspective(
    camera=(5.0*cos(0.7), 5.0*sin(0.7), 0.2),
    // camera=(0*cos(0), 5.0*sin(0), 5),
    target=(0,0,0),
    up=Z,
    autoadjust=true
);

pen[] gridline_pen = {rgb("#d25c5c") + 0.5pt, rgb("#4f71eb") + 0.5pt};
pen surface_pen = rgb("#ffffff") + opacity(0.4);
pen axes_pen = black + 1pt;
pen vector_pen = red + 2pt;
pen plane_pen = rgb("#a49e9e") + opacity(0.3);
pen outline_pen = rgb("#3f3f3f") + opacity(0.8);
light Light = light(diffuse=gray(0.1), (1,1,1));

// sphere
draw(unitsphere, surface_pen);

// U
real x10 = -0.1;
real y10 = 0.6;
pair r1s = (0.55, 0.3);

triple boundaryPoint(real t){
    real x = x10 + r1s.x*cos(t);
    real y = y10 + r1s.y*sin(t);
    real z = sqrt(1 - x^2 - y^2);
    return (x, y, z);
}
path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
draw(boundary, rgb("#712222") + linewidth(1pt));

// gridlines
int N_lines = 5;
real dx = r1s.x/(N_lines+1);
real dy = r1s.y/(N_lines+1);
for (int i=-N_lines; i<=N_lines; ++i){
    // constant x
    real x = x10 + i*dx;
    real Dy = r1s.y * sqrt(1 - (x-x10)^2/r1s.x^2); 
    real[] yLims = {y10 - Dy, y10 + Dy};
    triple xPoints(real y){
        return (x, y, sqrt(1-x^2-y^2));
    }
    path3 xLine = graph(xPoints, yLims[0], yLims[1], n=10);
    draw(xLine, gridline_pen[0]);

    // constant y
    real y = y10 + i*dy;
    real Dx = r1s.x * sqrt(1 - (y-y10)^2/r1s.y^2); 
    real[] xLims = {x10 - Dx, x10 + Dx};
    triple yPoints(real x){
        return (x, y, sqrt(1-x^2-y^2));
    }
    path3 yLine = graph(yPoints, xLims[0], xLims[1], n=10);
    draw(yLine, gridline_pen[0]);
}

// U'
real x20 = 0.4;
real y20 = 0.5;
pair r2s = (0.4, 0.3);
triple boundaryPoint(real t){
    real x = x20 + r2s.x*cos(t);
    real y = y20 + r2s.y*sin(t);
    real z = sqrt(1 - x^2 - y^2);
    return (x, y, z);
}

path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
draw(boundary, rgb("#322271") + linewidth(1pt));

// gridlines (radial + angular)
int N_lines = 2;
real dx = r2s.x/(N_lines+1);
real dy = r2s.y/(N_lines+1);
for (int i=-N_lines; i<=N_lines; ++i){
    // constant x
    real x = x20 + i*dx;
    real Dy = r2s.y * sqrt(1 - (x-x20)^2/r2s.x^2); 
    real[] yLims = {y20 - Dy, y20 + Dy};
    triple xPoints(real y){
        return (x, y, sqrt(1-x^2-y^2));
    }
    path3 xLine = graph(xPoints, yLims[0], yLims[1], n=10);
    draw(xLine, gridline_pen[1]);

    // constant y
    real y = y20 + i*dy;
    real Dx = r2s.x * sqrt(1 - (y-y20)^2/r2s.y^2); 
    real[] xLims = {x20 - Dx, x20 + Dx};
    triple yPoints(real x){
        return (x, y, sqrt(1-x^2-y^2));
    }
    path3 yLine = graph(yPoints, xLims[0], xLims[1], n=10);
    draw(yLine, gridline_pen[1]);
}

// homeomorphisms
real s = 1;
triple r1p = (-2, 0.5, 0);
triple r2p = (-0.85, 0.5, -1.15);
path3 planeOutline = r1p-s*Z-s*Y -- r1p+s*Z-s*Y -- r1p+s*Z+s*Y -- r1p-s*Z+s*Y -- cycle;
draw(surface(planeOutline), plane_pen);
draw(planeOutline, outline_pen);

// image boundary
triple boundaryPoint(real t){
    real x = r1s.x*cos(t);
    real y = r1s.y*sin(t);
    return r1p + (0, x, y);
}
path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
draw(boundary, rgb("#712222") + linewidth(1pt));

// image gridlines
N_lines = 5;
real dx = r1s.x/(N_lines+1);
real dy = r1s.y/(N_lines+1);
for (int i=-N_lines; i<=N_lines; ++i){
    // constant x
    real x = i*dx;
    real Dy = r1s.y * sqrt(1 - x^2/r1s.x^2); 
    real[] yLims = {-Dy, Dy};
    triple xPoints(real y){
        return r1p + (0, x, y);
    }
    path3 xLine = graph(xPoints, yLims[0], yLims[1], n=2);
    draw(xLine, gridline_pen[0]);
    
    // constant x
    real y = i*dy;
    real Dx = r1s.x * sqrt(1 - y^2/r1s.y^2); 
    real[] xLims = {-Dx, Dx};
    triple yPoints(real x){
        return r1p + (0, x, y);
    }
    path3 yLine = graph(yPoints, xLims[0], xLims[1], n=2);
    draw(yLine, gridline_pen[0]);
}

// map arrow 
triple pointSphere = (x10, y10, sqrt(1-x10^2-y10^2)) + 0.1*(1, 1, 1)/sqrt(3) - 0.2X;
triple pointPlane = r1p + 0.2(X+Y);
draw(pointSphere..(pointSphere+pointPlane)/2+0.2*(Z+Y)..pointPlane, Arrow3(6bp));


// labels
label("$U$", pointSphere, (0,0,1), fontsize(8pt));
label("$\varphi_U(U)$", pointPlane+0.3*Z, N, fontsize(8pt));
label("$\varphi_U$", (pointSphere+pointPlane)/2+(0,0.2,0.3), (0,0,1), fontsize(8pt));


// other homeomorphism
path3 planeOutline = r2p-s*X-s*Y -- r2p+s*X-s*Y -- r2p+s*X+s*Y -- r2p-s*X+s*Y -- cycle;
draw(surface(planeOutline), plane_pen);
draw(planeOutline, outline_pen);

// image boundary
triple boundaryPoint(real t){
    real x = r2s.x*cos(t);
    real y = r2s.y*sin(t);
    return r2p + (y, x, 0);
}
path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
draw(boundary, rgb("#322271") + linewidth(1pt));

// image gridlines
N_lines = 2;
real dx = r1s.x/(N_lines+1);
real dy = r1s.y/(N_lines+1);
for (int i=-N_lines; i<=N_lines; ++i){
    // constant x
    real x = i*dx;
    real Dy = r2s.y * sqrt(1 - x^2/r2s.x^2); 
    real[] yLims = {-Dy, Dy};
    triple xPoints(real y){
        return r2p + (y, x, 0);
    }
    path3 xLine = graph(xPoints, yLims[0], yLims[1], n=2);
    draw(xLine, gridline_pen[1]);
    
    // constant x
    real y = i*dy;
    real Dx = r2s.x * sqrt(1 - y^2/r2s.y^2); 
    real[] xLims = {-Dx, Dx};
    triple yPoints(real x){
        return r2p + (y, x, 0);
    }
    path3 yLine = graph(yPoints, xLims[0], xLims[1], n=2);
    draw(yLine, gridline_pen[1]);
}


// map arrow 
triple pointSphere2 = (x20, y20, sqrt(1-x20^2-y20^2)) + 0.1*(1, 1, 1)/sqrt(3);
triple pointPlane2 = r2p + 0.14*(Z);
triple intermediatePoint = 1.8(pointSphere2+pointPlane2)/2+0.2*(X+Y);
draw(pointSphere2..intermediatePoint..pointPlane2, Arrow3(6bp));

// labels
label("$U'$", pointSphere2, (0,1,1), fontsize(8pt));
label("$\varphi_{U'}(U')$", pointPlane2-0.3*Z, E, fontsize(8pt));
label("$\varphi_{U'}$", intermediatePoint, (0,-1,1), fontsize(8pt));

r2s = (0.4, 0.2);
// overlap
triple boundaryPoint(real t){
    real x = x20 - x10 + r2s.x*cos(t);
    real y = y20 - y10 + r2s.y*sin(t);
    return r1p + (0, x, y);
}
path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
draw(boundary, rgb("#322271") + linewidth(1pt));

triple boundaryPoint(real t){
    real x = x10 - x20 + r1s.x*cos(t);
    real y = y10 - y20 + r1s.y*sin(t);
    return r2p + (y, x, 0);
}
path3 boundary = graph(boundaryPoint, 0, 2pi, n=50);
draw(boundary, rgb("#712222") + linewidth(1pt));

// overlap arrow and labels
draw(pointPlane+(0.05,0.25,-0.1)..pointPlane2+(0.05,-0.1, 0.05), Arrow3(6bp));
label("$\varphi_{U'}\circ\varphi_{U}^{-1}$", (pointPlane+pointPlane2)/2, (0, 2, 0), fontsize(8pt));
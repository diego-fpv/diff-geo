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
pen[] gridline_pens = {rgb("#798bea") + 0.5pt, rgb("#ee8383") + 0.5pt};
pen surface_pen = rgb("#ffffff") + opacity(0.4);
pen[] axes_pens = {rgb("#000000") + 1pt, rgb("#9e1818") + 1pt};
pen vector_pen = red + 2pt;
pen plane_pen = rgb("#eb5555") + opacity(0.3);
pen outline_pen = rgb("#a01a1a") + opacity(0.8);
light Light = light(diffuse=gray(0.1), (1,1,1));

// sphere
draw(unitsphere, surface_pen);

// horizontal chart
real theta_min = pi/6;
real theta_max = pi - theta_min;
real theta_int = theta_max - theta_min;
// latitude
for (int i = 0; i <= 10; ++i) {
    real theta = theta_min + i*theta_int/10;  
    real z = cos(theta);
    real r = sin(theta);
    path3 lat = circle(c=(0, 0, z), r=r, normal=Z); 
    draw(lat, gridline_pens[1]); 
    draw(rotate(90, Y)*lat, gridline_pens[0]); 
}
// longitude
for (int i = 0; i<= 20; ++i){
    real phi = degrees(i*pi/10);
    triple normal_vec = (-sin(radians(phi)), cos(radians(phi)), 0);
    path3 lon = arc(c=(0,0,0), r=1, 
        theta1=degrees(theta_min), phi1=phi, 
        theta2=degrees(theta_max), phi2=phi, normal=normal_vec);
    // horizontal chart
    draw(lon, gridline_pens[1]);
    // vertical chart
    draw(rotate(90, Y)*lon, gridline_pens[0]);
}

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

import graph;
size(5cm);

pen path_pen = rgb("#3c59b9") + 0.8pt;
pen lines_pen = rgb("#c3c3c3") + 1pt;
pen axis_pen = rgb("#353535") + 1pt;
pen arrow_pen = rgb("#922c2c") + 0.8pt + opacity(0.6);
pen main_arrow = rgb("#621d1d") + 1pt;
pen aid_pen = rgb("#922c2c") + 0.3pt;

// axes
path xAxis = (-1.1,0)--(1.1,0);
path yAxis = (0,-1.1)--(0,1.1);
draw(xAxis, axis_pen);
draw(yAxis, axis_pen);

draw(box((-1, -1), (1, 1.)), lines_pen);

// S1
int Nlines = 2;
for (int i=-Nlines; i<=Nlines; ++i){
    int x = i;
    draw((i, -3)--(i, 3), lines_pen);
    int y = i;
    draw((-3, i)--(3, i), lines_pen);
}

pair trajectory(real t){
    real r = 1.3;
    return (r*cos(t), r*sin(t));
}
path traj = graph(trajectory, 0, 2pi, 100);
draw(traj, path_pen); 

// vectors
int Num = 55;
pair v0 = (1, 0);
pair p0 = trajectory(0);
draw(p0--p0+0.4v0, main_arrow, Arrow(6bp));
for (int i=0; i<Num; ++i){
    real t = i/Num*2pi;
    pair p = trajectory(t);
    pair Dr = p - p0;
    real vx = exp(Dr.y)*(cos(Dr.x)*v0.x - sin(Dr.x)*v0.y);
    real vy = exp(Dr.y)*(sin(Dr.x)*v0.x + cos(Dr.x)*v0.y);
    draw(p--p+0.4(vx, vy), arrow_pen, Arrow(6bp));
}

path frame = box((-2.1, -2.1), (2.1, 2.1));
clip(currentpicture, frame);






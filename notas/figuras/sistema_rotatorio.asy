if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed= true;
settings.toolbar=false;
viewportmargin=(2,2);

defaultfilename=outprefix();

import graph;

pen[] gridline_pens = {rgb("#adadad") + 0.5pt, rgb("#ee8383") + 0.5pt};
pen[] axes_pens = {rgb("#302f2f") + 1pt, rgb("#9e1818") + 1pt};

picture pic1;
size(pic1, 5cm);
picture pic2;
size(pic2, 5cm);

//gridlines

// original vectors
pair[] eCs = {(1, 0), (0, 1)};
// new vectors
real w = 1;
real t = 2.2;
pair[] eNs = {(cos(w*t), sin(w*t)), (-sin(w*t), cos(w*t))};

int n = 5;
for (int j=-n; j<n; ++j){
    // original system
    draw(pic1, (-n*eCs[0] + j*eCs[1])--(n*eCs[0]+j*eCs[1]), gridline_pens[0]);
    draw(pic1, (-n*eCs[1] + j*eCs[0])--(n*eCs[1]+j*eCs[0]), gridline_pens[0]);

    // galileo
    draw(pic1, (-n*eNs[1] + j*eNs[0])--(n*eNs[1]+j*eNs[0]), gridline_pens[1] + dashed);
    draw(pic1, (-n*eNs[0] + j*eNs[1])--(n*eNs[0]+j*eNs[1]), gridline_pens[1] + dashed);
}

// new vectors
pair[] eNs = {(1, 0), (0, 1)};
// original vectors
pair[] eCs = {(cos(w*t), -sin(w*t)), (sin(w*t), cos(w*t))};

int n = 5;
for (int j=-n; j<n; ++j){
    // original system
    draw(pic2, (-n*eCs[0] + j*eCs[1])--(n*eCs[0]+j*eCs[1]), gridline_pens[0]+dashed);
    draw(pic2, (-n*eCs[1] + j*eCs[0])--(n*eCs[1]+j*eCs[0]), gridline_pens[0]+dashed);

    // galileo
    draw(pic2, (-n*eNs[1] + j*eNs[0])--(n*eNs[1]+j*eNs[0]), gridline_pens[1]);
    draw(pic2, (-n*eNs[0] + j*eNs[1])--(n*eNs[0]+j*eNs[1]), gridline_pens[1]);
}

// trajectory
pair r0 = (-1, 0);
pair v0 = (1, 0);
pair r_original(real t) {
    return r0 + v0*t;
}
pair r_new(real t) {
    pair r = r_original(t);
    return (cos(w*t)*r.x + sin(w*t)*r.y, 
            -sin(w*t)*r.x + sin(w*t)*r.y);
}
real dt = 0.02;
int Num = 250;
path traj_original = r0;
path traj_new = r0;
for (int i = 1; i<=Num; ++i){
    traj_original = traj_original--r_original(i*dt);
    traj_new = traj_new..r_new(i*dt);
}
draw(pic1, traj_original, rgb("#3c68bb") + linewidth(2) + opacity(0.5));
draw(pic2, traj_new, rgb("#3c68bb") + linewidth(2) + opacity(0.5));

dot(pic1, r_original(t));
dot(pic2, r_new(t), rgb("#801a1a"));


draw(pic1, (0,0)--(1,0), axes_pens[0], Arrow(5bp));
draw(pic1, (0,0)--(0,1), axes_pens[0], Arrow(5bp));
draw(pic1, (0,0)--(cos(w*t),sin(w*t)), axes_pens[1], Arrow(5bp));
draw(pic1, (0,0)--(-sin(w*t),cos(w*t)), axes_pens[1], Arrow(5bp));
draw(pic1, arc((0, 0), (0.5, 0), (0.5*cos(w*t), 0.5*sin(w*t))), gridline_pens[1]+dashed, Arrow(6bp));

draw(pic2, (0,0)--(1,0), axes_pens[1], Arrow(5bp));
draw(pic2, (0,0)--(0,1), axes_pens[1], Arrow(5bp));
draw(pic2, (0,0)--(cos(w*t),-sin(w*t)), axes_pens[0], Arrow(5bp));
draw(pic2, (0,0)--(sin(w*t),cos(w*t)), axes_pens[0], Arrow(5bp));
draw(pic2, arc((0, 0), (0.5, 0), (0.5*cos(w*t), -0.5*sin(w*t)), CW), gridline_pens[0]+dashed, Arrow(6bp));


// clip to smaller frame
path frame = box((-3.1, -1.1), (3.1, 2.1));
clip(pic1, frame);
// clip to smaller frame
path frame = box((-3.1, -1.1), (3.1, 2.1));
clip(pic2, frame);


add(pic1, (0, 0));
add(pic2, (0, -2.8cm));
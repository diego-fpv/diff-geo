if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed= true;
settings.toolbar=false;
viewportmargin=(2,2);

defaultfilename=outprefix();

size(5cm);

pen[] gridline_pens = {rgb("#adadad") + 0.5pt, rgb("#ee8383") + 0.5pt};
pen[] axes_pens = {rgb("#000000") + 1pt, rgb("#9e1818") + 1pt};
pair ori = (0, 0);

// points 
real[][] rs = {{1, 1}, {2, 3}};
// original vectors
pair[] eCs = {(1, 0), (0, 1)};
// new vectors (v = 0.5)
real beta = 0.5;
real gamma(real beta){
    return 1/sqrt(1-beta^2);
}
pair[] eLs = {(gamma(beta), gamma(beta)*beta), (gamma(beta)*beta, gamma(beta))};

// light cones
draw((-5, -5)--(5, 5), linewidth(0.5)+black+dashed);
draw((-5, 5)--(5, -5), linewidth(0.5)+black+dashed);

// gridlines
int n = 5;
for (int j=-n; j<n; ++j){
    // original system
    draw((-n*eCs[0] + j*eCs[1])--(n*eCs[0]+j*eCs[1]), gridline_pens[0]);
    draw((-n*eCs[1] + j*eCs[0])--(n*eCs[1]+j*eCs[0]), gridline_pens[0]);

    // galileo
    draw((-n*eLs[1] + j*eLs[0])--(n*eLs[1]+j*eLs[0]), gridline_pens[1]);
    draw((-n*eLs[0] + j*eLs[1])--(n*eLs[0]+j*eLs[1]), gridline_pens[1]);
}

// basis vectors
draw((0,0)--eCs[0], axes_pens[0], Arrow(5bp));
draw((0,0)--eCs[1], axes_pens[0], Arrow(5bp));
draw((0,0)--eLs[0], axes_pens[1], Arrow(5bp));
draw((0,0)--eLs[1], axes_pens[1], Arrow(5bp));

label("$\mathbf{e}_x$", eCs[0], S);
label("$\mathbf{e}_{ct}$", eCs[1], NW);
label("$\mathbf{e}_{x'}$", eLs[0], E);
label("$\mathbf{e}_{ct'}$", eLs[1], NE);

// hyperbola
pair xy(real x) {
    return (x, sqrt(2+x^2));
}
int Num = 500;
real dx = 0.02;
path[] hyperbola = new path[2];
hyperbola[0] = xy(-5);
hyperbola[1] = -xy(-5);
for (int i=0; i<Num; ++i) {
    real x = -5 + i*dx;
    hyperbola[0] = hyperbola[0]..xy(x);
    hyperbola[1] = hyperbola[1]..(-xy(x));
}
draw(hyperbola[0], linewidth(1pt)+opacity(0.4));
draw(hyperbola[1], linewidth(1pt)+opacity(0.4));

fill(box((-2, -5), (0, 5)), opacity(0.3)+rgb("#3e83eb"));
draw(box((-2, -5), (-2, 5)), rgb("#27508d"));
draw(box((0, -5), (0, 5)), rgb("#27508d"));
dot((-2, 0), rgb("#27508d"));
dot((0, 0), rgb("#27508d"));
draw((0,0)--(-2,0),rgb("#27508d") + dashed + linewidth(1pt));
dot((-2, -1), rgb("#27508d"));
draw((0,0)--(-2,-1),rgb("#27508d") + dashed + linewidth(1pt));

label("$L$", (-2, 0), W);
label("$L'$", (-2, -1), W);

path frame = box((-3.1, -3.1), (3.1, 3.1));
clip(currentpicture, frame);

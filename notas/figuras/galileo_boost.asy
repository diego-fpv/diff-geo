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
pair[] eGs = {(1, 0), (0.5, 1)};

// gridlines
int n = 5;
for (int j=-n; j<n; ++j){
    // original system
    draw((-n*eCs[0] + j*eCs[1])--(n*eCs[0]+j*eCs[1]), gridline_pens[0]);
    draw((-n*eCs[1] + j*eCs[0])--(n*eCs[1]+j*eCs[0]), gridline_pens[0]);

    // galileo
    draw((-n*eGs[1] + j*eGs[0])--(n*eGs[1]+j*eGs[0]), gridline_pens[1]);
    draw((-n*eGs[0] + j*eGs[1])--(n*eGs[0]+j*eGs[1]), gridline_pens[1] + dashed);
}

for (int i=-1; i<=1; ++i){
    // t, x = const
    label(format("$%d$", i), (-2, i), NW, fontsize(6)+rgb("#5e5d5d"));
    label(format("$%d$", i), (i, 0), SW, fontsize(6)+rgb("#5e5d5d"));
    label(format("$%d$", i), (i-1, -2), NW, fontsize(6)+rgb("#db5c5c"));
    label(format("$%d$", i), (i, 0), NW, fontsize(6)+rgb("#db5c5c"));
    label(format("$%d$", i), (i+1, 2), NW, fontsize(6)+rgb("#db5c5c"));
    label(format("$%d$", i), (2, i), NW, fontsize(6)+rgb("#db5c5c"));
}

draw((0,0)--(1, 0), axes_pens[0], Arrow(6bp));
draw((0,0)--(0, 1), axes_pens[0], Arrow(6bp));

draw((0,0)--(1, 0), axes_pens[1]+dashed, Arrow(6bp));
draw((0,0)--(0.5, 1), axes_pens[1], Arrow(6bp));

dot((0,0));

dot((1,-2), rgb("#c00707"));
dot((2,-0), rgb("#c00707"));

label("$\mathbf{e}_x=\mathbf{e}_{x'}$", eCs[0], S);
label("$\mathbf{e}_{t}$", eCs[1], NW);
label("$\mathbf{e}_{t'}$", eGs[1], NE);


// clip to smaller frame
path frame = box((-3.1, -3.1), (3.1, 3.1));
clip(currentpicture, frame);

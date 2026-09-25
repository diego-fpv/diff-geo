if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed= true;
settings.toolbar=false;
viewportmargin=(2,2);

// settings.prc = true;
defaultfilename=outprefix();

// import three;
// import graph3;
// import tube;
import graph;
import "rk4" as rk4;
size(5cm, 5cm, IgnoreAspect);

real g = 9.8, L = 1.0;

// state y = [theta, omega]
real[] deriv(real t, real[] y) {
    real[] dydt = new real[2];
    dydt[0] = y[1];  // dtheta/dt = omega
    dydt[1] = -g/L*sin(y[0]);  // domega/dt = -g/L sin(theta)
    return dydt;
}

real[] y0 = {1.0, 5.0};  // initial theta, omega
real dt = 0.01;
int N = 200;

real[][] Y = rk4solve(deriv, 0, y0, dt, N);

real[] theta = new real[N+1];
real[] omega = new real[N+1];
for (int i = 0; i <= N; ++i) {
  theta[i] = Y[i][0];
  omega[i] = Y[i][1];
}

draw(graph(theta, omega), blue);
xaxis("$\theta$", BottomTop, LeftTicks);
yaxis("$\omega$", LeftRight, RightTicks);

// rk4.asy
// Generic RK4 integrator for first-order ODE systems y' = f(t, y)

// The derivative function type: takes t and state vector, returns dy/dt
typedef real[] derivsfunc(real t, real[] y);

// Single RK4 step
real[] rk4step(derivsfunc deriv, real t, real[] y, real dt) {

  	int n = y.length;
  	real[] k1 = deriv(t, y);

	real[] y2 = new real[n];
	for (int i = 0; i < n; ++i) {
		y2[i] = y[i] + dt/2*k1[i];
	}
	real[] k2 = deriv(t+dt/2, y2);
	
	real[] y3 = new real[n];
	for (int i = 0; i < n; ++i) {
		y3[i] = y[i] + dt/2*k2[i];
	}
	real[] k3 = deriv(t+dt/2, y3);

	real[] y4 = new real[n];
	for (int i = 0; i < n; ++i) {
		y4[i] = y[i] + dt*k3[i];
	}
	real[] k4 = deriv(t+dt, y4);

	real[] ynext = new real[n];
	for (int i = 0; i < n; ++i) {
		ynext[i] = y[i] + dt/6*(k1[i] + 2*k2[i] + 2*k3[i] + k4[i]);
	}
	return ynext;
}

// Full integration, returns array of state vectors over time
real[][] rk4solve(derivsfunc deriv, real ti, real[] yi, real tf, real dt) {
	int N = floor((tf - ti) / dt) + 1;
	real[][] Y = new real[N+1][];
	Y[0] = yi;
	real t = ti;
	for (int i = 1; i <= N; ++i) {
		Y[i] = rk4step(deriv, t, Y[i-1], dt);
		t += dt;
	}
	return Y;
}
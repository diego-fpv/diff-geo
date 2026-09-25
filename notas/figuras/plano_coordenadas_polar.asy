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
size(5cm);

pen[] gridline_pens = {rgb("#adadad") + 0.5pt, rgb("#ee8383") + 0.5pt};
pen[] axes_pens = {rgb("#000000") + 1pt, rgb("#9e1818") + 1pt};
pair ori = (0, 0);

// points 
int[] rs = {1, 2};
real[] thetas = {pi/6, 2*pi/3};
pair[] ps = {};
// cartesian vectors
pair[] eCs = {(1, 0), (0, 1)};
// polar vectors
pair[][] ePs = {};

for (int i=0; i<rs.length; ++i){   
    // points
    ps.push((rs[i]*cos(thetas[i]), rs[i]*sin(thetas[i])));
    
    // polar vectors
    pair[] row = {};
    for (int j=0; j<2; ++j){
        row.push((cos(thetas[i]), sin(thetas[i])));
        row.push(rs[i]*(-sin(thetas[i]), cos(thetas[i])));
    }
    ePs.push(row);
}

for (int i=0; i<rs.length; ++i){

    // cartesian gridlines
    int n = 4;
    for (int j=-n; j<=n; ++j){
        draw((-n*eCs[0]+j*eCs[1])--(n*eCs[0]+j*eCs[1]), gridline_pens[0]);
        draw((-n*eCs[1]+j*eCs[0])--(n*eCs[1]+j*eCs[0]), gridline_pens[0]);
    }
    
    // polar gridlines
    int n = 5;
    for (int j=0; j<=n; ++j){
        draw(circle(ori, j), gridline_pens[1]);
        pair aux = n*(cos(pi/6*j), sin(pi/6*j));
        draw((-aux)--aux, gridline_pens[1]);
    }
}
for (int i=0; i<rs.length; ++i){
    // cartesian vector draw
    draw(ps[i]--ps[i]+eCs[0], axes_pens[0], Arrow(5bp));
    draw(ps[i]--ps[i]+eCs[1], axes_pens[0], Arrow(5bp));
    // polar vector draw
    draw(ps[i]--ps[i]+ePs[i][0], axes_pens[1], Arrow(5bp));
    draw(ps[i]--ps[i]+ePs[i][1], axes_pens[1], Arrow(5bp));
}

// labels
label("$\mathbf{e}_{1}$", ps[0]+eCs[0], S);
label("$\mathbf{e}_{2}$", ps[0]+eCs[1], E);
label("$\mathbf{e}_{1'}$", ps[0]+ePs[0][0], E);
label("$\mathbf{e}_{2'}$", ps[0]+ePs[0][1], SW);
label("$\mathbf{e}_{1}$", ps[1]+eCs[0], N);
label("$\mathbf{e}_{2}$", ps[1]+eCs[1], E);
label("$\mathbf{e}_{1'}$", ps[1]+ePs[1][0], W);
label("$\mathbf{e}_{2'}$", ps[1]+ePs[1][1], SE);

// clip to smaller frame
path frame = box((-3.1, -3.1), (3.1, 3.1));
clip(currentpicture, frame);

// // pen surface_pen = rgb("#ffffff") + opacity(0.4);
// // pen vector_pen = red + 2pt;
// // pen plane_pen = rgb("#eb5555") + opacity(0.3);
// // pen outline_pen = rgb("#a01a1a") + opacity(0.8);
// // light Light = light(diffuse=gray(0.1), (1,1,1));

// // coordinate lines
// // for (int i = 1; i <= 6; ++i) {
// //     real theta = i*pi/6;
// //     real z = cos(theta);
// //     real r = sin(theta);
// //     path3 lat = circle(c=(0, 0, z), r=r, normal=Z);
// //     draw(lat, gridline_pen); 
// //     triple normal_vec = (cos(theta), sin(theta), 0);
// //     path3 lat = circle(c=(0,0,0), r=1, normal=normal_vec);
// //     draw(lat, gridline_pen); 
// // }

// // // particle
// // string[] point_names = {"$P$", "$P'$", "$P''$"};
// // real[] phi_p = {pi/3, 0, 4pi/3};
// // real[] theta_p = {pi/3, pi/2, pi/3};
// // real R = 0.05; // radius
// // // trajectory parameters
// // real[][][] vs = {{{0.5, -1}, {0.5, 1}},
// //                  {{0.4, -1.2}, {0.8, 0.7}},
// //                  {{0.3, -0.8}, {0.8, 0.3}}};
// // real[][][] as = {{{0.2, -2.5}, {0.0, 2.0}},
// //                  {{0.1, -1.9}, {0.0, 1.8}},
// //                  {{0.1, -1.7}, {1.9, 0.5}}};

// // for (int j = 0; j < phi_p.length; ++j) {

// //     triple rp = (sin(theta_p[j])*cos(phi_p[j]), sin(theta_p[j])*sin(phi_p[j]), cos(theta_p[j])); // position
// //     draw(shift(rp)*scale3(R)*unitsphere);
    
// //     // basis vectors
// //     triple n = 0.3*unit(rp);
// //     triple u_phi = 0.3*unit(cross(Z, n)); 
// //     triple u_theta = 0.3*unit(cross(u_phi, n));

// //     // draw trajectories and tangent vectors
// //     for (int i = 0; i < vs[j].length; ++i) {
// //         triple traj(real t) {
// //             real theta_t = vs[j][i][0]*t + as[j][i][0]/2*t^2;
// //             real phi_t = vs[j][i][1]*t + as[j][i][1]/2*t^2;
// //             return (cos(phi_t+phi_p[j])*sin(theta_t+theta_p[j]), sin(phi_t+phi_p[j])*sin(theta_t+theta_p[j]), cos(theta_t+theta_p[j])); 
// //         }
// //         path3 trajectory = graph(traj, -0.4, 0.4, n=100);
// //         draw(tube(trajectory, scale(0.05/3)*unitcircle), blue + linewidth(1bp) + opacity(0.3));

// //         triple tangent_vec = 0.3*unit(vs[j][i][0]*u_theta + vs[j][i][1]*u_phi);
// //         draw(rp--rp+tangent_vec, arrow=Arrow3(size=7bp), vector_pen);
// //     };
    
// //     draw(rp--rp+u_theta, arrow=Arrow3(size=6bp), axes_pen);
// //     label("$\mathbf{e}_1$", rp+u_theta, S, fontsize(8));
// //     draw(rp--rp+u_phi, arrow=Arrow3(size=6bp), axes_pen);
// //     label("$\mathbf{e}_2$", rp+u_phi, E, fontsize(8));
// //     label(point_names[j], rp, N);
    
// //     // tangent plane
// //     real s = 1.5;
// //     path3 planeOutline = rp-s*u_phi-s*u_theta -- rp+s*u_phi-s*u_theta -- rp+s*u_phi+s*u_theta -- rp-s*u_phi+s*u_theta -- cycle;
// //     draw(surface(planeOutline), plane_pen);
// //     draw(planeOutline, outline_pen);
// // }

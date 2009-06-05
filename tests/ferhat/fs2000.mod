// This file replicates the estimation of the CIA model from
// Frank Schorfheide (2000) "Loss function-based evaluation of DSGE models"
// Journal of  Applied Econometrics, 15, 645-670.
// the data are the ones provided on Schorfheide's web site with the programs.
// http://www.econ.upenn.edu/~schorf/programs/dsgesel.ZIP
// You need to have fsdat.m in the same directory as this file.
// This file replicates:
// -the posterior mode as computed by Frank's Gauss programs
// -the parameter mean posterior estimates reported in the paper
// -the model probability (harmonic mean) reported in the paper
// This file was tested with dyn_mat_test_0218.zip
// the smooth shocks are probably stil buggy
//
// The equations are taken from J. Nason and T. Cogley (1994)
// "Testing the implications of long-run neutrality for monetary business
// cycle models" Journal of Applied Econometrics, 9, S37-S70.
// Note that there is an initial minus sign missing in equation (A1), p. S63.
//
// Michel Juillard, February 2004

var m P c e W R k d n l gy_obs gp_obs y dA vv ww;
varexo e_a e_m;

parameters alp bet gam mst rho psi del;

alp = 0.33;
bet = 0.99;
gam = 0.003;
mst = 1.011;
rho = 0.7;
psi = 0.787;
del = 0.02;
toto = [2  3];

//model(sparse_dll,cutoff=1e-17);
model(sparse, cutoff=0);
//model;
/*0*/  exp(gam+e_a) = dA ;
/*1*/  log(m) = (1-rho)*log(mst) + rho*log(m(-1))+e_m;
/*2*/  -P/(c(+1)*P(+1)*m)+bet*P(+1)*(alp*exp(-alp*(gam+log(e(+1))))*k^(alp-1)*n(+1)^(1-alp)+(1-del)*exp(-(gam+log(e(+1)))))/(c(+2)*P(+2)*m(+1))=0;
/*3*/  l/n = W;
/*4*/  -(psi/(1-psi))*(c*P/(1-n))+l/n = 0;
/*5*/  R = P*(1-alp)*exp(-alp*(gam+e_a))*k(-1)^alp*n^(-alp)/W;
/*6*/  1/(c*P)-bet*P*(1-alp)*exp(-alp*(gam+e_a))*k(-1)^alp*n^(1-alp)/(m*l*c(+1)*P(+1)) = 0;
/*7*/  c+k = exp(-alp*(gam+e_a))*k(-1)^alp*n^(1-alp)+(1-del)*exp(-(gam+e_a))*k(-1);
/*8*/  P*c = m; 
/*9*/  m-1+d = l;
/*10*/ e = exp(e_a);
/*11*/ k(-1)^alp*n^(1-alp)*exp(-alp*(gam+e_a)) = y ;
/*12*/ gy_obs = dA*y/y(-1);
/*13*/ gp_obs = (P/P(-1))*m(-1)/dA;
/*14*/ vv = 0.2*ww+0.5*vv(-1)+1+c(-1)+e_a;
/*15*/ ww = 0.1*vv+0.5*ww(-1)+2;
/* A lt=
 0.5*vv-0.2*ww = 1
-0.1*vv+0.5*ww = 2
[ 0.5 -0.2][vv]   [1]
                =
[-0.1  0.5][ww]   [2]
det = 0.25-0.02 = 0.23
[vv]           [0.5  0.2] [1]           [0.9]   [3.91304]
     = 1/0.23*                = 1/0.23*       =
[ww]           [0.1  0.5] [2]           [1.1]   [4.7826]
*/
end;

initval;
k = 6;
m = mst;
P = 2.25;
c = 0.45;
e = 1;
W = 4;
R = 1.02;
d = 0.85;
n = 0.19;
l = 0.86;
y = 0.6;
gy_obs = exp(gam);
gp_obs = exp(-gam);
dA = exp(gam);
e_a=0;
e_m=0;
vv = 0;
ww = 0;
end;

shocks;
var e_a; stderr 0.014;
var e_m; stderr 0.005;
end;


options_.solve_tolf=1e-10;
options_.maxit_=100;
steady;
model_info;
//check;
shocks;
var e_a;
periods 1;
values 0.16;
end;


disp(toto(1,2));

simul(periods=200, method=lu);
//stoch_simul(periods=200,order=1);

rplot y;
rplot k;
rplot c;
/*estimated_params;
alp, beta_pdf, 0.356, 0.02;
bet, beta_pdf, 0.993, 0.002;
gam, normal_pdf, 0.0085, 0.003;
mst, normal_pdf, 1.0002, 0.007;
rho, beta_pdf, 0.129, 0.223;
psi, beta_pdf, 0.65, 0.05;
del, beta_pdf, 0.01, 0.005;
stderr e_a, inv_gamma_pdf, 0.035449, inf;
stderr e_m, inv_gamma_pdf, 0.008862, inf;
end;

varobs gp_obs gy_obs;

estimation(datafile=fsdat,nobs=192,loglinear,mh_replic=2000,mh_nblocks=5,mh_jscale=0.8);
*/

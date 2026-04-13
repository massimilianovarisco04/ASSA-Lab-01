clear;
close all;
clc;

%% Scelta qualitativa del metodo di integrazione
% Parametri e condizioni iniziali
invpendulumP = invpendulum_parameters ();
x_0 = [0; 0; deg2rad(1); 0];
t_0 = 0;
t_f = 100;

% Integrazione - soluzione di riferimento
tic;
ODE_obj = ode; 
% ode da matlab 2023 permette di interagire in questo modo con la funzione
% ODE, in modo da rendere tutto anche più leggibile per chi legge il codice
% senza averlo fatto. si potrebbe anche fare l'approccio più diretto
% chiamando direttamente ode45 per esempio, ma questo è meglio. 
ODE_obj.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input, invpendulumP);
ODE_obj.InitialValue = x_0;
ODE_obj.Solver = 'ode89';
ODE_obj.AbsoluteTolerance = 1e-12;
ODE_obj.RelativeTolerance = 1e-9;
ODEResults_obj = solve(ODE_obj, t_0, t_f);
tt = ODEResults_obj.Time'; 
xx = ODEResults_obj.Solution'; 
xcart_rif = xx(:,1);
theta_rif= xx(:,3);
t_es_rif = toc;

% Ode45
tic;
ODE_obj1 = ode;
ODE_obj1.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input, invpendulumP);
ODE_obj1.InitialValue = x_0;
ODE_obj1.Solver = 'ode45';
ODEResults_obj = solve(ODE_obj1, t_0, t_f);
t45 = ODEResults_obj.Time';
x45 = ODEResults_obj.Solution'; 
xcart45 = x45(:,1);
theta45= x45(:,3);
t_es_45 = toc;

% Ode23
tic;
ODE_obj2 = ode;
ODE_obj2.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input, invpendulumP);
ODE_obj2.InitialValue = x_0;
ODE_obj2.Solver = 'ode23';
ODEResults_obj = solve(ODE_obj2, t_0, t_f);
t23 = ODEResults_obj.Time';
x23 = ODEResults_obj.Solution'; 
xcart23 = x23(:,1);
theta23 = x23(:,3);
t_es_23 = toc;

% Ode78
tic;
ODE_obj3 = ode;
ODE_obj3.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input, invpendulumP);
ODE_obj3.InitialValue = x_0;
ODE_obj3.Solver = 'ode78';
ODEResults_obj = solve(ODE_obj3, t_0, t_f);
t78 = ODEResults_obj.Time';
x78 = ODEResults_obj.Solution'; 
xcart78 = x78(:,1);
theta78 = x78(:,3);
t_es_78 = toc;

% Grafico - confronto tra riferimento e ode45
figure(1)
subplot(3, 2, 1)
plot(tt, xcart_rif, 'k', 'LineWidth', 2);
hold on;
plot(t45, xcart45, 'r', 'LineWidth',2);
xlabel('Time [s]');
ylabel('Position [m]');
legend('Benchmark solution', 'Ode45', 'Location','southeast')
title ('Cart position - rif vs ode45');

subplot(3,2,2)
plot(tt, rad2deg(theta_rif), 'k', 'LineWidth',2);
hold on;
plot(t45, rad2deg(theta45), 'r', 'LineWidth', 2);
xlim([0, 5]);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
legend('Benchmark solution', 'Ode45', 'Location','southeast');
title ('Pendulum angle - rif vs ode45');

% Grafico - confronto tra riferimento e ode23
subplot(3,2,3)
plot(tt, xcart_rif, 'k', 'LineWidth', 2);
hold on;
plot(t23, xcart23, 'r', 'LineWidth',2);
xlabel(['Time [s]']);
ylabel('Position [m]');
legend ('Benchmark solution', 'Ode23', 'Location','southeast');
title ('Cart position - rif vs ode23');

subplot(3,2,4)
plot(tt, rad2deg(theta_rif), 'k', 'LineWidth',2);
hold on;
plot(t23, rad2deg(theta23), 'r', 'LineWidth', 2);
xlim([0, 5]);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
legend('Benchmark solution', 'Ode23', 'Location','southeast');
title ('Pendulum angle - rif vs ode23');

% Grafico - confronto tra riferimento e ode78
subplot(3,2,5)
plot(tt, xcart_rif, 'k', 'LineWidth', 2);
hold on;
plot(t78, xcart78, 'r', 'LineWidth',2);
xlabel('Time [s]');
ylabel('Cart position [m]');
legend('Benchmark solution', 'Ode78', 'Location','southeast');
title ('Cart position - rif vs ode78');

subplot(3,2,6)
plot(tt, rad2deg(theta_rif), 'k', 'LineWidth',2);
hold on;
plot(t78, rad2deg(theta78), 'r', 'LineWidth', 2);
xlim([0, 5]);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
legend('Benchmark solution','Ode78', 'Location','southeast');
title ('Pendulum angle - rif vs ode78');

%% Scelta quantitativa del metodo di integrazione 

% Calcolo errori assoluti
xcart_rif45 = interp1(tt, xcart_rif, t45);
xcart_rif23 = interp1(tt, xcart_rif, t23);
xcart_rif78 = interp1(tt, xcart_rif, t78);
theta_rif45 = interp1(tt, theta_rif, t45);
theta_rif23 = interp1(tt, theta_rif, t23);
theta_rif78 = interp1(tt, theta_rif, t78);

err_45 = abs(xcart_rif45 - xcart45);
err_23 = abs(xcart_rif23 - xcart23);
err_78 = abs(xcart_rif78 - xcart78);

errtheta_45 = abs(theta_rif45 - theta45);
errtheta_23 = abs(theta_rif23 - theta23);
errtheta_78 = abs(theta_rif78 - theta78);

figure(2)
subplot(3, 1, 1)
plot(t45, err_45, 'LineWidth',2);
hold on;
plot(t23,err_23, 'LineWidth',2);
plot(t78, err_78, 'LineWidth',2);
legend ('err45', 'err23', 'err78');
xlabel('Time [s]');
ylabel('Absolute error');
title ('absolute errors - positions');

subplot(3,1,2)
plot(t45, errtheta_45, 'LineWidth',2);
hold on;
plot(t23, errtheta_23, 'LineWidth',2);
plot(t78, errtheta_78, 'LineWidth', 2);
xlim([0, 10]);
xlabel('Time [s]');
ylabel('Absolute error');
legend ('err45', 'err23', 'err78');
title ('absolute errors - angles');

% Calcolo tempi di esecuzione
t_es = [t_es_rif, t_es_45, t_es_23, t_es_78];
labels = {'Benchmark solution', 'Ode45', 'Ode23', 'Ode78'};
subplot(3,1,3);
bar(t_es);
set(gca, 'XTickLabel', labels);
ylabel('Time of execution');
xlabel('Solver');
title('Times of execution');

%% Soluzione con Ode78
figure(3)
subplot(2,1,1);
plot(t78, xcart78, 'LineWidth',2);
xlabel('Time [s]');
ylabel('Position [m]');
title ('Cart postion x(t)');

subplot(2,1,2);
plot(t78, theta78, 'LineWidth',2);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
title('Pendulum angle \theta(t)');

%% Sensibilità alle tolleranze
% Integrazione con tolleranze di riferimento (RelTol = 1e-3, AbsTol=1e-6)
% Integrazione con valori di tolleranza più alti (RelTol=1e-6,AbsTol=1e-9)
tic;
ODE_obj4 = ode;
ODE_obj4.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input, invpendulumP);
ODE_obj4.InitialValue = x_0;
ODE_obj4.Solver = 'ode78';
ODE_obj4.AbsoluteTolerance = 1e-9;
ODE_obj4.RelativeTolerance = 1e-6;
ODEResults_obj = solve(ODE_obj4, t_0, t_f);
t78_1 = ODEResults_obj.Time';
x78_1 = ODEResults_obj.Solution'; 
xcart78_1 = x78_1(:,1);
theta78_1 = x78_1(:,3);
t_es_78_1 = toc;

% Integrazione con valori di tolleranza più bassi (RelTol=1e-2,AbsTol=1e-3);
tic;
ODE_obj5 = ode;
ODE_obj5.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input, invpendulumP);
ODE_obj5.InitialValue = x_0;
ODE_obj5.Solver = 'ode78';
ODE_obj5.AbsoluteTolerance = 1e-3;
ODE_obj5.RelativeTolerance = 1e-2;
ODEResults_obj = solve(ODE_obj5, t_0, t_f);
t78_2 = ODEResults_obj.Time';
x78_2 = ODEResults_obj.Solution'; 
xcart78_2 = x78_2(:,1);
theta78_2 = x78_2(:,3);
t_es_78_2 = toc;

% Confronto tra risultati
figure (4)
subplot(2,1,1)
plot(t78, xcart78, 'k', 'LineWidth',2);
hold on;
plot(t78_1, xcart78_1, 'r', 'LineWidth',2);
plot(t78_2, xcart78_2, 'b', 'LineWidth',2);
xlabel('Time [s]');
ylabel('Cart position [m]');
legend('Standard tolerances', 'Higher tolerances', 'Lower tolerances');
title('Tolerance comparison for cart position');

subplot(2,1,2);
plot(t78, rad2deg(theta78), 'k', 'LineWidth',2);
hold on;
plot(t78_1, rad2deg(theta78_1), 'r', 'LineWidth',2);
plot(t78_2, rad2deg(theta78_2), 'b', 'LineWidth',2);
xlabel('Time[s]');
ylabel('Pendulum angle [°]');
legend('Standard tolerances', 'Higher tolerances', 'Lower tolerances');
title('Tolerance comparison for pendulum angle');

% Tempi di esecuzione con diverse tolleranze
figure(5)
t_es = [t_es_78, t_es_78_1, t_es_78_2];
labels = {'Standard tolerances', 'Higher tolerances', 'Lower tolerances'};
bar(t_es);
set(gca, 'XTickLabel', labels);
title('Times of execution');

%% Soluzione con disturbo
t_f_d = 50;
x_0_d = [0; 0; 0; 0];
ODE_objd = ode;
ODE_objd.ODEFcn = @(t,x) invpendulumP_fd(t,x,@invpendulum_input_d, invpendulumP);
ODE_objd.InitialValue = x_0_d;
ODE_objd.Solver = 'ode78';
ODEResults_obj = solve(ODE_objd, t_0, t_f_d);
t_d = ODEResults_obj.Time';
x_d = ODEResults_obj.Solution'; 
xcart_d = x_d(:,1);
theta_d = x_d(:,3);

% Grafico del disturbo
u_c = zeros(length(t_d), 1);
u_d = zeros(length(t_d), 1);
for i = 1 : length(t_d)
    [u_c(i), u_d(i)] = invpendulum_input_d(t_d(i), invpendulumP);
end
figure (6)
plot(t_d, u_d, 'LineWidth',2);
grid on;
xlabel('Time [s]');
ylabel('Disturbance [N]');
title('Disturbance');

% Grafici della soluzione
figure(7)
subplot(2,1,1)
plot(t_d, xcart_d, 'LineWidth',2);
xlabel('Time [s]');
ylabel('Cart postion [m]');
title('Cart position with disturbance');

subplot(2,1,2)
plot(t_d, rad2deg(theta_d), 'LineWidth',2);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
title('Pendulum angle with disturbance');

%% Definizione funzioni
function invpendulumP = invpendulum_parameters()

M = 0.57;
rho = 0.36;
l = 0.64;
g = 9.81;
c = 0.1;
b = 0.005;
r = 0.02;
kt = 0.05;
d_0 = 0.3;
I_0 = rho*l;
I_1 = (rho/2)*(l^2);
I_2 = (rho/3)*(l^3);
alpha_0 = d_0*l;
alpha_1 = (d_0/2)*(l^2);
T1 = 1;
T2 = 3;

invpendulumP.M = M;
invpendulumP.rho = rho;
invpendulumP.l = l;
invpendulumP.g = g;
invpendulumP.c = c;
invpendulumP.b = b;
invpendulumP.r = r;
invpendulumP.kt = kt;
invpendulumP.d_0 = d_0;
invpendulumP.I_0 = I_0;
invpendulumP.I_1 = I_1;
invpendulumP.I_2 = I_2;
invpendulumP.alpha_0 = alpha_0;
invpendulumP.alpha_1 = alpha_1;
invpendulumP.T1 = T1;
invpendulumP.T2 = T2;
end

function [u_c, u_d] = invpendulum_input(t, invpendulumP)

kt = invpendulumP.kt;
r = invpendulumP.r;
i = 0;
d = 0;
u_c = (kt/r)*i;
u_d = d;
end

function [u_c, u_d] = invpendulum_input_d(t, invpendulumP)

kt = invpendulumP.kt;
r = invpendulumP.r;
T1 = invpendulumP.T1;
T2 = invpendulumP.T2;
i = 0; %è corrente, in anello aperto è sempre nulla.
if t<T1
    d1 = 0;
elseif t>T2
    d1 = 0;
else
    d1 = 1;
end
u_c = (kt/r)*i; 
u_d = d1;
end

function xdot = invpendulumP_f (t,x, input_fun, invpendulumP) %funzione per avere il sistema scritto in spazio di stato

I_1 = invpendulumP.I_1;
I_2 = invpendulumP.I_2;
I_0 = invpendulumP.I_0;
b = invpendulumP.b;
g = invpendulumP.g;
alpha_1 = invpendulumP.alpha_1;
c = invpendulumP.c;
alpha_0 = invpendulumP.alpha_0;
M = invpendulumP.M;
[u_c, u_d] = input_fun(t, invpendulumP);

x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);
u1 = u_c;
u2 = u_d;

xdot_1 = x2;
xdot_2 = (-(I_1/I_2)*b*x4*cos(x3)+(I_1^2/I_2)*g*sin(x3)*cos(x3)+(I_1/I_2)*u2*alpha_1*(cos(x3)^2)-I_1*(x4^2)*sin(x3)-c*x2+u1-u2*alpha_0)/(I_0+M-(I_1^2/I_2)*(cos(x3)^2));
xdot_3 = x4;
xdot_4 = (I_1*xdot_2*cos(x3)-b*x4+I_1*g*sin(x3)+u2*alpha_1*cos(x3))/I_2;

xdot = [xdot_1, xdot_2, xdot_3, xdot_4]';
end

function xdot_d = invpendulumP_fd (t,x, input_fun, invpendulumP) %sistema con disturbo in spazio di stato

I_1 = invpendulumP.I_1;
I_2 = invpendulumP.I_2;
I_0 = invpendulumP.I_0;
b = invpendulumP.b;
g = invpendulumP.g;
alpha_1 = invpendulumP.alpha_1;
c = invpendulumP.c;
alpha_0 = invpendulumP.alpha_0;
M = invpendulumP.M;
[u_c, u_d] = input_fun(t, invpendulumP);

x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);
u1 = u_c;
u2 = u_d;

xdot_1 = x2;
xdot_2 = (-(I_1/I_2)*b*x4*cos(x3)+((I_1^2)/I_2)*g*sin(x3)*cos(x3)+(I_1/I_2)*u2*alpha_1*(cos(x3)^2)-I_1*(x4^2)*sin(x3)-c*x2+u1-u2*alpha_0)/(I_0+M-(I_1^2/I_2)*(cos(x3)^2));
xdot_3 = x4;
xdot_4 = (I_1*xdot_2*cos(x3)-b*x4+I_1*g*sin(x3)+u2*alpha_1*cos(x3))/I_2;

xdot_d = [xdot_1, xdot_2, xdot_3, xdot_4]';
end


%% modello linearizzato 


I_1 = invpendulumP.I_1;
I_2 = invpendulumP.I_2;
I_0 = invpendulumP.I_0;
b = invpendulumP.b;
g = invpendulumP.g;
alpha_1 = invpendulumP.alpha_1;
c = invpendulumP.c;
alpha_0 = invpendulumP.alpha_0;
M = invpendulumP.M;
kt = invpendulumP.kt;
r = invpendulumP.r;
A = [0 1 0 0;
    0 -c/(I_0+M-(I_1^2)/I_2) ((I_1^2*g)/I_2)/(I_0+M-(I_1^2)/I_2) (-I_1*b/I_2)/(I_0+M-(I_1^2)/I_2);
    0 0 0 1;
    0 -c*I_1/(I_2*(I_0+M-(I_1^2)/I_2)) ((I_1^3*g)/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))+(I_1*g)/I_2 (-I_1^2*b/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))-b/I_2];
B = [0,0;
    kt/(r*(I_0+M-(I_1^2)/I_2)),((I_1*alpha_1)/I_2-alpha_0)/(I_0+M-(I_1^2)/I_2);
    0,0;
    I_1*kt/(r*I_2*(I_0+M-(I_1^2)/I_2)),((I_1^2*alpha_1)/I_2-I_1*alpha_0)/(I_2*(I_0+M-(I_1^2)/I_2))+alpha_1/I_2];

C = [1 0 0 0;
    0 0 1 0];
D = [0,0;0,0];
x_0 = [0 0 deg2rad(1) 0]';

t_f = 50;

invpendulumP.sys = ss(A,B,C,D);
t = 0:0.01:t_f; % Vettore tempo con passo fisso

% Definiamo i due ingressi
f = zeros(size(t));           % f(t) è sempre zero
d = (t >= 1) & (t <= 3);      % d(t) vale 1 tra 1 e 3 secondi, altrimenti 0

% Creiamo la matrice degli ingressi u (ogni colonna è un ingresso)
% u deve avere tante colonne quanti sono gli ingressi del sistema
u = [f; d]';

[yy, tt, xx] = lsim(invpendulumP.sys, u, t, x_0);

figure(8)
subplot(2,1,1)
plot(tt,yy(:,1));
xlabel('t(s)');
ylabel('x (m)');
grid on;
hold on;
subplot(2,1,2)
plot(tt,rad2deg(yy(:,2)));
xlabel('t(s)');
ylabel('\theta (deg)');

CIAO

clear;
close all;
clc;

%% Scelta qualitativa del metodo di integrazione (2.1)
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
figure('Name', '2.1 - Ode vs Benchmark Solution')
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
xlabel('Time [s]');
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

%% Scelta quantitativa del metodo di integrazione (2.1)

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

figure('Name', '2.1 - Absolute Err and ET')
subplot(3, 1, 1)
plot(t45, err_45, 'LineWidth',2);
hold on;
plot(t23,err_23, 'LineWidth',2);
plot(t78, err_78, 'LineWidth',2);
legend ('err45', 'err23', 'err78');
xlabel('Time [s]');
ylabel('Absolute error');
title ('absolute errors - Cart position');

subplot(3,1,2)
plot(t45, errtheta_45, 'LineWidth',2);
hold on;
plot(t23, errtheta_23, 'LineWidth',2);
plot(t78, errtheta_78, 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Absolute error');
legend ('err45', 'err23', 'err78');
title ('absolute errors - pendulum angle');

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
figure('Name', '2.1 - Ode78 Solution')
subplot(2,1,1);
plot(t78, xcart78, 'LineWidth',2);
xlabel('Time [s]');
ylabel('Position [m]');
title ('Cart postion x(t)');

subplot(2,1,2);
plot(t78, rad2deg(theta78), 'LineWidth',2);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
title('Pendulum angle \theta(t)');

%% Sensibilità alle tolleranze (2.1)
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
figure ('Name','2.1 - Tolerance sensitivity')
subplot(2,1,1)
plot(t78, xcart78, 'k', 'LineWidth',2);
hold on;
plot(t78_1, xcart78_1, 'r', 'LineWidth',2);
plot(t78_2, xcart78_2, 'b', 'LineWidth',2);
xlabel('Time [s]');
ylabel('Cart position [m]');
legend('Standard tolerances', 'Tighter tolerances', 'Looser tolerances');
title('Tolerance comparison for cart position');

subplot(2,1,2);
plot(t78, rad2deg(theta78), 'k', 'LineWidth',2);
hold on;
plot(t78_1, rad2deg(theta78_1), 'r', 'LineWidth',2);
plot(t78_2, rad2deg(theta78_2), 'b', 'LineWidth',2);
xlabel('Time[s]');
ylabel('Pendulum angle [°]');
legend('Standard tolerances', 'Tighter tolerances', 'Looser tolerances');
title('Tolerance comparison for pendulum angle');

% Tempi di esecuzione con diverse tolleranze
figure('Name','2.1 - ET with Different Tol')
t_es = [t_es_78, t_es_78_1, t_es_78_2];
labels = {'Standard tolerances', 'Tighter tolerances', 'Looser tolerances'};
bar(t_es);
set(gca, 'XTickLabel', labels);
title('Times of execution');

%% DISTURBO - Scelta qualitativa del metodo di integrazione (2.2)
% Parametri e condizioni iniziali
invpendulumP = invpendulum_parameters ();
x_0_d = [0; 0; 0; 0];
t_0_d = 0;
t_f_d = 50;

% DISTURBO Integrazione - soluzione di riferimento
tic;
ODE_obj = ode;
ODE_obj.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input_d, invpendulumP);
ODE_obj.InitialValue = x_0_d;
ODE_obj.Solver = 'ode89';
ODE_obj.AbsoluteTolerance = 1e-12;
ODE_obj.RelativeTolerance = 1e-9;
ODEResults_obj = solve(ODE_obj, t_0_d, t_f_d);
tt_d = ODEResults_obj.Time'; 
xx_d = ODEResults_obj.Solution'; 
xcart_rif_d = xx_d(:,1);
theta_rif_d= xx_d(:,3);
t_es_rif_d = toc;

% Ode45
tic;
ODE_obj1 = ode;
ODE_obj1.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input_d, invpendulumP);
ODE_obj1.InitialValue = x_0_d;
ODE_obj1.Solver = 'ode45';
ODEResults_obj = solve(ODE_obj1, t_0_d, t_f_d);
t45_d = ODEResults_obj.Time';
x45_d = ODEResults_obj.Solution'; 
xcart45_d = x45_d(:,1);
theta45_d= x45_d(:,3);
t_es_45_d = toc;

% Ode23
tic;
ODE_obj2 = ode;
ODE_obj2.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input_d, invpendulumP);
ODE_obj2.InitialValue = x_0_d;
ODE_obj2.Solver = 'ode23';
ODEResults_obj = solve(ODE_obj2, t_0_d, t_f_d);
t23_d = ODEResults_obj.Time';
x23_d = ODEResults_obj.Solution'; 
xcart23_d = x23_d(:,1);
theta23_d = x23_d(:,3);
t_es_23_d = toc;

% Ode78
tic;
ODE_obj3 = ode;
ODE_obj3.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input_d, invpendulumP);
ODE_obj3.InitialValue = x_0_d;
ODE_obj3.Solver = 'ode78';
ODEResults_obj = solve(ODE_obj3, t_0_d, t_f_d);
t78_d = ODEResults_obj.Time';
x78_d = ODEResults_obj.Solution'; 
xcart78_d = x78_d(:,1);
theta78_d = x78_d(:,3);
t_es_78_d = toc;

% DISTURBO Grafico - confronto tra riferimento e ode45
figure('Name', '2.2 - Ode vs Benchmark with Disturb')
subplot(3, 2, 1)
plot(tt_d, xcart_rif_d, 'k', 'LineWidth', 2);
hold on;
plot(t45_d, xcart45_d, 'r', 'LineWidth',2);
xlabel('Time [s]');
ylabel('Position [m]');
legend('Benchmark solution', 'Ode45', 'Location','southeast')
title ('Cart position with disturbance - rif vs ode45');

subplot(3,2,2)
plot(tt_d, rad2deg(theta_rif_d), 'k', 'LineWidth',2);
hold on;
plot(t45_d, rad2deg(theta45_d), 'r', 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
legend('Benchmark solution', 'Ode45', 'Location','southeast');
title ('Pendulum angle with disturbance - rif vs ode45');

% DISTURBO Grafico - confronto tra riferimento e ode23
subplot(3,2,3)
plot(tt_d, xcart_rif_d, 'k', 'LineWidth', 2);
hold on;
plot(t23_d, xcart23_d, 'r', 'LineWidth',2);
xlabel('Time [s]');
ylabel('Position [m]');
legend ('Benchmark solution', 'Ode23', 'Location','southeast');
title ('Cart position with disturbance - rif vs ode23');

subplot(3,2,4)
plot(tt_d, rad2deg(theta_rif_d), 'k', 'LineWidth',2);
hold on;
plot(t23_d, rad2deg(theta23_d), 'r', 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
legend('Benchmark solution', 'Ode23', 'Location','southeast');
title ('Pendulum angle with disturbance - rif vs ode23');

% DISTURBO Grafico - confronto tra riferimento e ode78
subplot(3,2,5)
plot(tt_d, xcart_rif_d, 'k', 'LineWidth', 2);
hold on;
plot(t78_d, xcart78_d, 'r', 'LineWidth',2);
xlabel('Time [s]');
ylabel('Cart position [m]');
legend('Benchmark solution', 'Ode78', 'Location','southeast');
title ('Cart position with disturbance - rif vs ode78');

subplot(3,2,6)
plot(tt_d, rad2deg(theta_rif_d), 'k', 'LineWidth',2);
hold on;
plot(t78_d, rad2deg(theta78_d), 'r', 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
legend('Benchmark solution','Ode78', 'Location','southeast');
title ('Pendulum angle with disturbance - rif vs ode78');

%% DISTURBO - Scelta quantitativa del metodo di integrazione 

% DISTURBO Calcolo errori assoluti
xcart_rif45_d = interp1(tt_d, xcart_rif_d, t45_d);
xcart_rif23_d = interp1(tt_d, xcart_rif_d, t23_d);
xcart_rif78_d = interp1(tt_d, xcart_rif_d, t78_d);
theta_rif45_d = interp1(tt_d, theta_rif_d, t45_d);
theta_rif23_d = interp1(tt_d, theta_rif_d, t23_d);
theta_rif78_d = interp1(tt_d, theta_rif_d, t78_d);

err_45_d = abs(xcart_rif45_d - xcart45_d);
err_23_d = abs(xcart_rif23_d - xcart23_d);
err_78_d = abs(xcart_rif78_d - xcart78_d);

errtheta_45_d = abs(theta_rif45_d - theta45_d);
errtheta_23_d = abs(theta_rif23_d - theta23_d);
errtheta_78_d = abs(theta_rif78_d - theta78_d);

figure('Name', 'Absolute Err and ET with Disturb')
subplot(3, 1, 1)
plot(t45_d, err_45_d, 'LineWidth',2);
hold on;
plot(t23_d,err_23_d, 'LineWidth',2);
plot(t78_d, err_78_d, 'LineWidth',2);
legend ('err45', 'err23', 'err78');
xlabel('Time [s]');
ylabel('Absolute error');
title ('absolute errors - Cart position with disturbance');

subplot(3,1,2)
plot(t45_d, errtheta_45_d, 'LineWidth',2);
hold on;
plot(t23_d, errtheta_23_d, 'LineWidth',2);
plot(t78_d, errtheta_78_d, 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Absolute error');
legend ('err45', 'err23', 'err78');
title ('absolute errors - pendulum angle with disturbance');

% Calcolo tempi di esecuzione
t_es_d = [t_es_rif_d, t_es_45_d, t_es_23_d, t_es_78_d];
labels = {'Benchmark solution', 'Ode45', 'Ode23', 'Ode78'};
subplot(3,1,3);
bar(t_es_d);
set(gca, 'XTickLabel', labels);
ylabel('Time of execution');
xlabel('Solver');
title('Times of execution');

%% DISTURBO - Soluzione con Ode23 (Migliore)
% Grafico del disturbo
u_c = zeros(length(t23_d), 1);
u_d = zeros(length(t23_d), 1);
for i = 1 : length(t23_d)
    [u_c(i), u_d(i)] = invpendulum_input_d(t23_d(i), invpendulumP);
end
figure ('Name', '2.2 - Disturb')
plot(t23_d, u_d, 'LineWidth',2);
grid on;
xlabel('Time [s]');
ylabel('Disturbance [N/m]');
title('Disturbance');

% Grafici della soluzione
figure('Name', '2.2 - Ode23 Solution with Disturb')
subplot(2,1,1);
plot(t23_d, xcart23_d, 'LineWidth',2);
xlabel('Time [s]');
ylabel('Position [m]');
title ('Cart postion with disturbance x(t)');

subplot(2,1,2);
plot(t23_d, rad2deg(theta23_d), 'LineWidth',2);
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
title('Pendulum angle with disturbance \theta(t)');

%% DISTURBO - Sensibilità alle tolleranze
% Integrazione con tolleranze di riferimento (RelTol = 1e-3, AbsTol=1e-6)
% Integrazione con valori di tolleranza più alti (RelTol=1e-6,AbsTol=1e-9)
tic;
ODE_obj4 = ode;
ODE_obj4.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input_d, invpendulumP);
ODE_obj4.InitialValue = x_0_d;
ODE_obj4.Solver = 'ode23';
ODE_obj4.AbsoluteTolerance = 1e-9;
ODE_obj4.RelativeTolerance = 1e-6;
ODEResults_obj = solve(ODE_obj4, t_0_d, t_f_d);
t23_1_d = ODEResults_obj.Time';
x23_1_d = ODEResults_obj.Solution'; 
xcart23_1_d = x23_1_d(:,1);
theta23_1_d = x23_1_d(:,3);
t_es_23_1_d = toc;

% Integrazione con valori di tolleranza più bassi (RelTol=1e-2,AbsTol=1e-3);
tic;
ODE_obj5 = ode;
ODE_obj5.ODEFcn = @(t,x) invpendulumP_f(t,x,@invpendulum_input_d, invpendulumP);
ODE_obj5.InitialValue = x_0_d;
ODE_obj5.Solver = 'ode23';
ODE_obj5.AbsoluteTolerance = 1e-3;
ODE_obj5.RelativeTolerance = 1e-2;
ODEResults_obj = solve(ODE_obj5, t_0_d, t_f_d);
t23_2_d = ODEResults_obj.Time';
x23_2_d = ODEResults_obj.Solution'; 
xcart23_2_d = x23_2_d(:,1);
theta23_2_d = x23_2_d(:,3);
t_es_23_2_d = toc;

% Confronto tra risultati
figure ('Name', 'Tolerance sensitivity with Disturb')
subplot(2,1,1)
plot(t23_d, xcart23_d, 'k', 'LineWidth',2);
hold on;
plot(t23_1_d, xcart23_1_d, 'r', 'LineWidth',2);
plot(t23_2_d, xcart23_2_d, 'b', 'LineWidth',2);
xlabel('Time [s]');
ylabel('Cart position [m]');
legend('Standard tolerances', 'Tighter tolerances', 'Looser tolerances');
title('Tolerance comparison for cart position with disturbance');

subplot(2,1,2);
plot(t23_d, rad2deg(theta23_d), 'k', 'LineWidth',2);
hold on;
plot(t23_1_d, rad2deg(theta23_1_d), 'r', 'LineWidth',2);
plot(t23_2_d, rad2deg(theta23_2_d), 'b', 'LineWidth',2);
xlabel('Time[s]');
ylabel('Pendulum angle [°]');
legend('Standard tolerances', 'Tighter tolerances', 'Looser tolerances');
title('Tolerance comparison for pendulum angle with disturbance');

% Tempi di esecuzione con diverse tolleranze
figure('Name', 'ET with different tolerances and Disturb')
t_es_d_t = [t_es_23_d, t_es_23_1_d, t_es_23_2_d];
labels = {'Standard tolerances', 'Tighter tolerances', 'Looser tolerances'};
bar(t_es_d_t);
set(gca, 'XTickLabel', labels);
title('Times of execution');

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


%% modello linearizzato (4)

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

eig_A = eig(A);
y = zeros( length(t23_d),2 );

for i = 1 : length(t23_d)

    eAt = expm(A * t23_d(i)); % expm fa l'esponenziale di una matrice
    y(i,:) = C*eAt*x_0;

end

figure('Name', '4.2 - Linear Model Solution')
subplot(2,1,1)
plot(t23_d,y(:,1));
xlabel('t(s)');
ylabel('x (m)');
grid on;
hold on;
subplot(2,1,2)
plot(t23_d,rad2deg(y(:,2)));
xlabel('t(s)');
ylabel('\theta (deg)');

%% troviamo il theta limite per avere un errore minore dell'1%
% Calcoliamo la soluzione del sistema non lineare ponendo theta = 1deg,
% come per il sistema lineare.
t_f_d = 50;
x_0_d = [0; 0; deg2rad(1); 0];
ODE_objd = ode;
ODE_objd.ODEFcn = @(t,x) invpendulumP_fd(t,x,@invpendulum_input_d, invpendulumP);
ODE_objd.InitialValue = x_0_d;
ODE_objd.Solver = 'ode78';
ODEResults_obj = solve(ODE_objd, t_0, t_f_d);
t_d = ODEResults_obj.Time';
x_d = ODEResults_obj.Solution'; 

% Calcolo la soluzione lineare con il vettore dei tempi del non lineare
y = zeros( length(t_d),2 );
for i = 1 : length(t_d)

    eAt = expm(A * t_d(i)); % expm fa l'esponenziale di una matrice
    y(i,:) = C*eAt*x_0;

end

% definizione parametri per ciclo while
theta_d = x_d(:,3);
tol = 1e-2;
err = 0;
theta_lim = 0;
j = 0;
t_lim = 0;

% ciclo while per calcolare l'errore relativo tra la soluzione lineare e
% non lineare (metto in gradi perchè ho messo la tolleranza sull'angolo in
% gradi)
while err < tol
    j = j + 1;
    y (j,2) = rad2deg(y(j,2));
    theta_d(j) = rad2deg(theta_d(j));
    err = abs (y(j,2)-theta_d(j))/theta_d(j);
    theta_lim = y(j,2);
    t_lim = t_d(j);
end

% vettore dei tempi fino a t_lim (scelgo j-1 perchè è il valore prima che 
% la soluzione superi la tolleranza) 
t_lin = zeros(1,j-1);
for ii = 1 : j-1
    t_lin(ii) = t_d(ii);
end

% plot lineare vs non lineare 
figure('Name','4.2 - Linear vs Non Linear Comparison')
plot(t_lin,y(1:1:j-1,2));
hold on 
grid on
plot (t_lin, theta_d(1:1:j-1));
legend ('Linear','Non Linear');
xlabel('t(s)');
ylabel('\theta (deg)');


%% simulinksss (3)
x_0_sim = [0,0]';

% grafico non lineare con simulink (3.1)
tic;
ex1 = sim("simulink_nonlineare_attrito_openloop.slx");
t_simulink=toc;

figure('Name', '3.1 - Simulink Solution')
subplot(2,1,1);
title('Position Cart');
plot(ex1.tout,ex1.x);
xlabel('t(s)');
ylabel('x (m)');

grid on;
subplot(2,1,2);
title('Pendulum Angle')
plot(ex1.tout,ex1.theta);
xlabel('t(s)');
ylabel('\theta (deg)');
grid on;

%confronto fra grafico non lineare in simulink e quello ottenuto con ode89
%in matlab (benchmark e ode78). Le impostazioni del solutore simulink sono
%state lasciate STANDARD per effettuare il confronto (considerazioni finali
%su latex)
figure('Name', '3.1 - Simulink Solution vs MATLAB Solution')
subplot(3,1,1)
plot(ex1.tout,ex1.x, 'LineWidth', 2);
hold on
plot(t23_d, xcart23_d, '--', 'LineWidth',2);
hold on
plot(tt_d, xcart_rif_d,'--', 'LineWidth', 2);
title('Cart Position')
xlabel('t(s)');
ylabel('x (m)');
legend('Simulink', 'Ode23', 'Benchmark (Ode89)');

subplot(3,1,2)
plot(ex1.tout,rad2deg(ex1.theta), 'LineWidth', 2);
hold on
plot(tt_d, rad2deg(theta_rif_d), '--', 'LineWidth',2);
hold on
plot(t23_d, rad2deg(theta23_d), '--', 'LineWidth', 2);
title('Pendulum Angle')
xlabel('t(s)');
ylabel('\theta (degrees)');
legend('Simulink', 'Ode23', 'Benchmark (Ode89)');

subplot(3,1,3)
plot(ex1.tout,ex1.disturb.Data, 'LineWidth', 2);
hold on
plot(t23_d, u_d, '--', 'LineWidth',2);
title('Disturb')
xlabel('t(s)');
ylabel('Disturb (N/m)');
legend('Simulink', 'Matlab');

figure('Name', 'ET between Simulink and MATLAB')
t_es = [t_es_23_d, t_simulink];
bar(t_es);
set(gca, 'XTickLabel', {'MATLAB (Ode23)', 'Simulink (Ode23)'});
ylabel('Execution Time [s]');
title('Times of execution');
%la grossa differenza temporale è data dal diverso modo in cui matlab e
%simulink gestiscono la risoluzione del problema. (considerazioni finali su
%latex)

% grafico linearizzato con simulink
% ex2 = sim("simulink_01_linearizzatp.slx");
% 
% figure()
% subplot(2,1,1);
% title('Position Cart');
% plot(ex2.tout,ex2.x_lin);
% xlabel('t(s)');
% ylabel('x (m)');
% 
% grid on;
% subplot(2,1,2);
% title('Pendulum Angle')
% plot(ex2.tout,ex2.theta_lin);
% xlabel('t(s)');
% ylabel('\theta (deg)');
% grid on;
% ex3 = sim("simulink_01_nonlineare_per_confronto_con_lineare.slx");


% lineare vs non lineare in simulink

% figure()
% plot(ex3.tout,rad2deg(ex3.theta));
% hold on
% grid on
% plot(ex2.tout,rad2deg(ex2.theta_lin));
% xlim([0 0.7]);
% ylim([0 20]);
% legend("non linear","linear");
% xlabel('t(s)');
% ylabel('\theta (deg)');
%% task 4.3
c = 0;
b = 0;
A = [0 1 0 0;
    0 0 ((I_1^2*g)/I_2)/(I_0+M-(I_1^2)/I_2) 0;
    0 0 0 1;
    0 ,0 ,((I_1^3*g)/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))+(I_1*g)/I_2 ,0];
B = [0,0;
    kt/(r*(I_0+M-(I_1^2)/I_2)),((I_1*alpha_1)/I_2-alpha_0)/(I_0+M-(I_1^2)/I_2);
    0,0;
    I_1*kt/(r*I_2*(I_0+M-(I_1^2)/I_2)),((I_1^2*alpha_1)/I_2-I_1*alpha_0)/(I_2*(I_0+M-(I_1^2)/I_2))+alpha_1/I_2];
eig_A_no_f=eig(A);
C = [1 0 0 0;
    0 0 1 0];
D = [0,0;0,0];
invpendulumP.sys = ss(A,B,C,D);
[yy,tt] = initial(invpendulumP.sys,x_0,0.7);

figure('Name', '4.3 - Linear Frictionless Model')
subplot(2,1,1);
title('Position Cart');
plot(tt,yy(:,1));
xlabel('t(s)');
ylabel('x (m)');
hold on;
plot(t_lin,y(1:1:j-1,1));
grid on;
legend("Frictionless","Friction")

subplot(2,1,2);
title('Pendulum Angle')
plot(tt,rad2deg(yy(:,2)));
grid on;
hold on; 
plot(t_lin,y(1:1:j-1,2));
xlabel('t(s)');
ylabel('\theta (deg)');
legend("Frictionless","Friction")
% nell'intorno del punto di equlibrio instabile, dove vale l'approssimazione lineare,
% il sistema senza attriti rimane identico a quello con, per poi divergere
% piu rapidamente verso l'infinito( causa: no attriti)

%% task 4.4 TRASFER FUNCTIONS
% For the frictionless linear model derived in the previous step, derive the
% symbolic expression of the following transfer functions (with inputs i(t),
% d(t) and outputs x(t), θ(t))

sys = ss(A, B, C, D);

% Converti in funzione di trasferimento G(s)
G = tf(sys);

G_x_i = G(1,1);
G_x_d = G(2,1);
G_theta_i = G(1,2);
G_theta_d = G(2,2);

%% task 4.5 POLE-ZERO ANALYSIS
%Using the numerical values of the parameters, compute and plot the pole
%zero maps of the transfer functions.
%Comment on the stability and dynamic properties of the system

figure('Name', '4.5 - Pole-Zero analysis')
subplot(2,2,1)
pzmap(G_x_i);
title('G_{x i}')
subplot(2,2,2)
pzmap(G_x_d);
title('G_{x d}')
subplot(2,2,3)
pzmap(G_theta_i);
title('G_{\theta i}')
subplot(2,2,4)
pzmap(G_theta_d);
title('G_{\theta d}')

%  tutti con  almeno un polo con parte reale positiva [GAME OVER]

%% (5.6)
%servono per far girare il simulink
xhi_c = 0.7;
wc = 10;
kd= xhi_c*wc/4.668;
kp= (wc^2+29.32)/9.336;
b = 0.005;
c = 0.1;

ex5 = sim('simulink_nonlineare_attrito.slx');
% Simulate the nonlinear model with friction and plot results
figure('Name', '5.7 - Nonlinear Model with Friction')
subplot(2,1,1);
title('Position Cart with Friction');
plot(ex5.tout, ex5.x);
xlabel('t(s)');
ylabel('x (m)');
grid on;

subplot(2,1,2);
title('Position Cart with Friction');
plot(ex5.tout, rad2deg(ex5.theta));
xlabel('t(s)');
ylabel('\theta (deg)');
grid on;
legend('Nonlinear with Friction');

%% 5.11
%vado a fare il tuning del PDI con metodo di Ziegler-Nichols
%step 1: 
ki=0;
kd=0;
kp=2.5; %questo è il primo valore per cui a regime si instaura un'oscillazione permanente che si smorza di meno di un grado fino a 100 secondi
%uso questo perchè un'oscillazione permanente perfetta è sostanzialmente
%impossibile anche dati gli errori del calcolatore.
%procedo a fare il tuning di kd e ki

exe=sim('simulink_PDI.slx');
figure('Name', 'PDI Tuning')
plot(exe.tout, rad2deg(exe.theta), Linewidth=2);
grid on



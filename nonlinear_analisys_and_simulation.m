clear;
close all;
clc;

%% TASK 2.1 - Scelta qualitativa del metodo di integrazione
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

%% TASK 2.1 - Scelta quantitativa del metodo di integrazione
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

%% TASK 2.1 - Soluzione con Ode78
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

%% TASK 2.1 - Sensibilità alle tolleranze
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

%% TASK 2.2 - Scelta qualitativa del metodo di integrazione
% Parametri e condizioni iniziali
invpendulumP = invpendulum_parameters ();
x_0_d = [0; 0; 0; 0];
t_0_d = 0;
t_f_d = 50;

% Integrazione - soluzione di riferimento
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

% Grafico - confronto tra riferimento e ode45
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

% Grafico - confronto tra riferimento e ode23
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

% Grafico - confronto tra riferimento e ode78
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

%% TASK 2.2 - Scelta quantitativa del metodo di integrazione 
% Calcolo errori assoluti
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

%% TASK 2.2 - Soluzione con Ode23
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

%% TASK 2.2 - Sensibilità alle tolleranze
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

%% TASK 3.1 - Simulink
% Definizione parametri iniziali (servono a simulink)
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

%% TASK 4.2 - modello linearizzato
% Definizione parametri iniziali
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

% Matrici lineari
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

% Grafico - modello linearizzato
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

%% TASK 4.2 - Theta limite per avere un errore minore dell'1%
% Calcolo soluzione del sistema non lineare ponendo theta = 1deg, come per il sistema lineare.
t_f_d = 50;
x_0_d = [0; 0; deg2rad(1); 0];
ODE_objd = ode;
ODE_objd.ODEFcn = @(t,x) invpendulumP_fd(t,x,@invpendulum_input_d, invpendulumP);
ODE_objd.InitialValue = x_0_d;
ODE_objd.Solver = 'ode78';
ODEResults_obj = solve(ODE_objd, t_0, t_f_d);
t_d = ODEResults_obj.Time';
x_d = ODEResults_obj.Solution'; 

% Calcolo soluzione lineare con il vettore dei tempi del non lineare
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

% Calcolo errore relativo tra la soluzione lineare e non lineare 
% (metto in gradi perchè ho messo la tolleranza sull'angolo in
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

% Grafico comportamento lineare vs non lineare 
figure('Name','4.2 - Linear vs Non Linear Comparison')
plot(t_lin,y(1:1:j-1,2));
hold on 
grid on
plot (t_lin, theta_d(1:1:j-1));
legend ('Linear','Non Linear');
xlabel('t(s)');
ylabel('\theta (deg)');

%% NON CAPISCO SE SERVE
% grafico linearizzato con simulink
ex2 = sim("simulink_linearizzato_openloop.slx");

figure()
subplot(2,1,1);
title('Position Cart');
plot(ex2.tout,ex2.x_lin);
xlabel('t(s)');
ylabel('x (m)');

grid on;
subplot(2,1,2);
title('Pendulum Angle')
plot(ex2.tout,ex2.theta_lin);
xlabel('t(s)');
ylabel('\theta (deg)');
grid on;
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

%% TASK 4.3 - Modello lineare in spazio di stato senza attriti
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

%% TASK 4.4 - Funzioni di trasferimento
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

%% TASK 4.5 - Analisi su posizione di poli e zeri
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

%% TASK 5.6 - Risposta in anello chiuso con controllore
%servono per far girare il simulink
b = 0;
c = 0;

xi = 0.7;
omega_n = 10;
kd= 1.5;
kp= 13.85;
x0 = [0,0,0,0]';

ODE_obj6 = ode;
ODE_obj6.ODEFcn = @(t,x) invpendulumP_frictionless(t,x,kd,kp,@invpendulum_input_d, invpendulumP);
ODE_obj6.InitialValue = x0;
ODE_obj6.Solver = 'ode23';
ODE_obj6.AbsoluteTolerance = 1e-13;
ODE_obj6.RelativeTolerance = 1e-12;
ODEResults_obj = solve(ODE_obj6, t_0_d, t_f_d);
t23_frictionless = ODEResults_obj.Time';
x23_frictionless = ODEResults_obj.Solution'; 
xcart23_frictionless = x23_frictionless(:,1);
theta23_frictionless = x23_frictionless(:,3);

ex5 = sim('simulink_nonlineare_nonattrito_closedloop.slx');
% Simulate the nonlinear model without friction and plot results
figure('Name', '5.6 - Pendulum Angle without Friction');
plot(ex5.tout, rad2deg(ex5.theta));
xlabel('t(s)');
ylabel('\theta (deg)');
hold on;
grid on;
plot(t23_frictionless,rad2deg(theta23_frictionless));
legend('Pendulum Angle without Friction (simulink)','Pendulum Angle without Friction (matlab)');
% Ricalcolo dell'input PD 
theta_rif = 0; 
u1_feedback = kp * (theta_rif - x23_frictionless(:,3)) + kd * (-x23_frictionless(:,4));

figure('Name','5.6 - Input ');
plot(ex5.tout, ex5.input);
xlabel('t(s)');
ylabel('i(A)'); % controllate pls
hold on;
plot(t23_frictionless, u1_feedback);
grid on;
legend('Input feedback (simulink)','Input feedback (matlab)');
function xdot_d = invpendulumP_frictionless (t,x,kd,kp, input_fun, invpendulumP) 
%sistema con disturbo in spazio di stato senza attriti

I_1 = invpendulumP.I_1;
I_2 = invpendulumP.I_2;
I_0 = invpendulumP.I_0;
g = invpendulumP.g;
alpha_1 = invpendulumP.alpha_1;
alpha_0 = invpendulumP.alpha_0;
kt = invpendulumP.kt;
r = invpendulumP.r;
M = invpendulumP.M;
[~ , u_d] = input_fun(t, invpendulumP);

x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);
% inseriamo il PD all'interno della nostra funzione 
theta_rif = 0;
u1 =  (kp * (theta_rif - x(3)) + kd * (- x(4)))*(kt/r);
u2 = u_d;


xdot_1 = x2;
xdot_2 = (((I_1^2)/I_2)*g*sin(x3)*cos(x3)+(I_1/I_2)*u2*alpha_1*(cos(x3)^2)-I_1*(x4^2)*sin(x3)+u1-u2*alpha_0)/(I_0+M-(I_1^2/I_2)*(cos(x3)^2));
xdot_3 = x4;
xdot_4 = (I_1*xdot_2*cos(x3)+I_1*g*sin(x3)+u2*alpha_1*cos(x3))/I_2;

xdot_d = [xdot_1, xdot_2, xdot_3, xdot_4]';
end

% Simulate the nonlinear model with friction and plot results
figure('Name', '5.6 - Position Cart');
plot(ex5.tout, ex5.x);
xlabel('t(s)');
ylabel('x (m)');
hold on;
grid on;
plot(t23_frictionless, xcart23_frictionless);
legend('Position Cart (simulink)','Position Cart (matlab)');

%% TASK 5.7 - Risposta in anello chiuso con controllore e attriti
c = invpendulumP.c;
b = invpendulumP.b;

% usiamo i guadagni trovati nel 5.4 per andare a vedere theta(t) e i(t) nel
% tempo , usando il modello non lineare senza attriti, con condizioni
% iniziali zero. (Si puo fare anche una simulazione in matlab o solo in simulink?) 

ex5 = sim('simulink_nonlineare_attrito.slx');
ex5p2 = sim('simulink_nonlineare_nonattrito_closedloop.slx');

figure('Name', '5.7 - Nonlinear Model with Friction')
subplot(3,1,1);
title('Position Cart');
plot(ex5.tout, ex5.x,'LineWidth',2);
hold on;
plot(ex5p2.tout, ex5p2.x,'LineWidth',2);
xlabel('t(s)');
ylabel('x (m)');
grid on;
legend ('Friction','Frictionless');

subplot(3,1,2);
title('Pendulum Angle');
plot(ex5.tout, rad2deg(ex5.theta),'LineWidth',2);
hold on;
plot(ex5p2.tout, rad2deg(ex5p2.theta),'LineWidth',2);
xlabel('t(s)');
ylabel('\theta (deg)');
grid on;
legend ('Friction','Frictionless');

subplot(3,1,3);
title('Current');
plot(ex5.tout, ex5.input,'LineWidth',2);
hold on;
plot(ex5p2.tout, ex5p2.input,'LineWidth',2);
xlabel('t(s)');
ylabel('I(A)');
grid on;
legend ('Friction','Frictionless');

%% TASK 5.11 - Scelta dei parametri di design per controllore PID
%faccio un tuning a mano guardando solo la condizione che abbiamo noi (non
%verifico sovraelongazione nè tempo di assestamento... theta rimane sempre
%un filo diverso da zero quindi il carrello continua a dare spinta. se ne
%va via il carrello, che potrebbe anche andare bene ma non so perchè theta
%non vada a zero preciso. non trovo il modo. 
kp = 8;        
ki = 2;   
kd = 1;
%821 è lo standard
if ki>(9.336*kp-29.32)*kd
    fprintf('il regolatore non va bene!\n');
end

PID=sim('simulink_PDI.slx');
figure('Name', 'PDI Tuned')
plot(PID.tout, rad2deg(PID.theta), Linewidth=2);
grid on
hold on;
plot(PID.tout, PID.x, LineWidth=2);
hold on
plot(PID.tout, PID.current.Data, LineWidth=2);
ylim([-15, 15]);
xlim([0 10]);
ylabel('\theta [Degrees] / X [m] / i [A]')
xlabel('Time [s]');
legend('Theta', 'X', 'i');

%% TASK 6.1 - Test di controllabilità
A = [0 1 0 0;
    0 0 ((I_1^2*g)/I_2)/(I_0+M-(I_1^2)/I_2) 0;
    0 0 0 1;
    0 ,0 ,((I_1^3*g)/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))+(I_1*g)/I_2 ,0];
%definisco B_u come la matrice che controlla solo l'input
B_u = [0;
    kt/(r*(I_0+M-(I_1^2)/I_2));
    0;
    I_1*kt/(r*I_2*(I_0+M-(I_1^2)/I_2))];

C = [1 0 0 0;
    0 0 1 0];

D = [0,0;0,0];
B_d = [0;
    ((I_1*alpha_1)/I_2-alpha_0)/(I_0+M-(I_1^2)/I_2);
    0;
    ((I_1^2*alpha_1)/I_2-I_1*alpha_0)/(I_2*(I_0+M-(I_1^2)/I_2))+alpha_1/I_2];
%per la verifica di controllabilità faccio la verifica del rango della
%matrice di controllabilità
Co=ctrb(A, B_u);
n=size(A,1);
iscontrollable=(rank(Co)==n);
if iscontrollable~=1
    fprintf('Il sistema non è controllabile');
end

%% TASK 6.2 - Posizionamento dei poli con controllore in spazio di stato
% Definizione matrici utili
B_d = [0;
    ((I_1*alpha_1)/I_2-alpha_0)/(I_0+M-(I_1^2)/I_2);
    0;
    ((I_1^2*alpha_1)/I_2-I_1*alpha_0)/(I_2*(I_0+M-(I_1^2)/I_2))+alpha_1/I_2];
D_d=[0;0];

K=zeros(4,1); %è il vettore dei guadagni che andremo a riempire con pole-placement
%closed loop system matrix:

% Mantengo lo smorzamento sempre a 0.7 (valore ottimale)
xi = 0.7;
% Prima coppia di frequenze (w_c = 1 e w_c = 2)
omega_n1_1 = 1; % Determina poli dominanti, più lenti)
omega_d1_1 = omega_n1_1*sqrt(1-xi^2);
pC_1_1 = -xi*omega_n1_1 + 1i*omega_d1_1;
pC_2_1 = -xi*omega_n1_1 - 1i*omega_d1_1;

omega_n2_1 = 2; % Determina poli ausiliari,  più veloci, es. 5-10x omega_n1_1
omega_d2_1 = omega_n2_1*sqrt(1-xi^2);
pC_3_1 = -xi*omega_n2_1 + 1i*omega_d2_1;
pC_4_1 = -xi*omega_n2_1 - 1i*omega_d2_1;

pC_1 = [pC_1_1 pC_2_1 pC_3_1 pC_4_1];

K_1 = place(A, B_u, pC_1);  % K sarà 2x4
%tuning dei poli fatto a buon senso...
%usiamo la funzione che risolve il problema di trovare i guadagni che
%mettano i poli proprio dove li vogliamo noi
A_c_1=A-B_u*K_1;

% Definisco il sistema
sys_cl_1=ss(A_c_1, B_d, C, D_d);

% Creo un vettore che esprime il disturbo (non posso passarglielo come funzione
t=0:0.01:10;
w = zeros(length(t), 1);
for k = 1:length(t)
    [~, w(k)] = invpendulum_input_d(t(k), invpendulumP);
end
x0=zeros(4,1);
% Risolvo
[x_dot_1, t_out_1, x_out_1] = lsim(sys_cl_1, w, t, x0);
% S_1_c = stepinfo(sys_cl_1(1,:));
% S_1_p = stepinfo(sys_cl_1(2,:));

% Seconda coppia di frequenze (w_c = 2 e w_c = 5)
omega_n1_2 = 2; % Determina poli dominanti, più lenti)
omega_d1_2 = omega_n1_2*sqrt(1-xi^2);
pC_1_2 = -xi*omega_n1_2 + 1i*omega_d1_2;
pC_2_2 = -xi*omega_n1_2 - 1i*omega_d1_2;

omega_n2_2 = 5; % Determina poli ausiliari,  più veloci, es. 5-10x omega_n1_1
omega_d2_2 = omega_n2_2*sqrt(1-xi^2);
pC_3_2 = -xi*omega_n2_2 + 1i*omega_d2_2;
pC_4_2 = -xi*omega_n2_2 - 1i*omega_d2_2;

pC_2 = [pC_1_2 pC_2_2 pC_3_2 pC_4_2];

K_2 = place(A, B_u, pC_2);  % K sarà 2x4
%tuning dei poli fatto a buon senso...
%usiamo la funzione che risolve il problema di trovare i guadagni che
%mettano i poli proprio dove li vogliamo noi
A_c_2=A-B_u*K_2;

% Definisco il sistema
sys_cl_2=ss(A_c_2, B_d, C, D_d);

% Risolvo
[x_dot_2, t_out_2, x_out_2] = lsim(sys_cl_2, w, t, x0);
i_out_2 = (-K_2 * x_out_2')';
% S_2_c = stepinfo(sys_cl_2(1,:));
% S_2_p = stepinfo(sys_cl_2(2,:));

% Terza coppia di frequenze (w_c = 5 e w_c = 10)
omega_n1_3 = 5; % Determina poli dominanti, più lenti)
omega_d1_3 = omega_n1_3*sqrt(1-xi^2);
pC_1_3 = -xi*omega_n1_3 + 1i*omega_d1_3;
pC_2_3 = -xi*omega_n1_3 - 1i*omega_d1_3;

omega_n2_3 = 10; % Determina poli ausiliari,  più veloci, es. 5-10x omega_n1_1
omega_d2_3 = omega_n2_3*sqrt(1-xi^2);
pC_3_3 = -xi*omega_n2_3 + 1i*omega_d2_3;
pC_4_3 = -xi*omega_n2_3 - 1i*omega_d2_3;

pC_3 = [pC_1_3 pC_2_3 pC_3_3 pC_4_3];

K_3 = place(A, B_u, pC_3);  % K sarà 2x4
%tuning dei poli fatto a buon senso...
%usiamo la funzione che risolve il problema di trovare i guadagni che
%mettano i poli proprio dove li vogliamo noi
A_c_3=A-B_u*K_3;

% Definisco il sistema
sys_cl_3=ss(A_c_3, B_d, C, D_d);

% Risolvo
[x_dot_3, t_out_3, x_out_3] = lsim(sys_cl_3, w, t, x0);
% S_3_c = stepinfo(sys_cl_3(1,:));
% S_3_p = stepinfo(sys_cl_3(2,:));

% Grafico della risposta - confronto tra le tre coppie
figure('Name', '6.2 Scelta dei poli per controllore in spazio di stato')
subplot(1,2,1)
plot(t_out_1, x_out_1(:,1), LineWidth=2);
hold on;
plot(t_out_2, x_out_2(:,1), LineWidth=2);
plot(t_out_3, x_out_3(:,1), 'LineWidth', 2);
grid on;
legend('wc = (1,2)', 'wc = (2, 5)', 'wc = (5,10)');
title('Influenza su posizione carrello');

subplot(1,2,2)
plot(t_out_1, rad2deg(x_out_1(:,3)), LineWidth=2);
hold on;
plot(t_out_2, rad2deg(x_out_2(:,3)), LineWidth=2);
plot(t_out_3, rad2deg(x_out_3(:,3)), 'LineWidth', 2);
grid on;
legend('wc = (1,2)', 'wc = (2, 5)', 'wc = (5,10)');
title('Influenza su angolo pendolo');

%% TASK 6.3 - Test di osservabilità
O = obsv(A, C);
if rank(O) == size(A,1)
    fprintf("Il sistema è osservabile\n");
else 
    fprintf("Il sistema non è osservabile\n");
end

% Posizionamento poli osservatore
% Mantengo lo smorzamento a 0.7 (scelta ottima)
% Primo tentativo (poli il doppio più veloci di quelli del controllore
omega_n_o1_1 = omega_n1_2*2;
omega_d_o1_1 = omega_n1_2*sqrt(1-xi^2)*2;
pC_1_o_1 = -xi*omega_n_o1_1 + 1i*omega_d_o1_1;
pC_2_o_1 = -xi*omega_n_o1_1- 1i*omega_d_o1_1;

omega_n_o2_1 = omega_n2_2*2;
omega_d_o2_1 = omega_n2_2*sqrt(1-xi^2)*2;
pC_3_o_1 = -xi*omega_n_o2_1 + 1i*omega_d_o2_1;
pC_4_o_1 = -xi*omega_n_o2_1 - 1i*omega_d_o2_1;

pC_o_1 = [pC_1_o_1 pC_2_o_1 pC_3_o_1 pC_4_o_1];

lT_o_1 = place(A',C', pC_o_1);
L_1 = lT_o_1';

% Secondo tentativo (poli il quadruplo più veloci di quelli del
% controllore)
omega_n_o1_2 = omega_n1_2*4;
omega_d_o1_2 = omega_n1_2*sqrt(1-xi^2)*4;
pC_1_o_2 = -xi*omega_n_o1_2 + 1i*omega_d_o1_2;
pC_2_o_2 = -xi*omega_n_o1_2- 1i*omega_d_o1_2;

omega_n_o2_2 = omega_n2_2*4;
omega_d_o2_2 = omega_n2_2*sqrt(1-xi^2)*4;
pC_3_o_2 = -xi*omega_n_o2_2 + 1i*omega_d_o2_2;
pC_4_o_2 = -xi*omega_n_o2_2 - 1i*omega_d_o2_2;

pC_o_2 = [pC_1_o_2 pC_2_o_2 pC_3_o_2 pC_4_o_2];

lT_o_2 = place(A',C', pC_o_2);
L_2 = lT_o_2';

% Terzo tentativo (poli 6 volte più veloci di quelli del controllore)
omega_n_o1_3 = omega_n1_2*6;
omega_d_o1_3 = omega_n1_2*sqrt(1-xi^2)*6;
pC_1_o_3 = -xi*omega_n_o1_3 + 1i*omega_d_o1_3;
pC_2_o_3 = -xi*omega_n_o1_3- 1i*omega_d_o1_3;

omega_n_o2_3 = omega_n2_2*6;
omega_d_o2_3 = omega_n2_2*sqrt(1-xi^2)*6;
pC_3_o_3 = -xi*omega_n_o2_3 + 1i*omega_d_o2_3;
pC_4_o_3 = -xi*omega_n_o2_3 - 1i*omega_d_o2_3;

pC_o_3 = [pC_1_o_3 pC_2_o_3 pC_3_o_3 pC_4_o_3];

lT_o_3 = place(A',C', pC_o_3);
L_3 = lT_o_3';

%% TASK 6.5 - Risposta in anello chiuso con compensatore
% Definizione parametri iniziali
x0_t = [x0; x0];   % stato iniziale aumentato (8x1)
[t_out_o1, x_out_o1] = ode23(@(t,x) closed_loop_nonlinear(t, x, K_2, L_1, A, B_u,  C, invpendulumP), t, x0_t);
[t_out_o2, x_out_o2] = ode23(@(t,x) closed_loop_nonlinear(t, x, K_2, L_2, A, B_u,  C, invpendulumP), t, x0_t);
[t_out_o3, x_out_o3] = ode23(@(t,x) closed_loop_nonlinear(t, x, K_2, L_3, A, B_u,  C, invpendulumP), t, x0_t);

% Estrazione variabili
x_real_out_o1 = x_out_o1(:, 1:4);
x_hat_out_o1  = x_out_o1(:, 5:8);
x_real_out_o2 = x_out_o2(:, 1:4);
x_hat_out_o2  = x_out_o2(:, 5:8);
x_real_out_o3 = x_out_o3(:, 1:4);
x_hat_out_o3  = x_out_o3(:, 5:8);

i_out_o1 = (-K_2 * x_hat_out_o1')';
i_out_o2 = (-K_2 * x_hat_out_o2')';
i_out_o3 = (-K_2 * x_hat_out_o3')';

% Errore di stima
err_c_1 = abs(x_real_out_o1(:,1) - x_hat_out_o1(:,1));
err_p_1 = abs(rad2deg(x_real_out_o1(:,3)-x_hat_out_o1(:,3)));
err_c_2 = abs(x_real_out_o2(:,1) - x_hat_out_o2(:,1));
err_p_2 = abs(rad2deg(x_real_out_o2(:,3)-x_hat_out_o2(:,3)));
err_c_3 = abs(x_real_out_o3(:,1) - x_hat_out_o3(:,1));
err_p_3 = abs(rad2deg(x_real_out_o3(:,3)-x_hat_out_o3(:,3)));

figure ('Name', '6.3 - Comparison between different choices for observer poles');
subplot(3,1,1);
plot(t_out_o1, i_out_o1, 'LineWidth',2);
hold on;
plot(t_out_o2, i_out_o2, 'LineWidth',2);
plot(t_out_o3, i_out_o3, 'LineWidth',2);
legend('First try', 'Second try', 'Third try');
xlabel('Time [s]');
ylabel('Current [A]');
title ('Current with observer');

subplot(3,1,2);
plot(t_out_o1, x_real_out_o1(:,1), 'LineWidth',2);
hold on;
plot(t_out_o2, x_real_out_o2(:,1), 'LineWidth',2);
plot(t_out_o3, x_real_out_o3(:,1), 'LineWidth',2);
legend('First try', 'Second try', 'Third try');
xlabel('Time [s]');
ylabel('Position [m]');
title ('Cart postion with observer');

subplot(3,1,3);
plot(t_out_o1, rad2deg(x_real_out_o1(:,3)), 'LineWidth',2);
hold on;
plot(t_out_o2, rad2deg(x_real_out_o2(:,3)), 'LineWidth',2);
plot(t_out_o3, rad2deg(x_real_out_o3(:,3)), 'LineWidth',2);
legend('First try', 'Second try', 'Third try');
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
title('Pendulum angle with observer');

figure('Name', '6.5 - Error with different poles for observer')
subplot(2,1,1)
plot(t_out_o1, err_c_1, 'LineWidth', 2);
hold on;
plot(t_out_o2, err_c_2, 'LineWidth', 2);
plot(t_out_o3, err_c_3, 'LineWidth', 2);
ylabel('Position [m]');
xlabel('Time [s]');
legend('First try', 'Second try', 'Third try');
title('Estimation error in cart position');

subplot(2,1,2)
plot(t_out_o1, err_p_1, 'LineWidth',2);
hold on;
plot(t_out_o2, err_p_2, 'LineWidth',2);
plot(t_out_o3, err_p_3, 'LineWidth',2);
ylabel('Pendulum angle [°]');
xlabel('Time [s]');
legend('First try', 'Second try', 'Third try');
title('Estimation error in pendulum angle');

figure('Name', '6.5 - Ode23 solution with and without observer')
subplot(3,1,1);
plot(t_out_o2, i_out_o2, 'LineWidth',2);
hold on;
plot(t_out_2, i_out_2, 'LineWidth',2);
legend('With Obs', 'Without Obs');
xlabel('Time [s]');
ylabel('Current [A]');
title ('Current with observer');

subplot(3,1,2);
plot(t_out_o2, x_real_out_o2(:,1), 'LineWidth',2);
hold on;
plot(t_out_2, x_out_2(:,1), LineWidth=2);
legend('With Obs', 'Without Obs');
xlabel('Time [s]');
ylabel('Position [m]');
title ('Cart postion with observer');

subplot(3,1,3);
plot(t_out_o2, rad2deg(x_real_out_o2(:,3)), 'LineWidth',2);
hold on;
plot(t_out_2, rad2deg(x_out_2(:,3)), LineWidth=2);
legend('With Obs', 'Without Obs');
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
title('Pendulum angle with observer');

%% 6.6 closed loop simultion with simulink

ex6 = sim("simulink_01_compensator.slx");

figure('Name', '6.6 - Simulink Solution')
subplot(3,1,1);
plot(ex6.tout,ex6.x,'LineWidth',2);
xlabel('t(s)');
ylabel('x(m)');
grid on;
subplot(3,1,2);
plot(ex6.tout,ex6.input,'LineWidth',2);
xlabel('t(s)');
ylabel('I(A)');
grid on;
subplot(3,1,3);
plot(ex6.tout,rad2deg(ex6.theta),'LineWidth',2);
xlabel('t(s)');
ylabel('\theta (deg)');
grid on;

err_sim_x     = abs(ex6.x(:,1) - ex6.x_hat(:,1));
err_sim_theta = abs(rad2deg(ex6.theta(:,1)- ex6.x_hat(:,3)));

figure('Name', '6.6 - Error Comparison')
subplot(2,1,1)
plot(ex6.tout, err_sim_x, 'LineWidth',2);
ylabel('Position [m]');
xlabel('Time [s]');
title('Estimation error in cart position');
grid on;
subplot(2,1,2)
plot(ex6.tout, err_sim_theta, 'LineWidth',2);
ylabel('Pendulum angle [°]');
xlabel('Time [s]');
title('Estimation error in pendulum angle');
grid on;



figure('Name', '6.6 -  Solution with and without observer')
subplot(3,1,1);
plot(ex6.tout, ex6.input, 'LineWidth',2);
hold on;
plot(t_out_2, i_out_2, 'LineWidth',2);
legend('With Obs', 'Without Obs');
xlabel('Time [s]');
ylabel('Current [A]');
title ('Current with observer');

subplot(3,1,2);
plot(ex6.tout, ex6.x, 'LineWidth',2);
hold on;
plot(t_out_2, x_out_2(:,1), LineWidth=2);
legend('With Obs', 'Without Obs');
xlabel('Time [s]');
ylabel('Position [m]');
title ('Cart postion with observer');

subplot(3,1,3);
plot(ex6.tout, rad2deg(ex6.theta), 'LineWidth',2);
hold on;
plot(t_out_2, rad2deg(x_out_2(:,3)), LineWidth=2);
legend('With Obs', 'Without Obs');
xlabel('Time [s]');
ylabel('Pendulum angle [°]');
title('Pendulum angle with observer');


%% TASK 7 - 
L1 = 0.076;
L2 = 0.76;
L3 = 3.6;
R = 3.6;
A_7_1 = [0 1 0 0 0;
    0 -c/(I_0+M-(I_1^2)/I_2) ((I_1^2*g)/I_2)/(I_0+M-(I_1^2)/I_2) (-I_1*b/I_2)/(I_0+M-(I_1^2)/I_2) (kt/r)/(I_0+M-(I_1)^2/I_2);
    0 0 0 1 0;
    0 -c*I_1/(I_2*(I_0+M-(I_1^2)/I_2)) ((I_1^3*g)/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))+(I_1*g)/I_2 (-I_1^2*b/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))-b/I_2 ((kt/r)*(I_1/I_2))/((I_0+M-(I_1)^2/I_2));
    0 0 0 -kt/L1 -R/L1];
A_7_2 = [0 1 0 0 0;
    0 -c/(I_0+M-(I_1^2)/I_2) ((I_1^2*g)/I_2)/(I_0+M-(I_1^2)/I_2) (-I_1*b/I_2)/(I_0+M-(I_1^2)/I_2) (kt/r)/(I_0+M-(I_1)^2/I_2);
    0 0 0 1 0;
    0 -c*I_1/(I_2*(I_0+M-(I_1^2)/I_2)) ((I_1^3*g)/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))+(I_1*g)/I_2 (-I_1^2*b/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))-b/I_2 ((kt/r)*(I_1/I_2))/((I_0+M-(I_1)^2/I_2));
    0 0 0 -kt/L2 -R/L2];
A_7_3 = [0 1 0 0 0;
    0 -c/(I_0+M-(I_1^2)/I_2) ((I_1^2*g)/I_2)/(I_0+M-(I_1^2)/I_2) (-I_1*b/I_2)/(I_0+M-(I_1^2)/I_2) (kt/r)/(I_0+M-(I_1)^2/I_2);
    0 0 0 1 0;
    0 -c*I_1/(I_2*(I_0+M-(I_1^2)/I_2)) ((I_1^3*g)/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))+(I_1*g)/I_2 (-I_1^2*b/I_2)/(I_2*(I_0+M-(I_1^2)/I_2))-b/I_2 ((kt/r)*(I_1/I_2))/((I_0+M-(I_1)^2/I_2));
    0 0 0 -kt/L3 -R/L3];
B_7_1 = [0,0;
    0,((I_1*alpha_1)/I_2-alpha_0)/(I_0+M-(I_1^2)/I_2);
    0,0;
    0,((I_1^2*alpha_1)/I_2-I_1*alpha_0)/(I_2*(I_0+M-(I_1^2)/I_2))+alpha_1/I_2
    1/L1, 0];
B_7_2 = [0,0;
    0,((I_1*alpha_1)/I_2-alpha_0)/(I_0+M-(I_1^2)/I_2);
    0,0;
    0,((I_1^2*alpha_1)/I_2-I_1*alpha_0)/(I_2*(I_0+M-(I_1^2)/I_2))+alpha_1/I_2
    1/L2, 0];
B_7_3 = [0,0;
    0,((I_1*alpha_1)/I_2-alpha_0)/(I_0+M-(I_1^2)/I_2);
    0,0;
    0,((I_1^2*alpha_1)/I_2-I_1*alpha_0)/(I_2*(I_0+M-(I_1^2)/I_2))+alpha_1/I_2
    1/L3, 0];
C_7 = [1 0 0 0 0;
    0 0 1 0 0];
D_7 = [0,0;0,0];
% Co=ctrb(A_7, B_7);
% n=size(A_7,1);
% iscontrollable=(rank(Co)==n);
% if iscontrollable~=1
%     fprintf('Il sistema non è controllabile');
% end
% Controllabile

% Controllore con ingresso tensione
K_7=zeros(5,1); %è il vettore dei guadagni che andremo a riempire con pole-placement
%closed loop system matrix:

pC_elettrico1 = -R/L1;
pC_elettrico2 = -R/L2;
pC_elettrico3 = -R/L3;

pC1 = [pC_2, pC_elettrico1];
pC2 = [pC_2, pC_elettrico2];
pC3 = [pC_2, pC_elettrico3];

K1 = place(A_7_1, B_7_1(:,1), pC1);  % K sarà 2x4
K2 = place(A_7_2, B_7_2(:,1), pC2);
K3 = place(A_7_3, B_7_3(:,1), pC3);
%tuning dei poli fatto a buon senso...
%usiamo la funzione che risolve il problema di trovare i guadagni che
%mettano i poli proprio dove li vogliamo noi
A_c_7_1=A_7_1-B_7_1(:,1)*K1;
A_c_7_2=A_7_2-B_7_2(:,1)*K2;
A_c_7_3=A_7_3-B_7_3(:,1)*K3;
x0_7 = zeros (5,1);

sys_cl1=ss(A_c_7_1, B_7_1(:,2), C_7, D_d);
sys_cl2=ss(A_c_7_2, B_7_2(:,2), C_7, D_d);
sys_cl3=ss(A_c_7_3, B_7_3(:,2), C_7, D_d);

% Risolvo
[x_dot_7_1, t_out_7_1, x_out_7_1] = lsim(sys_cl1, w, t, x0_7);
[x_dot_7_2, t_out_7_2, x_out_7_2] = lsim(sys_cl2, w, t, x0_7);
[x_dot_7_3, t_out_7_3, x_out_7_3] = lsim(sys_cl3, w, t, x0_7);
v_out_1 = (-K1 * x_out_7_1')';
v_out_2 = (-K2 * x_out_7_2')';
v_out_3 = (-K3 * x_out_7_3')';


figure('Name', 'Actuator dynamics - cart position')
plot(t_out_7_2, x_out_7_2(:,1), 'LineWidth',2);
hold on;
plot (t_out_2, x_out_2(:,1), 'LineWidth', 2);
legend('Actuator', 'Non actuator');

figure('Name', 'Actuator dynamics - pendulum angle')
plot(t_out_7_2, rad2deg(x_out_7_2(:,3)), 'LineWidth', 2);
hold on;
plot(t_out_2, rad2deg(x_out_2(:,3)), 'LineWidth', 2);
legend('Actuator', 'Non actuator');

figure('Name', 'Actuator dynamics - current')
plot(t_out_7_2, x_out_7_2(:,5), 'LineWidth', 2);
hold on;
plot(t_out_2, i_out_2, 'LineWidth', 2);
legend('Actuator', 'Non actuator');

figure('Name', 'Comparison with different L - cart position')
plot(t_out_7_1, x_out_7_1(:,1), 'LineWidth',2);
hold on;
plot (t_out_7_2, x_out_7_2(:,1), 'LineWidth', 2);
plot (t_out_7_3, x_out_7_3(:,1), 'LineWidth', 2);
legend('L1', 'L2', 'L3');

figure('Name', 'Comparison with different L - pendulum angle')
plot(t_out_7_1, rad2deg(x_out_7_1(:,3)), 'LineWidth',2);
hold on;
plot (t_out_7_2, rad2deg(x_out_7_2(:,3)), 'LineWidth', 2);
plot (t_out_7_3, rad2deg(x_out_7_3(:,3)), 'LineWidth', 2);
legend('L1', 'L2', 'L3');

figure('Name', 'Comparison with different L - current')
plot(t_out_7_1, x_out_7_1(:,5), 'LineWidth',2);
hold on;
plot (t_out_7_2, x_out_7_2(:,5), 'LineWidth', 2);
plot (t_out_7_3, x_out_7_3(:,5), 'LineWidth', 2);
legend('L1', 'L2', 'L3');


%% ----------------------- Definizione Funzioni ---------------------------
% Struttura contenente dati del problema
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

% Funzione per definire gli input in risposta libera (i e d assenti)
function [u_c, u_d] = invpendulum_input(t, invpendulumP)
    kt = invpendulumP.kt;
    r = invpendulumP.r;
    i = 0;
    d = 0;
    u_c = (kt/r)*i;
    u_d = d;
end

% Funzione per definire gli input in presenza di disturbo
function [u_c, u_d] = invpendulum_input_d(t, invpendulumP)
    kt = invpendulumP.kt;
    r = invpendulumP.r;
    % T1 = invpendulumP.T1;
    % T2 = invpendulumP.T2;
    i = 0; %è corrente, in anello aperto è sempre nulla.
    % if t<T1
    %     d1 = 0;
    % elseif t>T2
    %     d1 = 0;
    % else
    %     d1 = 1;
    % end
    u_c = (kt/r)*i; 
    u_d = d_fun(t, invpendulumP);
end

% Funzione per descrivere il disturbo
function d_f = d_fun(t, invpendulumP)
    T1 = invpendulumP.T1;
    T2 = invpendulumP.T2;
    if t<T1
        d_f = 0;
    elseif t>T2
        d_f = 0;
    else
        d_f = 1;
    end
end

% Funzione per scrivere il sistema in spazio di stato
function xdot = invpendulumP_f (t,x, input_fun, invpendulumP)
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

% Funzione per definire il sistema in spazio di stato con disturbo
function xdot_d = invpendulumP_fd (t,x, input_fun, invpendulumP)
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

% Funzione per ottenere la risposta del sistema in presenza dell'osservatore
function dx_t = closed_loop_nonlinear(t, x_t, K, L, A, B_u,C, invpendulumP)
    x     = x_t(1:4);    % stato reale (sistema nonlineare)
    x_hat = x_t(5:8);    % stato stimato dall'osservatore

    % Disturbo 
    d_f = d_fun(t, invpendulumP);

    % Legge di controllo 
    u_c = -K*x_hat;

    % Uscita misurata 
    y = C * x;

    % Sistema NONLINEARE 
    x_dot = nonlinear_per_oss(x, u_c, d_f, invpendulumP);

    % --- Osservatore (lineare) ---
    x_hat_dot = (A-L*C-B_u*K)*x_hat+L*y;
    %qui non ci può stare la matrice B_d legata all'osservatore perchè non
    %può sapere l'osservatore quale sia il disturbo prima che esso stesso
    %si verifichi. le informazioni sul disturbo gli devono giungere tramite
    %y.

    dx_t = [x_dot; x_hat_dot];
end

% Funzione per definire il sistema non lineare da utilizzare con l'osservatore
function xdot_d = nonlinear_per_oss (x, u_c, d_f, invpendulumP) 
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

    x1 = x(1);
    x2 = x(2);
    x3 = x(3);
    x4 = x(4);
    u1 = u_c*kt/r;
    u2 = d_f;
    
    xdot_1 = x2;
    xdot_2 = (-(I_1/I_2)*b*x4*cos(x3)+((I_1^2)/I_2)*g*sin(x3)*cos(x3)+(I_1/I_2)*u2*alpha_1*(cos(x3)^2)-I_1*(x4^2)*sin(x3)-c*x2+u1-u2*alpha_0)/(I_0+M-(I_1^2/I_2)*(cos(x3)^2));
    xdot_3 = x4;
    xdot_4 = (I_1*xdot_2*cos(x3)-b*x4+I_1*g*sin(x3)+u2*alpha_1*cos(x3))/I_2;
    
    xdot_d = [xdot_1, xdot_2, xdot_3, xdot_4]';
end


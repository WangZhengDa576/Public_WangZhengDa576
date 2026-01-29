% HST Project 2: Observer-Based Control for a Nonlinear System
% This script simulates an inventory-price-demand system. It uses a
% state-feedback controller and a Luenberger observer designed from a
% linearized model to regulate the true nonlinear system.
%
% v2: Fixes an off-by-one error in the simulation loop that caused a
% divergence at the final time step and improves plot visibility.

% --- 1. Initialization ---
clear; clc; close all;

% --- 2. System Parameters and Equilibrium Point ---
% Model Parameters
alpha = 100.0;     % Max demand
beta = 0.01;       % Price sensitivity
c1 = 0.1;          % Price sensitivity to inventory
c2 = 0.5;          % Price sensitivity to demand
xtarget = 200.0;   % Target inventory level
P_star = 50.0;     % Target equilibrium price (x2*)
v = alpha*exp(-beta*P_star); % Target demand dependent on target price
k = 0.2;           % Output definition parameter

% Equilibrium Point (x_eq, u_eq, y_eq)
x1_star = xtarget;
x2_star = P_star;
x3_star = alpha * exp(-beta * P_star);
u1_star = -c2 * x3_star;
u2_star = x3_star;

x_eq = [x1_star; x2_star; x3_star];
u_eq = [u1_star; u2_star];
y_eq = x2_star; % True equilibrium output y* = x2*

% --- 3. Linearization and System Matrices ---
A = [1,   beta*x3_star,  0;
     -c1, 1,             c2;
     0,   -beta*x3_star, 0];
B = [0, 1; 1, 0; 0, 0];
C = [-k, 1, 0];
D = [0, 0];

% --- 4. Controllability and Observability Checks ---
Q = [B, A*B, A*A*B];
S = [C; C*A; C*A*A];
controllable = (rank(Q) == 3);
observable = (rank(S) == 3);
fprintf('System is controllable: %d (Rank of Q = %d)\n', controllable, rank(Q));
fprintf('System is observable: %d (Rank of S = %d)\n\n', observable, rank(S));

% --- 5. Gain Design (Pole Placement) ---
controller_poles = [0.7, 0.8, 0.9];
K = place(A, B, controller_poles);
fprintf('State feedback gain K:\n'); disp(K);

observer_poles = [0.3, 0.4, 0.5];
L = place(A', C', observer_poles)';
fprintf('Observer gain L:\n'); disp(L);

% --- 6. Closed-Loop Simulation ---
T = 50; % Simulation length

% State and Output History
x_true = zeros(3, T);
x_hat_tilde = zeros(3, T);
y_true = zeros(1, T);

% Error History for Plotting
estimation_error = zeros(3, T);
regulation_error = zeros(3, T);

% Initial Conditions
x_true(:, 1) = [x1_star*0.4; x2_star*1.6; x3_star*0.6];
x_hat_tilde(:, 1) = (x_true(:, 1) - x_eq) + [5; -10; 5];

% Simulation Loop
for t = 1:(T-1)
    % Step 1: Controller
    u = u_eq - K * x_hat_tilde(:, t);

    % Step 2: System Update
    x_t = x_true(:, t);
    demand = alpha * exp(-beta * x_t(2));
    x1_next = x_t(1) + u(2) - demand;
    x2_next = x_t(2) + u(1) - c1 * (x_t(1) - xtarget) + c2 * x_t(3);
    x3_next = demand;
    x_true(:, t + 1) = [x1_next; x2_next; x3_next];

    % Step 3: Measurement
    y_true(t) = x_t(2) - k * (x_t(1) - xtarget);

    % Step 4: Observer Update
    y_tilde = y_true(t) - y_eq;
    u_tilde = u - u_eq;
    y_hat_tilde = C * x_hat_tilde(:, t) + D * u_tilde;
    x_hat_tilde(:, t + 1) = A * x_hat_tilde(:, t) + B * u_tilde + L * (y_tilde - y_hat_tilde);

    % Step 5: Logging
    x_tilde_true = x_t - x_eq;
    regulation_error(:, t) = x_tilde_true;
    estimation_error(:, t) = x_tilde_true - x_hat_tilde(:, t);
end

% --- Calculate final values at t=T for the plot ---
t = T;
x_t = x_true(:, t);
y_true(t) = x_t(2) - k * (x_t(1) - xtarget);
x_tilde_true = x_t - x_eq;
regulation_error(:, t) = x_tilde_true;
estimation_error(:, t) = x_tilde_true - x_hat_tilde(:, t);

% --- 7. Plotting Results ---
figure('Position', [100, 100, 1200, 800]);

x_hat_full = x_hat_tilde + x_eq;

% Plot 1: State Convergence
subplot(2, 2, 1);
plot(1:T, x_true(1, :), 'b-', 'LineWidth', 1.5); hold on;
plot(1:T, x_hat_full(1, :), 'b--', 'LineWidth', 1.5);
plot(1:T, x_true(2, :), 'g-', 'LineWidth', 1.5);
plot(1:T, x_hat_full(2, :), 'g--', 'LineWidth', 1.5);
plot(1:T, x_true(3, :), 'r-', 'LineWidth', 1.5);
plot(1:T, x_hat_full(3, :), 'r--', 'LineWidth', 1.5);
yline(xtarget, 'k:', 'LineWidth', 2, 'Label', 'Target Inventory');
yline(P_star, 'k:', 'LineWidth', 2, 'Label', 'Target Price');
yline(v, 'k:', 'LineWidth', 2, 'Label', 'Target Demand');
title('State-Feedback Control with Luenberger Observer');
xlabel('Time step'); ylabel('State Values');
legend('x1 True', 'x1 Est.', 'x2 True', 'x2 Est.', 'x3 True', 'x3 Est.');
grid on; hold off;

% Plot 2: Estimation Error
subplot(2, 2, 2);
plot(1:T, estimation_error(1, :), 'b-', 'LineWidth', 1.5); hold on;
plot(1:T, estimation_error(2, :), 'g-', 'LineWidth', 1.5);
plot(1:T, estimation_error(3, :), 'r-', 'LineWidth', 1.5);
title('Estimation Error (e = x_{tilde} - x_{hat tilde})');
xlabel('Time step'); ylabel('Error');
legend('e1 (Inventory)', 'e2 (Price)', 'e3 (Demand)');
grid on; hold off;

% Plot 3: Regulation Error
subplot(2, 2, 3);
plot(1:T, regulation_error(1, :), 'b-', 'LineWidth', 1.5); hold on;
plot(1:T, regulation_error(2, :), 'g-', 'LineWidth', 1.5);
plot(1:T, regulation_error(3, :), 'r-', 'LineWidth', 1.5);
title('Regulation Error (x_{tilde} = x - x_{eq})');
xlabel('Time step'); ylabel('Error');
legend('x_{tilde}1', 'x_{tilde}2', 'x_{tilde}3');
grid on; hold off;

% For plotting, calculate the estimated output
y_hat = x_hat_full(2, :) - k * (x_hat_full(1, :) - xtarget);

% Plot 4: System Output
subplot(2, 2, 4);
plot(1:T, y_true, 'k-', 'LineWidth', 1.5); hold on;
plot(1:T, y_hat, 'm--', 'LineWidth', 1.5);
yline(y_eq, 'k:', 'LineWidth', 2, 'Label', 'Equilibrium Output');
title('System Output (y = x2 - k*(x1 - xtarget))');
xlabel('Time step'); ylabel('Output y');
legend('y (True)', 'y (Estimated)');
grid on; hold off;


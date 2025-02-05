clc

E_L = out.e_l;
E_O = out.e_psi;
Delta_w = out.delta_w_f;
Tau_Z = out.tau_z;

E_C_bar = out.e_c;
E_Obs_bar = out.e_o;
Tau_W_bar = out.tau_w;
RHO_bar = out.rho;
VX = out.v_x;

% Calculo de los RMSE
[N i] = size(E_L.Data);
rmse_el = 0;
rmse_epsi = 0;
rmse_ec = 0;
for i=1:N
    rmse_el = rmse_el+E_L.Data(i)^2;
    rmse_epsi = rmse_epsi+E_O.Data(i)^2;
    rmse_ec = rmse_ec+E_C_bar.Data(i)^2;
end
rmse_el = (rmse_el/N)^(0.5)
rmse_epsi = (rmse_epsi/N)^(0.5)
rmse_ec = (rmse_ec/N)^(0.5)

% Calculo de la velocidad vx
vx_prom = mean(VX.Data(5000:N))
vx_inc = std(VX.Data(5000:N))

% Graficas Control Lateral
figure(1)
subplot(4,1,1);
plot(E_L.Time,E_L.Data,'r','LineWidth',2)
set(gca,'FontSize',20)
ylabel('$e_l$ $(m)$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([-0.25 0.75]);
%ylim([-3.0 5.0]);
grid on;

subplot(4,1,2);
plot(E_O.Time,E_O.Data,'b','LineWidth',2)
set(gca,'FontSize',20)
ylabel('$e_{\psi}$ $(rad)$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([-0.25 0.25]);
%ylim([-0.6 0.6]);
grid on;

subplot(4,1,3);
plot(Delta_w.Time,Delta_w.Data,'m','LineWidth',2)
set(gca,'FontSize',20)
ylabel('$\delta_w$ $(rad)$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([-0.4 0.2]);
%ylim([-0.4 0.4]);
grid on;

subplot(4,1,4);
plot(Tau_Z.Time,Tau_Z.Data,'k','LineWidth',2)
set(gca,'FontSize',20)
xlabel('Tiempo $(s)$','Interpreter','latex', 'FontSize', 22)
ylabel('$\tau_z$ $(Nm)$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([-8*10^6 5*10^6]);
grid on;

% Graficas Control Longitudinal
figure(2)
subplot(5,1,1);
plot(E_C_bar.Time,E_C_bar.Data,'r','LineWidth',2)
set(gca,'FontSize',20)
ylabel('$\bar{e}_c$ $(rad/s)$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([-10.0 10.0]);
%ylim([-10 50]);
grid on;

subplot(5,1,2);
plot(E_Obs_bar.Time,E_Obs_bar.Data,'b','LineWidth',2)
set(gca,'FontSize',20)
ylabel('$\bar{e}_o$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([-0.5 0.2]);
grid on;

subplot(5,1,3);
plot(Tau_W_bar.Time,Tau_W_bar.Data,'m','LineWidth',2)
set(gca,'FontSize',20)
ylabel('$\bar{\tau}_w$ $(Nm)$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([-5000.0 10000.0]);
%ylim([-5000 30000]);
grid on;

subplot(5,1,4);
plot(RHO_bar.Time,RHO_bar.Data,'g','LineWidth',2)
set(gca,'FontSize',20)
ylabel('$\bar{\rho}$ $(rad/s)$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([0.0 15.0]);
%ylim([0 70]);
grid on;

subplot(5,1,5);
plot(VX.Time,VX.Data,'k','LineWidth',2)
set(gca,'FontSize',20)
xlabel('Tiempo $(s)$','Interpreter','latex', 'FontSize', 22)
ylabel('$v_x$ $(m/s)$','Interpreter','latex', 'FontSize', 22)
xlim([0 60]);
ylim([0.0 4.0]);
%ylim([0 20]);
grid on;
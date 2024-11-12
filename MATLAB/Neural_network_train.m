%% S1-S100
clear all
clc
path = 'Datagen/data_';
for i=61:100
    x1 = [];
    x2 = [];
    y = [];
    file = append('Datagen/data_',int2str(i),'.mat');
    load(file,'out');
    x1 = out.Tau_z.Data(1:15000);
    x2 = out.rho_ref.Data(1:15000);
    y = out.delta_w.Data(1:15000);
    name = append('Datagen/Serie_',int2str(i),'.csv');
    csvwrite(name,[x1,x2,y]);
end

% plot(x1)
% hold on
% plot(x2)
% plot(y)

%% MIN_MAX
clear all
clc
MAX_bag_x1 = [];
MIN_bag_x1 = [];
MAX_bag_x2 = [];
MIN_bag_x2 = [];
MAX_bag_y = [];
MIN_bag_y = [];
for i=1:100
    out = [];
    file_i = append('Datagen/data_',int2str(i),'.mat');
    load(file_i,'out');
    MAX_bag_x1(i) = max(out.Tau_z.Data(1:15000));
    MIN_bag_x1(i) = min(out.Tau_z.Data(1:15000));

    MAX_bag_x2(i) = max(out.rho_ref.Data(1:15000));
    MIN_bag_x2(i) = min(out.rho_ref.Data(1:15000));

    MAX_bag_y(i) = max(out.delta_w.Data(1:15000));
    MIN_bag_y(i) = min(out.delta_w.Data(1:15000)); 
end
max(MAX_bag_x1)
min(MIN_bag_x1)

max(MAX_bag_x2)
min(MIN_bag_x2)

max(MAX_bag_y)
min(MIN_bag_y)

%% Graficas
clear all
clc

x1 = [];
x2 = [];
y = [];
file = append('Datagen/data_75.mat');
load(file,'out');
x1 = out.Tau_z.Data(1:15000);
x2 = out.rho_ref.Data(1:15000);
y = out.delta_w.Data(1:15000);
t = out.tout(1:15000);

tiledlayout(3,1)

ax1 = nexttile;
plot(ax1,t,x1,'r','LineWidth',2)
title(ax1,'Tau_z')
ylabel(ax1,'Nm')

ax2 = nexttile;
plot(ax2,t,x2,'m','LineWidth',2)
title(ax2,'rho')
ylabel(ax2,'rad/s')

ax3 = nexttile;
plot(ax3,t,y,'b','LineWidth',2)
title(ax3,'delta_w')
xlabel(ax3,'s')
ylabel(ax3,'rad')
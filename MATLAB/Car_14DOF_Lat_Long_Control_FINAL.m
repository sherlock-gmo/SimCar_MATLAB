clear all 
clc
addpath(genpath('Images'));

%**************************CAMINO***************************
% drivingScenarioDesigner
load('road_FINAL.mat');
xRef = data.RoadSpecifications.Centers(:,1);
yRef = -data.RoadSpecifications.Centers(:,2);
N = length(xRef);
distancematrix = squareform(pdist([xRef,yRef]));
distancesteps = zeros(N-1,1);
for i = 2:N
    distancesteps(i-1,1) = distancematrix(i,i-1);
end
totalDistance = sum(distancesteps); % Total traveled distance
distbp = cumsum([0; distancesteps]); % Distance for each waypoint
gradbp = linspace(0,totalDistance,N); % Linearize distance
% linearize X and Y vectors based on distance
xRef2 = interp1(distbp,xRef,gradbp,'pchip');
yRef2 = interp1(distbp,yRef,gradbp,'pchip');
xRef2s = smooth(gradbp,xRef2);
yRef2s = smooth(gradbp,yRef2);
curvature = getCurvature(xRef2s,yRef2s);

%**************************PARAMETROS***************************
% Suspension
m = 1440/4; % 1/4 de la masa total del chasis [kg]
k = 32500;  % [N/m] resorte de la suspension
b = 2250;   % [Ns/m] amortiguador de la suspension
mR = 80;    % [kg] masa de cada suspension y llanta
kR = 200000;% [N/m] 'resorte' de la llanta

% Neumaticos
r0 = 0.285; % [m] radio de la llanta
rstat = 0.275; % [m] radio deformado de la llanta (reposo)
reff = 0.265;  % [m0] radio deformado de la llanta (movimiento)
Iw = 1;     % [kgm^2] momento de inercia de la llanta

% Chasis
Ix = 900;   % [kgm^2] momento de inercia X
Iy = 2000;  % [kgm^2] momento de inercia y
Iz = 2000;  % [kgm^2] momento de inercia z
lf = 1.016; % [m]         
lr = 1.524; % [m]
lh = 0.035; % [m]  
c = 1.5/2;  % [m]
d = 2*reff; % [m]
l = 0.75;   % [m]
L = lf+lr;  % [m]
lw = (2*c-0.205)/2; % [m]

% Fuerzas
f = 0.015;  % const. prop.
u = 0.9;    % coeficiente de friccion
C_alpha = u*(-45500); % [Nrad]
C_sigma = u*(5000);  % [N]
g = 9.8;    % [m/s^2]
uFz = 4500; % [N]

% velocidad de cada rueda
Ar1 = [0 -d-l -c; d+l 0 lf; c -lf 0];
Ar2 = [0 -d-l -c; d+l 0 -lr; c lr 0];
Ar3 = [0 -d-l c; d+l 0 lf; -c -lf 0];
Ar4 = [0 -d-l c; d+l 0 -lr; -c lr 0];

% Pose inicial
x0 = xRef2s(1);
y0 = yRef2s(1);
z0 = 0;
psi0 = 88*(pi/180);

% Controlador Longitudinal (ADR)
% 100[km/h] = 27.7778[m/s] = 157.8947[rad/s]
rho_w = 19*(157.8947/100);   % [rad/s] Verl. rueda de referencia
r = 1/4;    % ratio de los engranajes de la tracccion
K1 = 800000;    % [N/s] Cota sup. de DFx
D1 = 1.0;   % [rad/s] Cota sup. del error de seguimiento
D2 = 1.0;   % Cota sup. del error de estimacion de la insertidumbre
zeta = 1.5; %1.0
wn = 0.25;  %10.0 
q = (((2*zeta*(wn^3)*(D1^2))/(K1*D2))^(1/3))*(0.99); %*(0.75)
kp = 2*zeta*wn/q;
ki = (wn^2)/(q^2);


% Controlador Lateral (LSTM+BS)
Kz1 = 1;  
Kz2 = 13; 
Kz3 = 20;

fc = 1;         % Frecuencia de corte del filtro PB en Hz
wc = 2*pi*fc;
lh_vis = 5.0;   % Distancia de observacion
C_line = linspace(-lh_vis,lh_vis,30);
% Red LSTM
model_path = '/media/sherlock2204/Alice/Mis_Documentos_R/Doctorado/Tesis/SimCar_MATLAB/python/k2.8.0/LSTM_network_k2.8.0_trained.h5';
net = importKerasNetwork(model_path);

Vx_test = 50*(27.7778/100);

%% Curvature Function

function curvature = getCurvature(xRef,yRef)
% Calculate gradient by the gradient of the X and Y vectors
DX = gradient(xRef);
D2X = gradient(DX);
DY = gradient(yRef);
D2Y = gradient(DY);
curvature = (DX.*D2Y - DY.*D2X) ./(DX.^2+DY.^2).^(3/2);
end
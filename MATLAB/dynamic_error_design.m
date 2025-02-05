clear all
clc

syms y(x)
zeta = 50.0; %1.5
wn = 150.0;  %0.25 
kp = 2*zeta*wn;
ki = (wn^2);
roots([1 kp ki])
ode = diff(y,x,2)+kp*x*diff(y,x)+ki*y == 0;
Dy = diff(y,x);
cond = [Dy(0) == -5; y(0) == 5];
ySol(x) = dsolve(ode,cond);
%fplot(ySol,[0 10])

%hold on
num = [kp ki];
den = [1 kp ki];
F = tf(num,den);
step(F)

vp = eig([[-kp 1];[-ki 0]])
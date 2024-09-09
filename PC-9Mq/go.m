clear;

global wchord wspan CD S Cyb CydR CLa CLdE Clp CldA Cma Cmq CmdE Cnb Cnr CndR g m invI I;

load PC-9M_SI.in

I = [
    [Ixx,-Ixy,-Ixz];
    [-Ixy,Iyy,-Iyz];
    [-Ixz,-Iyz,Izz]
    ];
invI = inv(I);

phi = 0.; theta = 0.; psi = -180.*pi/180.;
quat = eul2Quat([psi,theta,phi],'ZYX');

t = linspace(0.,30.,600);
%    [u=40., v, w, p, q, r, quat]
ic = [140.,0.,0.,0.,0.,0.,quat];
[t,x] = ode45(@(t,x)f(t,x),t,ic);

for i = 1:size(t)(1)

  quat = [x(i,7),x(i,8),x(i,9),x(i,10)];
  [CBLL] = dcm(quat);

  % phi, theta, psi
  eul(i,:) = quat2Eul(quat);

  u = x(i,1); v = x(i,2); w = x(i,3);
  xbdot(i,:) = CBLL*[u,v,w]';

endfor

xb = cumtrapz(t,xbdot(:,1));
yb = cumtrapz(t,xbdot(:,2));
zb = cumtrapz(t,xbdot(:,3));

figure(1);
plot3(xb,yb,-zb,'-','linewidth',2);
set(gca, 'FontSize',14);
xlabel('X, m'); ylabel('Y, m'); zlabel('Z, m');
grid on
axis equal
%{
figure(2);
plot(t,wrapToPi(eul(:,1))*180./pi,'LineWidth',2);
set(gca, 'FontSize',14);
xlabel('time, s'); ylabel('Roll, deg');
grid on

figure(3);
plot(t,wrapToPi(eul(:,2))*180./pi,'LineWidth',2);
set(gca, 'FontSize',14);
xlabel('time, s'); ylabel('Pitch, deg');
grid on

figure(4);
plot(t,wrapToPi(eul(:,3))*180./pi,'LineWidth',2);
set(gca, 'FontSize',14);
xlabel('time, s'); ylabel('Yaw, deg');
grid on
%}
csvwrite('../trajectory/x.csv', [xb,yb,zb,x(:,1:6),eul(:,1:3)]);

function [xdot] = f(t,x)

  global wchord wspan CD S Cyb CydR CLa CLdE Clp CldA Cma Cmq CmdE Cnb Cnr CndR g m invI I;

  V = x(1:3);
  u = V(1); v = V(2); w = V(3);
  W = x(4:6);
  p = W(1); q = W(2); r = W(3);
  quat = [x(7),x(8),x(9),x(10)];

  rho = 1.293;
  V2 = u^2 + v^2 + w^2;
  qdyn = 0.5*rho*V2;
  damp = wchord/(2.*sqrt(V2));

  a = atan2(w, u);
%  b = atan2(v, u);
  b = asin(v/sqrt(V2));

  [dE,dA,dR,T] = controls(t);

  Cy = Cyb*b + CydR*dR;
  Fy = Cy*qdyn*S;
  Cz0 = 0.115; % Tweak here to get it right! Also, see Snowden!
%  AOA limiter, recoverable spin only
%  if (a > 30.*pi/180.); CLa = 0.; else; CLa += 0.; end
  Cz = -Cz0 - CLa*a + CLdE*dE;
  Fz = Cz*qdyn*S;
  Cx = -CD; % To be computed in terms of lift coefficient Cz!
  Fx = Cx*qdyn*S;

  Cl = Clp*p*damp + CldA*dA;
  Mx = Cl*qdyn*S*wspan;
  Cm = Cma*a + Cmq*q*damp + CmdE*dE;
  My = Cm*qdyn*S*wchord;
  Cn = Cnb*b  + Cnr*r*damp + CndR*dR;
  Mz = Cn*qdyn*S*wspan;

  Fx += T;

  F = [Fx,Fy,Fz]';
  M = [Mx,My,Mz]';

  [CBLL] = dcm(quat);
  CLLB = CBLL';

  G = CLLB*[0.,0.,m*g]';
  F += G;

  vdot = F/m - cross(W,V);
  wdot = invI*(M - cross(W,I*W));

  q0 = quat(1); q1 = quat(2); q2 = quat(3); q3 = quat(4);
  quatdot = [
            [-q1, -q2, -q3],
            [q0, -q3, q2],
            [q3, q0, -q1],
            [-q2, q1, q0]
            ]*[p,q,r]'*0.5;

  xdot = [vdot;wdot;quatdot];

endfunction

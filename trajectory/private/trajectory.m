function [M] = trajectory(X);

  load pc-21;

  V = [V(:,1) V(:,2) V(:,3)];
  V(:,1) = V(:,1) + 5000.;
  V(:,3) = V(:,3) - 1000.;

  corr = max(abs(V(:,1)));
  V = V./(0.0025*corr);

  p = patch('faces', F, 'vertices', V, ...
  'facecolor', [0.8 0.8 1.0], ...
  'EdgeColor', 'none', ...
  'FaceLighting', 'gouraud', ...
  'AmbientStrength', 0.15);

  camlight('headlight');
  material('dull');

  x = X(:,1); y = X(:,2); z = -X(:,3);

  hold on;
  plot3(x,y,z);
%  lighting gouraud;
  grid on;
  axis('image');
  view([-135 35]);

  V0 = V;
  sX = size(x);
  sV = size(V0);
  for i = 1:5:sX(1)

    phi = -X(i,10); theta = -X(i,11); psi = X(i,12);
%{
    T = [cos(psi)*cos(theta), -sin(psi)*cos(theta), sin(theta);
         cos(psi)*sin(theta)*sin(phi) + sin(psi)*cos(phi) ...
        -sin(psi)*sin(theta)*sin(phi)+cos(psi)*cos(phi) ...
        -cos(theta)*sin(phi);
        -cos(psi)*sin(theta)*cos(phi)+sin(psi)*sin(phi) ...
         sin(psi)*sin(theta)*cos(phi)+cos(psi)*sin(phi) ...
         cos(theta)*cos(phi)];
%}
    quat = eul2Quat([psi,theta,phi],'ZYX');
    [CBLL] = dcm(quat);
    T = CBLL;

    V1 = T*V0';

    X1 = repmat([x(i),y(i),z(i)],sV(1),1);
    V2 = V1' + X1;

    clf;
    p = patch('faces', F, 'vertices', V2);
    set(p, 'facecolor', [0.8 0.8 1.0]);
    set(p, 'EdgeColor', 'none');
    set(p, 'FaceLighting', 'gouraud');
    set(p, 'AmbientStrength', 0.15);
    grid on;
    axis('image');
    view([-135 35]);
    camlight('headlight');
    material('dull');
    hold on;
    plot3(x,y,z,'LineWidth',2);
    pause(0.05);

  end

%{
  V(:,1) += x(150);
  V(:,2) += y(150);
  V(:,3) += z(150);

  p = patch('faces', F, 'vertices', V, ...
  'facecolor', [0.8 0.8 1.0], ...
  'EdgeColor', 'none', ...
  'FaceLighting', 'gouraud', ...
  'AmbientStrength', 0.15);

  xlabel('X');
  ylabel('Y');
  zlabel('Z');
  title('Spin');
%}
  M = 0;
end

function testings()
  [x y] = meshgrid( linspace(-3,3,50), linspace(-5,5,50) );
  z = exp(-x.^2-0.5*y.^2).*cos(4*x) + exp(-3*((x+0.5).^2+0.5*y.^2));
  idx = ( abs(z)>0.001 );
  z(idx) = 0.001 * sign(z(idx)); 

  figure('renderer','opengl')
  patch(surf2patch(surf(x,y,z)), 'FaceColor','interp');
  set(gca, 'Box','on', ...
    'XColor',[.3 .3 .3], 'YColor',[.3 .3 .3], 'ZColor',[.3 .3 .3], 'FontSize',8)
  title('$e^{-x^2 - \frac{y^2}{2}}\cos(4x) + e^{-3((x+0.5)^2+\frac{y^2}{2})}$', ...
    'Interpreter','latex', 'FontSize',12) 

  view(35,65)
  colormap( [flipud(cool);cool] )
  camlight headlight, lighting phong

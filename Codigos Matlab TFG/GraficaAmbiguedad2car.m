% elecccion de estados q(k)(Px1,Py1,Px2,Py2) u(k)=[Vx1,Vy1,Vx2,Vy2]

% Definicion de matrices 
F=eye(4);
% H=eye(4);
H=[1,0,0,0;0,1,0,0;0,0,0,0;0,0,0,0];
dt=0.05;
G=eye(4)*dt;
% tiempo de simulacion
t=5 %segundos 


% entrada 
%Vx1=1:(1/50):9-1/50 %cm/s
Vx1=5*ones(1,400)
Vy1=5*ones(1,400) %cm/s
Vx2=3*ones(1,400) %cm/s 
%Vy2=-9:(1/100):-5-1/100 %cm/s
Vy2=-5*ones(1,400)
u=[Vx1;Vy1;Vx2;Vy2]
%insertidumbre de medida

sigmaV=(10)%cm/s
sigmaP=(1) %cm/s

%Matriz de incertidumbre inicial (P(0))

P=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];

Pmedidad=eye(4)*sigmaP^2 %incetidumbre de medida
Pmedida_distancia=1 %sigma^2 del sensor de distancia
%Matriz de estado inicial estimado 
q=[0,0,0,0]'


%Matriz de insertidumbre de entrada 
Q=eye(4)*sigmaV^2;


%Matriz de medida
%Hmes=eye(4); 
% Hmes=[1,1,0,0];

% simulación de ruta "real" 

%estado inicial real 
qreal=[normrnd(0,sigmaP),normrnd(0,sigmaP),normrnd(0,sigmaP),normrnd(0,sigmaP)]



%avance estimado

qlog=[0,0,0,0];
Plog=[0,0,0,0];
i=2

for j=dt:dt:t
     q=F*q+G*u(:,i-1);
    
    P=F*P*F'+G*Q*G'
    %Intento de correccion, no estoy seguro si funciona bien
   
    e=eig(P);
    
    qlog(i,1)=q(1);
    qlog(i,2)=q(2);
    qlog(i,3)=q(3);
    qlog(i,4)=q(4);
    
    subplot(2,1,1)
    hold off
    %punto estimado carro 1
    plot(q(1),q(2),'x')
    hold on
     %trayectoria estimada 1
    
    plot(qlog(:,1),qlog(:,2),'b.')
    hold on
    % punto estemado vehiculo 2
    plot(q(3),q(4),'gx')
    hold on
     %trayectoria estimada 2
    
    plot(qlog(:,3),qlog(:,4),'g.')
    hold on

    ylabel('y(cm)')
    xlabel('x(cm)')
   
    axis('equal')
    title('Sistema en coordenadas absolutas')
    
    legend('Punto estimado V1','Trayectoria estimada V1','Punto estimado V2','Trayectoria estimada V2','Interpreter','Latex')
    
    subplot(2,1,2)
    hold off
    % Punto estimado en coordenadas relativas
    plot(q(3)-q(1),q(4)-q(2),'x')
    hold on
    plot(qlog(:,3)-qlog(:,1),qlog(:,4)-qlog(:,2),'b.')
    axis('equal')
    ylabel('y(cm)')
    xlabel('x(cm)')
    title('Sistema en coordenadas relativas')
    ylim([-50 0])
    r=sqrt((q(3)-q(1))^2+(q(4)-q(2))^2)
    
%     ellipse(r,r,0,0,0,'r')
    legend('Punto relativo estimado V21','Trayectoria relativa estimada V21','Interpreter','Latex')
    pause(0.0001)
    
    i=i+1;
end

%% Grafica de ambiguedad de corrección 
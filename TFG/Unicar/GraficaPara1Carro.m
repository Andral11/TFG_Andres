F=eye(2);
% H=eye(4);
% H=[1,0,0,0;0,1,0,0;0,0,0,0;0,0,0,0];
dt=0.05;
G=eye(2)*dt;
% tiempo de simulacion
t=20 %segundos 


% entrada 
%Vx1=1:(1/50):9-1/50 %cm/s
Vx1=5*ones(1,400)
Vy1=5*ones(1,400) %cm/s
u=[Vx1;Vy1]
%insertidumbre de medida

sigmaV=(2)%cm/s
sigmaP=(4) %cm/s

%Matriz de incertidumbre inicial (P(0))

P=[1,0;0,1];

Pmedidad=eye(2)*sigmaP^2 %incetidumbre de medida
Pmedida_distancia=1 %sigma^2 del sensor de distancia
%Matriz de estado inicial estimado 
q=[0,0]'


%Matriz de insertidumbre de entrada 
Q=eye(2)*sigmaV^2;


%Matriz de medida
%Hmes=eye(4); 
% Hmes=[1,1,0,0];

% simulación de ruta "real" 

%estado inicial real 
% qreal=[normrnd(0,sigmaP),normrnd(0,sigmaP)] % para posición inicial posible distinta a la estimada
qreal=[0,0] %posicion real igual a la estimada




%construcción de trayectoria "real" 
i=2
ureal=[normrnd(Vx1,sigmaV),normrnd(Vy1,sigmaV)];
% ureal=[Vx1,Vy1] %velocidad inicial igual que la estimda
for j=dt:dt:t
    %velocidad en el instante k 
    
    %posicion en el instante k+1
    qreal(i,1)=qreal(i-1,1)+ureal(1,1)*dt;
    qreal(i,2)=qreal(i-1,2)+ureal(1,2)*dt;
    i=i+1;
end 

%%Plot de ruta real
 
%avance estimado

qlog=[0,0];
Plog=[0,0];
i=2
cont=1
for j=dt:dt:t
     q=F*q+G*u(:,i-1);
    
    P=F*P*F'+G*Q*G'
    %Intento de correccion, no estoy seguro si funciona bien
     if (mod(i,50)==0) %%si llega una medida de posición
       H=[1 0;
            0 1];
        H1=[1,0]
        H2=[0,1]
        Pmedida_distancia=eye(2) 
        Py=H*P*H' %covarianza de la distancia estimada a partir de las posiciones estimadas
        S=Pmedida_distancia+Py
            
        K=P*H'*S^-1
        P
        P=P-K*H*P
        yhatm=[qreal(i,1);qreal(i,2)];
        
        q=q+K*(yhatm-H*q)
        cont=cont+1
     end
    e=eig(P);
    
    qlog(i,1)=q(1);
    qlog(i,2)=q(2);
   
%     Plog(i,1)=P(1,1);
%     Plog(i,2)=P(2,2);
    
    hold off
    
    % punto real carro 1
    plot(qreal(i,1),qreal(i,2),'r*')
    hold on
    %trayectoria real carro 1
    plot(qreal(:,1),qreal(:,2),'r.')
    hold on
    %punto estimado carro 1
    plot(q(1),q(2),'bx')
    hold on
    %trayectoria estimada
    
    plot(qlog(:,1),qlog(:,2),'b.')
    hold on
    
    %desviación tipica de carro 1
      H=[1 0;0 1];
      XY = elipse_P(q(1),q(2),P,H);
      plot(XY(:,1), XY(:,2), '-')
      hold on
   
   
    ylabel('y(cm)')
    xlabel('x(cm)')
    
    pause(0.001);
    axis('equal')
    
    i=i+1;
end
legend('Posici\''on real','Posible trayectoria real','Posici\''on estimada','Trayectoria estimada','Interpreter','Latex')
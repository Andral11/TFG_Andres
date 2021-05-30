% elecccion de estados q(k)(Px12,Py12,Px13,Py13) u(k)=[Vx12,Vy12,Vx13,Vy13]
figure;
% Definicion de matrices 
F=eye(4);
% H=eye(4);
dt=0.01;
G=[dt 0 0 0; 0 dt 0 0; 0 0 dt 0; 0 0 0 dt]

% tiempo de simulacion
t=4 %segundos 
% entrada 
%Vx1=1:(1/50):9-1/50 %cm/s
taux=dt:dt:t
Vx21=1*ones(1,400)
Vy21=3*ones(1,400) %cm/s
Vx31=1*ones(1,400) %cm/s 
%Vy2=-9:(1/100):-5-1/100 %cm/s
Vy31=-3*ones(1,400)
u=[Vx21;Vy21;Vx31;Vy31]

%insertidumbre de entrada

sigmaV=(10)%cm/s
sigmaP=1.1 %cm
Q=eye(4)*sigmaV^2;
% Q(2,2)=0

% posiciones relativas reales iniciales
qreal=[normrnd(5,sigmaP),normrnd(0,sigmaP),normrnd(4,sigmaP),normrnd(-5,sigmaP)]'

%construcción de trayectoria "real" 
i=2

for j=dt:dt:t
    %velocidad en el instante k
    qreal(:,i)=F*qreal(:,i-1)+G*u(:,1);
    
    
    i=i+1;
end 

%posiciones relativas estimadas iniciales

q=[5,0,4,-5]'
P=eye(4)*1
qlog=[0,0,0,0];
Plog=[0,0,0,0];
i=2

for j=dt:dt:t
     q=F*q+G*u(:,i-1);
    
    P=F*P*F'+G*Q*G'
    %Intento de correccion, no estoy seguro si funciona bien
    if (mod(i,100)==0) %%si llega una medida de posición
        % dos correcciones 
        % correción de posición relativa carro 1
        Pmedida_distancia=eye(3);
        H3hector=[q(1)-q(3),q(2)-q(4),-q(1)+q(3),-q(2)+q(4)]
        H3prueba= [q(1)-2*q(3),q(2)-2*q(4),q(3),q(4)]
        H=[q(1),q(2),0,0;
           0,0,q(3),q(4);
           H3hector]
          
        
%         H=[q(1),q(2),0,0]
        Py=H*P*H' %covarianza de la distancia estimada a partir de las posiciiones estimadas
        S=Pmedida_distancia+Py
            
        K=P*H'*S^-1
        P
        P=P-K*H*P
        yhatm=[qreal(1,i)^2+qreal(2,i)^2;
               ;qreal(3,i)^2+qreal(4,i)^2;
               (qreal(3,i)-qreal(1,i))^2+(qreal(4,i)-qreal(2,i))^2]
%         yhatm=[qreal(i,1)^2+qreal(i,2)^2;qreal(i,3)^2+qreal(i,4)^2;(qreal(i,3)-qreal(i,1))^2+(qreal(i,4)-qreal(i,2))^2]
        q=q+K*(yhatm-H*q)
        pause();
        % correción de posición relativa carro 2
%         H=[-q(1),-q(2),q(3),q(4)]
%         Py=H*P*H' %covarianza de la distancia estimada a partir de las posiciiones estimadas
%         S=Pmedida_distancia+Py
%             
%         K=P*H'*S^-1
%         P
%         P=P-K*H*P
%         yhatm=qreal(i,3)^2+qreal(i,4)^2
%         q=q+K*(yhatm-H*q)
    end
%     [V,D]=eig(P);
%     P*V-V*D
    e=eig(P);
    qlog(i,1)=q(1);
    qlog(i,2)=q(2);
    qlog(i,3)=q(3);
    qlog(i,4)=q(4);
    Plog(i,1)=P(1,1);
    Plog(i,2)=P(2,2);
    Plog(i,3)=P(3,3);
    Plog(i,4)=P(4,4);
    hold off
    %punto estimado carro 1
    plot(q(1),q(2),'x')
    hold on
    %trayectoria real carro 1
    plot(qreal(1,:),qreal(2,:),'r')
    hold on
    % punto real carro 1
    plot(qreal(1,i),qreal(2,i),'r*')
    hold on
    % punto estimado carro 1 
    plot(q(3),q(4),'gx')
    hold on
    % trayectoria real carro 2
    plot(qreal(3,:),qreal(4,:),'k')
    %punto real carro 2
    hold on
    plot(qreal(3,i),qreal(4,i),'k*')
    ylabel('y(cm)')
    xlabel('x(cm)')
%     xline(qreal(150,1))
%     xline(qreal(300,1))
    
%     %desviación tipica de carro 1
      H=[1 0 0 0;0 1 0 0];
      XY = elipse_P(q(1),q(2),P,H);
      plot(XY(:,1), XY(:,2), '-')
      hold on
    % desviacion tipica carro 2
      H=[0 0 1 0;0 0 0 1];
      XY = elipse_P(q(3),q(4),P,H);
      plot(XY(:,1), XY(:,2), '-')
      hold on
    axis('equal')
    pause(0.001)

%grafica de distancia de la trayectoria real


    i=i+1;
end

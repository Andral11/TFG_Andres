% elecccion de estados q(k)(Px12,Py12,Px13,Py13) u(k)=[Vx12,Vy12,Vx13,Vy13]

% Definicion de matrices 
F=eye(4);
% H=eye(4);
dt=0.05;
G=[dt 0 0 0; 0 dt 0 0; 0 0 dt 0; 0 0 0 dt]

% tiempo de simulacion
t=20 %segundos 
% entrada 
%Vx1=1:(1/50):9-1/50 %cm/s
taux=dt:dt:t
Vx21=2*ones(1,400)
Vy21=1*ones(1,400) %cm/s
Vx31=3*ones(1,400) %cm/s 
%Vy2=-9:(1/100):-5-1/100 %cm/s
Vy31=-5*ones(1,400)
u=[Vx21;Vy21;Vx31;Vy31]

%insertidumbre de entrada

sigmaV=(1)%cm/s
sigmaP=1 %cm
Q=eye(4)*sigmaV^2;
% Q(2,2)=0

% posiciones relativas reales iniciales
qreal=[normrnd(5,sigmaP),normrnd(0,sigmaP),normrnd(4,sigmaP),normrnd(-5,sigmaP)]

%construcci�n de trayectoria "real" 
i=2

for j=dt:dt:t
    %velocidad en el instante k 
    ureal=[normrnd(Vx21(i-1),sigmaV),normrnd(Vy21(i-1),sigmaV),normrnd(Vx31(i-1),sigmaV),normrnd(Vy31(i-1),sigmaV)];
    %posicion en el instante k+1
    qreal(i,1)=qreal(i-1,1)+ureal(1,1)*dt;
    qreal(i,2)=qreal(i-1,2)+ureal(1,2)*dt;
    qreal(i,3)=qreal(i-1,3)+ureal(1,3)*dt;
    qreal(i,4)=qreal(i-1,4)+ureal(1,4)*dt;
    i=i+1;
end 

%posiciones relativas estimadas iniciales

q=[5,0,4,-5]'
P=eye(4)*0
qlog=[0,0,0,0];
Plog=[0,0,0,0];
i=2

for j=dt:dt:t
     q=F*q+G*u(:,i-1);
    
    P=F*P*F'+G*Q*G'
    %Intento de correccion, no estoy seguro si funciona bien
    if (mod(i,50)==0) %%si llega una medida de posici�n
        % dos correcciones 
        % correci�n de posici�n relativa carro 1
        Pmedida_distancia=eye(3);
        H=[q(1),q(2),0,0;
           0,0,q(3),q(4);
           q(1)-q(3),q(2)-q(4),-q(1)+q(3),-q(2)+q(4)]
          
        H3prueba= [q(1)-2*q(3),q(2)-2*q(4),q(3),q(4)]
%         H=[q(1),q(2),0,0]
        Py=H*P*H' %covarianza de la distancia estimada a partir de las posiciiones estimadas
        S=Pmedida_distancia+Py
            
        K=P*H'*S^-1
        P
        P=P-K*H*P
        yhatm=[qreal(i,1)^2+qreal(i,2)^2]
%         yhatm=[qreal(i,1)^2+qreal(i,2)^2;qreal(i,3)^2+qreal(i,4)^2;(qreal(i,3)-qreal(i,1))^2+(qreal(i,4)-qreal(i,2))^2]
        q=q+K*(yhatm-H*q)
        % correci�n de posici�n relativa carro 2
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
    plot(qreal(:,1),qreal(:,2),'r')
    hold on
    % punto real carro 1
    plot(qreal(i,1),qreal(i,2),'r*')
    hold on
    % punto estimado carro 1 
    plot(q(3),q(4),'gx')
    hold on
    % trayectoria real carro 2
    plot(qreal(:,3),qreal(:,4),'k')
    %punto real carro 2
    hold on
    plot(qreal(i,3),qreal(i,4),'k*')
    ylabel('y(cm)')
    xlabel('x(cm)')
%     xline(qreal(150,1))
%     xline(qreal(300,1))
    
    %desviaci�n tipica de carro 1
    ellipse(sqrt(e(2)),sqrt(e(1)),0,q(1),q(2))
    hold on
    % desviacion tipica carro 2
    ellipse(sqrt(e(3)),sqrt(e(4)),0,q(3),q(4),'g')
    axis('equal')
    pause(0.0001)
    i=i+1;
end

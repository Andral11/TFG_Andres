% Prueba de sistema 

F=eye(6);

% H=eye(4);

dt=0.05;
G=[eye(4);-1 0 1 0;0 -1 0 1]*dt

t=20 %segundos 
% entrada 
%Vx1=1:(1/50):9-1/50 %cm/s
taux=dt:dt:t
Vx21=2*ones(1,400)
Vy21=0*ones(1,400) %cm/s
Vx31=3*ones(1,400) %cm/s 
%Vy2=-9:(1/100):-5-1/100 %cm/s
Vy31=-5*ones(1,400)
u=[Vx21;Vy21;Vx31;Vy31]

%insertidumbre de entrada

sigmaV=(10)%cm/s
sigmaP=1 %cm
Q=eye(4)*sigmaV^2;
Q(2,2)=0

% posiciones relativas reales iniciales
qreal=[normrnd(5,sigmaP),0,normrnd(4,sigmaP),normrnd(-5,sigmaP)]
qreal=[qreal,qreal(3)-qreal(1),qreal(4)-qreal(2)]
%construcción de trayectoria "real" 
i=2

for j=dt:dt:t
    %velocidad en el instante k 
    ureal=[normrnd(Vx21(i-1),sigmaV),0,normrnd(Vx31(i-1),sigmaV),normrnd(Vy31(i-1),sigmaV)];
    ureal=[ureal,ureal(3)-ureal(1),ureal(4)-ureal(2)]
    %posicion en el instante k+1
    qreal(i,1)=qreal(i-1,1)+ureal(1,1)*dt;
    qreal(i,2)=qreal(i-1,2)+ureal(1,2)*dt;
    qreal(i,3)=qreal(i-1,3)+ureal(1,3)*dt;
    qreal(i,4)=qreal(i-1,4)+ureal(1,4)*dt;
    qreal(i,5)=qreal(i-1,5)+ureal(1,5)*dt;
    qreal(i,6)=qreal(i-1,6)+ureal(1,6)*dt;
    i=i+1;
end 

P=eye(6)*0
q=[5,0,4,-5,4-5,-5]'
Pmedida_distancia=1
qlog=[0,0,0,0];
i=2
for j=dt:dt:t
    q=F*q+G*u(:,i-1);
    P=F*P*F'+G*Q*G'
    %Intento de correccion, no estoy seguro si funciona bien
    if (mod(i,50)==0) %%si llega una medida de posición
        % dos correcciones 
        % correción de posición relativa carro 1
        H=[q(1),q(2),0,0,0,0;
           0,0,q(3),q(4),0,0;
           0,0,0,0,q(5),q(6);
           0,0,q(5)/q(3),q(6)/(4),0,0]
       
        Py=H*P*H' %covarianza de la distancia estimada a partir de las posiciiones estimadas
        S=Pmedida_distancia+Py
            
        K=P*H'*S^-1
        P
        P=P-K*H*P
        yhatm=[qreal(i,1)^2+qreal(i,2)^2]
%         yhatm=[qreal(i,1)^2+qreal(i,2)^2;qreal(i,3)^2+qreal(i,4)^2;(qreal(i,3)-qreal(i,1))^2+(qreal(i,4)-qreal(i,2))^2]
        q=q+K*(yhatm-H*q)
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
    qlog(i,1)=q(1);
    qlog(i,2)=q(2);
    qlog(i,3)=q(3);
    qlog(i,4)=q(4);
    
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
    hold off
    i=i+1;
    pause(0.1);
    
end
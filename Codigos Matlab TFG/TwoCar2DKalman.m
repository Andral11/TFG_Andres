% elecccion de estados q(k)(Px1,Py1,Px2,Py2) u(k)=[Vx1,Vy1,Vx2,Vy2]

% Definicion de matrices 
F=eye(4);
% H=eye(4);
H=[1,0,0,0;0,1,0,0;0,0,0,0;0,0,0,0];
dt=0.05;
G=eye(4)*dt;
% tiempo de simulacion
t=20 %segundos 


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





%construcción de trayectoria "real" 
i=2

for j=dt:dt:t
    %velocidad en el instante k 
    ureal=[normrnd(Vx1(i-1),sigmaV),normrnd(Vy1(i-1),sigmaV),normrnd(Vx2(i-1),sigmaV),normrnd(Vy2(i-1),sigmaV)];
    %posicion en el instante k+1
    qreal(i,1)=qreal(i-1,1)+ureal(1,1)*dt;
    qreal(i,2)=qreal(i-1,2)+ureal(1,2)*dt;
    qreal(i,3)=qreal(i-1,3)+ureal(1,3)*dt;
    qreal(i,4)=qreal(i-1,4)+ureal(1,4)*dt;
    i=i+1;
end 

%%Plot de ruta real

% carro 1
plot(qreal(:,1),qreal(:,2))
hold on
% carro 2
plot(qreal(:,3),qreal(:,4))
 
%avance estimado

qlog=[0,0,0,0];
Plog=[0,0,0,0];
i=2

for j=dt:dt:t
     q=F*q+G*u(:,i-1);
    
    P=F*P*F'+G*Q*G'
    %Intento de correccion, no estoy seguro si funciona bien
    if (mod(i,50)==0) %%si llega una medida de posición
        H=[q(1),q(2),0,0]
        Py=H*P*H' %covarianza de la distancia estimada a partir de las posiciones estimadas
        S=Pmedida_distancia+Py
            
        K=P*H'*S^-1
        P
        P=P-K*H*P
        yhatm=qreal(i,1)^2+qreal(i,2)^2
        q=q+K*(yhatm-H*q)
    end
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
    
    %desviación tipica de carro 1
    ellipse(sqrt(e(1)),sqrt(e(2)),0,q(1),q(2))
    hold on
    % desviacion tipica carro 2
    ellipse(sqrt(e(3)),sqrt(e(4)),0,q(3),q(4),'g')
    axis('equal')
    pause(0.0001)
    i=i+1;
end

%% version del sistema en coordenadas relativas 
% incertidumbre relatvia inicial
Prel=[2,0;0,2]
% incertidumbre de medida relativa sigma_a^2+sigma_b^2
Prelmed=[sigmaP^2*2,0;0,sigmaP^2*2]
Pmedida_distancia=1
% incertidumbre de la entrada relativa
Qrel=[sigmaV^2*2,0;0,sigmaV^2*2]
%Estados: posiciones relativas
F=[1,0;0,1] 
G=[dt,0;0,dt]
%estado inicial P21x=0 P21y=0
qrel=[0,0]';
%posición relativa "real": Extraida de la seccion de codigo anterior 
auxX=qreal(:,3)-qreal(:,1)
auxY=qreal(:,4)-qreal(:,2)
qrelreal(:,1)=auxX
qrelreal(:,2)=auxY
urel=[u(3)-u(1);u(4)-u(2)];
i=2
for j=dt:dt:t
     qrel=F*qrel+G*urel;
    
     
     
     
    Prel=F*Prel*F'+G*Qrel*G';
    %Intento de corrección, no se si esta funcionando correctamente
    if (mod(i,50)==0) %%si llega una medida de posición
        
        H=[qrel(1),qrel(2)]
        Py=H*Prel*H' %covarianza de la distancia estimada a partir de las posiciiones estimadas
        S=Pmedida_distancia+Py
            
        K=Prel*H'*S^-1
        Prel
        Prel=Prel-K*H*Prel
        yhatm=qrelreal(i,1)^2+qrelreal(i,2)^2
       
        qrel=qrel+K*(yhatm-H*qrel)
%         S=Pmedida+P
%         
%         K=P*H'*S^-1
%         P=P-K*H*P
%         q=q+K*(qreal(i,:)'-H*q)
    end
    e=eig(Prel);
    
    qrellog(i,1)=q(1);
    qrellog(i,2)=qrel(2);
  
    Prellog(i,1)=P(1,1);
    Prellog(i,2)=P(2,2);
   
    hold off
    %punto estimado de posicion relativa carro 2
    plot(qrel(1),qrel(2),'x')
    hold on
    %trayectoria real en coordenadas relativas carro 2
    plot(qrelreal(:,1),qrelreal(:,2),'r')
    hold on
    % punto real en coordenadas relativas de carro 2
    plot(qrelreal(i,1),qrelreal(i,2),'r*')
    hold on
    
    ylabel('y(cm)')
    xlabel('x(cm)')
%     xline(qreal(150,1))
%     xline(qreal(300,1))
    
    %desviación tipica relativa
    ellipse(sqrt(e(1)),sqrt(e(2)),0,qrel(1),qrel(2))
    hold on
    yhatm=qrelreal(i,1)^2+qrelreal(i,2)^2;
     ellipse(sqrt(yhatm),sqrt(yhatm),0,0,0)
        hold on
        
    axis('equal')
    pause(0.0001)
    i=i+1;
end
%% Intento aceleración 

% elecccion de estados q(k)(Px1,Py1,Px2,Py2) u(k)=[Vx1,Vy1,Vx2,Vy2]

% Definicion de matrices 
F=eye(4);
% H=eye(4);
H=[1,0,0,0;0,1,0,0;0,0,0,0;0,0,0,0];
dt=0.05;
G=eye(4)*dt;

% entrada 
Vx1=5 %cm/s
Vy1=5 %cm/s
Vx2=3 %cm/s 
Vy2=-5 %cm/s
u=[Vx1;Vy1;Vx2;Vy2]
%insertidumbre de medida

sigmaV=(10)%cm/s
sigmaP=(1) %cm/s

%Matriz de incertidumbre inicial (P(0))

P=[1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
Pmedida=eye(4)*sigmaP^2 %incetidumbre de medida

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




% tiempo de simulacion
t=20 %segundos 

%construcción de trayectoria "real" 
i=2

for j=dt:dt:t
    %velocidad en el instante k 
    ureal=[normrnd(Vx1,sigmaV),normrnd(Vy1,sigmaV),normrnd(Vx2,sigmaV),normrnd(Vy2,sigmaV)];
    %posicion en el instante k+1
    qreal(i,1)=qreal(i-1,1)+ureal(1,1)*dt;
    qreal(i,2)=qreal(i-1,2)+ureal(1,2)*dt;
    qreal(i,3)=qreal(i-1,3)+ureal(1,3)*dt;
    qreal(i,4)=qreal(i-1,4)+ureal(1,4)*dt;
    i=i+1;
end 

%%Plot de ruta real

% carro 1
plot(qreal(:,1),qreal(:,2))
hold on
% carro 2
plot(qreal(:,3),qreal(:,4))
 
%avance estimado

qlog=[0,0,0,0];
Plog=[0,0,0,0];
i=2

for j=dt:dt:t
     q=F*q+G*u;
    
    P=F*P*F'+G*Q*G';
    %Intento de correccion, no estoy seguro si funciona bien
%     if (mod(i,150)==0) %%si llega una medida de posición
%         S=Pmedida+P
%         K=P*H'*S^-1
%         P=P-K*H*P
%         q=q+K*(qreal(i,:)'-H*q)
%     end
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
    
    %desviación tipica de carro 1
    ellipse(sqrt(e(1)),sqrt(e(2)),pi/8,q(1),q(2))
    hold on
    % desviacion tipica carro 2
    ellipse(sqrt(e(3)),sqrt(e(4)),pi/8,q(3),q(4),'g')
    pause(0.0001)
    i=i+1;
end


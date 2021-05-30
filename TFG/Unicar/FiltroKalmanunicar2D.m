%sistema de 1 vehiculo posiciones X e Y con velocidad como entrada
A=[1,0;0,1];
dt=0.001;
B=[dt,0;0,dt];
C=[1,0;0,1];
D=0;
ve=ss(A,B,C,D,dt);

t=0:dt:2;
vt=[t.^2',ones(length(t),1)];
[ys,t,x]=lsim(ve,vt,t);
% [ys,t,x]=step(ve,t);

%% Version filtro de kalman 
F=[1,0;0,1];
dt=0.1;
t=100 %segundos 
G=[dt,0;0,dt];
Hobs=[1,0;0,1];
D=0;
q=[0;0];
sigma2_V=(10)^2 %cm/s
sigma2_P=(1)^2 %cm
% valores iniciales de estaods
P=[1,0;0,1]; % matriz de covarianza inicial
Hmes=[1,0;0,1]; %% llegan medidas de x e y
Vx=0.5*100
Vy=Vx
u=[Vx;Vy];
Q=[sigma2_V,0;0,sigma2_V];
Pmedida=[sigma2_P,0;0,sigma2_P]
qlog=[0;0];
i=1;
%velocidad real 
vx=0.42*100
vy=0.45*100
ttotal=0:dt:t
xreal=vx*ttotal
yreal=vy*ttotal
qmedido=[xreal;yreal]

%iteraciones 
for j=dt:dt:t
    q=F*q+G*u;
    
    P=F*P*F'+G*Q*G';
    if (mod(i,400)==0) %%si llega una medida de posición
        S=Pmedida+P
        K=P*Hobs'*S^-1
        P=P-K*Hobs*P
        q=q+K*(qmedido(:,i)-Hobs*q)
    end
    e=eig(P);
    i=i+1;
    qlog(1,i)=q(1);
    qlog(2,i)=q(2);
    hold off
    plot(q(1),q(2),'x')
    hold on
    plot(qmedido(1,i),qmedido(2,i),'*')
    ylabel('y(cm)')
    xlabel('x(cm)')
    xline(qmedido(1,400))
    xline(qmedido(1,800))
    axis([0 60*100 0 60*100])
    ellipse(e(1),e(2),0,q(1),q(2))
    pause(0.0001)
end
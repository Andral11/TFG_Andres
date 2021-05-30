close all
% posicion de referencia 
Z0=[0,0]

%Generación de distancias 
d10=2.2360679775
d20=2.2360679775
d12=1.41421356237

%determinacion de los angulos

angZ0=(acosd((d10^2+d20^2-d12^2)/(2*d10*d20)))
angZ2=(acosd((d12^2+d20^2-d10^2)/(2*d12*d20)))
angZ1=180-angZ0-angZ2
pause()
syms a b c x y
eqn=sqrt((sqrt(a^2-y^2)-sqrt(b^2-x^2))^2+(y-x)^2)-c
x=solve(eqn,x)
c=d12
a=d20
b=d10
x=((a^2*y + b^2*y - c^2*y + (a^2 - y^2)^(1/2)*(- a^4 + 2*a^2*b^2 + 2*a^2*c^2 - b^4 + 2*b^2*c^2 - c^4)^(1/2))/(2*a^2))
% x=(a^2*y + b^2*y - c^2*y - (a^2 - y^2)^(1/2)*(- a^4 + 2*a^2*b^2 + 2*a^2*c^2 - b^4 + 2*b^2*c^2 - c^4)^(1/2))/(2*a^2)
eqn1=abs(atan(sqrt(b^2-x^2)/x)-atan(sqrt(a^2-y^2)/y))-(angZ0/180*pi)
y=0:0.001:1
% eqn1=abs(atan(sqrt(b^2-((a^2*y + b^2*y - c^2*y + (a^2 - y.^2).^(1/2).*(- a^4 + 2*a^2*b^2 + 2*a^2*c^2 - b^4 + 2*b^2*c^2 - c^4)^(1/2))/(2*a^2)).^2)./((a^2*y + b^2*y - c^2*y + (a^2 - y.^2).^(1/2)*(- a^4 + 2*a^2*b^2 + 2*a^2*c^2 - b^4 + 2*b^2*c^2 - c^4).^(1/2))/(2*a^2)))-atan(sqrt(a^2-y.^2)./y))-(angZ0/180*pi)
% plot(y,eqn1)
%% 
% Px3=vpasolve(eqn1,y)
% Px3=fzero(fun,x0)
syms y
x=((a^2*y + b^2*y - c^2*y + (a^2 - y^2)^(1/2)*(- a^4 + 2*a^2*b^2 + 2*a^2*c^2 - b^4 + 2*b^2*c^2 - c^4)^(1/2))/(2*a^2))
Px2=double(subs(x,'y',Px3))
Py3=sqrt(a^2-Px3^2)
Py2=sqrt(b^2-Px2^2)
abs(atan(sqrt(b^2-Px3^2)/Px3)-atan(sqrt(a^2-Px2^2)/Px2))
A=[0,0]
B=[Px2,Py2]
C=[Px3,Py3]
figure
plot(A(1),A(2),'bo')
hold on
plot(abs(B(1)),abs(B(2)),'ro')
hold on
plot(abs(C(1)),abs(C(2)),'ko')
hold on
D10=double(sqrt(Px2^2+Py2^2));
d10;
D20=double(sqrt(Px3^2+Py3^2));
d20;
D12=double(sqrt((Px3-Px2)^2+(Py3-Py2)^2));
%revisar las distancias
check10=D10-d10
check20=D20-d20
check12=D12-d12
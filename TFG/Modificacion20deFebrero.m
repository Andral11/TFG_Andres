% Generacion de posiciones absolutas P(X,Y)

P1=[rand*5,rand*5]
P2=[rand*5,rand*5]
P3=[rand*5,rand*5]

%% 

flag=1
figure;
plot(P1(1),P1(2),'ro')
hold on
plot(P2(1),P2(2),'bo')
hold on
plot(P3(1),P3(2),'go')
hold on

%Calculo de distancias
d12=sqrt((P2(1)-P1(1))^2+(P2(2)-P1(2))^2)    %distancia entre P1 y P2
d13=sqrt((P3(1)-P1(1))^2+(P3(2)-P1(2))^2)     % distancia entre P1 y P3
d23=sqrt((P3(1)-P2(1))^2+(P3(2)-P2(2))^2)     %distancia entre P2 y P3
a=d12;
b=d13;
c=d23;
area=0.25*sqrt((a+b+c)*(-a+b+c)*(a-b+c)*(a+b-c))
% Posicionamiento relativo 
[P1r,P2r,P3r]=FuncionPosicionamiento(d12,d13,d23,flag,area)
plot(P1r(1),P1r(2),'r*')
hold on
plot(P2r(1),P2r(2),'b*')
hold on
plot(P3r(1),P3r(2),'g*')
d12r=sqrt((P2r(1)-P1r(1))^2+(P2r(2)-P1r(2))^2)    %distancia realativa entre P1 y P2
d13r=sqrt((P3r(1)-P1r(1))^2+(P3r(2)-P1r(2))^2)     % distancia relativa entre P1 y P3
d23r=sqrt((P3r(1)-P2r(1))^2+(P3r(2)-P2r(2))^2)     %distancia relativa entre P2 y P3
a=d12r;
b=d13r;
c=d23r;
arear=0.25*sqrt((a+b+c)*(-a+b+c)*(a-b+c)*(a+b-c))

d12-d12r
d13-d13r
d23-d23r
area-arear
%% matriz de rotacion 
flip=0
suma=[0;0]
switch flag
    case 1
        suma=[P1(2);P1(1)];
        dx=sqrt((P1(1)+d12-P2(1))^2+(P1(2)-P2(2))^2)
        alfa=acos((2*d12^2-dx^2)/2/d12^2)
        %cuadrante?
%         if(P1(1)>(P2(1)))
%             flip=1
%             dx=sqrt((P1(1)-d12-P2(1))^2+(P1(2)-P2(2))^2)
%             alfa=acos((2*d12^2-dx^2)/2/d12^2)
%         end
        
        if(P1(2)<P2(2))
            rot=2*pi-alfa;
            
        else 
            rot=alfa;
        end
    case 2
        suma=[P2(2);P2(1)];
         dx=sqrt((P2(1)+d23-P3(1))^2+(P2(2)-P3(2))^2)
        alfa=acos((2*d23^2-dx^2)/2/d23^2)
        %cuadrante?
%         if(P1(1)>(P2(1)))
%             flip=1
%             dx=sqrt((P1(1)-d12-P2(1))^2+(P1(2)-P2(2))^2)
%             alfa=acos((2*d12^2-dx^2)/2/d12^2)
%         end
        
        if(P2(2)<P3(2))
            rot=2*pi-alfa;
            
        else 
            rot=alfa;
        end
    case 3
       suma=[P3(2);P3(1)];
       
         dx=sqrt((P3(1)+d13-P1(1))^2+(P3(2)-P1(2))^2)
        alfa=acos((2*d13^2-dx^2)/2/d13^2)
        %cuadrante?
%         if(P1(1)>(P2(1)))
%             flip=1
%             dx=sqrt((P1(1)-d12-P2(1))^2+(P1(2)-P2(2))^2)
%             alfa=acos((2*d12^2-dx^2)/2/d12^2)
%         end
        
        if(P3(2)<P1(2))
            rot=2*pi-alfa;
            
        else 
            rot=alfa;
        end
end
%rotacion del triangulo para comprobar 

trianguloreal=[P1r(2),P2r(2),P3r(2);P1r(1),P2r(1),P3r(1)]

rotMATRIX=[cos(rot),-sin(rot);sin(rot),cos(rot)];
flip=0;
if(flip==1)
    trianguloreal=[-1,0;0,1]*trianguloreal 
end
trianguloreal=rotMATRIX*trianguloreal+suma
hold on
plot(trianguloreal(2,1),trianguloreal(1,1),'rx')
hold on
plot(trianguloreal(2,2),trianguloreal(1,2),'bx')

hold on
plot(trianguloreal(2,3),trianguloreal(1,3),'gx')

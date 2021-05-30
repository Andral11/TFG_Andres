% Generacion del triangulo (solo para pruebas
close all
P1=[rand*5,rand*5]
P2=[rand*5,rand*5]
P3=[rand*5,rand*5]



figure;
plot(P1(1),P1(2),'ro')
hold on
plot(P2(1),P2(2),'bo')
hold on
plot(P3(1),P3(2),'go')
hold on
% Eleccion de regla
regla=input('Derecha (0) o izquierda(1)? ')
% Eleccion de que dispositivo sera la referencia
flag=1
% Calculo de distancias (con el trinagulo generado
d12=sqrt((P2(1)-P1(1))^2+(P2(2)-P1(2))^2)    %distancia entre P1 y P2
d13=sqrt((P3(1)-P1(1))^2+(P3(2)-P1(2))^2)     % distancia entre P1 y P3
d23=sqrt((P3(1)-P2(1))^2+(P3(2)-P2(2))^2)     %distancia entre P2 y P3
% estas distancias se obtendran de las placas, se caculan en este caso para
% comprobar el funcionamiento del codigo 
a=d12;
b=d13;
c=d23;
area=0.25*sqrt((a+b+c)*(-a+b+c)*(a-b+c)*(a+b-c))
% Posicionamiento relativo 
[P1r,P2r,P3r]=FuncionPosicionamiento(d12,d13,d23,flag,area,regla)

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
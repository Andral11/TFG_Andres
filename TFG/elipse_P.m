function XY = elipse_P(xo,yo,P,H)
% Entradas
% P: matriz de convarianza, al menos de 2x2
% H: seleccionas dos estados (o dos combinaciones de ellos) para
% pintar la elipse de incertidumbre
% xo, yo: Centro de la elipse
%
% Salidas
% XY: Colección de puntos para dibujar la elipse

if(min(eig(P) <= 0))
    error("P no es positiva definida o cuadrada")
end

sizeP = size(P);
if(sizeP(1) < 2)
    error("P ha de ser al menos de 2x2")
end

sizeH = size(H);
if(sizeH(1) ~= 2)
    error("H ha de tener únicamente dos filas")
end

numXY = 100; % numero de puntos para la elipse
delta = 2*pi/numXY;
XY = zeros(numXY,2);

for t = 1:numXY
    xy(1,1) = cos((t-1)*delta);
    xy(2,1) = sin((t-1)*delta);
    
    xy = H*P*H'*xy;
    
    XY(t,1) = xy(1) + xo;
    XY(t,2) = xy(2) + yo;
end


end

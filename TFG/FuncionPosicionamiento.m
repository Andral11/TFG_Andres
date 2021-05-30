function [P1r,P2r,P3r]=FuncionPosicionamiento(d12,d13,d23,flag,area,regla)
%flag represantara cual de los puntos esta ejecutando la funcion por ende
%el punto mod4(flag +1)+1 estara inmediatamente a la derecha. 

switch flag
    case 1
        
        P1r=[0,0];
        if regla==0
            P2r=[d12,0];
        else
            P2r=[-d12,0];
        end
        h=2*area/d12
        x=sqrt(d13^2-h^2)
        P3r=[x,h];
        d23r=sqrt((P3r(1)-P2r(1))^2+(P3r(2)-P2r(2))^2);
        if(abs(d23-d23r)>10^-6)
            P3r=[-x,h];
        end
        
        
    case 2 
        
        P2r=[0,0];
        if regla==0
            P3r=[d23,0];
        else
            P3r=[-d23,0];
        end
        
        h=2*area/d23
        x=sqrt(d12^2-h^2)
        P1r=[x,h];
        d13r=sqrt((P3r(1)-P1r(1))^2+(P3r(2)-P1r(2))^2);
        if(abs(d13-d13r)>10^-6)
            P1r=[-x,h];
        end
    case 3
        P3r=[0,0];
        if regla==0
            P1r=[d13,0];
        else
            P1r=[-d13,0];
        end
        
        h=2*area/d13
        x=sqrt(d23^2-h^2)
        P2r=[x,h];
        d12r=sqrt((P2r(1)-P1r(1))^2+(P2r(2)-P1r(2))^2);
        if(abs(d12-d12r)>10^-6)
            P2r=[-x,h];
         
        end
    otherwise
        P3r=[0,0];
        P1r=[0,0];
        P2r=[0,0];
end
end
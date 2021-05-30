close all
syms x y
clear eqn1 
c=d12
a=d20
b=d10
y=0:0.00002:3.5;
i=1
eqn1(i)=0
while (imag(eqn1)==0)
        x=((a^2*y(i) + b^2*y(i) - c^2*y(i) + (a^2 - y(i).^2).^(1/2)*(- a^4 + 2*a^2*b^2 + 2*a^2*c^2 - b^4 + 2*b^2*c^2 - c^4).^(1/2))/(2*a^2));
        % x=(a^2*y(i) + b^2*y(i) - c^2*y(i) - (a^2 - y(i)^2)^(1/2)*(- a^4 + 2*a^2*b^2 + 2*a^2*c^2 - b^4 + 2*b^2*c^2 - c^4)^(1/2))/(2*a^2)
        eqn1(i)=(atand(sqrt(b^2-x.^2)./x)-atand(sqrt(a^2-y(i).^2)./y(i)))-angZ0;
        i=i+1;
end
figure
aux=max(eqn1)
p=find(eqn1==aux)
Px3=y(p)
plot(y(1:i-1),eqn1(1:i-1))
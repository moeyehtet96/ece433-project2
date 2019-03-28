clear
clc

Vdc = 200;
r = 0.1;
L = 1e-3;
f = 200;
T = 1/f;
tau = L/r;

I_max = (Vdc/r)*(1-exp(-T/(2*tau)))/(1+exp(-T/(2*tau)));
I_min = -I_max;

t = 0:T/1000:T;

for k = 1:length(t)
    if t(k) <= T/2
        V_ac(k) = Vdc;
        V_S14(k) = 0;
        V_S23(k) = V_ac(k);
        i_ac(k) = Vdc/r + (I_min - (Vdc/r))*exp(-t(k)/tau);
        i_S14(k) = i_ac(k);
        i_S23(k) = 0;
        i_dc(k) = i_ac(k);
    else
        V_ac(k) = -Vdc;
        V_S14(k) = -V_ac(k);
        V_S23(k) = 0;
        i_ac(k) = -Vdc/r + (I_max + (Vdc/r))*exp(-(t(k)-(T/2))/tau);
        i_S14(k) = 0;
        i_S23(k) = -i_ac(k);
        i_dc(k) = -i_ac(k);
    end
end

figure;
plot(t,V_ac)

figure;
plot(t,i_ac)

figure;
plot(t,V_S14)

figure;
plot(t,i_S14)

figure;
plot(t,V_S23)

figure;
plot(t,i_S23)

figure;
plot(t,i_dc)
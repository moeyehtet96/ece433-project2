clear
clc

Vac_fund = 800/pi; % magnitude of fundamental component
Vdc = Vac_fund*pi/4; % Vac_fund = Vdc*4/pi

% given quantities
r = 0.1;
L = 1e-3;
f = 200;
T = 1/f;

tau = L/r; % time constant

I_max = (Vdc/r)*(1-exp(-T/(2*tau)))/(1+exp(-T/(2*tau))); % maximum ac current
I_min = -I_max; % minimum ac current

t = 0:T/1000:T; % time vector

% loop to determine the quantities
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

% Transistor Voltages
V_T14 = V_S14;
V_T23 = V_S23;

% Diode Voltages
V_d14 = -V_S14;
V_d23 = -V_S23;

% Transistor Currents
i_T14 = i_S14 .* (i_S14 >= 0);
i_T23 = i_S23 .* (i_S23 >= 0);

% Diode Currents
i_d14 = i_S14 .* -(i_S14 <= 0);
i_d23 = i_S23 .* -(i_S23 <= 0);

figure;
ax1 = subplot(3,2,1);
plot(t,i_ac)
ylim([-300 300])
title("AC Current")
xlabel("t (s)")
ylabel("i_a_c (A)")

ax2 = subplot(3,2,2);
plot(t,i_dc)
ylim([-300 300])
title("DC Current")
xlabel("t (s)")
ylabel("i_d_c (A)")

ax3 = subplot(3,2,3);
plot(t,i_T14)
ylim([0 300])
title("Transistor 1 and 4 Current")
xlabel("t (s)")
ylabel("i_T_1_,_T_4 (A)")

ax5 = subplot(3,2,5);
plot(t,i_T23)
ylim([0 300])
title("Transistor 2 and 3 Current")
ylabel("i_T_2_,_T_3 (A)")
xlabel("t (s)")

ax4 = subplot(3,2,4);
plot(t,i_d14)
ylim([0 300])
title("Diode 1 and 4 Current")
xlabel("t (s)")
ylabel("i_d_1_,_d_4 (A)")

ax6 = subplot(3,2,6);
plot(t,i_d23)
ylim([0 300])
title("Diode 2 and 3 Current")
xlabel("t (s)")
ylabel("i_d_2_,_d_3 (A)")
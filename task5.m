% Single Phase Inverter - Sine Triangle
clear all
clc

m = 1; % modular index

V_dc = 200; % Input DC Voltage
L = 1e-3; % Load Inductance Value
r = 0.1; % Load Resistance Value
f_ac = 200; % Output AC Voltage Frequency
T_ac = 1/f_ac; % Output AC Voltage Period
f_sw = 4000; % Switching Frequency
T_sw = 1/f_sw; % Switching Period 
del_t = T_sw/100; % Time Step
t_end = 25*T_ac; % Simulation End Time

% Initializations
i_ac(1) = 0;
t(1) = 0;
d(1) = 0.5 + 0.5*m*cos(2*pi*200*t(1) - pi/2);
c(1) = d(1) > tri_gen(100,t(1),f_sw);
pos(1) = tri_gen(100,t(1),f_ac) > 0.5;
neg(1) = tri_gen(100,t(1),f_ac) <= 0.5;
V_ag(1) = c(1)*V_dc;
V_bg(1) = (1-c(1))*V_dc;
V_ac(1) = V_ag(1) - V_bg(1);
V_T14(1) = -neg(1)*V_ac(1);
V_T23(1) = pos(1)*V_ac(1);
V_d14(1) = -V_T14(1);
V_d23(1) = -V_T23(1);
i_S14(1) = pos(1)*i_ac(1);
i_S23(1) = -neg(1)*i_ac(1);
i_T14(1) = i_S14(1)*(i_S14(1) > 0);
i_T23(1) = i_S23(1)*(i_S23(1) > 0);
i_d14(1) = i_S14(1)*-(i_S14(1) <= 0);
i_d23(1) = i_S23(1)*-(i_S23(1) <= 0);
k = 1;

% Backward Euler Integration Routine
while t(k) < t_end
    d(k+1) = 0.5 + 0.5*m*cos(2*pi*f_ac*(t(k)+del_t) - pi/2);
    c(k+1) = d(k+1) > tri_gen(100,t(k)+del_t,f_sw);
    pos(k+1) = tri_gen(100,t(k)+del_t,f_ac) > 0.5;
    neg(k+1) = tri_gen(100,t(k)+del_t,f_ac) <= 0.5;
    V_ag(k+1) = c(k+1)*V_dc;
    V_bg(k+1) = (1-c(k+1))*V_dc;
    V_ac(k+1) = V_ag(k+1) - V_bg(k+1);
    i_ac(k+1) = (1/(1+(r*del_t/L))) * (i_ac(k) + del_t*V_ac(k+1)/L);
    V_T14(k+1) = -neg(k+1)*V_ac(k+1);
    V_T23(k+1) = pos(k+1)*V_ac(k+1);
    V_d14(k+1) = -V_T14(k+1);
    V_d23(k+1) = -V_T23(k+1);
    i_S14(k+1) = pos(k+1)*i_ac(k+1);
    i_S23(k+1) = -neg(k+1)*i_ac(k+1);
    i_T14(k+1) = i_S14(k+1)*(i_S14(k+1) > 0);
    i_T23(k+1) = i_S23(k+1)*(i_S23(k+1) > 0);
    i_d14(k+1) = i_S14(k+1)*-(i_S14(k+1) <= 0);
    i_d23(k+1) = i_S23(k+1)*-(i_S23(k+1) <= 0);
    t(k+1) = t(k) + del_t;
    k = k+1;
end

figure;
plot(t,V_ac)
xlim([23*T_ac 24*T_ac])
ylim([-300 300])
title("Output AC Voltage")
xlabel("t (s)")
ylabel("V_a_c (V)")

figure;
plot(t,i_ac)
xlim([23*T_ac 24*T_ac])
title("Output AC Current")
xlabel("t (s)")
ylabel("i_a_c (A)")

figure;
ax1 = subplot(4,2,1);
plot(t,V_T14)
xlim([23*T_ac 24*T_ac])
title("Transistor 1 and 4 Voltage")
xlabel("t (s)")
ylabel("V_T_1_,_T_4 (V)")

ax3 = subplot(4,2,3);
plot(t,V_T23)
xlim([23*T_ac 24*T_ac])
title("Transistor 2 and 3 Voltage")
xlabel("t (s)")
ylabel("V_T_2_,_T_3 (V)")

ax5 = subplot(4,2,5);
plot(t,V_d14)
xlim([23*T_ac 24*T_ac])
title("Diode 1 and 4 Voltage")
xlabel("t (s)")
ylabel("V_d_1_,_d_4 (V)")

ax7 = subplot(4,2,7);
plot(t,V_d23)
xlim([23*T_ac 24*T_ac])
title("Diode 2 and 3 Voltage")
xlabel("t (s)")
ylabel("V_d_2_,_d_3 (V)")

ax2 = subplot(4,2,2);
plot(t,i_T14)
xlim([23*T_ac 24*T_ac])
title("Transistor 1 and 4 Current")
xlabel("t (s)")
ylabel("i_T_1_,_T_4 (A)")

ax4 = subplot(4,2,4);
plot(t,i_T23)
xlim([23*T_ac 24*T_ac])
title("Transistor 2 and 3 Current")
xlabel("t (s)")
ylabel("i_T_2_,_T_3 (A)")

ax6 = subplot(4,2,6);
plot(t,i_d14)
xlim([23*T_ac 24*T_ac])
title("Diode 1 and 4 Current")
xlabel("t (s)")
ylabel("i_d_1_,_d_4 (A)")

ax8 = subplot(4,2,8);
plot(t,i_d23)
xlim([23*T_ac 24*T_ac])
title("Diode 2 and 3 Current")
xlabel("t (s)")
ylabel("i_d_2_,_d_3 (A)")
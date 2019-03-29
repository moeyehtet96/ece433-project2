% Single Phase Inverter - Sine Triangle
m = 1;

V_dc = 200; % Input DC Voltage
L = 1e-3; % Load Inductance Value
r = 0.1; % Load Resistance Value
f_ac = 200; % Output AC Voltage Frequency
T_ac = 1/f_ac; % Output AC Voltage Period
f_sw = 4000; % Switching Frequency
T_sw = 1/f_sw; % Switching Period 
del_t = T_sw/100; % Time Step
t_end = 10*T_ac; % Simulation End Time

% Initializations
i_ac(1) = 0; %-248.7060;
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

tri_sw = tri_gen(100,t,f_sw);

N = 500;
[avg,ak,bk,rw,err] = fourier(t,V_ac,T_ac,N);

fdmtl = bk(1);

f = 1/T_ac:1/T_ac:500/T_ac;

figure;
plot(t,V_ac)
xlim([8*T_ac 9*T_ac])
ylim([-300 300])
title("Output AC Voltage")

figure;
plot(t,i_ac)
xlim([8*T_ac 9*T_ac])
title("Output AC Current")

figure;
ax1 = subplot(4,2,1);
plot(t,V_T14)
xlim([8*T_ac 9*T_ac])
title("Transistor 1 and 4 Voltage")

ax3 = subplot(4,2,3);
plot(t,V_T23)
xlim([8*T_ac 9*T_ac])
title("Transistor 2 and 3 Voltage")

ax5 = subplot(4,2,5);
plot(t,V_d14)
xlim([8*T_ac 9*T_ac])
title("Diode 1 and 4 Voltage")

ax7 = subplot(4,2,7);
plot(t,V_d23)
xlim([8*T_ac 9*T_ac])
title("Diode 2 and 3 Voltage")

ax2 = subplot(4,2,2);
plot(t,i_T14)
xlim([8*T_ac 9*T_ac])
title("Transistor 1 and 4 Current")

ax4 = subplot(4,2,4);
plot(t,i_T23)
xlim([8*T_ac 9*T_ac])
title("Transistor 2 and 3 Current")

ax6 = subplot(4,2,6);
plot(t,i_d14)
xlim([8*T_ac 9*T_ac])
title("Diode 1 and 4 Current")

ax8 = subplot(4,2,8);
plot(t,i_d23)
xlim([8*T_ac 9*T_ac])
title("Diode 2 and 3 Current")
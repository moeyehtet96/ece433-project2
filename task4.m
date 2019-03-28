clear
clc

V_dc = 200; % Input DC Voltage
L = 1e-3; % Load Inductance Value
r = 0.1; % Load Resistance Value
f_sw = 200; % Switching Frequency
T_sw = 1/f_sw; % Switching Period
del_t = T_sw/1000; % Time Step
t_end = 2*T_sw; % Simulation End Time

% Initializations
i_ac(1) = -248.7060;
t(1) = 0;
T14(1) = 1;
T23(1) = 0;
V_ag(1) = T14(1)*V_dc;
V_bg(1) = T23(1)*V_dc;
V_ac(1) = V_ag(1) - V_bg(1);
k = 1;

% Backward Euler Integration Routine
while t(k) < t_end
    T14(k+1) = tri_gen(100,t(k)+del_t,f_sw) > 0.5;
    T23(k+1) = tri_gen(100,t(k)+del_t,f_sw) <= 0.5;
    V_ag(k+1) = T14(k+1)*V_dc;
    V_bg(k+1) = T23(k+1)*V_dc;
    V_ac(k+1) = V_ag(k+1) - V_bg(k+1);
    i_ac(k+1) = (1/(1+(r*del_t/L))) * (i_ac(k) + del_t*V_ac(k+1)/L);
    t(k+1) = t(k) + del_t;
    k = k+1;
end

N = 100;
[avg,ak,bk,rw,err] = fourier(t,V_ac,T_sw,N);

f = 1/T_sw:1/T_sw:100/T_sw;

figure;
plot(t,V_ac)

figure;
plot(t,i_ac)

figure;
stem(f,ak)
title("ak")

figure;
stem(f,bk)
title("bk")

figure;
ax1 = subplot(2,1,1);
plot(t,rw)
title("reconstructed")

ax2 = subplot(2,1,2);
plot(t,V_ac)
title("original")

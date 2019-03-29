% Single Phase Inverter - 180 degree Switching

clear
clc

V_dc = 200; % Input DC Voltage
L = 1e-3; % Load Inductance Value
r = 0.1; % Load Resistance Value
f_sw = 200; % Switching Frequency
T_sw = 1/f_sw; % Switching Period
del_t = T_sw/1000; % Time Step
t_end = 25*T_sw; % Simulation End Time

% Initializations
i_ac(1) = 0; %-248.7060;
t(1) = 0;
T14(1) = 1;
T23(1) = 0;
V_ag(1) = T14(1)*V_dc;
V_bg(1) = T23(1)*V_dc;
V_ac(1) = V_ag(1) - V_bg(1);
V_T14(1) = -T23(1)*V_ac(1);
V_T23(1) = T14(1)*V_ac(1);
V_d14(1) = -V_T14(1);
V_d23(1) = -V_T23(1);
i_S14(1) = T14(1)*i_ac(1);
i_S23(1) = -T23(1)*i_ac(1);
i_T14(1) = i_S14(1)*(i_S14(1) > 0);
i_T23(1) = i_S23(1)*(i_S23(1) > 0);
i_d14(1) = i_S14(1)*-(i_S14(1) <= 0);
i_d23(1) = i_S23(1)*-(i_S23(1) <= 0);
k = 1;

% Backward Euler Integration Routine
while t(k) < t_end
    T14(k+1) = tri_gen(100,t(k)+del_t,f_sw) > 0.5;
    T23(k+1) = tri_gen(100,t(k)+del_t,f_sw) <= 0.5;
    V_ag(k+1) = T14(k+1)*V_dc;
    V_bg(k+1) = T23(k+1)*V_dc;
    V_ac(k+1) = V_ag(k+1) - V_bg(k+1);
    i_ac(k+1) = (1/(1+(r*del_t/L))) * (i_ac(k) + del_t*V_ac(k+1)/L);
    V_T14(k+1) = -T23(k+1)*V_ac(k+1);
    V_T23(k+1) = T14(k+1)*V_ac(k+1);
    V_d14(k+1) = -V_T14(k+1);
    V_d23(k+1) = -V_T23(k+1);
    i_S14(k+1) = T14(k+1)*i_ac(k+1);
    i_S23(k+1) = -T23(k+1)*i_ac(k+1);
    i_T14(k+1) = i_S14(k+1)*(i_S14(k+1) > 0);
    i_T23(k+1) = i_S23(k+1)*(i_S23(k+1) > 0);
    i_d14(k+1) = i_S14(k+1)*-(i_S14(k+1) <= 0);
    i_d23(k+1) = i_S23(k+1)*-(i_S23(k+1) <= 0);
    t(k+1) = t(k) + del_t;
    k = k+1;
end

N = 100;
[avg,ak,bk,rw,err] = fourier(t,V_ac,T_sw,N);

f = 1/T_sw:1/T_sw:100/T_sw;

figure;
plot(t,V_ac)
xlim([23*T_sw 24*T_sw])
ylim([-250 250])
title("Output AC Voltage")
xlabel("t (s)")
ylabel("V_a_c (V)")

figure;
plot(t,i_ac)
xlim([23*T_sw 24*T_sw])
ylim([-300 300])
title("Output AC Current")
xlabel("t (s)")
ylabel("i_a_c (A)")

figure;
ax1 = subplot(4,2,1);
plot(t,V_T14)
xlim([23*T_sw 24*T_sw])
ylim([-50 250])
title("Transistor 1 and 4 Voltage")
xlabel("t (s)")
ylabel("V_T_1_,_T_4 (V)")

ax3 = subplot(4,2,3);
plot(t,V_T23)
xlim([23*T_sw 24*T_sw])
ylim([-50 250])
title("Transistor 2 and 3 Voltage")
xlabel("t (s)")
ylabel("V_T_2_,_3_4 (V)")

ax5 = subplot(4,2,5);
plot(t,V_d14)
xlim([23*T_sw 24*T_sw])
ylim([-250 50])
title("Diode 1 and 4 Voltage")
xlabel("t (s)")
ylabel("V_d_1_,_d_4 (V)")

ax7 = subplot(4,2,7);
plot(t,V_d23)
xlim([23*T_sw 24*T_sw])
ylim([-250 50])
title("Diode 2 and 3 Voltage")
xlabel("t (s)")
ylabel("V_d_2_,_d_3 (V)")

ax2 = subplot(4,2,2);
plot(t,i_T14)
xlim([23*T_sw 24*T_sw])
ylim([-50 300])
title("Transistor 1 and 4 Current")
xlabel("t (s)")
ylabel("i_T_1_,_T_4 (A)")

ax4 = subplot(4,2,4);
plot(t,i_T23)
xlim([23*T_sw 24*T_sw])
ylim([-50 300])
title("Transistor 2 and 3 Current")
xlabel("t (s)")
ylabel("i_T_2_,_T_3 (A)")

ax6 = subplot(4,2,6);
plot(t,i_d14)
xlim([23*T_sw 24*T_sw])
ylim([-50 300])
title("Diode 1 and 4 Current")
ylabel("i_d_1_,_d_4 (A)")

ax8 = subplot(4,2,8);
plot(t,i_d23)
xlim([23*T_sw 24*T_sw])
ylim([-50 300])
title("Diode 2 and 3 Current")
ylabel("i_d_2_,_d_3 (A)")

figure;
stem(f,ak)
title("ak Vs frequency")
xlabel("Frequency (Hz)")
ylabel("ak")

figure;
stem(f,bk)
title("bk Vs frequency")
xlabel("Frequency (Hz)")
ylabel("bk")

figure;
ax1 = subplot(2,1,1);
plot(t,rw)
title("Reconstructed Output Voltage")
xlabel("t (s)")
ylabel("V_a_c(Reconstructed) (V)")

ax2 = subplot(2,1,2);
plot(t,V_ac)
title("Original Output Voltage")
xlabel("t (s)")
ylabel("V_a_c(Original) (V)")

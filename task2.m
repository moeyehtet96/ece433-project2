clear all
clc

T = 2*pi/10; % fundamental frequency
t = 0:T/1000:1; % time vector
x = 0.5 + cos(10*t) + sin(10*t) + cos(40*t) + sin(50*t) + sin(100*t) + cos(500*t + pi/4); % input waveform
N = 50; % number of terms

[avg,ak,bk,rw,err] = fourier(t,x,T,N);

figure;
ax1 = subplot(2,1,1);
plot(t,rw)
title("Reconstructed Output Voltage")
xlabel("t (s)")
ylabel("V_a_c(Reconstructed) (V)")

ax2 = subplot(2,1,2);
plot(t,x)
title("Original Output Voltage")
xlabel("t (s)")
ylabel("V_a_c(Original) (V)")

err

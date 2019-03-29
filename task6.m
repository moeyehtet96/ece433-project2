% Amplitude of Fundamental Component Vs m
clear all
clc

m = [0 0.2 0.4 1.0 1.3 1.6 2.0 3.0 3.5];

% loop for fundamental amplitude
for a = 1:length(m)
    fund_amp(a) = single_sine_tri(m(a));
end

plot(m,fund_amp)
title("Fundamental Amplitude Vs m")
xlabel("m")
ylabel("Fundamental Amplitude (V)")
    
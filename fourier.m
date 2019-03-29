function [avg,ak,bk,rw,err] = fourier(t,x,T,N)
w = 2*pi/T; % rad/s
del_t = t(2)-t(1); % time step
n_period = T/del_t; % number of time data points in one period

% loop for ak and bk
for k = 1:N
    ak(k) = 0;
    bk(k) = 0;
    for m = 1:n_period
        ak(k) = ak(k) + 2*(x(m)*cos(k*w*t(m))*del_t)/T;
        bk(k) = bk(k) + 2*(x(m)*sin(k*w*t(m))*del_t)/T;
    end
end

avg = average(x,T,del_t); % average of input waveform

% loop for reconstructed waveform
rw = avg;
for k = 1:N
    rw = rw + ak(k)*cos(k*w*t) + bk(k)*sin(k*w*t);
end

err = sqrt(abs(x-rw).^2); % rms error
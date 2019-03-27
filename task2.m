T = 2*pi/10;
t = 0:T/1000:1;
x = 0.5 + cos(10*t) + sin(10*t) + cos(40*t) + sin(50*t) + sin(100*t) + cos(500*t + pi/4);
N = 50;

[avg,ak,bk,rw,err] = fourier(t,x,T,N);

f = 1/T:1/T:50/T;

figure;
stem(f,ak)
ylim([-1 1])

figure;
stem(f,bk)
ylim([-1 1])

figure;
ax1 = subplot(2,1,1);
plot(t,rw)
ax2 = subplot(2,1,2);
plot(t,x)

avg

err

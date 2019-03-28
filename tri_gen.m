function x = tri_gen(z,t,f)
T = 1/f;
a0 = 1/2; % offset value
x = 0; % initialize the triangle wave

% creates a 0.5 amplitude triangle wave with zero offset
for n = 1:z*2
    x = (2/(n*pi)^2)*(cos(n*pi)-1)*cos(2*n*pi*f*(t + (T/4))) + x;
end

x = x + a0; % add offset

%plot(t(1:length(t)-1),x(1:length(x)-1))

function val_rms = rms(x,T,dt)
n_period = T/dt;
val_rms = 0;

for m = 1:n_period
    val_rms = val_rms + (x(m)^2)*dt/T;
end

val_rms = sqrt(val_rms);
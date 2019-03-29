clear all
clc

r = 0.1;
L = 5e-3;
I_dsr = 10;
w_ac = 400*pi;
f_ac = w_ac/(2*pi);
T_ac = 1/f_ac;
del_t = T_ac/10000;
t_end = 10*T_ac;

Vdc_min = sqrt(3)*sqrt(((r*I_dsr)^2) + ((w_ac*L*I_dsr)^2))
fprintf("Minimum Vdc is %4f.\n",Vdc_min)
Vdc = input("Input Vdc > Vdc_min:")

h = I_dsr/100;

i_as(1) = 0;
i_bs(1) = 0;
i_cs(1) = 0;

T1(1) = 1;
T4(1) = 0;

T2(1) = 1;
T5(1) = 0;

T3(1) = 1;
T6(1) = 0;

t(1) = 0;
k = 1;


while t < t_end
    V_ag(k) = T1(k)*Vdc;
    V_bg(k) = T2(k)*Vdc;
    V_cg(k) = T3(k)*Vdc;
    
    V_as(k) = (2/3)*V_ag(k) - (1/3)*V_bg(k) - (1/3)*V_cg(k);
    V_bs(k) = (2/3)*V_bg(k) - (1/3)*V_ag(k) - (1/3)*V_cg(k);
    V_cs(k) = (2/3)*V_cg(k) - (1/3)*V_ag(k) - (1/3)*V_bg(k);
    
    i_as(k+1) = i_as(k) + del_t*(V_as(k) - r*i_as(k))/L;
    i_bs(k+1) = i_bs(k) + del_t*(V_bs(k) - r*i_bs(k))/L;
    i_cs(k+1) = i_cs(k) + del_t*(V_cs(k) - r*i_cs(k))/L;
    
    if i_as(k+1) > I_dsr*cos(w_ac*t(k)) + h
        T4(k+1) = 1;
        T1(k+1) = 0;
    elseif i_as(k+1) < I_dsr*cos(w_ac*t(k)) - h
        T4(k+1) = 0;
        T1(k+1) = 1;
    else
        T4(k+1) = T4(k);
        T1(k+1) = T1(k);
    end
    
    if i_bs(k+1) > I_dsr*cos(w_ac*t(k) - 2*pi/3) + h
        T5(k+1) = 1;
        T2(k+1) = 0;
    elseif i_bs(k+1) < I_dsr*cos(w_ac*t(k) - 2*pi/3) - h
        T5(k+1) = 0;
        T2(k+1) = 1;
    else
        T5(k+1) = T5(k);
        T2(k+1) = T2(k);
    end
    
    if i_cs(k+1) > I_dsr*cos(w_ac*t(k) + 2*pi/3) + h
        T6(k+1) = 1;
        T3(k+1) = 0;
    elseif i_cs(k+1) < I_dsr*cos(w_ac*t(k) + 2*pi/3) - h
        T6(k+1) = 0;
        T3(k+1) = 1;
    else
        T6(k+1) = T6(k);
        T3(k+1) = T3(k);
    end
    
    t(k+1) = t(k) + del_t;
    k = k + 1;
end

Ias_hys_upper = I_dsr*cos(w_ac*t) + h;
Ias_hys_lower = I_dsr*cos(w_ac*t) - h;

figure;
plot(t,i_as)
hold on
plot(t,Ias_hys_upper)
hold on
plot(t,Ias_hys_lower)
    
    


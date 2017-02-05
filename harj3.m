signal = load('521273S_signals.mat');

%Case 1

figure
x = linspace(0.001,10.000,10000);

subplot(3,1,1)
plot(x, signal.mhb(1:10000));
xlabel('seconds')
ylabel('mV')
title('mhb signal')

subplot(3,1,2)
plot(x, signal.abd_sig1(1:10000));
xlabel('seconds')
ylabel('mV')
title('first abdomen signal')

l = 1; %jossain 1-21-välillä
c = 0.66; %0-1-välillä
energy = 186;
numbersteps = c/energy;
ha = dsp.LMSFilter('Length', l, 'StepSize', numbersteps);
[y1, e1, wts1] = step(ha, signal.mhb, signal.abd_sig1);

subplot(3,1,3)
plot(x, e1(1:10000), 'red', x, signal.fhb(1:10000), 'blue');
xlabel('seconds')
ylabel('mV')
title('fhb signal (blue), filtered signal (red)')

coef1 = corrcoef(e1(1500:10000), signal.fhb(1500:10000))
MSE1 = immse(e1(1500:10000), signal.fhb(1500:10000))

% Case 2

figure

subplot(3,1,1)
plot(x, signal.mhb(1:10000));
xlabel('seconds')
ylabel('mV')
title('mhb signal')

subplot(3,1,2)
plot(x, signal.abd_sig2(1:10000));
xlabel('seconds')
ylabel('mV')
title('second abdomen signal')

l2 = 1; %jossain 1-21-välillä
c2 = 0.86; %0-1-välillä
energy = 186;
numbersteps2 = c2/energy;
ha = dsp.LMSFilter('Length', l2, 'StepSize', numbersteps2);
[y2, e2, wts2] = step(ha, signal.mhb, signal.abd_sig2);

subplot(3,1,3)
plot(x, e2(1:10000), 'red', x, signal.fhb(1:10000), 'blue');
xlabel('seconds')
ylabel('mV')
title('fhb signal (blue), filtered signal (red)')

coef2 = corrcoef(e2(2000:10000), signal.fhb(2000:10000))
MSE2 = immse(e2(2000:10000), signal.fhb(2000:10000))

% Case 3

figure

subplot(3,1,1)
plot(x, signal.mhb(1:10000));
xlabel('seconds')
ylabel('mV')
title('mhb signal')

subplot(3,1,2)
plot(x, signal.abd_sig3(1:10000));
xlabel('seconds')
ylabel('mV')
title('third abdomen signal')

l3 = 21;
c3 = 0.99; %0-1-välillä
energy = 186;
numbersteps3 = c3/energy;
ha = dsp.LMSFilter('Length', l3, 'StepSize', numbersteps3);
[y3, e3, wts3] = step(ha, signal.mhb, signal.abd_sig3);

subplot(3,1,3)
plot(x, e3(1:10000), 'red', x, signal.fhb(1:10000), 'blue');
xlabel('seconds')
ylabel('mV')
title('fhb signal (blue), filtered signal (red)')

coef3 = corrcoef(e3(2000:10000), signal.fhb(2000:10000))
MSE3 = immse(e3(2000:10000), signal.fhb(2000:10000))

%% Case 4

figure

subplot(3,1,1)
plot(x, signal.abd_sig_real(1:10000));
xlabel('seconds')
ylabel('mV')
title('real abdomen signal')

subplot(3,1,2)
plot(x, signal.mhb_real(1:10000));
xlabel('seconds')
ylabel('mV')
title('real mhb signal')

l4 = 10; %jossain 1-21-välillä
c4 = 0.5; %0-1-välillä
energy = 157;
numbersteps4 = c4/energy;
ha = dsp.LMSFilter('Length', l4, 'StepSize', numbersteps4);
[y4, e4, wts4] = step(ha, signal.mhb_real, signal.abd_sig_real);

subplot(3,1,3)
plot(x, signal.abd_sig_real(1:10000), 'blue', x, e4(1:10000), 'red');
xlabel('seconds')
ylabel('mV')
title('filtered signal (blue)')
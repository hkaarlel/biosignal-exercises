ecg = dlmread('521273S_ecg.txt');
ecg1 = ecg - ecg(1);

figure
x = linspace(0.005,20.000,4000);

b1 = [1, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1];
a1 = [32, -64, 32];
ecg2 = filter(b1,a1,ecg1);

subplot(6,1,2)
plot(x, ecg2(1:4000));
xlabel('seconds')
ylabel('au')
title('Lowpass-filtered signal')

b2 = [-1/32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1/32];
a2 = [1, -1];
ecg3 = filter(b2,a2,ecg2);

subplot(6,1,3)
plot(x, ecg3(1:4000));
xlabel('seconds')
ylabel('au')
title('Bandpass-filtered signal')

b3 = [1/8, 2/8, -2/8, -1/8];
a3 = 1;
ecg4 = filter(b3,a3,ecg3);

subplot(6,1,4)
plot(x, ecg4(1:4000));
xlabel('seconds')
ylabel('au')
title('Derivative-operated signal')

ecg5 = ecg4.*ecg4;

subplot(6,1,5)
plot(x, ecg5(1:4000));
xlabel('seconds')
ylabel('au')
title('Squared signal')

windowSize = 30;
b4 = (1/windowSize)*ones(1,windowSize);
a4 = 1;
ecg6 = filter(b4,a4,ecg5);

% Delays: Low-pass 5 samples, High-pass 16 samples
[QRSStart, QRSEnd] = detectQRS(ecg6, 50, 150, 1150);

subplot(6,1,6)
plot(x, ecg6(1:4000));
xlabel('seconds')
ylabel('au')
title('Integrated signal, output')
hold on;
plot(QRSStart/200, ecg6(QRSStart), 'r*');
plot(QRSEnd/200, ecg6(QRSEnd), 'go');

subplot(6,1,1)
plot(x, ecg1(1:4000));
xlabel('seconds')
ylabel('au')
title('Original signal')
hold on;
plot((QRSStart-21)/200, ecg1(QRSStart-21), 'r*');
plot((QRSEnd-21)/200, ecg1(QRSEnd-21), 'go');
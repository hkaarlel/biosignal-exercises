e01 = load('521273S_ecg_signal.dat');
figure
x = linspace(0.001,9.519,9519);

subplot(4,2,1)
plot(x, e01);
xlabel('seconds')
ylabel('au')
title('signal')

subplot(4,2,2)
plot(linspace(2,3,1001), e01(2000:3000));
xlabel('seconds')
ylabel('au')
title('signal, one cardiac cycle')

%moving average filter
windowSize = 10;
b1 = (1/windowSize)*ones(1,windowSize);
a1 = 1;
e02 = filter(b1,a1,e01);

subplot(4,2,3)
plot(x, e02);
xlabel('seconds')
ylabel('au')
title('signal with moving average filter')

subplot(4,2,4)
plot(linspace(2,3,1001), e02(2000:3000));
xlabel('seconds')
ylabel('au')
title('signal with moving average filter, one cardiac cycle')

%derivative based filter
a2 = [1, -0.995];
b2 = [1, -1];
[h, w] = freqz(b2,a2);
h = real(max(h));
b2 = b2/h;
e03 = filter(b2,a2,e01);

subplot(4,2,5)
plot(x, e03);
xlabel('seconds')
ylabel('au')
title('signal with derivative-based filter')

subplot(4,2,6)
plot(linspace(2,3,1001), e03(2000:3000));
xlabel('seconds')
ylabel('au')
title('signal with derivative-based filter, one cardiac cycle')

%convoluted filter
a3 = conv(a1,a2);
b3 = conv(b1,b2);
e04 = filter(b3,a3,e01);

subplot(4,2,7)
plot(x, e04);
xlabel('seconds')
ylabel('au')
title('signal with convoluted filter')

subplot(4,2,8)
plot(linspace(2,3,1001), e04(2000:3000));
xlabel('seconds')
ylabel('au')
title('signal with convoluted filter, one cardiac cycle')
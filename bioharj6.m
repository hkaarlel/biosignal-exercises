signal = dlmread('521273S_emgforce2.txt');
time = signal(:, 1);
forcesig = signal(:, 2);
EMGsig = signal(:, 3);

%Rescaling
forcesignorm = (forcesig - min(forcesig))/(max(forcesig)-min(forcesig))*100;
%Remove bias
EMGsignorm = EMGsig - mean(EMGsig);


%Find the portions
begs = [];
ends = [];
for i = 1:length(forcesignorm)-1
    if forcesignorm(i) <= 10 && forcesignorm(i+1) > 10
        begs = [begs i];
    end
    if forcesignorm(i) >= 10 && forcesignorm(i+1) < 10
        ends = [ends i];
    end
end

%% Find the maxes and 75%:s of maxes
segmax = zeros(1,length(begs));
segmaxi = zeros(1,length(begs));
begs75 = [];
ends75 = [];
for j = 1:length(begs)
    for i = begs(j):ends(j)
        if forcesignorm(i) > segmax(j)
           segmaxi(j) = i;
           segmax(j) = forcesignorm(i);
        end
    end
    for i = begs(j):ends(j)
        if forcesignorm(i) <= 0.75*segmax(j) && forcesignorm(i+1) > 0.75*segmax(j)
            begs75 = [begs75 i];
        end
        if forcesignorm(i) >= 0.75*segmax(j) && forcesignorm(i+1) < 0.75*segmax(j)
            ends75 = [ends75 i];
        end
    end
    for i =1:length(begs75)
        if begs75(i) < begs(i)
            begs75(i) = [];
            ends75(i-1) = [];
        end
    end
end

%% Plotting the signals with marks
figure

subplot(2,1,1)
plot(time, forcesignorm);
xlabel('seconds')
ylabel('%MVC')
title('normalized force')
hold on
plot(begs/2000, 10, 'r*');
plot(ends/2000, 10, 'ro');
plot(segmaxi/2000, segmax, 'g*');
plot(begs75/2000, forcesignorm(begs75), 'b*');
plot(ends75/2000, forcesignorm(begs75), 'bo');

subplot(2,1,2)
plot(time, EMGsignorm);
xlabel('seconds')
ylabel('mV')
title('EMG signal')


%% Periodogram estimate
segments1 = buffer(EMGsignorm(begs75(1):ends75(1)),750,100);
segments2 = buffer(EMGsignorm(begs75(2):ends75(2)),750,100);
segments3 = buffer(EMGsignorm(begs75(3):ends75(3)),750,100);
segments4 = buffer(EMGsignorm(begs75(4):ends75(4)),750,100);
segments5 = buffer(EMGsignorm(begs75(5):ends75(5)),750,100);


nfft = 256;
pxxmean = zeros(129, length(begs75));
f = zeros(129, length(begs75));
[pxx1, f(:,1)] = pwelch(segments1, [], [], nfft, 2000);
pxxmean(:,1) = mean(pxx1,2);
[pxx2, f(:,2)] = pwelch(segments2, [], [], nfft, 2000);
pxxmean(:,2) = mean(pxx2,2);
[pxx3, f(:,3)] = pwelch(segments3, [], [], nfft, 2000);
pxxmean(:,3) = mean(pxx3,2);
[pxx4, f(:,4)] = pwelch(segments4, [], [], nfft, 2000);
pxxmean(:,4) = mean(pxx4,2);
[pxx5, f(:,5)] = pwelch(segments5, [], [], nfft, 2000);
pxxmean(:,5) = mean(pxx5,2);

% for the second sample
if length(begs75) == 6
    segments6 = buffer(EMGsignorm(begs75(6):ends75(6)),750,100);
    [pxx6, f(:,6)] = pwelch(segments6, [], [], nfft, 2000);
    pxxmean(:,6) = mean(pxx6,2);
end


%% figure with EMG signal segments and corresponding PSD averages

figure

subplot(2,6,1)
plot(time(begs75(1):ends75(1)), EMGsignorm(begs75(1):ends75(1)));
subplot(2,6,2)
plot(time(begs75(2):ends75(2)), EMGsignorm(begs75(2):ends75(2)));
subplot(2,6,3)
plot(time(begs75(3):ends75(3)), EMGsignorm(begs75(3):ends75(3)));
subplot(2,6,4)
plot(time(begs75(4):ends75(4)), EMGsignorm(begs75(4):ends75(4)));
subplot(2,6,5)
plot(time(begs75(5):ends75(5)), EMGsignorm(begs75(5):ends75(5)));
subplot(2,6,7)
plot(f(:,1), pxxmean(:,1));
subplot(2,6,8)
plot(f(:,2), pxxmean(:,2));
subplot(2,6,9)
plot(f(:,3), pxxmean(:,3));
subplot(2,6,10)
plot(f(:,4), pxxmean(:,4));
subplot(2,6,11)
plot(f(:,5), pxxmean(:,5));
%for the second sample
if length(begs75) == 6
    subplot(2,6,6)
    plot(time(begs75(6):ends75(6)), EMGsignorm(begs75(6):ends75(6)));
    subplot(2,6,12)
    plot(f(:,6), pxxmean(:,6));
end

%% The mean frequencies
meanf = zeros(1,length(begs75));
meanffunction = zeros(1,length(begs75));
for i = 1:length(begs75)
    numerator = 0;
    denominator = 0;
    for j = 1:129
        numerator = numerator + (f(j,i)*pxxmean(j,i));
        denominator = denominator + pxxmean(j,i);
    end
    meanf(i) = numerator/denominator;
    meanffunction(i) = meanfreq(EMGsignorm(begs75(i):ends75(i)), 2000);
end
signal = dlmread('521273S_respiratoryAirflow.txt');

% Plotting the figure
figure
x = linspace(0,2301/50,2301);
plot(x, signal);
xlabel('seconds')
ylabel('ml')
hold on

% Finding the start points of exp. and insp.
goingUp = [];
goingDown = [];
Ti = [];
Te = [];
for i = 1:length(signal)-1
    if signal(i) <= 0 && signal(i+1) > 0
        goingUp = [goingUp i];
    end
    if signal(i) >= 0 && signal(i+1) < 0
        goingDown = [goingDown i];
    end
end

%% average duty cycle Ti / Ttot

zeroPasses = 0;
for i = goingDown(1)+1:goingDown(length(goingDown))-1
    if signal(i) <= 0 && signal(i+1) > 0
        zeroPasses = zeroPasses + 1;
    end
    if signal(i) >= 0 && signal(i+1) < 0
        zeroPasses = zeroPasses + 1;
    end
end
respiratoryRate = (zeroPasses*60/2)/46

%% respiratory rate [breaths per minute]
% Counting the lengths of time for Ti and Te
for i = 1:length(goingUp)
   Ti = [Ti (goingUp(i) - goingDown(i))];
end
for i = 1:length(goingDown)-1
   Te = [Te (goingDown(i+1) - goingUp(i))];
end

Ttot = mean(Ti) + mean(Te);
dutyCycle = mean(Ti)/Ttot


%% average Tptef / Te

% Finding the peaks
peaks = zeros(1, length(goingUp)+1);
peaksx = zeros(1, length(goingUp)+1);
bottoms = zeros(1, length(goingUp));
bottomsx = zeros(1, length(goingUp));
Tptf = [];

% the peak of the first uncomplete expiratory breath (put to the last place in the peaks array)
for i = 1:goingDown(1)
        if signal(i) > peaks(length(goingUp)+1)
           peaks(length(goingUp)+1) = signal(i);
           peaksx(length(goingUp)+1) = i;
        end
end

%the proper peaks and bottoms
for j = 1:length(goingUp)
    for i = goingUp(j):goingDown(j+1)
        if signal(i) > peaks(j)
           peaks(j) = signal(i);
           peaksx(j) = i;
        end
    end
    for i = goingDown(j):goingUp(j)
        if signal(i) < bottoms(j)
           bottoms(j) = signal(i);
           bottomsx(j) = i;
        end
    end
    Tptf = [Tptf (peaksx(j)-goingUp(j))];
end
averageTptefperTe = mean(Tptf/Te)


%% marking the peaks

plot(peaksx/50, peaks, 'r*');
plot(bottomsx/50, bottoms, 'b*');

hline = refline(0);
hline.Color = 'r';

%% average and standard deviation of peak-to-peak (inspiration -> expiration) airflow

peaktopeaks = peaks(1:length(bottoms))-bottoms;
meanptp = mean(peaktopeaks);

avgdevsum = 0;
stddevsum = 0;
for i = 1:length(peaktopeaks)
    avgdevsum = avgdevsum + abs(meanptp-peaktopeaks(i));
    stddevsum = stddevsum + (meanptp-peaktopeaks(i))^2;
end
avgDev = avgdevsum/length(bottoms)
stdDev = sqrt(stddevsum/length(bottoms))


%% Additional task: average expirotary volume
volumes = zeros(1, length(goingUp));
for j = 1:length(goingUp)
    for i = goingUp(j):goingDown(j+1)
        volumes(j) = volumes(j) + signal(i);
    end
end
avgvolume = mean(volumes)
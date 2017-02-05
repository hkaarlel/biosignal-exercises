signal = dlmread('521273S_emgforce.txt');
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
segmax = zeros(1,5);
segmaxi = zeros(1,5);
begsseven = [];
endsseven = [];
for j = 1:length(begs)
    for i = begs(j):ends(j)
        if forcesignorm(i) > segmax(j)
           segmaxi(j) = i;
           segmax(j) = forcesignorm(i);
        end
    end
    for i = begs(j):ends(j)
        if forcesignorm(i) <= 0.75*segmax(j) && forcesignorm(i+1) > 0.75*segmax(j)
            begsseven = [begsseven i];
        end
        if forcesignorm(i) >= 0.75*segmax(j) && forcesignorm(i+1) < 0.75*segmax(j)
            endsseven = [endsseven i];
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
plot(begsseven/2000, forcesignorm(begsseven), 'b*');
plot(endsseven/2000, forcesignorm(begsseven), 'bo');

subplot(2,1,2)
plot(time, EMGsignorm);
xlabel('seconds')
ylabel('mV')
title('EMG signal')



%% Average force exerted, DR and RMS
avgforces = zeros(1,5);
EMGmax = zeros(1,5);
EMGmin = zeros(1,5);
DRs = zeros(1,5);
RMSs = zeros(1,5);
for j = 1:length(begsseven)
    for i = begsseven(j):endsseven(j)
       avgforces(j) = avgforces(j)+forcesignorm(i);
       
       if EMGsignorm(i) > EMGmax(j)
           EMGmax(j) = EMGsignorm(i);
       end
       if EMGsignorm(i) < EMGmin(j)
           EMGmin(j) = EMGsignorm(i);
       end
       
       RMSs(j) = RMSs(j) + EMGsignorm(i)*EMGsignorm(i);
    end
    avgforces(j) = avgforces(j)/(endsseven(j)-begsseven(j));
    DRs(j) = EMGmax(j) - EMGmin(j);
    RMSs(j) = sqrt(RMSs(j)/(endsseven(j)-begsseven(j)));
end
avgforces
DRs
RMSs


%% Plotting DR and RMS

figure

subplot(2,1,1)
plot(avgforces, DRs, '*');
xlabel('average forces (%MVC)')
ylabel('DR')
title('DR parameters versus the average forces')
hold on;
p1 = polyfit(avgforces, DRs, 1);
y1 = polyval(p1,avgforces);
plot(avgforces, y1);

subplot(2,1,2)
plot(avgforces, RMSs, '*');
xlabel('average forces (%MVC)')
ylabel('RMS')
title('RMS parameters versus the average forces')
hold on;
p2 = polyfit(avgforces, RMSs, 1);
y2 = polyval(p2,avgforces);
plot(avgforces, y2);


%% Computing the coefficient r for DR

numerator = 0;
denumx = 0;
denumy = 0;
for i = 1:5
   numerator = numerator + avgforces(i)*DRs(i);
   denumx = denumx + avgforces(i)^2;
   denumy = denumy + DRs(i)^2;
end
numerator = (numerator - 5*mean(avgforces)*mean(DRs))^2;
denominator = (denumx-5*(mean(avgforces))^2)*(denumy-5*(mean(DRs))^2);
DRr = sqrt(numerator/denominator)

%% Computing the coefficient r for RMS

numerator = 0;
denumx = 0;
denumy = 0;
for i = 1:5
   numerator = numerator + avgforces(i)*RMSs(i);
   denumx = denumx + avgforces(i)^2;
   denumy = denumy + RMSs(i)^2;
end
numerator = (numerator - 5*mean(avgforces)*mean(RMSs))^2;
denominator = (denumx-5*(mean(avgforces))^2)*(denumy-5*(mean(RMSs))^2);
RMSr = sqrt(numerator/denominator)
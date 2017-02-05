spirometer = dlmread('521273S_spirometer.txt');
beltsignals = dlmread('521273S_beltsignals.txt');
regcoeffs1 = dlmread('521273S_regcoeffs1.txt');
regcoeffs2 = dlmread('521273S_regcoeffs2.txt');

resampledsm = resample(spirometer, 1, 2);

%Prediction1:
Fest1 = regcoeffs1(1) * beltsignals(:,1) + regcoeffs1(2) * beltsignals(:,2);

%Prediction2:
Fest2 = regcoeffs2(1) * beltsignals(:,1) + regcoeffs2(2) * beltsignals(:,2) + regcoeffs2(3) * beltsignals(:,1).^2 + regcoeffs2(4) * beltsignals(:,2).^2;

%R^2-values:
SSerr1 = 0;
SSerr2 = 0;
SStot = 0;
datamean = mean(resampledsm);
for i = 1:3000
    SSerr1 = SSerr1 + (resampledsm(i) - Fest1(i))^2;
    SSerr2 = SSerr2 + (resampledsm(i) - Fest2(i))^2;
    SStot = SStot + (resampledsm(i) - datamean)^2;
end
R1 = 1 - SSerr1/SStot
R2 = 1 - SSerr2/SStot
%Now R1 = 0.8820 < R2 = 0.8946

%RMSE-values:
RMSE1 = sqrt(SSerr1/length(resampledsm))
RMSE2 = sqrt(SSerr2/length(resampledsm))
%Now RMSE1 = 9.79e3 > RMSE2 = 9.26e3

%Plotting
figure
x = linspace(1,60,3000);
subplot(2,1,1)
plot(x, resampledsm, 'black', x, Fest1, 'red', x, Fest2, 'blue');
xlabel('seconds')
ylabel('ml')
title('Spirometer airflow signal (black), predicted respiratory airflow signals 1 and 2 (red, blue)')
subplot(2,1,2)
plot(x, beltsignals(:,1), 'blue', x, beltsignals(:,2), 'green');
xlabel('seconds')
ylabel('au')
title('Chest signal (blue), abdomen signal (green)')


%extra
j = 1;
k = 1;
peaks = zeros(1,2);
bottoms = zeros(1,2);
addon = zeros(1,2);
for j = 2:length(Fest2)
    if (Fest2(j) > peaks(k,2)) && (Fest2(j) > 0) && (Fest2(j-1) > 0)
        peaks(k,1) = j;
        peaks(k,2) = Fest2(j);
    end
    if (Fest2(j) < bottoms(k,2)) && (Fest2(j) < 0) && (Fest2(j-1) < 0)
        bottoms(k,1) = j;
        bottoms(k,2) = Fest2(j);
    end
    if ((Fest2(j-1) <= 0) && (Fest2(j) >= 0)) || ((Fest2(j-1) >= 0) && (Fest2(j) <= 0))
        peaks = [peaks; addon];
        bottoms = [bottoms; addon];
        k = k+1;
    end
end

subplot(1,1,1)
x = linspace(1,3000,3000);
plot(x, Fest2, 'black')
hold on;
plot(peaks(2:end,1), peaks(2:end,2), 'r*');
plot(bottoms(2:end,1), bottoms(2:end,2), 'go');
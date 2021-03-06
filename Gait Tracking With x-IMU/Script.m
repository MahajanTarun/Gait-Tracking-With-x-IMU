%%
clear;
close all;
clc;
addpath('Quaternions');
addpath('ximu_matlab_library');
%%
% -------------------------------------------------------------------------
% Select dataset (comment in/out)

% Fs = 100
% filePath = 'Biolab-Datasets/coleta1';
% startTime = 8;
% stopTime = 37.5;

% Fs = 100
% filePath = 'Biolab-Datasets/coleta2';
% startTime = 8;
% stopTime = 35;

Fs = 100;
filePath = 'Biolab-Datasets/coleta3';
startTime = 8;
stopTime = 55;


%Fs = 200
% filePath = 'Biolab-Datasets-bin/leituras';
% startTime = 9;
% stopTime = 24;

%Fs = 200
% filePath = 'Biolab-Datasets-bin/leituras2';
% startTime = 10;
% stopTime = 50;

%Fs = 200
% filePath = 'Biolab-Datasets-bin/leituras3';
% startTime = 15;
% stopTime = 42;

%Fs = 200
% filePath = 'Biolab-Datasets-bin/leituras4';
% startTime = 10;
% stopTime = 47;

% Fs = 200
% filePath = 'Biolab-Datasets-bin/leituras5';
% startTime = 2;
% stopTime = 17;

% Fs = 200
% filePath = 'Biolab-Datasets-bin/leituras6';
% startTime = 1;
% stopTime = 148;

%Fs = 256
% filePath = 'Datasets/straightLine';
% startTime = 6;
% stopTime = 26;

%Fs = 256
% filePath = 'Datasets/stairsAndCorridor';
% startTime = 5;
% stopTime =

%Fs = 256
% filePath = 'Datasets/spiralStairs';
% startTime = 4;
% stopTime = 47;

% -------------------------------------------------------------------------
%% Import data

samplePeriod = 1/Fs;
xIMUdata = xIMUdataClass(filePath, 'InertialMagneticSampleRate', 1/samplePeriod);
time = xIMUdata.CalInertialAndMagneticData.Time;
gyrX = xIMUdata.CalInertialAndMagneticData.Gyroscope.X;
gyrY = xIMUdata.CalInertialAndMagneticData.Gyroscope.Y;
gyrZ = xIMUdata.CalInertialAndMagneticData.Gyroscope.Z;
accX = xIMUdata.CalInertialAndMagneticData.Accelerometer.X;
accY = xIMUdata.CalInertialAndMagneticData.Accelerometer.Y;
accZ = xIMUdata.CalInertialAndMagneticData.Accelerometer.Z;
clear('xIMUdata');

% -------------------------------------------------------------------------
%% Manually frame data

% startTime = 0;
% stopTime = 10;

indexSel = find(sign(time-startTime)+1, 1) : find(sign(time-stopTime)+1, 1);
time = time(indexSel);
gyrX = gyrX(indexSel, :);
gyrY = gyrY(indexSel, :);
gyrZ = gyrZ(indexSel, :);
accX = accX(indexSel, :);
accY = accY(indexSel, :);
accZ = accZ(indexSel, :);

% -------------------------------------------------------------------------
%% Detect stationary periods

% Compute accelerometer magnitude
acc_mag = sqrt(accX.*accX + accY.*accY + accZ.*accZ);

% HP filter accelerometer data
filtCutOff = 0.001;
[b, a] = butter(1, (2*filtCutOff)/(1/samplePeriod), 'high');
acc_magFilt = filtfilt(b, a, acc_mag);

% Compute absolute value
acc_magFilt = abs(acc_magFilt);

% LP filter accelerometer data
filtCutOff = 5;
[b, a] = butter(1, (2*filtCutOff)/(1/samplePeriod), 'low');
acc_magFilt = filtfilt(b, a, acc_magFilt);

% Threshold detection
stationaty_start_time = acc_magFilt(1:(startTime+1)*Fs);
statistical_stationary_threshold = mean(stationaty_start_time) + 2*std(stationaty_start_time);
stationary_threshold = 0.05;

disp(['Limiar Calculado = ', num2str(mean(stationaty_start_time)), ' + 2 * ',num2str(std(stationaty_start_time)), ' = ', num2str(statistical_stationary_threshold)]);
disp(['Limiar Fixo = ', num2str(stationary_threshold)]);

stationary = acc_magFilt < 0.05;

% -------------------------------------------------------------------------
%% Plot data raw sensor data and stationary periods
figure('Position', [1300 10 900 600], 'Name', 'Sensor Data');
ax(1) = subplot(2,1,1);
    hold on; grid on;
    plot(time, gyrX, 'r');
    plot(time, gyrY, 'g');
    plot(time, gyrZ, 'b');
    title('Gyroscope');
    xlabel('Time (s)');
    ylabel('Angular velocity (^\circ/s)');
    legend('X', 'Y', 'Z');
    hold off;
ax(2) = subplot(2,1,2);
    hold on; grid on;
    plot(time, accX, 'r');
    plot(time, accY, 'g');
    plot(time, accZ, 'b');
    plot(time, acc_magFilt, ':k');
    plot(time, stationary, 'k', 'LineWidth', 2);
    title('Accelerometer');
    xlabel('Time (s)');
    ylabel('Acceleration (g)');
    legend('X', 'Y', 'Z', 'Filtered', 'Stationary');
    hold off;
linkaxes(ax,'x');

% -------------------------------------------------------------------------
%% Compute orientation

quat = zeros(length(time), 4);
AHRSalgorithm = AHRS('SamplePeriod', 1/Fs, 'Kp', 1, 'KpInit', 1);

% Initial convergence
initPeriod = 2;
indexSel = 1 : find(sign(time-(time(1)+initPeriod))+1, 1);
for i = 1:2000;
    AHRSalgorithm.UpdateIMU([0 0 0], [mean(accX(indexSel)) mean(accY(indexSel)) mean(accZ(indexSel))]);
end

% For all data
for t = 1:length(time)
    if(stationary(t))
        AHRSalgorithm.Kp = 0.5;
    else
        AHRSalgorithm.Kp = 0;
    end
    AHRSalgorithm.UpdateIMU(deg2rad([gyrX(t) gyrY(t) gyrZ(t)]), [accX(t) accY(t) accZ(t)]);
    quat(t,:) = AHRSalgorithm.Quaternion;
end

% -------------------------------------------------------------------------
%% Compute translational accelerations

% Rotate body accelerations to Earth frame
acc = quaternRotate([accX accY accZ], quaternConj(quat));

% % Remove gravity from measurements
% acc = acc - [zeros(length(time), 2) ones(length(time), 1)];     % unnecessary due to velocity integral drift compensation

% Convert acceleration measurements to m/s/s
acc = acc * 9.81;

%% Plot translational accelerations
figure('Position', [1300 10 900 300], 'Name', 'Accelerations');
hold on; grid on;
plot(time, acc(:,1), 'r');
plot(time, acc(:,2), 'g');
plot(time, acc(:,3), 'b');
title('Acceleration');
xlabel('Time (s)');
ylabel('Acceleration (m/s/s)');
legend('X', 'Y', 'Z');
hold off;

% -------------------------------------------------------------------------
%% Compute translational velocities

acc(:,3) = acc(:,3) - 9.81;

% Integrate acceleration to yield velocity
vel = zeros(size(acc));
for t = 2:length(vel)
    vel(t,:) = vel(t-1,:) + acc(t,:) * samplePeriod;
    if(stationary(t) == 1)
        vel(t,:) = [0 0 0];     % force zero velocity when foot stationary
    end
end


% Compute integral drift during non-stationary periods
velDrift = zeros(size(vel));
stationaryStart = find([0; diff(stationary)] == -1);
stationaryEnd = find([0; diff(stationary)] == 1);
for i = 1:numel(stationaryEnd)
    driftRate = vel(stationaryEnd(i)-1, :) / (stationaryEnd(i) - stationaryStart(i));
    enum = 1:(stationaryEnd(i) - stationaryStart(i));
    drift = [enum'*driftRate(1) enum'*driftRate(2) enum'*driftRate(3)];
    velDrift(stationaryStart(i):stationaryEnd(i)-1, :) = drift;
end

% Remove integral drift
vel = vel - velDrift;

%% Plot translational velocity
figure('Position', [1300 10 900 300], 'Name', 'Velocity');
hold on; grid on;
plot(time, vel(:,1), 'r');
plot(time, vel(:,2), 'g');
plot(time, vel(:,3), 'b');
title('Velocity');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('X', 'Y', 'Z');
hold off;

% -------------------------------------------------------------------------
%% Compute translational position

% Integrate velocity to yield position
pos = zeros(size(vel));
for t = 2:length(pos)
    pos(t,:) = pos(t-1,:) + vel(t,:) * samplePeriod;    % integrate velocity to yield position
end


%% rotação de base para corrigir o alinhamento do sensor
th = atan2(15, 98);
x_ = pos(:,1);
y_ = pos(:,2);
u_ = y_.*sin(-th) + x_.*cos(-th);
v_ = y_.*cos(-th) - x_.*sin(-th);
pos(:,1) = u_;
pos(:,2) = v_;
%% Plot translational position
figure('Position', [1300 10 900 600], 'Name', 'Posição');
hold on; grid on;
plot(time, pos(:,1)*100, 'r', 'linewidth', 2);
plot(time, pos(:,2)*100, 'g', 'linewidth', 2);
plot(time, pos(:,3)*100, 'b', 'linewidth', 2);
title('Posição');
xlabel('Tempo (s)');
ylabel('Posição (cm)');
legend('X', 'Y', 'Z');
hold off;
xlim([8, 52])

disp('Erro em Z: ')
disp(abs(pos(length(pos),3)))
% -------------------------------------------------------------------------
%% Plot 3D foot trajectory

% % Remove stationary periods from data to plot
% posPlot = pos(find(~stationary), :);
% quatPlot = quat(find(~stationary), :);
posPlot = pos;
quatPlot = quat;

% Extend final sample to delay end of animation
extraTime = 2;
onesVector = ones(extraTime*(1/samplePeriod), 1);
posPlot = [posPlot; [posPlot(end, 1)*onesVector, posPlot(end, 2)*onesVector, posPlot(end, 3)*onesVector]];
quatPlot = [quatPlot; [quatPlot(end, 1)*onesVector, quatPlot(end, 2)*onesVector, quatPlot(end, 3)*onesVector, quatPlot(end, 4)*onesVector]];

% Create 6 DOF animation
SamplePlotFreq = 2;
Spin = 120;
SixDofAnimation(posPlot, quatern2rotMat(quatPlot), ...
                'SamplePlotFreq', SamplePlotFreq, 'Trail', 'All', ...
                'Position', [9 39 1280 768], 'View', [(100:(Spin/(length(posPlot)-1)):(100+Spin))', 10*ones(length(posPlot), 1)], ...
                'AxisLength', 0.1, 'ShowArrowHead', false, ...
                'Xlabel', 'X (m)', 'Ylabel', 'Y (m)', 'Zlabel', 'Z (m)', 'ShowLegend', false, ...
                'CreateAVI', false, 'AVIfileNameEnum', false, 'AVIfps', ((1/samplePeriod) / SamplePlotFreq));

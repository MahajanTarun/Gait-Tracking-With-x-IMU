clear;
close all;
clc;
addpath('Quaternions');
addpath('ximu_matlab_library');

% -------------------------------------------------------------------------
% Select dataset (comment in/out)

Fs = 100;
%Fs = 256;
% filePath = 'Biolab-Datasets/coleta1';
% startTime = 8;
% stopTime = 37.5;

filePath = 'Biolab-Datasets/coleta3';
startTime = 8;
stopTime = 55;

% filePath = 'Datasets/straightLine';
% startTime = 6;
% stopTime = 26;
% filePath = 'Datasets/stairsAndCorridor';
% startTime = 5;
% stopTime = 
% filePath = 'Datasets/spiralStairs';
% startTime = 4;
% stopTime = 47;

% -------------------------------------------------------------------------
% Import data

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
% Manually frame data

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

dist_erros = zeros(1,10);
st_ths = zeros(1,10);
for st_th = 1:10;
   % -------------------------------------------------------------------------
    % Detect stationary periods

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
    stationary = acc_magFilt < st_th/200;
    st_ths(st_th) = st_th/200;


    % -------------------------------------------------------------------------
    % Compute orientation

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
    % Compute translational accelerations

    % Rotate body accelerations to Earth frame
    acc = quaternRotate([accX accY accZ], quaternConj(quat));

    % % Remove gravity from measurements
    % acc = acc - [zeros(length(time), 2) ones(length(time), 1)];     % unnecessary due to velocity integral drift compensation

    % Convert acceleration measurements to m/s/s
    acc = acc * 9.81;

    % -------------------------------------------------------------------------
    % Compute translational velocities

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
    
    % -------------------------------------------------------------------------
    % Compute translational position

    % Integrate velocity to yield position
    pos = zeros(size(vel));
    for t = 2:length(pos)
        pos(t,:) = pos(t-1,:) + vel(t,:) * samplePeriod;    % integrate velocity to yield position
    end
    
    %disp('Erro: ')
    % X max deve ser proximo a 3.3
    % Y max deve ser proximo a 2.7
    % Z max deve ser proximo a 0
    % Erro = sqrt(errox^2+erroy^2+erroz^2)
    x_max = max(abs(pos(:,1)));
    y_max = max(abs(pos(:,2)));
    z_max = max(abs(pos(:,3)));
    erro_dist = sqrt((x_max-3.3)^2 + (y_max-2.7)^2 + (z_max-0)^2);
    dist_erros(st_th) = erro_dist;
    disp(st_th)
end

plot(st_ths, dist_erros)
xlabel('Th')
ylabel('Error')
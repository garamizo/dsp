%% DSP - Laboratory #6
% Guilherme Aramizo Ribeiro
%% Definitions
rpm = 15000; % motor operating speed [rpm]

%% Getting calibration factor
% Calibrating a signal
%     Input frequency range: [Fmin Fmax] = [149.2 149.2] Hz
%     Input voltage range: [Vmin Vmax] = ?
% 
%     Fs = 13.1072e6/(256*31) > 300 Hz = 2*Fmax
%     winsize = 476, minimize leakage
%     noavg = 32

% acquisition parameters
Fs = 13.1072e6/(256*31);
winsize = 476;
noavg = 32;
range = 5;
bits = 24;

% Simulate signal
time = linspace(0, (winsize*(noavg+2))/Fs, winsize*(noavg+2)).';
calib_factor_ = 9.81*3/5; % (m/s^2)/V
y = myDSP.discretize( ...
    (9.8*sqrt(2))*sin(2*pi*149.2*time) / calib_factor_, bits, range);

%{
plot(time*1e3, y, 'o-')
xlim([0 30])
xlabel('time [ms]'); ylabel('acc voltage [V]')
%}

% Visualize auto-power
yreshaped = myDSP.reshape(y, winsize, 0);

win = window(@flattopwin, winsize);
gain = [1; 2*ones(winsize-1, 1)] / (mean(win)*winsize);

GY = bsxfun(@times, fft(bsxfun(@times, yreshaped, win)), gain);
Gyy = squeeze(mean(conj(GY) .* GY, 2));

f = linspace(0, Fs, winsize);

figure
subplot(211); semilogy(f, sqrt(Gyy)); grid on; grid minor
xlim([0 Fs/2]); xlabel('frequency [Hz]')
subplot(212); plot(time*1e3, y, 'o-'); xlabel('time [s]'); xlim([0 30])

calib_factor = (9.81*sqrt(2))/2.355; % Calibration factor

%% Set #1

% Steady state 0.5*rpm speed
%     Input frequency range: [Fmin Fmax] = [149.2 149.2] Hz
%     Input voltage range: [Vmin Vmax] = ?
% 
%     Fs = 13.1072e6/(256*31) > 300 Hz = 2*Fmax
%     winsize = 476, minimize leakage
%     noavg = 32

% acquisition parameters
Fs = 13.1072e6/(256*31);
winsize = 476;
noavg = 32;
range = 5;
bits = 24;




close all;
clear all;

% GENERATE SIGNAl
noise = randn(50000,1);
x = filter(1,[1 1/2 1/3 1/4], noise); % 3rd order forward predictor
x = x(end-4096+1:end); % last 4096 samples of AR process to avoid startup transients

% LPC
a = lpc(x,3); % signal, filter order
est_x = filter([0 -a(2:end)],1,x);

% COMPARE LAST 100 SAMPLES OF EACH
plot(1:100, x(end-100+1:end), 1:100,est_x(end-100+1:end), '--')
grid
xlabel('Sample Number')
ylabel('Amplitude')
legend('Original signal','LPC estimate')

% PREDICTION ERROR
e = x - est_x;
[acs, lags] = xcorr(e,'coeff');

% PLOT AUTOCORRELATION
figure(2)
plot(lags, acs)
grid
xlabel('Lags')
ylabel('Normalized Autocorrelation')
ylim([-0.1 1.1])
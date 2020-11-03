%% lpss_fft.m
%%
%% Load wav and plot in frequency domain using fft
%% Construct proper one-sided function for display

close all;clear all;clc;

[y, Fs] = audioread('samples/hood_m.wav');
L = length(y); % number of samples

% PLOT TIME DOMAIN
figure(1);
title('time domain')
plot(y);
xlabel('t (milliseconds)');
ylabel('X(t)');

% CALCULATE FFT
Y = fft(y);
P2 = abs(Y/L); % two-sided spectrum
P1 = P2(1:L/2+1); % single-sided spectrum
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

% PLOT FFT
figure(2);
title('fft')
plot(f, P1);
xlabel('f (Hz)')
ylabel('|P1(f)|')
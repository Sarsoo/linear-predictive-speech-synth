%% lpss_cepstrum.m
%%
%% Load wav and calculate cepstrum

close all;clear all;clc;

CEPSTRUM_COEFFS = 100;

% READ SIGNAL
[y, Fs] = audioread('samples/hood_m.wav');
sample_length = length(y);
half = sample_length / 2;

t = (0:sample_length - 1);
c = rceps(y);
% c = cceps(y);
% plot(t(1:sample_length), c(1:sample_length))
plot(t(1:half), c(1:half))

xlabel('Quefrency')
ylabel('ceps(x[n])')
% xlim([0 sample_length])
xlim([0 half])

%% PLOT FFT

c = cceps(y);
c(CEPSTRUM_COEFFS:end) = 0;
% [cep_freqs, cep_vals] = fft_(c, Fs);
cep_vals = fft(c);
cep_vals = cep_vals(1:floor(sample_length/2+1));
cep_freqs = Fs*(0:(sample_length/2))/sample_length;

figure(2)
cep_plot = plot(cep_freqs, 20*log10(abs(cep_vals)), 'g');
cep_plot.LineWidth = 2;
hold off
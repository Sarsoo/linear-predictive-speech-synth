%% lpss_cepstrum.m
%%
%% Load wav and calculate cepstrum

close all;clear all;clc;

CEPSTRUM_COEFFS = 100;
CEPSTRUM_THRESHOLD = 0.1;
LOW_PASS_COEFF = 0.9;
F0 = 60; % low-pitched male speech
% F0 = 600; % children

CEPSTRUM_FFT = false;

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
title('Cepstrum')

%% PLOT FFT
if CEPSTRUM_FFT
    
c(CEPSTRUM_COEFFS:end) = 0;
% [cep_freqs, cep_vals] = fft_(c, Fs);
cep_vals = fft(c);
cep_vals = cep_vals(1:floor(sample_length/2+1));
cep_freqs = Fs*(0:(sample_length/2))/sample_length;

figure(2)
cep_plot = plot(cep_freqs, 20*log10(abs(cep_vals)));
cep_plot.LineWidth = 2;

end

%% SMOOTH CEPSTRUM

a = [1 -LOW_PASS_COEFF];
[filter_vals, filter_freqs] = freqz(1, a, 1000, Fs);

figure(3)
plot(filter_freqs, 20*log10(filter_vals));
xlabel('Frequency (Hz)')
ylabel('Amplitude (dB)')
title('Low Pass Filter Response')

c_filt = filter(1, a, c);

figure(4)
plot(t(1:half), c_filt(1:half));
xlabel('Quefrency')
ylabel('ceps(x[n])')
title('Cepstrum Post-Low-Pass')

%% AUTOCORELLATION
figure(5)
autocorr(c(1:half), Fs/F0, true, Fs);
title('Cepstrum Autocorrelation')

figure(6)
[smooth_cep_autocorr, smooth_cep_lags] = autocorr(c_filt(1:half), Fs/F0, true, Fs);
title('Smoothed Cepstrum Autocorrelation')
hold on

smooth_cep_autocorr(smooth_cep_autocorr < CEPSTRUM_THRESHOLD) = 0;

maxima = islocalmax(smooth_cep_autocorr);
maxima_freqs = smooth_cep_lags(maxima)
maxima_db = smooth_cep_autocorr(maxima);

maxima_plot = plot(maxima_freqs, maxima_db, 'rx');
maxima_plot.MarkerSize = 8;
maxima_plot.LineWidth = 1.5;

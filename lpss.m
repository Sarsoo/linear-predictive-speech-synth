%% lpss.m
%%
%% Coursework script

close all;clear all;clc;

LPC_ORDER = 8;
DISPLAY_SAMPLES = 1000;
WINDOW_NUMBER = 10;
WINDOW_OVERLAP = 5; % ms

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y, Fs] = audioread('samples/hood_m.wav');
L = length(y) % number of samples
DISPLAY_SAMPLES = min([DISPLAY_SAMPLES L]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LPC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = aryule(y, LPC_ORDER) % signal, filter order
est_y = filter(0.02, a, y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PREDICTION ERROR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
e = y - est_y;
[acs, lags] = xcorr(e,'coeff');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPARE TWO SIGNALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x = 1:DISPLAY_SAMPLES;
% figure(1)
% plot(x, y(end-DISPLAY_SAMPLES+1:end), x, est_y(end-DISPLAY_SAMPLES+1:end), '--')

%plot(x, y(end-DISPLAY_SAMPLES+1:end))
%plot(x, est_y(end-DISPLAY_SAMPLES+1:end))

% grid
% xlabel('Sample Number')
% ylabel('Amplitude')
% legend('Original signal','LPC estimate')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT AUTOCORRELATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(2)
% plot(lags, acs)
% grid
% xlabel('Lags')
% ylabel('Normalized Autocorrelation')
%ylim([-0.1 1.1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT FREQUENCY RESPONSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATE FFT
[freq_dom_freqs, freq_dom_vals] = fft_(y, Fs);
 
% GET FILTER RESPONSE
[h, filter_freqs] = freqz(1, a, length(freq_dom_freqs), Fs);

figure(3)
plot(freq_dom_freqs, 20*log10(freq_dom_vals), 'r', filter_freqs, 20*log10(abs(h)), 'b')
% plot(w/pi, 20*log10(abs(h)))
grid
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
legend('Original Signal', 'LPC Filter')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT ORIGINAL SPECTROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(4)
% spectro(y, Fs, WINDOW_NUMBER, WINDOW_OVERLAP);
% colormap bone

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sound(y, Fs);

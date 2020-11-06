%% lpss_preemph.m
%%
%% Load wav and play with preemphasis filter

close all;clear all;clc;

[y, Fs] = audioread('samples/hood_m.wav');

b = [1 -0.68];

[filter_vals, filter_freqs] = freqz(b, 1, 1000, Fs);

%% PREEMPH FILTER RESPONSE
figure(1)
plot(filter_freqs, filter_vals);
xlabel('Frequency (Hz)')
ylabel('Amplitude')

%% ORIGINAL FFT
[freq_dom_freqs, freq_dom_vals] = fft_(y, Fs);
figure(2)
plot(freq_dom_freqs, 20*log10(freq_dom_vals));
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Original spectrum')

%% POST FILTER FFT
y_filt = filter(b, 1, y);
[freq_dom_freqs_post, freq_dom_vals_post] = fft_(y_filt, Fs);
figure(3)
plot(freq_dom_freqs_post, 20*log10(freq_dom_vals_post));
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Post-filter spectrum')

%% BOTH
figure(4)
plot(freq_dom_freqs, 20*log10(freq_dom_vals), 'b');
hold on
plot(freq_dom_freqs_post, 20*log10(freq_dom_vals_post), 'r--');
hold off
xlabel('Frequency (Hz)')
ylabel('Amplitude')
legend('Original Signal', 'Filtered')
title('Post-filter spectrum')
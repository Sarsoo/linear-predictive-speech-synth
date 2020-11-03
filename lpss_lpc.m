%% lpss_lpc.m
%%
%% Load wav and calculate LPC coeffs

close all;clear all;clc;

ORDER = 50;
DISPLAY_SAMPLES = 1000;

% READ SIGNAL
[y, Fs] = audioread('samples/hood_m.wav');
L = length(y) % number of samples
DISPLAY_SAMPLES = min([DISPLAY_SAMPLES L]);

% CALCULATE FFT
[freq_dom_freqs, freq_dom_vals] = fft_(y, Fs);

for ITER=1:5:ORDER
    
    % LPC
    a = lpc(y,ITER); % signal, filter order
    
    % COMPARE FREQ DOMAIN
    [h, filter_freqs] = freqz(1, a, length(freq_dom_freqs), Fs);
    
    figure(1)
    plot(freq_dom_freqs, 20*log10(freq_dom_vals), 'r', filter_freqs, 20*log10(abs(h)), 'b')
    % plot(w/pi, 20*log10(abs(h)))
    grid
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
    legend('Original Signal', 'LPC Filter')

    % COMPARE TWO SIGNALS TIME DOMAIN
%     est_y = filter(0.02, a, y);
%     x = 1:DISPLAY_SAMPLES;
%     figure(2)
%     plot(x, y(end-DISPLAY_SAMPLES+1:end), x, est_y(end-DISPLAY_SAMPLES+1:end), '--')
%     %plot(x, y(end-DISPLAY_SAMPLES+1:end))
%     %plot(x, est_y(end-DISPLAY_SAMPLES+1:end))
%     grid
%     xlabel('Sample Number')
%     ylabel('Amplitude')
%     legend('Original signal','LPC estimate')


    pause(0.5)

end
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

index = 1;

for ITER=1:5:ORDER
    
    subplot(4, 2, index);
    
    % LPC
    a = lpc(y,ITER); % signal, filter order
    
    % COMPARE FREQ DOMAIN
    [h, filter_freqs] = freqz(1, a, length(freq_dom_freqs), Fs);
    
    figure(1)
    %% SIGNAL FFT RESPONSE
    orig_freq_plot = plot(freq_dom_freqs, 20*log10(abs(freq_dom_vals)), 'black');
    orig_freq_plot.Color(4) = 0.1;
    orig_freq_plot.LineWidth = 1;
    hold on
    
    %% LPC FILTER RESPONSE
    [filter_vals, filter_freqs] = freqz(1, a, length(freq_dom_freqs), Fs);
    filter_vals_db = 20*log10(abs(filter_vals));

    lpc_freq_plot = plot(filter_freqs, filter_vals_db, 'b');
    lpc_freq_plot.LineWidth = 2;
    
    %% ARYULE FILTER RESPONSE
    ary = aryule(y, ITER);
    [filter_vals, filter_freqs] = freqz(1, ary, length(freq_dom_freqs), Fs);
    filter_vals_db = 20*log10(abs(filter_vals));

    lpc_freq_plot = plot(filter_freqs, filter_vals_db, 'r');
    lpc_freq_plot.LineWidth = 1;
    
    %% ARCOV FILTER RESPONSE
    arc = arcov(y, ITER);
    [filter_vals, filter_freqs] = freqz(1, arc, length(freq_dom_freqs), Fs);
    filter_vals_db = 20*log10(abs(filter_vals));

    lpc_freq_plot = plot(filter_freqs, filter_vals_db, 'g');
    lpc_freq_plot.LineWidth = 1;
    
%     % MAXIMA
%     % estimate formant frequencies from maxima of LPC filter freq response
%     maxima = islocalmax(filter_vals_db);
%     maxima_freqs = filter_freqs(maxima)
%     maxima_db = filter_vals_db(maxima);
% 
%     if length(maxima_freqs) ~= 0
%         maxima_plot = plot(maxima_freqs, maxima_db, 'rx');
%         maxima_plot.MarkerSize = 12;
%         maxima_plot.LineWidth = 2;
%     end
    
    % plot(freq_dom_freqs, 20*log10(freq_dom_vals), 'r', filter_freqs, 20*log10(abs(h)), 'b')
    % plot(w/pi, 20*log10(abs(h)))
    hold off
    grid
    xlabel('Frequency (Hz)')
    ylabel('Magnitude (dB)')
%     legend('Original Signal', 'LPC Filter', 'Local Maxima')
    legend('Original Signal', 'LPC Filter', 'Aryule LPC Filter', 'Arcov LPC Filter')
    title(strcat(['LPC Spectra: Order ' num2str(ITER)]));

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

    index = index + 1;

end
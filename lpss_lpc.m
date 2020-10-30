%% lpss_lpc.m
%%
%% Load wav and calculate LPC coeffs

close all;
clear all;

ORDER = 40;
DISPLAY_SAMPLES = 1000;

% READ SIGNAL
[y, Fs] = audioread('samples/hood_m.wav');
sample_size = size(y);
L = sample_size(1); % number of samples
DISPLAY_SAMPLES = min([DISPLAY_SAMPLES L]);

for ITER=1:ORDER
    
    % LPC
    a = lpc(y,ITER); % signal, filter order
    est_y = filter(0.02, a, y);

    % PREDICTION ERROR
    e = y - est_y;
    [acs, lags] = xcorr(e,'coeff');

    % COMPARE TWO SIGNALS
    x = 1:DISPLAY_SAMPLES;
    figure(2)
    plot(x, y(end-DISPLAY_SAMPLES+1:end), x, est_y(end-DISPLAY_SAMPLES+1:end), '--')
    %plot(x, y(end-DISPLAY_SAMPLES+1:end))
    %plot(x, est_y(end-DISPLAY_SAMPLES+1:end))
    grid
    xlabel('Sample Number')
    ylabel('Amplitude')
    legend('Original signal','LPC estimate')

    % PLOT AUTOCORRELATION
%     figure(2)
%     plot(lags, acs)
%     grid
%     xlabel('Lags')
%     ylabel('Normalized Autocorrelation')
%     ylim([-0.1 1.1])

end
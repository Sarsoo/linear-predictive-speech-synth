%% lpss.m
%%
%% Coursework script

close all;clear all;clc;

SEGMENT_LENGTH = 100; % ms
SEGMENT_OFFSET = 0; % ms from start

LPC_ORDER = 20;
AC_DISP_SAMPLES = 1000; % autocorrelation display samples
WINDOW_NUMBER = 10;
WINDOW_OVERLAP = 5; % ms

F0 = 60; % low-pitched male speech
% F0 = 600; % children

% flags for selective running
FREQ_RESPONSE = ~false;
AUTOCORRELATION = false;
CEPSTRUM_PLOT = false;
CEPSTRUM_ONE_SIDED = true;
ORIG_LPC_T_COMPARE = false;
ORIG_SPECTROGRAM = false;
PLAY = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y, Fs] = audioread('samples/hood_m.wav');
y = clip_segment(y, Fs, SEGMENT_LENGTH, SEGMENT_OFFSET);

L = length(y) % number of samples

max_lag = Fs/ F0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LPC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = lpc(y, LPC_ORDER) % signal, filter order
est_y = filter(0.02, a, y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPARE ORIGINAL SIGNAL WITH LPC (T DOMAIN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ORIG_LPC_T_COMPARE
x = 1:AC_DISP_SAMPLES;
AC_DISP_SAMPLES = min([AC_DISP_SAMPLES L]);

figure(1)
plot(x, y(end-AC_DISP_SAMPLES+1:end), x, est_y(end-AC_DISP_SAMPLES+1:end), '--')

% plot(x, y(end-DISPLAY_SAMPLES+1:end))
% plot(x, est_y(end-DISPLAY_SAMPLES+1:end))

grid
xlabel('Sample Number')
ylabel('Amplitude')
legend('Original signal','LPC estimate')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% T DOMAIN PREDICTION ERROR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_domain_err = y - est_y;

if AUTOCORRELATION
figure(2)
[acs, lags] = autocorr(t_domain_err, max_lag, true, Fs);
title('Autocorrelation for error in  Time domain')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FREQUENCY RESPONSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FREQ_RESPONSE
figure(3)

%% ORIGINAL FFT
[freq_dom_freqs, freq_dom_vals] = fft_(y, Fs);

orig_freq_plot = plot(freq_dom_freqs, 20*log10(abs(freq_dom_vals)), 'black');
orig_freq_plot.Color(4) = 0.25;
orig_freq_plot.LineWidth = 1;
hold on

%% LPC FILTER RESPONSE
[filter_vals, filter_freqs] = freqz(1, a, length(freq_dom_freqs), Fs);
filter_vals_db = 20*log10(abs(filter_vals));

lpc_freq_plot = plot(filter_freqs, filter_vals_db, 'b');
lpc_freq_plot.LineWidth = 2;

% MAXIMA
maxima = islocalmax(filter_vals_db);
maxima_freqs = filter_freqs(maxima)
maxima_db = filter_vals_db(maxima)

maxima_plot = plot(maxima_freqs, maxima_db, 'rx');
maxima_plot.MarkerSize = 12;
maxima_plot.LineWidth = 2;

%% PLOT
hold off
grid
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
legend('Original Signal', 'LPC Filter', 'LPC Maxima')
title('Frequency Response For Speech Signal and LPC Filter')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CEPSTRUM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cep = rceps(y);
% cep = cceps(y);

if CEPSTRUM_PLOT
ceps_t = (0:L - 1);

figure(4)
if CEPSTRUM_ONE_SIDED
    plot(ceps_t(1:L / 2), cep(1:L / 2))
else
    plot(ceps_t(1:L), cep(1:L))
end

grid
xlabel('Quefrency')
ylabel('ceps(x[n])')
if CEPSTRUM_ONE_SIDED
    xlim([0 L / 2])
    title('One-sided Speech Signal Cepstrum')
else
    xlim([0 L])
    title('Speech Signal Cepstrum')
end
end

%% AUTOCORRELATION
if AUTOCORRELATION
figure(5)
[cep_autocorr, cep_lags] = autocorr(cep(1:L/2), max_lag, true, Fs);
title('One-sided Cepstrum Autocorrelation')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT ORIGINAL SPECTROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ORIG_SPECTROGRAM
figure(6)
spectro(y, Fs, WINDOW_NUMBER, WINDOW_OVERLAP);
colormap bone
title('Speech Signal Spectrogram')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PLAY
sound(y, Fs);
end
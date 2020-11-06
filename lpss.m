%% lpss.m
%%
%% Coursework script

close all;clear all;clc;

SEGMENT_LENGTH = 100; % ms
SEGMENT_OFFSET = 0; % ms from start

LPC_ORDER = 20;
AC_DISP_SAMPLES = 1000; % autocorrelation display samples
WINDOW_NUMBER = 10; % number of windows for spectrogram
WINDOW_OVERLAP = 5; % ms
SYNTH_WINDOW_NUMBER = 100; % number of windows for spectrogram
SYNTH_WINDOW_OVERLAP = 10; % ms

PREEMPHASIS_COEFFS = [1 -0.8]; % first order zero coeff for pre-emphasis

F0 = 60; % low-pitched male speech
% F0 = 600; % children

% flags for selective running
PREEMPHASIS = false;
CEPSTRUM_LOW_PASS = true; % smooth cepstrum for fund. freq. isolation
CEPSTRUM_LOW_PASS_COEFFS = [1 -0.7];

FREQ_RESPONSE = true;
AUTOCORRELATION = false;

CEPSTRUM_COMPLEX = false; % else real cepstrum
CEPSTRUM_PLOT = true;
CEPSTRUM_THRESHOLD = 0.075; % threshold for isolating peaks in cepstrum

ORIG_LPC_T_COMPARE = false;

ORIG_SPECTROGRAM = true;
SYNTH_SPECTROGRAM = true;

SYNTHESISED_SOUND_LENGTH = 500; % ms

PLAY = false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[y, Fs] = audioread('samples/head_f.wav');
% take segment of sample for processing
y = clip_segment(y, Fs, SEGMENT_LENGTH, SEGMENT_OFFSET);
y_orig = y;

if PREEMPHASIS
    y = filter(PREEMPHASIS_COEFFS, 1, y);
end

L = length(y); % number of samples

max_lag = Fs/ F0; % for autocorrelation

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

% plot t domain for original signal and estimation using LPC coeffs

figure(1)
plot(x, y(end-AC_DISP_SAMPLES+1:end), x, est_y(end-AC_DISP_SAMPLES+1:end), '--')

grid
xlabel('Sample Number')
ylabel('Amplitude')
legend('Original signal','LPC estimate')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% T DOMAIN PREDICTION ERROR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_domain_err = y - est_y; % residual?

if AUTOCORRELATION
figure(2)
[acs, lags] = autocorr(t_domain_err, max_lag, true, Fs);
title('Autocorrelation of error in time domain')
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
% estimate formant frequencies from maxima of LPC filter freq response
maxima = islocalmax(filter_vals_db);
maxima_freqs = filter_freqs(maxima)
maxima_db = filter_vals_db(maxima);

maxima_plot = plot(maxima_freqs, maxima_db, 'rx');
maxima_plot.MarkerSize = 12;
maxima_plot.LineWidth = 2;

%% PRE_FILTER LPC
if PREEMPHASIS
    [prefilter_vals, prefilter_freqs] = freqz(1, lpc(y_orig, LPC_ORDER), length(freq_dom_freqs), Fs);

    prefilter_plot = plot(prefilter_freqs, 20*log10(abs(prefilter_vals)), 'g');
    prefilter_plot.Color(4) = 0.8;
    prefilter_plot.LineWidth = 1;
end

%% PLOT
hold off
grid
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
if PREEMPHASIS
    legend('Original Signal', 'LPC Filter', 'LPC Maxima', 'LPC No Pre-emphasis')
else
    legend('Original Signal', 'LPC Filter', 'LPC Maxima')
end
title('Frequency Response For Speech Signal and LPC Filter')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CEPSTRUM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if CEPSTRUM_COMPLEX
    cep = cceps(y);
else
    cep = rceps(y);
end
cep_filt = filter(1, CEPSTRUM_LOW_PASS_COEFFS, cep);

if CEPSTRUM_PLOT % plot cepstrum in t domain
ceps_t = (0:L - 1);

if CEPSTRUM_LOW_PASS
    c = cep_filt;
else
    c = cep;
end

figure(4)
hold on
plot(ceps_t(1:round(L / 2)), c(1:round(L / 2)))

%% MAXIMA 
% value threshold
c(c < CEPSTRUM_THRESHOLD) = 0;
cep_maxima_indexes = islocalmax(c);

cep_maxima_times = ceps_t(1:round(L / 2));
cep_maxima_times = ceps_t(cep_maxima_indexes);
c = c(cep_maxima_indexes);

% quefrency threshold
cep_time_indexes = 20 < cep_maxima_times;
cep_maxima_times = cep_maxima_times(cep_time_indexes);
c = c(cep_time_indexes);

% 1st half
cep_half_indexes = cep_maxima_times <= round(L / 2);
cep_maxima_times = cep_maxima_times(cep_half_indexes);
c = c(cep_half_indexes);

maxima_plot = plot(cep_maxima_times, c, 'rx');
maxima_plot.MarkerSize = 8;
maxima_plot.LineWidth = 1.5;

grid
xlabel('Quefrency')
ylabel('ceps(x[n])')
xlim([0 L / 2])
title('Speech Signal Cepstrum')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CALCULATE FUNDAMENTAL FREQUENCY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CEPSTRUM
if CEPSTRUM_PLOT && length(cep_maxima_times) >= 1    
    pitch_period = cep_maxima_times(c == max(c));
    fundamental_freq = 1 / (pitch_period / Fs)
else
    disp('pitch periods not identified')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERATE SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('fundamental_freq')
    excitation = get_impulse_train(fundamental_freq, Fs, SYNTHESISED_SOUND_LENGTH);

    synth_sound = filter(1, a, excitation);
    
    audiowrite('out.wav', synth_sound, Fs);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SPECTROGRAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ORIG_SPECTROGRAM
figure(6)
spectro(y, Fs, WINDOW_NUMBER, WINDOW_OVERLAP);
colormap bone
title('Speech Signal Spectrogram')
end

if SYNTH_SPECTROGRAM
figure(7)
spectro(synth_sound, Fs, SYNTH_WINDOW_NUMBER, SYNTH_WINDOW_OVERLAP);
colormap bone
title('Synthesised Vowel Sound Spectrogram')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PLAY
sound(y, Fs);
pause(1);
if exist('synth_sound')
    sound(synth_sound, Fs);
end
end
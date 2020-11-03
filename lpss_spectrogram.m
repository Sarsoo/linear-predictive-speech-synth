%% lpss_spectrogram.m
%%
%% Load wav and plot spectrogram

close all;clear all;clc;

WINDOW_NUMBER = 20;

% matrix by audio channel and sample frequency
[y, Fs] = audioread('samples/hood_m.wav');
window_size = round(length(y) / ((WINDOW_NUMBER + 1)/2));

freqRes = Fs / window_size
timeRes = window_size / Fs

spectrogram(y, window_size, round(window_size/2), [], Fs, 'yaxis');
%view(-45, 65) % For spinning the map on its axis for a 3D view
%colormap bone % grayscale
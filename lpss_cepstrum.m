%% lpss_cepstrum.m
%%
%% Load wav and calculate cepstrum

close all;clear all;clc;

% READ SIGNAL
[y, Fs] = audioread('samples/hood_m.wav');

t = (0:length(y) - 1);
c = rceps(y);
% c = cceps(y);
plot(t, c)
xlabel('Quefrency')
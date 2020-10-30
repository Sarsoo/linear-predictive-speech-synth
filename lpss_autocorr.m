%% lpss_autocorr.m
%%
%% Load wav and run through autocorr from econometrics toolbox
%% Used max range of m lags calculated from sample frequency

close all;
clear all;

[y, Fs] = audioread('samples/hood_m.wav');
sample_size = size(y);
L = sample_size(1); % number of samples

f0 = 60; % low-pitched male speech
%f0 = 600; % children

m = Fs / f0; % from lecture 2, max number of lags required to search

autocorr(y,'NumLags', m)
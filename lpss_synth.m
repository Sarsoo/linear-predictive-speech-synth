%% lpss.m
%%
%% Coursework script

close all;clear all;clc;

Fs = 24000; % Hz, sampling
Ff = 100; % Hz, fundamental
sample_length = 1000; % ms

sample = get_impulse_train(Ff, Fs, sample_length)
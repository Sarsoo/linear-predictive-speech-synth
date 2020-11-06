%% get_impulse_train.m
%%
%% Generate periodic impulse train for use in speech synth
%%
%% Signal of pitch fundamental_freq sampled at sampling_freq
%% for time length_ms
function signal = get_impulse_train(fundamental_freq, sampling_freq, length_ms)

if fundamental_freq > sampling_freq
    disp('Fundamental frequency greater than sampling_freq')
    signal = [];
    return
end

required_samples = ms_to_samples(length_ms, sampling_freq);
pitch_period = 1 / fundamental_freq;
sample_period = 1 / sampling_freq;

cell_length = round(pitch_period / sample_period);

% cell to be repeated into periodic signal
pitch_cell = [1 zeros(1, cell_length - 1)];
required_cells = ceil(required_samples / cell_length);

signal = repmat(pitch_cell, 1, required_cells);
signal = signal(1:required_samples);
end

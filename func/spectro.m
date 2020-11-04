function spectro(signal, sample_frequency, windows, overlap_interval)

sample_overlap = ms_to_samples(overlap_interval, sample_frequency);

sample_size = size(signal);
%window_size = round(sample_size(1) / ((windows + 1)/2))

% Turn windows into window width in samples, take into account overlap
window_size = round((sample_size(1) + (windows + 1) * sample_overlap) / (windows+1));

spectrogram(signal, window_size, sample_overlap, [], sample_frequency, 'yaxis');

end


function samples = ms_to_samples(time_in, sample_freq)
    samples = (time_in / 1000) * sample_freq;
end
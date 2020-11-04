function output = clip_segment(signal, Fs, seg_length, offset)

signal_length_samples = length(signal);
seg_length_samples = min(ms_to_samples(seg_length, Fs), signal_length_samples);
offset_samples = max(ms_to_samples(offset, Fs), 1);

seg_length_samples = min(seg_length_samples, signal_length_samples - 1);

if signal_length_samples < seg_length_samples + offset_samples
    offset_samples = signal_length_samples - seg_length_samples;
end

output = signal(offset_samples:offset_samples + seg_length_samples);

end


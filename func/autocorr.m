function [cep_autocorr, cep_lags] = autocorr(signal, max_lags, time, Fs)

[cep_autocorr, cep_lags] = xcorr(signal, max_lags, 'coeff');
% [cep_autocorr, cep_lags] = xcorr(signal, 'coeff');

if time
    cep_lags = 1000*cep_lags/Fs; % turn samples into ms
end

plot(cep_lags, cep_autocorr)
grid
if time
    xlabel('Delay (ms)')
else
    xlabel('Delay (samples)')
end
ylabel('Normalized Autocorrelation')
title('Autocorrelation')
xlim([min(cep_lags) max(cep_lags)]);

end


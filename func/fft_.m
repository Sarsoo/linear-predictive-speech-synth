function [frequencies, values] = fft_(signal, sample_frequency)

L=length(signal);

Y = fft(signal);
P2 = abs(Y); % two-sided spectrum
% P2 = abs(Y/L); % two-sided spectrum
P1 = P2(1:floor(L/2+1)); % single-sided spectrum
P1(2:end-1) = 2*P1(2:end-1);
frequencies = sample_frequency*(0:(L/2))/L;
values = P1;

end


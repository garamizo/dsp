classdef myDSP  
methods(Static)

function [SIGNAL, nowin] = reshape(signal, win_size, overlap_p)
%RESHAPE Reshape vector in window blocks, with overlaps
%     Example:
%     % Generate data
%     % Define dynamic system
%     sys = rss(3, 2, 1);
%     Fs = -100*min(real(eig(sys.A)));
%     N = 10000;
% 
%     time = linspace(0, N/Fs, N).';
%     u = reshape(repmat(randn(round(N/20),1), [1 20]).', [N 1]);
%     y = lsim(sys, u, time);
% 
%     winsize = 1000;
%     overlap = 0.3;
%     yreshaped = myDSP.reshape(y, winsize, overlap);
%     ureshaped = myDSP.reshape(u, winsize, overlap);
% 
%     win = window(@hann, winsize);
%     gain = [1; 2*ones(winsize-1, 1)] / (mean(win)*winsize);
% 
%     GY = bsxfun(@times, fft(bsxfun(@times, yreshaped, win)), gain);
%     Gyy = squeeze(mean(conj(GY) .* GY, 2));
% 
%     GU = bsxfun(@times, fft(bsxfun(@times, ureshaped, win)), gain);
%     Guy = squeeze(mean(bsxfun(@times, conj(GU), GY), 2));
% 
%     f = linspace(0, Fs, winsize);
% 
%     figure
%     subplot(311); semilogy(f, sqrt(Gyy)); grid on; grid minor
%     xlim([0 Fs/2]); xlabel('frequency [Hz]')
%     subplot(312); semilogy(f, sqrt(abs(Guy))); grid on; grid minor
%     xlim([0 Fs/2]); xlabel('frequency [Hz]')
%     subplot(313); plot(time, y); xlabel('time [s]')

    len = size(signal, 1); % signal length
    nocha = size(signal, 2); % number of channels

    if win_size > len
        error('Window size is greater than signal size')
    end
    if overlap_p > 1 || overlap_p < 0
        error('Overlap should range between 0 and 1')
    end

    overlap = round(overlap_p*win_size);
    nowin = floor((len-win_size)/(win_size-overlap) + 1); % # of windows

    SIGNAL = zeros(win_size, nowin, nocha);
    for k = 1 : nocha
        % make overlap multiple of win_size, percentual to absolute
        idx = repmat((1:win_size).', [1 nowin]) + ...
            repmat((0:nowin-1)*(win_size-overlap), [win_size 1]);
        SIGNAL(:,:,k) = reshape(signal(idx,k), [win_size, nowin]);
    end
end 


function Y = discretize( U, N, V )
    % Discretize vector U on the range +-V into N bits

    U = uencode( U, N, V, 'signed');

    U = cast( U, 'double' );
    N = cast( N, 'double' );
    V = cast( V, 'double' );

    Y = interp1( [ -2^(N-1) 2^(N-1)-1 ], [-V V], U );
end

end


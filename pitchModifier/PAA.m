% approx. mode; not good for raising tone
filename = "refrain.m4a";
tic;[x,Fs] = audioread(filename);toc;
difkey = -2.3;    % +1 for each raising semitone
f = 0.5^(difkey/12);    % ratio of audios, >1 low freq output
tic;[y,A] = voice(x(:,1),f);toc;
%clear sound;y=y./max(y);sound(y,Fs);
filename = filename+'_key='+string(difkey)+'.wav';
%audiowrite(filename,y,Fs)
%tabulate(A(2:end)-A(1:end-1))

function [y,A] = voice(x,f)
% resample and resize the output length
mtpr = floor(2^16/sqrt(2*f));    % multipler for sampling
x = resample(x,round(f*mtpr),mtpr);
if size(x,2) == 1
    x = x';
end
ypts = round(size(x,2)/f);    % length of output
y = zeros(1,ypts);    % for output

% some samplings for interpolation
W = 1000;
xw = (1:W)/(W+1);    % weighting
ox = (1-W):0;    % origin position

padX = [zeros(1,W) x zeros(1,5*W)];
y(1:W) = x(1:W);    % initial state
pxp = 0;    % previous x position
kf = 0;    % key flag

risl = floor((f*2-1)*W);    % related-index shift length
A = zeros(1,floor(ypts/W));    % safe key flag; not essential

for yp = W:W:(ypts-2*W)    % y position
    ypox = yp+ox;
    nxp = round(f*yp);    % new x position
    kf = kf + (nxp-pxp);    % predicting key flag position
    pxp = nxp;
    
    % find the key flag (approx. part)
    if kf > W*4
        kf = kf-ceil((kf-W*4)/risl)*risl;
    end
    A(yp/W) = kf;
    
    % interpolation by weighting
    xpshift = kf+nxp+ox+W;
    y(ypox) = ((1-xw).*y(ypox)) + (xw.*padX(xpshift));
    y(ypox+W) = padX(W+xpshift);
end
end

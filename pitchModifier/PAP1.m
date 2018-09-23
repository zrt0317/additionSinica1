% precise ver
filename = "refrain.m4a";
tic;[x, Fs] = audioread(filename);toc;
difkey = -3;    % pitch raising amount; +1 for raising semitone
f = 0.5^(difkey/12);    % f: ratio of audios; f>1 low freq output
tic;[y, A] = voice(x(:, 1), f);toc;clear sound;
sound(y, Fs);
%tabulate(A(2:end)-A(1:end-1))

function [y, A] = voice(x, f)
W = 1000;    % sample and weighting length per iteration
spd = 64;    % sampling distance
iasl = 1;    % interpolate-amending steplegth

% resample and resize the output length
x = resample(x,round(f*10000),10000);
if size(x, 2) == 1
    x = x';
end
ys = round(size(x,2) / f);    % output size
y = zeros(1, ys);    % output vector

% some samplings for interpolation
xw = (1:W)/(W+1);    % weighting
ox = (1-W):0;        % origin position
sx = (1-W):spd:0;    % sampling

padX = [zeros(1, W) x zeros(1, 5*W)];    % sample range
y(1:W) = x(1:W);    % initial state
pxp = 0;    % previous x position
kf = 0;    % key flag

% interpolate-amending
k = 0:iasl:W*4;     % interpolate-amending range
ti0 = repmat(k,size(sx,2),1)'+repmat(W+sx,size(k,2),1);
A = zeros(1,floor(ys/W));    % safe key flag; not essential

for yp = W:W:(ys-2*W)    % y position
    nxp = round(f*yp);    % new x position
    kf = kf + (nxp-pxp);    % predicting key flag position
    pxp = nxp;
    
    % find the key flag
    if kf > W*4
        ti = ti0+nxp;
        
        % parallel computing / not to save all values?
        t = padX(ti);
        rx = [sqrt(sum(abs(t).^2,2))'
            sum(t.*repmat(y(yp+sx),size(k,2),1),2)'];
        R = (rx(1,:) ~= 0).*rx(2,:)./(rx(1,:)+(rx(1,:)==0));
        kf = min(find(R == max(R))-1);
    end
    
    A(yp/W) = kf;
    
    % interpolation by weighting
    xpshift = kf+ox+W+nxp;
    y(yp+ox) = ((1-xw).*y(yp+ox)) + (xw.*padX(xpshift));
    y(yp+ox+W) = padX(W+xpshift);
end
end

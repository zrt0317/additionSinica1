clear;close all;
A = double(imread('cameraman.tif'));
Axx = A;
max_iter = 800;
lambda = 5;

%templet = randperm(size(A,1)*size(A,2),ceil(size(A,1)*size(A,2)/2));
templet = (rem(A,5)==1);
P = ones(size(A,1),size(A,2));
P(templet) = 0;
A(templet) = 0;
tb = 0;
ta = 1;

R = decomwav(A);
imshow(reconwav(R), [],'InitialMagnification','fit')
xb = R;
xa = R;

show = Axx;
absdelM = zeros(1, max_iter);
reldelM = zeros(1, max_iter);

for k = 1:max_iter
    y = xa + ((tb-1)/ta)*(xa-xb);
    g = y - decomwav(P.*reconwav(y)) + R;
    xb = xa;
    temp = abs(g)-lambda;
    xa = sign(g).*temp.*(temp>0);
    xa(:,:,1,1) = g(:,:,1,1);
    tt = ta;
    ta = (1+sqrt(1+4*ta^2))/2;
    tb = tt;
    if mod(k-1,10) == 0
        showold = show;
        show = reconwav(y);
        
        imshow(show, [],'InitialMagnification','fit')
        title(k);
        pause(.01)
        absdelM(k) = sum(sum(abs(Axx-show)));
        reldelM(k) = max(max(abs(showold-show)));
    end    
end

figure
semilogy(nonzeros(absdelM))
figure
semilogy(nonzeros(reldelM))
[a,b]=min(nonzeros(absdelM))
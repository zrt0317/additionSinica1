function reconwav = reconwav(D)

%M = [1/4 1/2 1/4; sqrt(2)/4 0 -sqrt(2)/4; -1/4 1/2 -1/4];
M = [1/16 1/4 3/8 1/4 1/16;
    1/16 -1/4 3/8 -1/4 1/16;
    -1/8 1/4 0 -1/4 1/8;
    sqrt(6)/16 0 -sqrt(6)/8 0 sqrt(6)/16;
    -1/8 -1/4 0 1/4 1/8];
reconwav = zeros(size(D,1),size(D,2));

RE = zeros(size(D));

for r1 = 1:size(M,1)
    for r2 = 1:size(M,1)
        RE(:,:,r1,r2) = conv2(conv2(D(:,:,r1,r2),M(r2,end:-1:1)','same'),M(r1,end:-1:1),'same');
        reconwav = reconwav + RE(:,:,r1,r2);
    end
end

end
function decomwav = decomwav(A)

%M = [1/4 1/2 1/4; sqrt(2)/4 0 -sqrt(2)/4; -1/4 1/2 -1/4];
M = [1/16 1/4 3/8 1/4 1/16;
    1/16 -1/4 3/8 -1/4 1/16;
    -1/8 1/4 0 -1/4 1/8;
    sqrt(6)/16 0 -sqrt(6)/8 0 sqrt(6)/16;
    -1/8 -1/4 0 1/4 1/8];
decomwav = zeros(size(A,1),size(A,2),size(M,1),size(M,1));

for r1 = 1:size(M,1)
    TEMP = conv2(A,M(r1,:),'same');
    for r2 = 1:size(M,1)
        decomwav(:,:,r1,r2) = conv2(TEMP,M(r2,:)','same');
    end
end

end
% Enter your sodoku problem here
M =[0 0 5 3 0 0 0 0 0
    8 0 0 0 0 0 0 2 0
    0 7 0 0 1 0 5 0 0 
    4 0 0 0 0 5 3 0 0
    0 1 0 0 7 0 0 0 6
    0 0 3 2 0 0 0 8 0
    0 6 0 5 0 0 0 0 9
    0 0 4 0 0 0 0 3 0
    0 0 0 0 0 9 7 0 0];
% Above is a problem given by Arto Inkala

S =sodoku(M)    % sove the sodoku and print

function S = sodoku(M,S)
if nargin==1
    S = zeros([size(M),0]);
end

firstId = find(M(:)==0, 1);    % find first blank cell
if isempty(firstId)    % no blanks: solution
    S(:,:,size(S,3)+1) = M;    % save
else    % calculate the list of all valid numbers
    i = mod(firstId-1,9)+1;
    j = ceil(firstId/9);
    m = M(ceil(i/3)*3-2:ceil(i/3)*3,...
        ceil(j/3)*3-2:ceil(j/3)*3);    % 3*3 block
    for k = 1:9     % loop through all 9 possibilities
        if ~sum(M(i,:)==k) && ~sum(M(:,j)==k) && ~sum(m(:)==k)
            M(i,j) = k;    % OK for column, row, and block: put in
            S = sodoku(M,S);    % recursive
        end
    end
end
end

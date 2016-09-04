function covc = ar(p1,rho)
% Function ar aims to generate an AR correlation matrix \Sigma which satisfies \Sigma_{jk} = rho ^|j-k|
% Input:
%	p1: the dimension of the correlation matrix
% 	rho: controls the degree of association
% Ouput:
%   covc: a correlation matrix
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/09/02 $
covc = zeros(p1);
for i = 1:p1
    for j = 1:p1
        covc(i,j) = rho^(abs(i-j));
    end
end

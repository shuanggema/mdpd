function value = fprcal(betahat,betaori)
% Function fprcal aims to calculate the false positive rate of the esimated beta 
% Input:
% 	betahat: estimated beta. p dimensional vector.
%	betaori: original beta. p dimensional vector.
% Ouput:
%   value: the false positive rate
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/05/03 $
index1 = find(abs(betahat)>0.001);
index2 = find(abs(betaori)>0.001);
index3 = setdiff(index1,index2);
index4 = find(abs(betaori)<= 0.001);
value = length(index3)/length(index4);
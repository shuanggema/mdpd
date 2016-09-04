function value=tprcal(betahat,betaori)
% Function tprcal aims to calculate the true positive rate of the esimated beta 
% Input:
% 	betahat: estimated beta. p dimensional vector.
%	betaori: original beta. p dimensional vector.
% Ouput:
%   value: the true positive rate
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/09/02 $
index1=find(abs(betahat)>0.001);
index2=find(abs(betaori)>0.001);
index3=setdiff(index1,index2);
value=(length(index1)-length(index3))/length(index2);
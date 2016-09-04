function auc = auccalc(FPR,TPR)
% Function auccalc aims to calculate the area under the curve (AUC)
% Input:
%	FPR: false positive rate set
% 	TPR: true positive rate set
% Ouput:
%   auc: the area under the curve (AUC)
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/09/02 $
FPR(1) = 0;
TPR(1) = 0;
FPR(length(FPR)) = 1;
TPR(length(TPR)) = 1;
auc = 0;
[FPR,indexxx] = sort(FPR);
TPR = TPR(indexxx);
for i = 1:length(FPR)
    if i == 1
        auc = auc+FPR(i)*TPR(i)/2;
    else
        auc = auc+(FPR(i)-FPR(i-1))*(TPR(i)+TPR(i-1))/2;
    end
end
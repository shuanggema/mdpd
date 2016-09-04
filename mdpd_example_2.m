% This Demo shows how to use function mdpd to select the important covariates
% under the multi-response variable linear regression model. We use the AUC
% and SSE (sum squared error of the bias of beta) criterion to evaluate the 
% proposed method. We also can use the 5-fold cross validation to select the
% best tuning parameter.
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/09/02 $
tic,
clear
n = 200;
alpha = 0.1;
nLambda = 20;
lambdaRatio  =  0.0001;
p1 = 50;
p2 = 1;
w = randn(n,p1);
covc = ar(p1,0.5);
x = w*covc^0.5;
betapart1 = zeros(p1,p2);
betapart2 = zeros(p1,p2);
for i = 1:p2
    betapart1(1:5,i) = 0.4+0.8*rand(5,1);
    len = randperm(10,1);
    tempindex = 5+randperm((p1-5),len);
    betapart1(tempindex,i) = 0.4+0.8*rand(len,1);
end
y = x*betapart1+randn(n,p2);
x = [ones(n,1),x];
[n,p1] = size(x);
betamulti = zeros(p1,p2);
sigmamulti = zeros(1,p2);
betaset = zeros(p1,p2,nLambda);
sigmaset = zeros(p2,nLambda);
%%%%%%%%%%%%%%
for ppp = 1:p2
for i = 1:100
%     i
    lambdai = i;
    beta0 = mdpd(x,y(:,ppp),lambdai,alpha);
if sum(abs(beta0) <= 0.001) == p1
    break;
end
end
lambdaMax = i;
lambdaMin  =  lambdaMax * lambdaRatio;
loghi  =  log(lambdaMax);
loglo  =  log(lambdaMin);
logrange  =  loghi - loglo;
interval  =  -logrange/(nLambda-1);
lambda  =  exp(loghi:interval:loglo)';
bicset = zeros(nLambda,1);
for i = 1:nLambda
    for ttt = 1:5
        xtest = x((ttt-1)*n/5+1:ttt*n/5,:);
        ytest = y((ttt-1)*n/5+1:ttt*n/5,:);
        xtrain = x(setdiff(1:n,(ttt-1)*n/5+1:ttt*n/5),:);
        ytrain = y(setdiff(1:n,(ttt-1)*n/5+1:ttt*n/5),:);        
	beta0 = mdpd(xtrain,ytrain(:,ppp),lambda(i),alpha);
    bicset(i,1) = bicset(i,1)+sum((ytest(:,ppp)-xtest*beta0).^2);
    end
end
for i = 1:nLambda
	[beta0,sigmaset(ppp,i)] = mdpd(x,y(:,ppp),lambda(i),alpha);
    betaset(:,ppp,i) = beta0;
end
bicbesti = find(bicset == min(bicset));
betamulti(:,ppp) = betaset(:,ppp,bicbesti);
sigmamulti(ppp) = sigmaset(ppp,bicbesti);
end
sse = sum(sum((betamulti(2:end,:)-betapart1).^2));
tprset = zeros(nLambda,1);
fprset = zeros(nLambda,1);
for i = 1:nLambda
tprset(i,1) = TPRcal(betaset(2:end,:,i),betapart1);
fprset(i,1) = FPRcal(betaset(2:end,:,i),betapart1);
end
auc = auccalc(fprset,tprset);
toc

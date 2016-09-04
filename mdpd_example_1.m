% This Demo shows how to use function mdpd to select the important covariates
% under the linear regression model. We use the AUC and SSE (sum squared error
% of the bias of beta) criterion to evaluate the proposed method. We also can 
% use the 5-fold cross validation to select the best tuning parameter.
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/09/02 $
tic,
clear
n = 100;
p = 100;
alpha = 0.1;
%%%%%%%%%%%%%%%%%%%%%%%%%
w = randn(n,p);
covc = ar(p,0);
% covc = ar(p,0.2);
% covc = ar(p,0.8);
x = w*covc^0.5;
%%%%%%%%%%%%%%%%%%%%%%%
len = 10;
beta = zeros(p,1);
beta0 = zeros(p,1);
beta(1:len) = 0.5+rand(len,1);

ccc = 1;
index = zeros(n,1);
epsilon = zeros(n,1);
epsindex = randperm(n,floor(n*(1-ccc)));
epsilon(setdiff(1:n,epsindex)) = randn(floor(n*ccc),1);
epsilon(epsindex) = randn(floor(n*(1-ccc)),1)+5;
index(epsindex) = 1;

y = x*beta+epsilon;
% y = x*beta+mixrnd(n,1,ccc);

% ccc = 0.7;
% index = zeros(n,1);
% epsilon = zeros(n,1);
% for ii = 1:n
%     rrr = rand();
%     if rrr< = c
%         epsilon(ii) = randn();
%     else
%         index(ii) = 1;
%         epsilon(ii) = 7*randn();
%     end
% end
% y = x*beta+epsilon;
% % y = x*beta+mixtrnd(n,1,ccc);
%%%%%%%%%%%%%%%%%%%%
% x = [ones(n,1),x];
nLambda = 20;
lambdaRatio  =  0.0001;
w = randn(n,p);
for i = 1:100
%     i
    lambdai = i;
    beta0 = mdpd(x,y,lambdai,alpha);
%     beta0 = ladcd(x,y,lambdai);
if sum(abs(beta0)<=0.001) == p
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
betaset = zeros(p,nLambda);
sigmaset = zeros(1,nLambda);
bicset = zeros(nLambda,1);
for i = 1:nLambda
%     i
    for ttt = 1:5
        xtest = x((ttt-1)*n/5+1:ttt*n/5,:);
        ytest = y((ttt-1)*n/5+1:ttt*n/5);
        xtrain = x(setdiff(1:n,(ttt-1)*n/5+1:ttt*n/5),:);
        ytrain = y(setdiff(1:n,(ttt-1)*n/5+1:ttt*n/5));        
	[beta0,sigmaset(i)] = mdpd(xtrain,ytrain,lambda(i),alpha);
    bicset(i,1) = bicset(i,1)+sum(ytest-xtest*beta0).^2;
    end
end
for i = 1:nLambda
%     i
	[beta0,sigmaset(i)] = mdpd(x,y,lambda(i),alpha);
    betaset(:,i) = beta0(:);
end
bicbesti = find(bicset == min(bicset));
betamulti = betaset(:,bicbesti(1));
toc


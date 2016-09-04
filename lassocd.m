function betahat=lassocd(x,y,lam)
% Function lassocd aims to estimate the coefficient of the linear regression model
% Input:
%	x: covariates
%	y: response variable
% 	lam: penalty parameter
% Ouput:
%   betahat: coefficient of the linear regression model
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/09/02 $
maxit = 200;
maxit1 = 200;
toler = 1E-4;
[n, p] = size(x);
betahat = (x'*x + 0.02*eye(p))\(x'*y);
delta = ones(p,1);
it = 0;
while sum(delta.^2) > toler && it < maxit
    it = it + 1;
    beta0 = betahat;
	for j = 1:p
        delta1 = 1;
        it1 = 0;
        while sum(delta1.^2) > toler && it1 < maxit1
            betaj = betahat(j);
            derive = sum(-x(:,j).*(y-x*betahat)) + n*lam*sign(betahat(j));
            hessian = sum(x(:,j).^2) + n*lam/(abs(betahat(j)));
            betahat(j) = betahat(j) - derive/hessian;
            it1 = it1+1;
            delta1 = betaj - betahat(j);
        end
	end
    delta = betahat - beta0;
end
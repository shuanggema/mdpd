function [beta, sigma0]  =  mdpd(x,y,lambda,alpha)
% Function mdpd aims to estimate the coefficient of the linear regression model based on the MDPD method
% Input:
%	x: covariates
%	y: response variable
% 	lam: penalty parameter; can be selected by cross validation method
%	alpha: robust parameter; usually choosen as 0.1~0.3
% Ouput:
%   beta: coefficient of the linear regression model
%	sigma0: estimation of the error variance
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/09/02 $
maxit  =  20;
toler  =  1E-4;
[n,p] = size(x);
it = 0;
delta = ones(p,1);
betaols = (x'*x+0.02*eye(p))\(x'*y);
betahat = betaols;
while sum(delta.^2) > toler && it < maxit
    it = it + 1;
    beta0 = betahat;
    fun = @(sigma)(sum((1-(y-x*beta0).^2/sigma^2).*exp(-alpha*(y-x*beta0).^2/2/sigma^2))-n*alpha/(1+alpha)^1.5);
    sigmah = sqrt(sum((y-x*beta0).^2)/n);
    if sigmah < 0.01
        sigmah = 0.01;
    end
	if sigmah > 5
        sigmah = 5;
	end
	sigma0 = biselect(fun);
    if isnan(sigma0) == 1
        sigma0 = sigmah;
    end     
    c = alpha/sigma0^2;
    weight = exp(-1/2*c*(y-x*beta0).^2)/sum(exp(-1/2*c*(y-x*beta0).^2))*n;
    yweight = sqrt(weight).*y;
    xweight = sqrt(weight)*ones(1,p).*x;
	betahat = lassocd(xweight,yweight,lambda);
    delta = betahat-beta0;
end
beta = betahat;
function value =biselect(fun,min1,max1)
% Function biselect aims to find the solution of function fun based on the
% biselect method
% Input:
%	fun: the function which needs to be solved
%	min1: minimal solution of fun 
% 	rho: maximal solution of fun
% Ouput:
%   value: solution of fun
% Yangguang Zang <yangguang.zang@gmail.com>
% $Revision: 1.0.0 $  $Date: 2016/09/02 $
if nargin < 2
    a = 0.01;
    b = 5;
else
    a = min1;
    b = max1;
end
delta = 1;
maxit = 200;
toler = 1E-12;
it = 0;
if fun(a)*fun(b) > 0
    value = NaN;
else
    while delta^2 > toler && it < maxit
        it = it + 1;
    if fun(a) * fun(a/2 + b/2) < 0
        b = a/2 + b/2;
    elseif fun(b) * fun(a/2 + b/2) < 0
        a = a/2 + b/2;
    end
    delta = a - b;
    end
    value = a;
end


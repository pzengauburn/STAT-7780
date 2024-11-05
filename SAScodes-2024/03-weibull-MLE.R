######################################################################
## find the MLE of Weibull distribution
## Peng Zeng 
## 09-17-2014
## 08-08-2018 updated
######################################################################

MLE.weibull = function(x, iniMLE = NULL, maxiter = 100, tol = 1e-7)
{
  if(is.null(iniMLE))
  { ## assume exponential 
    iniMLE = c(1.0, 1.0 / mean(x));
  }

  iter = 0; conv = tol + 1.0; 
  newMLE = iniMLE; MLE.track = matrix(newMLE, nrow = 1);
  while((iter < maxiter) && (conv > tol))
  {
    iter = iter + 1;
    curMLE = newMLE;

    onestep = MLE.weibull.onestep(x, curMLE);
    newMLE = onestep$MLE;

    MLE.track = rbind(MLE.track, newMLE);
    conv = max(abs(curMLE - newMLE));
  }
  
  rownames(MLE.track) = paste('step', 0:iter, sep = '');

  list(iniMLE = iniMLE, MLE = curMLE, cov = solve(-onestep$H),
       MLE.track = MLE.track, iter = iter, conv = conv);
}


MLE.weibull.onestep = function(x, curMLE)
{
  n = length(x); 
  alpha = curMLE[1]; lambda = curMLE[2];
  xlog = log(x); xa = x^alpha;

  Uvec = numeric(2);
  Uvec[1] = n / alpha + sum(xlog) - lambda * sum(xa * xlog);
  Uvec[2] = n / lambda - sum(xa);

  Hmat = matrix(0, nrow = 2, ncol = 2);
  Hmat[1, 1] = -n / alpha / alpha - lambda * sum(xa * xlog * xlog);
  Hmat[1, 2] = -sum(xa * xlog);
  Hmat[2, 1] = Hmat[1, 2];
  Hmat[2, 2] = -n / lambda / lambda;

  newMLE = curMLE - solve(Hmat, Uvec);
 
  list(MLE = newMLE, U = Uvec, H = Hmat);
}

######################################################################
## example
## notice that: shape = alpha and scale = lambda^(-1/alpha)
######################################################################

x = rweibull(200, shape = 2.0, scale = 4.0^(-1/2.0));
ans = MLE.weibull(x);

ans2 = MLE.weibull(x, iniMLE = c(0.5, 1))


iter = 5000
MLEmat = matrix(0.0, nrow = iter, ncol = 2);
for(i in 1:iter)
{
  x = rweibull(200, shape = 2.0, scale = 4.0^(-1/2.0));
  fit = MLE.weibull(x);
  MLEmat[i, ] = fit$MLE;
}
cov(MLEmat)
ans$cov

######################################################################
## hypothesis testing
## H0: alpha = 2.0, lambda = 4.0
######################################################################

x = rweibull(200, shape = 2.0, scale = 4.0^(-1/2.0));
ans = MLE.weibull(x);
theta0 = c(2.0, 4.0);

# Wald's test
X2.W = t(ans$MLE - theta0) %*% solve(ans$cov) %*% (ans$MLE - theta0);
1 - pchisq(X2.W, df = 2);

# LRT
ell = function(alpha, lambda, x)
{
  n = length(x);
  n * log(alpha) + n * log(lambda) + (alpha - 1) * sum(log(x)) - lambda * sum(x^alpha);
}

X2.LR = 2 * (ell(ans$MLE[1], ans$MLE[2], x) - ell(2.0, 4.0, x));
1 - pchisq(X2.LR, df = 2);

# scores test
Uvec = function(alpha, lambda, x)
{
  n = length(x);
  u1 = n / alpha + sum(log(x)) - lambda * sum(x^alpha * log(x));
  u2 = n / lambda - sum(x^alpha);
  c(u1, u2)
}

Imat = function(alpha, lambda, x)
{
  n = length(x);
  xlog = log(x); xa = x^alpha;
  Amat = matrix(0, nrow = 2, ncol = 2);
  Amat[1, 1] = n / alpha / alpha + lambda * sum(xa * xlog * xlog);
  Amat[1, 2] = sum(xa * xlog);
  Amat[2, 1] = Amat[1, 2];
  Amat[2, 2] = n / lambda / lambda;
  Amat;
}

X2.score = t(Uvec(2.0, 4.0, x)) %*% solve(Imat(2.0, 4.0, x)) %*% Uvec(2.0, 4.0, x);
1 - pchisq(X2.score, df = 2);

######################################################################
## THE END
######################################################################

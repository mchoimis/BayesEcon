% 로그 사전밀도 계산하기
function lnPrior = lnprior(theta, Spec)

% hyperparameters
alpha0 = Spec.alpha0;
beta0 = Spec.beta0;

Normal_mu = Spec.Normal_mu;
Normal_V = Spec.Normal_V;

a0 = Spec.a0;
d0 = Spec.d0;

% 베타분포
ind_beta = Spec.ind_beta;
lnPrior = sumc(lnpdfbeta(theta(ind_beta), alpha0, beta0));

% 정규 분포
ind_Normal = Spec.ind_Normal;
lnPrior = lnPrior + sumc(lnpdfn(theta(ind_Normal), Normal_mu, Normal_V));

% 역감마 분포
ind_IG = Spec.ind_IG;
lnPrior = lnPrior + lnpdfig(theta(ind_IG), a0/2, d0/2);
end


function lnSDr = Linear_SDratio( Data, MHm, b_0, B_0, ind_Res, ind_UNRes)
% log Savage-Dickey ratio ��� �Լ�
% ������ ������ ����

theta_Res = b_0(ind_Res); % M2���� beta3�� ���� ����

%% �α� ���� �е� ����ϱ�

lnprior = sumc(lnpdfn(theta_Res, b_0(ind_Res),diag(B_0(ind_Res,ind_Res)))); % log Savage-Dickey ratio�� �ι�°��, prior�� �����̴�.

%% �α� ���Ĺе� ����ϱ�
Y = Data(:,1);
X = Data(:,2:end);
n = rows(MHm);
k = rows(b_0);
betam = MHm(:, 1:k);
sig2m = MHm(:, k+1);

% log full conditional for beta
XX = X'*X;
XY = X'*Y;
precB_0 = invpd(B_0);

lnfcb3 = zeros(n,1);

for iter = 1:n
    
    sig2_inv = 1/sig2m(iter);
    
    B_1 = invpd(sig2_inv*XX + precB_0); % full conditional variance B_1 for beta under M1
    A = (sig2_inv*XY + precB_0*b_0);
    M = B_1*A; % full conditional mean for beta under M1
    
    % full conditional for beta3 (��Ʈ ����), ���⼭ 2�� ���2 = (beta1 beta2)', 
    % 1�� ��� 1 = (beta3)
    beta = betam(iter, :)';
    mu2 = M(ind_UNRes);
    mu1 = M(ind_Res);
    
    Sig12 = B_1(ind_Res, ind_UNRes);
    Sig22inv = invpd(B_1(ind_UNRes,ind_UNRes));
    
    mu1_2 = mu1 + Sig12*Sig22inv*(beta(ind_UNRes) - mu2); % full conditional mean for beta3
    
    Sig11 = B_1(ind_Res,ind_Res);
    Sig1_2 = Sig11 - Sig12*Sig22inv*Sig12'; % full conditional variance for beta3
    
    lnfcb3(iter) = lnpdfn(theta_Res, mu1_2, Sig1_2);

end

lnpost = log(meanc(exp(lnfcb3)));

lnSDr = lnprior - lnpost;

disp('================================================================');
disp(['�α� SD density ratio = ', num2str(lnSDr)]);
disp('=================================================================');
end


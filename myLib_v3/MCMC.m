function [ MHm, accpt, postmom] = MCMC(lnpost,lnlik, paramconst, n0, n1, theta_hat, V, freq, Spec )
% MCMC �ùķ��̼�

if Spec.MH < 1
   error(' Spec.MH >= 1 �̾�� �� ');
end
n = n0 + n1;
nMH = rows(theta_hat); % MH �Ķ������ ��
MHm = zeros(n,nMH);
counter = zeros(nMH,1);

theta0 = theta_hat; % initial value
V0 = V;

for iter = 1:n
%% ��������
    % theta0 = ���� �ݺ������� theta
    % theta_bar = �ĺ����������� ���
    % theta_hat = ���ĺ����� �ֺ�
    % theta1 = �������� (proposal)
    [theta1, theta_bar, V] = Proposal_step(lnpost, paramconst, theta_hat, theta0, V0, Spec);
    
    %% MH step
    [theta0, accept, lnpost0] = MH_step(lnpost, paramconst, theta_bar, theta0, theta1, V, Spec );
    lnlik0 = lnlik(theta0,Spec);
    MHm(iter,:) = theta0'; % ����
    
    % counting acceptance for each parameter
    counter = counter + accept;
    
%% �߰� �������    
     prt2(theta0,lnpost0,lnlik0,counter,iter, freq);
    
    
end

MHm = MHm(n0+1:n,:); % ����
accpt = 100*counter/n;
save MHm.txt -ascii MHm;
%% Step 3 : ������� ����
alpha= 0.025;
postmom = MHout(MHm,alpha);
Output = [postmom(:,2) postmom(:,3) postmom(:,4)  postmom(:,6) postmom(:,7) accpt postmom(:,8) ];
disp('===============================================================================');
switch Spec.MH
    case 0
        disp('�齺 ���ø�');
    case 1
        disp('Tailored Independent M-H');
    case 2
        disp('Tailored Dependent M-H');
    case 3
        disp('���� ���� M-H');
end
disp('===============================================================================');
disp('    ���     ǥ�ؿ���     2.5%     97.5%   ��ȿ���� ��� acc.rate(%) Geweke-p ��   ');
disp('-------------------------------------------------------------------------------');
disp(Output);
disp('-------------------------------------------------------------------------------');

if Spec.MH > 0
    se = sqrt(diag(V0)); % ǥ�ؿ���
disp('===============================================================================');
disp(' ���ö� �ٻ� ���');
disp('-------------------------------------------------------------------------------');
disp('    ���   ǥ�ؿ���  ');
disp('---------------------------------------------------------');
disp([theta_hat se]);
disp('---------------------------------------------------------');
fmax = lnlik(theta_hat,Spec);
disp(['�쵵 = ', num2str(fmax)]);
disp('---------------------------------------------------------');

end

%% ���ĺ��� �׸��׸���
npara = cols(MHm); % �Ķ������ ��
m1 = round(sqrt(npara));
m2 = ceil(sqrt(npara));
for i = 1:npara
    subplot(m1, m2, i);
    para = MHm(:, i);
    minp = minc(para); % �ּ�
    maxp = maxc(para); % �ִ�
    intvl = (maxp - minp)/50;
    interval = minp:intvl:maxp;
    hist(para, interval);
    xlabel(['para ', num2str(i)])
end

end

%% �ĺ��������� ���ø�
% theta0 = ���� �ݺ������� theta
% theta_bar = �ĺ����������� ���
% theta_hat = ���ĺ����� �ֺ�
% theta1 = �������� (proposal)
function [theta1, theta_bar, V] = Proposal_step(lnpost, paramconst, theta_hat, theta0, V, Spec)

if Spec.MH == 1 % if tailored Independent M-H
    nu = Spec.nu; % t-������ ������
    theta_bar = theta_hat;
    theta1 = randmvt(nu, theta_bar, V); % proposal
    
elseif Spec.MH == 2 % if tailored Dependent M-H
    nu = Spec.nu; % t-������ ������
    V0 = V;
    lnpost0 = lnpost(theta0, Spec);
    indbj = 1:rows(theta0);
    indbj = indbj';
    g = - Gradpnew1(lnpost, theta0, indbj, Spec); % 4 by 1
    H = - FHESSnew1(lnpost, theta0, indbj, Spec); % 4 by 4
    H = real(H);
    H = 0.5*(H + H');
    Hinv = invpd(H);
    db = Hinv*g'/2;
    theta_bar = theta0 + db;
    
    valid = paramconst(theta_bar, Spec);  % ������ �����ϸ� valid = 1, �ƴϸ� valid = 0
    islnpost = lnpost(theta_bar, Spec) - lnpost0 >= 0; 
    isOK = valid*islnpost;
    SF = 0.5; % Stepsize
    while isOK < 0.5 % ������ ������ ������ Stepsizeũ�� ���̱�
        theta_bar = theta0 + SF*db;
        valid = paramconst(theta_bar, Spec);
        islnpost = lnpost(theta_bar, Spec) - lnpost0 >= 0;
        isOK = valid*islnpost;
        SF = SF*SF;
        if SF < 0.0001
            theta_bar = theta_hat;
            isOK = 1;
        end
    end
    
    % �ĺ����������� �л�-���л� ����ϱ�
    H = - FHESSnew1(lnpost, theta_bar, indbj, Spec); % 4 by 4
    H = real(H);
    H = 0.5*(H + H');
    V = invpd(H);
    V = 0.5*(V + V');
    
    % �������� �����ϱ�
    [~, p] = chol(V);
    if p > 0  % ���� V�� ������ ������
        V = V0;
        theta1 = randmvt(nu,theta_bar,V);
    else
        theta1 = randmvt(nu,theta_bar,V);
    end
    
elseif Spec.MH == 3 % ���Ǻ��� M-H
    theta_bar = theta0;
    theta1 = theta_bar + chol(V)'*randn(rows(theta_bar), 1);
end

end

%% M-H �� ����ϱ�

function [theta0, accept, lnpost0] = MH_step(lnpost, paramconst, theta_bar, theta0, theta1, V, Spec )

lnpost0 = lnpost(theta0, Spec);

% �ĺ������е� ����ϱ�
if Spec.MH < 3 % if tailored M-H
    nu = Spec.nu; % t-������ ������
    q0 = lnpdfmvt(theta0, theta_bar, V, nu);
    q1 = lnpdfmvt(theta1, theta_bar, V, nu);
elseif Spec.MH == 3 % if ���� ���� M-H
    q0 = 0;
    q1 = 0;
end

pd = lnpost0 + q1; % M-H ���� �и�(�α�)

% ������ �����ϴ��� Ȯ���ϱ�
valid = paramconst(theta1, Spec);

% ���� �������� ���ϸ� theta1�� �Ⱒ�ǰ� ���� �� theta0�� ����ȴ�.
if valid == 0
    accept = 0;
    lnpost0 = pd;
else
    
    % ���� ������ �����ϸ� MH rate�� ����ؼ� �Ⱒ�Ǵ� �����Ѵ�.
    lnpost1 = lnpost(theta1, Spec);
    
    pn = lnpost1 + q0; % M-H ���� ����(�α�)
    
    loga = pn - pd;% �α� M-H ��
    
    accept = log(rand(1,1)) < loga; % ���� ����Ǹ� accept = 1, �ƴϸ� accept = 0
    theta0 = accept*theta1 + (1-accept)*theta0;
    lnpost0 = accept*lnpost1 + (1-accept)*lnpost0;
    
end

end

function prt2(theta,lnpost0,lnlik0,counter,iter, freq)
% �߰���� �����ֱ�
[~, resid] = minresid(iter,freq);

if resid == 0
    acct_rate = 100*counter/iter; % acceptance rate
    
    clc
    disp('==================================================')
    disp(['���� �ݺ������� ',num2str(iter)]);
    disp('--------------------------------------------------')
    disp(['�α� �쵵 + �α� �����е� = ',num2str(lnpost0)]);
    disp(['�α� �쵵 = ', num2str(lnlik0)]);
    disp('--------------------------------------------------');
    disp(' theta  acceptance rate (%)');
    disp('-----------------------------------');
    disp([theta, acct_rate]);
    disp('===================================');
    
end
end

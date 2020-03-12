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

function prt2(theta,lnpost0,lnlik0,counter,iter, freq)
% 중간결과 보여주기
[~, resid] = minresid(iter,freq);

if resid == 0
    acct_rate = 100*counter/iter; % acceptance rate
    
    clc
    disp('==================================================')
    disp(['현재 반복시행은 ',num2str(iter)]);
    disp('--------------------------------------------------')
    disp(['로그 우도 + 로그 사전밀도 = ',num2str(lnpost0)]);
    disp(['로그 우도 = ', num2str(lnlik0)]);
    disp('--------------------------------------------------');
    disp(' theta  acceptance rate (%)');
    disp('-----------------------------------');
    disp([theta, acct_rate]);
    disp('===================================');
    
end
end

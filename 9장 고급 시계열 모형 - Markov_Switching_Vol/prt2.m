% print information on current iteration 
function  prt2(psi,Stm,Omegam,diag_Sigmam,iter,indcut)
global indP

Cm = makeC(psi);
Gm = makeG(psi);
Vol1 = diag(Omegam(:,:,1));
Vol2 = diag(Omegam(:,:,2));
Rho1 = corrcov(Omegam(:,:,1));
rho1 = [Rho1(1,2);Rho1(1,3);Rho1(2,3)];
Rho2 = corrcov(Omegam(:,:,2));
rho2 = [Rho2(1,2);Rho2(1,3);Rho2(2,3)];

disp('==================================');
disp( [' indcut is ', num2str(indcut)]); 
disp( [' current iteration is ', num2str(iter)]); 
disp('----------------------------------');
disp( ['C1 =  ', num2str(Cm(:,1)')]);  
disp( ['C2 =  ', num2str(Cm(:,2)')]);
disp( ['G1 =  ', num2str(diag(Gm(:,:,1))')]);
disp( ['G2 =  ', num2str(diag(Gm(:,:,2))')]);
disp('----------------------------------');
disp( ['V1 =  ', num2str(Vol1')]);
disp( ['V2 =  ', num2str(Vol2')]);
disp( ['rho1 =  ', num2str(rho1')]);
disp( ['rho2 =  ', num2str(rho2')]);
disp( ['100*Sigam1 =  ', num2str(100*diag_Sigmam(:,1)')]);
disp( ['100*Sigam2 =  ', num2str(100*diag_Sigmam(:,2)')]);
disp( ['P =  ', num2str(psi(indP)')]);
disp( ['Proportion =  ', num2str(sumc(Stm)')]);
disp('----------------------------------');

end
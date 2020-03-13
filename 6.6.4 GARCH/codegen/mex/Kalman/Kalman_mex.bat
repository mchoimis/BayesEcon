@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2014a
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2014a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=Kalman_mex
set MEX_NAME=Kalman_mex
set MEX_EXT=.mexw64
call mexopts.bat
echo # Make settings for Kalman > Kalman_mex.mki
echo COMPILER=%COMPILER%>> Kalman_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> Kalman_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> Kalman_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> Kalman_mex.mki
echo LINKER=%LINKER%>> Kalman_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> Kalman_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> Kalman_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> Kalman_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> Kalman_mex.mki
echo BORLAND=%BORLAND%>> Kalman_mex.mki
echo OMPFLAGS= >> Kalman_mex.mki
echo OMPLINKFLAGS= >> Kalman_mex.mki
echo EMC_COMPILER=msvc120>> Kalman_mex.mki
echo EMC_CONFIG=optim>> Kalman_mex.mki
"C:\Program Files\MATLAB\R2014a\bin\win64\gmake" -B -f Kalman_mex.mk

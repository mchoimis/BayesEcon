/*
 * Kalman_terminate.c
 *
 * Code generation for function 'Kalman_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "Kalman.h"
#include "Kalman_terminate.h"

/* Function Definitions */
void Kalman_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void Kalman_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (Kalman_terminate.c) */

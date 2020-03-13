/*
 * Kalman_initialize.c
 *
 * Code generation for function 'Kalman_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "Kalman.h"
#include "Kalman_initialize.h"
#include "Kalman_data.h"

/* Function Definitions */
void Kalman_initialize(emlrtContext *aContext)
{
  emlrtStack st = { NULL, NULL, NULL };

  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, aContext, NULL, 1);
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (Kalman_initialize.c) */

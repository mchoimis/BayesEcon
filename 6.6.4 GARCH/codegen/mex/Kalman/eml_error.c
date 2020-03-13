/*
 * eml_error.c
 *
 * Code generation for function 'eml_error'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "Kalman.h"
#include "eml_error.h"

/* Variable Definitions */
static emlrtRTEInfo d_emlrtRTEI = { 20, 5, "eml_error",
  "C:\\Program Files\\MATLAB\\R2014a\\toolbox\\eml\\lib\\matlab\\eml\\eml_error.m"
};

/* Function Definitions */
void b_eml_error(const emlrtStack *sp)
{
  static char_T cv3[4][1] = { { 's' }, { 'q' }, { 'r' }, { 't' } };

  emlrtErrorWithMessageIdR2012b(sp, &d_emlrtRTEI,
    "Coder:toolbox:ElFunDomainError", 3, 4, 4, cv3);
}

void eml_error(const emlrtStack *sp)
{
  static char_T cv2[3][1] = { { 'l' }, { 'o' }, { 'g' } };

  emlrtErrorWithMessageIdR2012b(sp, &d_emlrtRTEI,
    "Coder:toolbox:ElFunDomainError", 3, 4, 3, cv2);
}

/* End of code generation (eml_error.c) */

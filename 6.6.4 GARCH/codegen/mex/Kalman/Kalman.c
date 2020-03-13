/*
 * Kalman.c
 *
 * Code generation for function 'Kalman'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "Kalman.h"
#include "Kalman_emxutil.h"
#include "eml_error.h"
#include "eml_int_forloop_overflow_check.h"
#include "Kalman_mexutil.h"
#include "Kalman_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 18, "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m" };

static emlrtRSInfo b_emlrtRSI = { 19, "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m" };

static emlrtRSInfo c_emlrtRSI = { 24, "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m" };

static emlrtRSInfo d_emlrtRSI = { 9, "lnpdfn",
  "D:\\Dropbox\\MATLAB\\Textbook\\myLib_v2\\lnpdfn.m" };

static emlrtRSInfo e_emlrtRSI = { 11, "lnpdfn",
  "D:\\Dropbox\\MATLAB\\Textbook\\myLib_v2\\lnpdfn.m" };

static emlrtRSInfo f_emlrtRSI = { 14, "log",
  "C:\\Program Files\\MATLAB\\R2014a\\toolbox\\eml\\lib\\matlab\\elfun\\log.m" };

static emlrtRSInfo g_emlrtRSI = { 14, "sqrt",
  "C:\\Program Files\\MATLAB\\R2014a\\toolbox\\eml\\lib\\matlab\\elfun\\sqrt.m"
};

static emlrtRSInfo h_emlrtRSI = { 5, "sumc",
  "D:\\Dropbox\\MATLAB\\Textbook\\myLib_v2\\sumc.m" };

static emlrtRSInfo i_emlrtRSI = { 61, "sum",
  "C:\\Program Files\\MATLAB\\R2014a\\toolbox\\eml\\lib\\matlab\\datafun\\sum.m"
};

static emlrtRSInfo j_emlrtRSI = { 22, "eml_int_forloop_overflow_check",
  "C:\\Program Files\\MATLAB\\R2014a\\toolbox\\eml\\lib\\matlab\\eml\\eml_int_forloop_overflow_check.m"
};

static emlrtMCInfo emlrtMCI = { 16, 1, "error",
  "C:\\Program Files\\MATLAB\\R2014a\\toolbox\\eml\\lib\\matlab\\lang\\error.m"
};

static emlrtRTEInfo emlrtRTEI = { 1, 24, "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m" };

static emlrtRTEInfo b_emlrtRTEI = { 10, 1, "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m" };

static emlrtBCInfo emlrtBCI = { -1, -1, 5, 6, "theta", "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m", 0 };

static emlrtBCInfo b_emlrtBCI = { -1, -1, 6, 6, "theta", "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m", 0 };

static emlrtBCInfo c_emlrtBCI = { -1, -1, 7, 8, "theta", "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m", 0 };

static emlrtBCInfo d_emlrtBCI = { -1, -1, 8, 7, "theta", "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m", 0 };

static emlrtBCInfo e_emlrtBCI = { -1, -1, 16, 13, "ym", "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m", 0 };

static emlrtBCInfo f_emlrtBCI = { -1, -1, 16, 15, "ym", "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m", 0 };

static emlrtBCInfo g_emlrtBCI = { -1, -1, 18, 5, "lnLm", "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m", 0 };

static emlrtBCInfo h_emlrtBCI = { -1, -1, 19, 5, "Volm", "Kalman",
  "D:\\Dropbox\\MATLAB\\Textbook\\Chap6\\GARCH_New_TaMH\\Kalman.m", 0 };

static emlrtRSInfo l_emlrtRSI = { 16, "error",
  "C:\\Program Files\\MATLAB\\R2014a\\toolbox\\eml\\lib\\matlab\\lang\\error.m"
};

/* Function Definitions */
void Kalman(const emlrtStack *sp, const emxArray_real_T *theta, const
            emxArray_real_T *ym, emxArray_real_T *lnL, emxArray_real_T *Volm)
{
  emxArray_real_T *lnLm;
  int32_T i0;
  real_T e_L;
  int32_T i;
  real_T sig2t;
  int32_T t;
  const mxArray *y;
  static const int32_T iv0[2] = { 1, 24 };

  const mxArray *m0;
  char_T cv0[24];
  static const char_T cv1[24] = { 's', 'i', 'g', 'm', 'a', ' ', 's', 'h', 'o',
    'u', 'l', 'd', ' ', 'b', 'e', ' ', 'p', 'o', 's', 'i', 't', 'i', 'v', 'e' };

  boolean_T overflow;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  emlrtHeapReferenceStackEnterFcnR2012b(sp);
  emxInit_real_T(sp, &lnLm, 1, &b_emlrtRTEI, true);
  i0 = theta->size[0];
  emlrtDynamicBoundsCheckFastR2012b(1, 1, i0, &emlrtBCI, sp);
  i0 = theta->size[0];
  emlrtDynamicBoundsCheckFastR2012b(2, 1, i0, &b_emlrtBCI, sp);
  i0 = theta->size[0];
  emlrtDynamicBoundsCheckFastR2012b(3, 1, i0, &c_emlrtBCI, sp);
  i0 = theta->size[0];
  emlrtDynamicBoundsCheckFastR2012b(4, 1, i0, &d_emlrtBCI, sp);
  e_L = theta->data[3];
  i0 = lnLm->size[0];
  lnLm->size[0] = ym->size[0];
  emxEnsureCapacity(sp, (emxArray__common *)lnLm, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  i = ym->size[0];
  for (i0 = 0; i0 < i; i0++) {
    lnLm->data[i0] = 0.0;
  }

  i0 = Volm->size[0];
  Volm->size[0] = ym->size[0];
  emxEnsureCapacity(sp, (emxArray__common *)Volm, i0, (int32_T)sizeof(real_T),
                    &emlrtRTEI);
  i = ym->size[0];
  for (i0 = 0; i0 < i; i0++) {
    Volm->data[i0] = 0.0;
  }

  sig2t = theta->data[0] / ((1.0 - theta->data[1]) - theta->data[2]);
  t = 0;
  while (t <= ym->size[0] - 1) {
    i0 = ym->size[1];
    emlrtDynamicBoundsCheckFastR2012b(1, 1, i0, &f_emlrtBCI, sp);
    i0 = ym->size[0];
    i = t + 1;
    emlrtDynamicBoundsCheckFastR2012b(i, 1, i0, &e_emlrtBCI, sp);
    sig2t = (theta->data[0] + theta->data[1] * (e_L * e_L)) + theta->data[2] *
      sig2t;
    st.site = &emlrtRSI;

    /*  log pdf of normal */
    /*  x = normal variates */
    /*  mu = vector of means */
    /*  sig2vec = vector of variances */
    /*  gauss function */
    if (sig2t < 0.0) {
      b_st.site = &d_emlrtRSI;
      y = NULL;
      m0 = emlrtCreateCharArray(2, iv0);
      for (i = 0; i < 24; i++) {
        cv0[i] = cv1[i];
      }

      emlrtInitCharArrayR2013a(&b_st, 24, m0, cv0);
      emlrtAssign(&y, m0);
      c_st.site = &l_emlrtRSI;
      error(&c_st, y, &emlrtMCI);
    }

    b_st.site = &e_emlrtRSI;
    e_L = 2.0 * sig2t * 3.1415926535897931;
    if (e_L < 0.0) {
      c_st.site = &f_emlrtRSI;
      eml_error(&c_st);
    }

    i0 = lnLm->size[0];
    i = 1 + t;
    lnLm->data[emlrtDynamicBoundsCheckFastR2012b(i, 1, i0, &g_emlrtBCI, sp) - 1]
      = -0.5 * muDoubleScalarLog(e_L) - 0.5 * (ym->data[t] * ym->data[t]) /
      sig2t;
    st.site = &b_emlrtRSI;
    if (sig2t < 0.0) {
      b_st.site = &g_emlrtRSI;
      b_eml_error(&b_st);
    }

    i0 = Volm->size[0];
    i = 1 + t;
    Volm->data[emlrtDynamicBoundsCheckFastR2012b(i, 1, i0, &h_emlrtBCI, sp) - 1]
      = muDoubleScalarSqrt(sig2t);
    e_L = ym->data[t];
    t++;
    emlrtBreakCheckFastR2012b(emlrtBreakCheckR2012bFlagVar, sp);
  }

  st.site = &c_emlrtRSI;

  /*  gauss function */
  if (lnLm->size[0] > 1) {
    b_st.site = &h_emlrtRSI;
    e_L = lnLm->data[0];
    c_st.site = &i_emlrtRSI;
    overflow = (lnLm->size[0] > 2147483646);
    if (overflow) {
      d_st.site = &j_emlrtRSI;
      check_forloop_overflow_error(&d_st);
    }

    for (i = 2; i <= lnLm->size[0]; i++) {
      e_L += lnLm->data[i - 1];
    }

    i0 = lnL->size[0] * lnL->size[1];
    lnL->size[0] = 1;
    lnL->size[1] = 1;
    emxEnsureCapacity(&st, (emxArray__common *)lnL, i0, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    lnL->data[0] = e_L;
  } else {
    i0 = lnL->size[0] * lnL->size[1];
    lnL->size[0] = 1;
    lnL->size[1] = lnLm->size[0];
    emxEnsureCapacity(&st, (emxArray__common *)lnL, i0, (int32_T)sizeof(real_T),
                      &emlrtRTEI);
    i = lnLm->size[0];
    for (i0 = 0; i0 < i; i0++) {
      lnL->data[lnL->size[0] * i0] = lnLm->data[i0];
    }
  }

  emxFree_real_T(&lnLm);
  emlrtHeapReferenceStackLeaveFcnR2012b(sp);
}

/* End of code generation (Kalman.c) */

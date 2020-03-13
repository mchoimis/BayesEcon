/*
 * _coder_Kalman_api.c
 *
 * Code generation for function '_coder_Kalman_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "Kalman.h"
#include "_coder_Kalman_api.h"
#include "Kalman_emxutil.h"

/* Variable Definitions */
static emlrtRTEInfo c_emlrtRTEI = { 1, 1, "_coder_Kalman_api", "" };

/* Function Declarations */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static const mxArray *b_emlrt_marshallOut(const emxArray_real_T *u);
static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *ym, const
  char_T *identifier, emxArray_real_T *y);
static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y);
static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);
static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *theta, const
  char_T *identifier, emxArray_real_T *y);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);
static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret);

/* Function Definitions */
static void b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  e_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static const mxArray *b_emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  static const int32_T iv4[1] = { 0 };

  const mxArray *m3;
  y = NULL;
  m3 = emlrtCreateNumericArray(1, iv4, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m3, (void *)u->data);
  emlrtSetDimensions((mxArray *)m3, u->size, 1);
  emlrtAssign(&y, m3);
  return y;
}

static void c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *ym, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  d_emlrt_marshallIn(sp, emlrtAlias(ym), &thisId, y);
  emlrtDestroyArray(&ym);
}

static void d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId, emxArray_real_T *y)
{
  f_emlrt_marshallIn(sp, emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv5[1];
  boolean_T bv0[1];
  int32_T iv6[1];
  iv5[0] = -1;
  bv0[0] = true;
  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 1U, iv5, bv0, iv6);
  ret->size[0] = iv6[0];
  ret->allocatedSize = ret->size[0];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

static void emlrt_marshallIn(const emlrtStack *sp, const mxArray *theta, const
  char_T *identifier, emxArray_real_T *y)
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  b_emlrt_marshallIn(sp, emlrtAlias(theta), &thisId, y);
  emlrtDestroyArray(&theta);
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  static const int32_T iv3[2] = { 0, 0 };

  const mxArray *m2;
  y = NULL;
  m2 = emlrtCreateNumericArray(2, iv3, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m2, (void *)u->data);
  emlrtSetDimensions((mxArray *)m2, u->size, 2);
  emlrtAssign(&y, m2);
  return y;
}

static void f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId, emxArray_real_T *ret)
{
  int32_T iv7[2];
  boolean_T bv1[2];
  int32_T i;
  int32_T iv8[2];
  for (i = 0; i < 2; i++) {
    iv7[i] = -1;
    bv1[i] = true;
  }

  emlrtCheckVsBuiltInR2012b(sp, msgId, src, "double", false, 2U, iv7, bv1, iv8);
  ret->size[0] = iv8[0];
  ret->size[1] = iv8[1];
  ret->allocatedSize = ret->size[0] * ret->size[1];
  ret->data = (real_T *)mxGetData(src);
  ret->canFreeData = false;
  emlrtDestroyArray(&src);
}

void Kalman_api(const mxArray * const prhs[2], const mxArray *plhs[2])
{
  emxArray_real_T *theta;
  emxArray_real_T *ym;
  emxArray_real_T *lnL;
  emxArray_real_T *Volm;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &theta, 1, &c_emlrtRTEI, true);
  b_emxInit_real_T(&st, &ym, 2, &c_emlrtRTEI, true);
  b_emxInit_real_T(&st, &lnL, 2, &c_emlrtRTEI, true);
  emxInit_real_T(&st, &Volm, 1, &c_emlrtRTEI, true);

  /* Marshall function inputs */
  emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "theta", theta);
  c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "ym", ym);

  /* Invoke the target function */
  Kalman(&st, theta, ym, lnL, Volm);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(lnL);
  plhs[1] = b_emlrt_marshallOut(Volm);
  Volm->canFreeData = false;
  emxFree_real_T(&Volm);
  lnL->canFreeData = false;
  emxFree_real_T(&lnL);
  ym->canFreeData = false;
  emxFree_real_T(&ym);
  theta->canFreeData = false;
  emxFree_real_T(&theta);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_Kalman_api.c) */

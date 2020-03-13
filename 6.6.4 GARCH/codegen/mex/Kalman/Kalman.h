/*
 * Kalman.h
 *
 * Code generation for function 'Kalman'
 *
 */

#ifndef __KALMAN_H__
#define __KALMAN_H__

/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "Kalman_types.h"

/* Function Declarations */
extern void Kalman(const emlrtStack *sp, const emxArray_real_T *theta, const
                   emxArray_real_T *ym, emxArray_real_T *lnL, emxArray_real_T
                   *Volm);

#endif

/* End of code generation (Kalman.h) */

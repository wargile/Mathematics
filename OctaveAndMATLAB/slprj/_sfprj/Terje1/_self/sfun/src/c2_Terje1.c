/* Include files */

#include "blascompat32.h"
#include "Terje1_sfun.h"
#include "c2_Terje1.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "Terje1_sfun_debug_macros.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
static const char *c2_debug_family_names[5] = { "nargin", "nargout", "u1", "u2",
  "y" };

static const mxArray *c2_eml_mx;
static const mxArray *c2_b_eml_mx;
static const mxArray *c2_c_eml_mx;
static const char *c2_b_debug_family_names[8] = { "weights", "S1", "S2",
  "nargin", "nargout", "u1", "u2", "y" };

/* Function Declarations */
static void initialize_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance);
static void initialize_params_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance);
static void enable_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance);
static void disable_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance);
static void c2_update_debugger_state_c2_Terje1(SFc2_Terje1InstanceStruct
  *chartInstance);
static const mxArray *get_sim_state_c2_Terje1(SFc2_Terje1InstanceStruct
  *chartInstance);
static void set_sim_state_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance,
  const mxArray *c2_st);
static void finalize_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance);
static void sf_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber);
static int32_T c2_Sampling_error(SFc2_Terje1InstanceStruct *chartInstance,
  int16_T c2_u1[6], int16_T c2_u2[6]);
static void c2_times(SFc2_Terje1InstanceStruct *chartInstance, int16_T c2_a0[6],
                     int32_T c2_c[6]);
static int32_T c2_mtimes(SFc2_Terje1InstanceStruct *chartInstance, int32_T
  c2_a0[6], int16_T c2_b0[6]);
static const mxArray *c2_sf_marshall(void *chartInstanceVoid, void *c2_u);
static const mxArray *c2_b_sf_marshall(void *chartInstanceVoid, void *c2_u);
static const mxArray *c2_c_sf_marshall(void *chartInstanceVoid, void *c2_u);
static const mxArray *c2_d_sf_marshall(void *chartInstanceVoid, void *c2_u);
static void c2_info_helper(c2_ResolvedFunctionInfo c2_info[69]);
static const mxArray *c2_e_sf_marshall(void *chartInstanceVoid, void *c2_u);
static const mxArray *c2_f_sf_marshall(void *chartInstanceVoid, void *c2_u);
static int32_T c2_emlrt_marshallIn(SFc2_Terje1InstanceStruct *chartInstance,
  const mxArray *c2_y, const char_T *c2_name);
static uint8_T c2_b_emlrt_marshallIn(SFc2_Terje1InstanceStruct *chartInstance,
  const mxArray *c2_b_is_active_c2_Terje1, const char_T *c2_name);
static void init_dsm_address_info(SFc2_Terje1InstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c2_is_active_c2_Terje1 = 0U;
  sf_mex_assign(&c2_c_eml_mx, sf_mex_call_debug("numerictype", 1U, 8U, 15,
    "FractionLength", 6, 11.0, 15, "BinaryPoint", 6, 11.0, 15,
    "FixedExponent", 6, -11.0, 15, "Slope", 6, 0.00048828125));
  sf_mex_assign(&c2_b_eml_mx, sf_mex_call_debug("numerictype", 1U, 10U, 15,
    "WordLength", 6, 32.0, 15, "FractionLength", 6, 38.0, 15,
    "BinaryPoint", 6, 38.0, 15, "FixedExponent", 6, -38.0, 15, "Slope", 6,
    3.6379788070917130E-012));
  sf_mex_assign(&c2_eml_mx, sf_mex_call_debug("fimath", 1U, 38U, 15, "RoundMode",
    15, "floor", 15, "OverflowMode", 15, "wrap", 15,
    "ProductMode", 15, "KeepLSB", 15, "ProductWordLength", 6, 32.0, 15,
    "MaxProductWordLength", 6, 128.0, 15, "ProductFractionLength", 6
    , 30.0, 15, "ProductFixedExponent", 6, -30.0, 15, "ProductSlope", 6,
    9.3132257461547852E-010, 15, "ProductSlopeAdjustmentFactor", 6
    , 1.0, 15, "ProductBias", 6, 0.0, 15, "SumMode", 15, "KeepLSB", 15,
    "SumWordLength", 6, 32.0, 15, "MaxSumWordLength", 6, 128.0, 15,
    "SumFractionLength", 6, 30.0, 15, "SumFixedExponent", 6, -30.0, 15,
    "SumSlope", 6, 9.3132257461547852E-010, 15,
    "SumSlopeAdjustmentFactor", 6, 1.0, 15, "SumBias", 6, 0.0, 15,
    "CastBeforeSum", 3, TRUE));
}

static void initialize_params_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance)
{
}

static void enable_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c2_update_debugger_state_c2_Terje1(SFc2_Terje1InstanceStruct
  *chartInstance)
{
}

static const mxArray *get_sim_state_c2_Terje1(SFc2_Terje1InstanceStruct
  *chartInstance)
{
  const mxArray *c2_st = NULL;
  const mxArray *c2_y = NULL;
  int32_T c2_hoistedGlobal;
  int32_T c2_u;
  const mxArray *c2_b_y = NULL;
  int32_T c2_b_u;
  const mxArray *c2_c_y = NULL;
  uint8_T c2_b_hoistedGlobal;
  uint8_T c2_c_u;
  const mxArray *c2_d_y = NULL;
  int32_T *c2_e_y;
  c2_e_y = (int32_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c2_st = NULL;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_createcellarray(2));
  c2_hoistedGlobal = *c2_e_y;
  c2_u = c2_hoistedGlobal;
  c2_b_y = NULL;
  c2_b_u = c2_u;
  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_b_u, 6, 0U, 0U, 0U, 0));
  sf_mex_assign(&c2_b_y, sf_mex_call("embedded.fi", 1U, 8U, 15, "fimath", 14,
    sf_mex_dup(c2_eml_mx), 15, "numerictype", 14, sf_mex_dup
                 (c2_b_eml_mx), 15, "simulinkarray", 14, c2_c_y, 15,
    "fimathislocal", 3, TRUE));
  sf_mex_setcell(c2_y, 0, c2_b_y);
  c2_b_hoistedGlobal = chartInstance->c2_is_active_c2_Terje1;
  c2_c_u = c2_b_hoistedGlobal;
  c2_d_y = NULL;
  sf_mex_assign(&c2_d_y, sf_mex_create("y", &c2_c_u, 3, 0U, 0U, 0U, 0));
  sf_mex_setcell(c2_y, 1, c2_d_y);
  sf_mex_assign(&c2_st, c2_y);
  return c2_st;
}

static void set_sim_state_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance,
  const mxArray *c2_st)
{
  const mxArray *c2_u;
  int32_T *c2_y;
  c2_y = (int32_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c2_doneDoubleBufferReInit = TRUE;
  c2_u = sf_mex_dup(c2_st);
  *c2_y = c2_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 0)),
    "y");
  chartInstance->c2_is_active_c2_Terje1 = c2_b_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c2_u, 1)),
    "is_active_c2_Terje1");
  sf_mex_destroy(&c2_u);
  c2_update_debugger_state_c2_Terje1(chartInstance);
  sf_mex_destroy(&c2_st);
}

static void finalize_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance)
{
  sf_mex_destroy(&c2_eml_mx);
  sf_mex_destroy(&c2_b_eml_mx);
  sf_mex_destroy(&c2_c_eml_mx);
}

static void sf_c2_Terje1(SFc2_Terje1InstanceStruct *chartInstance)
{
  int32_T c2_i0;
  int32_T c2_i1;
  int32_T c2_previousEvent;
  int32_T c2_i2;
  int16_T c2_hoistedGlobal[6];
  int32_T c2_i3;
  int16_T c2_b_hoistedGlobal[6];
  int32_T c2_i4;
  int16_T c2_u1[6];
  int32_T c2_i5;
  int16_T c2_u2[6];
  uint32_T c2_debug_family_var_map[5];
  real_T c2_nargin = 2.0;
  real_T c2_nargout = 1.0;
  int32_T c2_y;
  int32_T c2_i6;
  int16_T c2_b_u1[6];
  int32_T c2_i7;
  int16_T c2_b_u2[6];
  int32_T *c2_b_y;
  int16_T (*c2_c_u2)[6];
  int16_T (*c2_c_u1)[6];
  c2_c_u2 = (int16_T (*)[6])ssGetInputPortSignal(chartInstance->S, 1);
  c2_b_y = (int32_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c2_c_u1 = (int16_T (*)[6])ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG,0);
  for (c2_i0 = 0; c2_i0 < 6; c2_i0 = c2_i0 + 1) {
    _SFD_DATA_RANGE_CHECK((real_T)(*c2_c_u1)[c2_i0], 0U);
  }

  _SFD_DATA_RANGE_CHECK((real_T)*c2_b_y, 1U);
  for (c2_i1 = 0; c2_i1 < 6; c2_i1 = c2_i1 + 1) {
    _SFD_DATA_RANGE_CHECK((real_T)(*c2_c_u2)[c2_i1], 2U);
  }

  c2_previousEvent = _sfEvent_;
  _sfEvent_ = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG,0);
  for (c2_i2 = 0; c2_i2 < 6; c2_i2 = c2_i2 + 1) {
    c2_hoistedGlobal[c2_i2] = (*c2_c_u1)[c2_i2];
  }

  for (c2_i3 = 0; c2_i3 < 6; c2_i3 = c2_i3 + 1) {
    c2_b_hoistedGlobal[c2_i3] = (*c2_c_u2)[c2_i3];
  }

  for (c2_i4 = 0; c2_i4 < 6; c2_i4 = c2_i4 + 1) {
    c2_u1[c2_i4] = c2_hoistedGlobal[c2_i4];
  }

  for (c2_i5 = 0; c2_i5 < 6; c2_i5 = c2_i5 + 1) {
    c2_u2[c2_i5] = c2_b_hoistedGlobal[c2_i5];
  }

  sf_debug_symbol_scope_push_eml(0U, 5U, 5U, c2_debug_family_names,
    c2_debug_family_var_map);
  sf_debug_symbol_scope_add_eml(&c2_nargin, c2_c_sf_marshall, 0U);
  sf_debug_symbol_scope_add_eml(&c2_nargout, c2_c_sf_marshall, 1U);
  sf_debug_symbol_scope_add_eml(&c2_u1, c2_b_sf_marshall, 2U);
  sf_debug_symbol_scope_add_eml(&c2_u2, c2_b_sf_marshall, 3U);
  sf_debug_symbol_scope_add_eml(&c2_y, c2_sf_marshall, 4U);
  CV_EML_FCN(0, 0);

  /*  This block supports the Embedded MATLAB subset. */
  /*  See the help menu for details.  */
  _SFD_EML_CALL(0,6);
  for (c2_i6 = 0; c2_i6 < 6; c2_i6 = c2_i6 + 1) {
    c2_b_u1[c2_i6] = c2_u1[c2_i6];
  }

  for (c2_i7 = 0; c2_i7 < 6; c2_i7 = c2_i7 + 1) {
    c2_b_u2[c2_i7] = c2_u2[c2_i7];
  }

  c2_y = c2_Sampling_error(chartInstance, c2_b_u1, c2_b_u2);
  _SFD_EML_CALL(0,-6);
  sf_debug_symbol_scope_pop();
  *c2_b_y = c2_y;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG,0);
  _sfEvent_ = c2_previousEvent;
  sf_debug_check_for_state_inconsistency(_Terje1MachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber)
{
  _SFD_SCRIPT_TRANSLATION(c2_chartNumber, 0U, sf_debug_get_script_id(
    "C:/coding/Octave/Sampling_error.m"));
}

static int32_T c2_Sampling_error(SFc2_Terje1InstanceStruct *chartInstance,
  int16_T c2_u1[6], int16_T c2_u2[6])
{
  int32_T c2_y;
  uint32_T c2_debug_family_var_map[8];
  static const char *c2_sv0[8] = { "weights", "S1", "S2", "nargin", "nargout",
    "u1", "u2", "y" };

  real_T c2_weights[6];
  int32_T c2_S1;
  int32_T c2_S2;
  real_T c2_nargin = 2.0;
  real_T c2_nargout = 1.0;
  int32_T c2_i8;
  static real_T c2_dv0[6] = { 3.3333333333333331E-001, 0.25, 0.2,
    1.6666666666666666E-001, 1.4285714285714285E-001, 0.125 };

  int32_T c2_i9;
  int16_T c2_b_u1[6];
  int32_T c2_x[6];
  int32_T c2_i10;
  int32_T c2_b_y[6];
  int32_T c2_i11;
  int32_T c2_c_y[6];
  int32_T c2_i12;
  int16_T c2_c_u1[6];
  int32_T c2_i13;
  int16_T c2_b_u2[6];
  int32_T c2_b_x[6];
  int32_T c2_i14;
  int32_T c2_d_y[6];
  int32_T c2_i15;
  int32_T c2_e_y[6];
  int32_T c2_i16;
  int16_T c2_c_u2[6];
  int32_T c2_a0;
  int32_T c2_b0;
  const mxArray *c2_m0 = NULL;
  const mxArray *c2_m1 = NULL;
  int32_T c2_a;
  int32_T c2_b;
  const mxArray *c2_m2 = NULL;
  const mxArray *c2_m3 = NULL;
  const mxArray *c2_m4 = NULL;
  const mxArray *c2_m5 = NULL;
  const mxArray *c2_m6 = NULL;
  const mxArray *c2_m7 = NULL;
  const mxArray *c2_m8 = NULL;
  const mxArray *c2_m9 = NULL;
  const mxArray *c2_m10 = NULL;
  const mxArray *c2_m11 = NULL;
  const mxArray *c2_m12 = NULL;
  const mxArray *c2_m13 = NULL;
  const mxArray *c2_m14 = NULL;
  const mxArray *c2_m15 = NULL;
  const mxArray *c2_m16 = NULL;
  const mxArray *c2_m17 = NULL;
  const mxArray *c2_m18 = NULL;
  const mxArray *c2_m19 = NULL;
  const mxArray *c2_m20 = NULL;
  const mxArray *c2_m21 = NULL;
  const mxArray *c2_m22 = NULL;
  const mxArray *c2_m23 = NULL;
  sf_debug_symbol_scope_push_eml(0U, 8U, 8U, c2_sv0, c2_debug_family_var_map);
  sf_debug_symbol_scope_add_eml(&c2_weights, c2_d_sf_marshall, 0U);
  sf_debug_symbol_scope_add_eml(&c2_S1, c2_sf_marshall, 1U);
  sf_debug_symbol_scope_add_eml(&c2_S2, c2_sf_marshall, 2U);
  sf_debug_symbol_scope_add_eml(&c2_nargin, c2_c_sf_marshall, 3U);
  sf_debug_symbol_scope_add_eml(&c2_nargout, c2_c_sf_marshall, 4U);
  sf_debug_symbol_scope_add_eml(c2_u1, c2_b_sf_marshall, 5U);
  sf_debug_symbol_scope_add_eml(c2_u2, c2_b_sf_marshall, 6U);
  sf_debug_symbol_scope_add_eml(&c2_y, c2_sf_marshall, 7U);
  CV_SCRIPT_FCN(0, 0);

  /*  Note #eml directive above, that tells MATLAB to compile this function */
  /*  for use % in a Simulink model (see Terje1.mdl) */
  _SFD_SCRIPT_CALL(0,6);
  for (c2_i8 = 0; c2_i8 < 6; c2_i8 = c2_i8 + 1) {
    c2_weights[c2_i8] = c2_dv0[c2_i8];
  }

  /*  Note mrdivide syntax */
  _SFD_SCRIPT_CALL(0,8);
  for (c2_i9 = 0; c2_i9 < 6; c2_i9 = c2_i9 + 1) {
    c2_b_u1[c2_i9] = c2_u1[c2_i9];
  }

  c2_times(chartInstance, c2_b_u1, c2_x);
  for (c2_i10 = 0; c2_i10 < 6; c2_i10 = c2_i10 + 1) {
    c2_b_y[c2_i10] = c2_x[c2_i10];
  }

  for (c2_i11 = 0; c2_i11 < 6; c2_i11 = c2_i11 + 1) {
    c2_c_y[c2_i11] = c2_b_y[c2_i11];
  }

  for (c2_i12 = 0; c2_i12 < 6; c2_i12 = c2_i12 + 1) {
    c2_c_u1[c2_i12] = c2_u1[c2_i12];
  }

  c2_S1 = c2_mtimes(chartInstance, c2_c_y, c2_c_u1);
  _SFD_SCRIPT_CALL(0,9);
  for (c2_i13 = 0; c2_i13 < 6; c2_i13 = c2_i13 + 1) {
    c2_b_u2[c2_i13] = c2_u2[c2_i13];
  }

  c2_times(chartInstance, c2_b_u2, c2_b_x);
  for (c2_i14 = 0; c2_i14 < 6; c2_i14 = c2_i14 + 1) {
    c2_d_y[c2_i14] = c2_b_x[c2_i14];
  }

  for (c2_i15 = 0; c2_i15 < 6; c2_i15 = c2_i15 + 1) {
    c2_e_y[c2_i15] = c2_d_y[c2_i15];
  }

  for (c2_i16 = 0; c2_i16 < 6; c2_i16 = c2_i16 + 1) {
    c2_c_u2[c2_i16] = c2_u2[c2_i16];
  }

  c2_S2 = c2_mtimes(chartInstance, c2_e_y, c2_c_u2);
  _SFD_SCRIPT_CALL(0,11);
  c2_a0 = c2_S1;
  c2_b0 = c2_S2;
  sf_mex_destroy(&c2_m0);
  sf_mex_destroy(&c2_m1);
  c2_a = c2_a0;
  c2_b = c2_b0;
  sf_mex_destroy(&c2_m2);
  sf_mex_destroy(&c2_m3);
  sf_mex_destroy(&c2_m4);
  sf_mex_destroy(&c2_m5);
  sf_mex_destroy(&c2_m6);
  sf_mex_destroy(&c2_m7);
  sf_mex_destroy(&c2_m8);
  sf_mex_destroy(&c2_m9);
  sf_mex_destroy(&c2_m10);
  sf_mex_destroy(&c2_m11);
  sf_mex_destroy(&c2_m12);
  sf_mex_destroy(&c2_m13);
  sf_mex_destroy(&c2_m14);
  sf_mex_destroy(&c2_m15);
  sf_mex_destroy(&c2_m16);
  sf_mex_destroy(&c2_m17);
  c2_y = c2_a - c2_b;
  sf_mex_destroy(&c2_m18);
  sf_mex_destroy(&c2_m19);
  sf_mex_destroy(&c2_m20);
  sf_mex_destroy(&c2_m21);
  sf_mex_destroy(&c2_m22);
  sf_mex_destroy(&c2_m23);
  _SFD_SCRIPT_CALL(0,-11);
  sf_debug_symbol_scope_pop();
  return c2_y;
}

static void c2_times(SFc2_Terje1InstanceStruct *chartInstance, int16_T c2_a0[6],
                     int32_T c2_c[6])
{
  const mxArray *c2_m24 = NULL;
  const mxArray *c2_m25 = NULL;
  int32_T c2_i17;
  int16_T c2_a[6];
  const mxArray *c2_m26 = NULL;
  const mxArray *c2_m27 = NULL;
  const mxArray *c2_m28 = NULL;
  const mxArray *c2_m29 = NULL;
  const mxArray *c2_m30 = NULL;
  const mxArray *c2_m31 = NULL;
  const mxArray *c2_m32 = NULL;
  const mxArray *c2_m33 = NULL;
  const mxArray *c2_m34 = NULL;
  const mxArray *c2_m35 = NULL;
  const mxArray *c2_m36 = NULL;
  const mxArray *c2_m37 = NULL;
  int32_T c2_i18;
  int16_T c2_b_a[6];
  int32_T c2_i19;
  static int16_T c2_iv0[6] = { 21845, 16384, 13107, 10922, 9362, 8192 };

  int32_T c2_b_c[6];
  int32_T c2_i20;
  const mxArray *c2_m38 = NULL;
  const mxArray *c2_m39 = NULL;
  const mxArray *c2_m40 = NULL;
  const mxArray *c2_m41 = NULL;
  sf_mex_destroy(&c2_m24);
  sf_mex_destroy(&c2_m25);
  for (c2_i17 = 0; c2_i17 < 6; c2_i17 = c2_i17 + 1) {
    c2_a[c2_i17] = c2_a0[c2_i17];
  }

  sf_mex_destroy(&c2_m26);
  sf_mex_destroy(&c2_m27);
  sf_mex_destroy(&c2_m28);
  sf_mex_destroy(&c2_m29);
  sf_mex_destroy(&c2_m30);
  sf_mex_destroy(&c2_m31);
  sf_mex_destroy(&c2_m32);
  sf_mex_destroy(&c2_m33);
  sf_mex_destroy(&c2_m34);
  sf_mex_destroy(&c2_m35);
  sf_mex_destroy(&c2_m36);
  sf_mex_destroy(&c2_m37);
  for (c2_i18 = 0; c2_i18 < 6; c2_i18 = c2_i18 + 1) {
    c2_b_a[c2_i18] = c2_a[c2_i18];
  }

  for (c2_i19 = 0; c2_i19 < 6; c2_i19 = c2_i19 + 1) {
    c2_b_c[c2_i19] = c2_b_a[c2_i19] * c2_iv0[c2_i19];
  }

  for (c2_i20 = 0; c2_i20 < 6; c2_i20 = c2_i20 + 1) {
    c2_c[c2_i20] = c2_b_c[c2_i20];
  }

  sf_mex_destroy(&c2_m38);
  sf_mex_destroy(&c2_m39);
  sf_mex_destroy(&c2_m40);
  sf_mex_destroy(&c2_m41);
}

static int32_T c2_mtimes(SFc2_Terje1InstanceStruct *chartInstance, int32_T
  c2_a0[6], int16_T c2_b0[6])
{
  int32_T c2_cout;
  const mxArray *c2_m42 = NULL;
  const mxArray *c2_m43 = NULL;
  int32_T c2_i21;
  int32_T c2_a[6];
  int32_T c2_i22;
  int16_T c2_b[6];
  const mxArray *c2_m44 = NULL;
  const mxArray *c2_m45 = NULL;
  const mxArray *c2_m46 = NULL;
  const mxArray *c2_m47 = NULL;
  const mxArray *c2_m48 = NULL;
  const mxArray *c2_m49 = NULL;
  const mxArray *c2_m50 = NULL;
  const mxArray *c2_m51 = NULL;
  const mxArray *c2_m52 = NULL;
  const mxArray *c2_m53 = NULL;
  const mxArray *c2_m54 = NULL;
  const mxArray *c2_m55 = NULL;
  int32_T c2_c;
  real_T c2_k;
  real_T c2_b_k;
  int32_T c2_b_a;
  int16_T c2_b_b;
  int32_T c2_prodAB;
  const mxArray *c2_m56 = NULL;
  const mxArray *c2_m57 = NULL;
  const mxArray *c2_m58 = NULL;
  const mxArray *c2_m59 = NULL;
  const mxArray *c2_m60 = NULL;
  const mxArray *c2_m61 = NULL;
  const mxArray *c2_m62 = NULL;
  const mxArray *c2_m63 = NULL;
  sf_mex_destroy(&c2_m42);
  sf_mex_destroy(&c2_m43);
  for (c2_i21 = 0; c2_i21 < 6; c2_i21 = c2_i21 + 1) {
    c2_a[c2_i21] = c2_a0[c2_i21];
  }

  for (c2_i22 = 0; c2_i22 < 6; c2_i22 = c2_i22 + 1) {
    c2_b[c2_i22] = c2_b0[c2_i22];
  }

  sf_mex_destroy(&c2_m44);
  sf_mex_destroy(&c2_m45);
  sf_mex_destroy(&c2_m46);
  sf_mex_destroy(&c2_m47);
  sf_mex_destroy(&c2_m48);
  sf_mex_destroy(&c2_m49);
  sf_mex_destroy(&c2_m50);
  sf_mex_destroy(&c2_m51);
  sf_mex_destroy(&c2_m52);
  sf_mex_destroy(&c2_m53);
  sf_mex_destroy(&c2_m54);
  sf_mex_destroy(&c2_m55);
  c2_c = 0;
  for (c2_k = 1.0; c2_k <= 6.0; c2_k = c2_k + 1.0) {
    c2_b_k = c2_k;
    c2_b_a = c2_a[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)_SFD_INTEGER_CHECK("",
      c2_b_k), 1, 6, 2, 0) - 1];
    c2_b_b = c2_b[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)_SFD_INTEGER_CHECK("",
      c2_b_k), 1, 6, 1, 0) - 1];
    c2_prodAB = c2_b_a * c2_b_b;
    c2_c = c2_c + c2_prodAB;
  }

  c2_cout = c2_c;
  sf_mex_destroy(&c2_m56);
  sf_mex_destroy(&c2_m57);
  sf_mex_destroy(&c2_m58);
  sf_mex_destroy(&c2_m59);
  sf_mex_destroy(&c2_m60);
  sf_mex_destroy(&c2_m61);
  sf_mex_destroy(&c2_m62);
  sf_mex_destroy(&c2_m63);
  return c2_cout;
}

static const mxArray *c2_sf_marshall(void *chartInstanceVoid, void *c2_u)
{
  const mxArray *c2_y = NULL;
  int32_T c2_b_u;
  const mxArray *c2_b_y = NULL;
  int32_T c2_c_u;
  const mxArray *c2_c_y = NULL;
  SFc2_Terje1InstanceStruct *chartInstance;
  chartInstance = (SFc2_Terje1InstanceStruct *)chartInstanceVoid;
  c2_y = NULL;
  if (sf_debug_check_fi_license()) {
    c2_b_u = *((int32_T *)c2_u);
    c2_b_y = NULL;
    c2_c_u = c2_b_u;
    c2_c_y = NULL;
    sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_c_u, 6, 0U, 0U, 0U, 0));
    sf_mex_assign(&c2_b_y, sf_mex_call("embedded.fi", 1U, 8U, 15, "fimath", 14,
      sf_mex_dup(c2_eml_mx), 15, "numerictype", 14, sf_mex_dup
                   (c2_b_eml_mx), 15, "simulinkarray", 14, c2_c_y, 15,
      "fimathislocal", 3, FALSE));
    sf_mex_assign(&c2_y, c2_b_y);
  } else {
    sf_mex_assign(&c2_y, sf_mex_create("y", "Cannot display value.", 15, 0U, 0U,
      0U, 2, 1, strlen("Cannot display value.")));
  }

  return c2_y;
}

static const mxArray *c2_b_sf_marshall(void *chartInstanceVoid, void *c2_u)
{
  const mxArray *c2_y = NULL;
  int32_T c2_i23;
  int16_T c2_b_u[6];
  const mxArray *c2_b_y = NULL;
  int32_T c2_i24;
  int16_T c2_c_u[6];
  const mxArray *c2_c_y = NULL;
  SFc2_Terje1InstanceStruct *chartInstance;
  chartInstance = (SFc2_Terje1InstanceStruct *)chartInstanceVoid;
  c2_y = NULL;
  for (c2_i23 = 0; c2_i23 < 6; c2_i23 = c2_i23 + 1) {
    c2_b_u[c2_i23] = (*((int16_T (*)[6])c2_u))[c2_i23];
  }

  c2_b_y = NULL;
  for (c2_i24 = 0; c2_i24 < 6; c2_i24 = c2_i24 + 1) {
    c2_c_u[c2_i24] = c2_b_u[c2_i24];
  }

  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_c_u, 4, 0U, 1U, 0U, 1, 6));
  sf_mex_assign(&c2_b_y, sf_mex_call("embedded.fi", 1U, 8U, 15, "fimath", 14,
    sf_mex_dup(c2_eml_mx), 15, "numerictype", 14, sf_mex_dup
                 (c2_c_eml_mx), 15, "simulinkarray", 14, c2_c_y, 15,
    "fimathislocal", 3, FALSE));
  sf_mex_assign(&c2_y, c2_b_y);
  return c2_y;
}

static const mxArray *c2_c_sf_marshall(void *chartInstanceVoid, void *c2_u)
{
  const mxArray *c2_y = NULL;
  real_T c2_b_u;
  const mxArray *c2_b_y = NULL;
  SFc2_Terje1InstanceStruct *chartInstance;
  chartInstance = (SFc2_Terje1InstanceStruct *)chartInstanceVoid;
  c2_y = NULL;
  c2_b_u = *((real_T *)c2_u);
  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", &c2_b_u, 0, 0U, 0U, 0U, 0));
  sf_mex_assign(&c2_y, c2_b_y);
  return c2_y;
}

static const mxArray *c2_d_sf_marshall(void *chartInstanceVoid, void *c2_u)
{
  const mxArray *c2_y = NULL;
  int32_T c2_i25;
  real_T c2_b_u[6];
  const mxArray *c2_b_y = NULL;
  SFc2_Terje1InstanceStruct *chartInstance;
  chartInstance = (SFc2_Terje1InstanceStruct *)chartInstanceVoid;
  c2_y = NULL;
  for (c2_i25 = 0; c2_i25 < 6; c2_i25 = c2_i25 + 1) {
    c2_b_u[c2_i25] = (*((real_T (*)[6])c2_u))[c2_i25];
  }

  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", &c2_b_u, 0, 0U, 1U, 0U, 2, 1, 6));
  sf_mex_assign(&c2_y, c2_b_y);
  return c2_y;
}

const mxArray *sf_c2_Terje1_get_eml_resolved_functions_info(void)
{
  const mxArray *c2_nameCaptureInfo = NULL;
  c2_ResolvedFunctionInfo c2_info[69];
  c2_ResolvedFunctionInfo (*c2_b_info)[69];
  const mxArray *c2_m64 = NULL;
  int32_T c2_i26;
  c2_ResolvedFunctionInfo *c2_r0;
  c2_nameCaptureInfo = NULL;
  c2_info_helper(c2_info);
  c2_b_info = (c2_ResolvedFunctionInfo (*)[69])c2_info;
  (*c2_b_info)[64].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m";
  (*c2_b_info)[64].name = "eml_fixpt_times";
  (*c2_b_info)[64].dominantType = "embedded.fi";
  (*c2_b_info)[64].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/eml_fixpt_times.m";
  (*c2_b_info)[64].fileLength = 1981U;
  (*c2_b_info)[64].fileTime1 = 1252000086U;
  (*c2_b_info)[64].fileTime2 = 0U;
  (*c2_b_info)[65].context = "[]C:/coding/Octave/Sampling_error.m";
  (*c2_b_info)[65].name = "ctranspose";
  (*c2_b_info)[65].dominantType = "embedded.fi";
  (*c2_b_info)[65].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/ctranspose.m";
  (*c2_b_info)[65].fileLength = 571U;
  (*c2_b_info)[65].fileTime1 = 1242298358U;
  (*c2_b_info)[65].fileTime2 = 0U;
  (*c2_b_info)[66].context = "[]C:/coding/Octave/Sampling_error.m";
  (*c2_b_info)[66].name = "mtimes";
  (*c2_b_info)[66].dominantType = "embedded.fi";
  (*c2_b_info)[66].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/mtimes.m";
  (*c2_b_info)[66].fileLength = 8211U;
  (*c2_b_info)[66].fileTime1 = 1252000088U;
  (*c2_b_info)[66].fileTime2 = 0U;
  (*c2_b_info)[67].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/mtimes.m";
  (*c2_b_info)[67].name = "eml_checkfimathforbinaryops";
  (*c2_b_info)[67].dominantType = "embedded.fi";
  (*c2_b_info)[67].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/eml_checkfimathforbinaryops.m";
  (*c2_b_info)[67].fileLength = 1001U;
  (*c2_b_info)[67].fileTime1 = 1234901164U;
  (*c2_b_info)[67].fileTime2 = 0U;
  (*c2_b_info)[68].context = "[]C:/coding/Octave/Sampling_error.m";
  (*c2_b_info)[68].name = "minus";
  (*c2_b_info)[68].dominantType = "embedded.fi";
  (*c2_b_info)[68].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/minus.m";
  (*c2_b_info)[68].fileLength = 5356U;
  (*c2_b_info)[68].fileTime1 = 1252000086U;
  (*c2_b_info)[68].fileTime2 = 0U;
  sf_mex_assign(&c2_m64, sf_mex_createstruct("nameCaptureInfo", 1, 69));
  for (c2_i26 = 0; c2_i26 < 69; c2_i26 = c2_i26 + 1) {
    c2_r0 = &c2_info[c2_i26];
    sf_mex_addfield(c2_m64, sf_mex_create("nameCaptureInfo", c2_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c2_r0->context)), "context",
                    "nameCaptureInfo", c2_i26);
    sf_mex_addfield(c2_m64, sf_mex_create("nameCaptureInfo", c2_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c2_r0->name)), "name",
                    "nameCaptureInfo", c2_i26);
    sf_mex_addfield(c2_m64, sf_mex_create("nameCaptureInfo", c2_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c2_r0->dominantType)),
                    "dominantType", "nameCaptureInfo", c2_i26);
    sf_mex_addfield(c2_m64, sf_mex_create("nameCaptureInfo", c2_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c2_r0->resolved)), "resolved"
                    , "nameCaptureInfo", c2_i26);
    sf_mex_addfield(c2_m64, sf_mex_create("nameCaptureInfo", &c2_r0->fileLength,
      7, 0U, 0U, 0U, 0), "fileLength", "nameCaptureInfo",
                    c2_i26);
    sf_mex_addfield(c2_m64, sf_mex_create("nameCaptureInfo", &c2_r0->fileTime1,
      7, 0U, 0U, 0U, 0), "fileTime1", "nameCaptureInfo",
                    c2_i26);
    sf_mex_addfield(c2_m64, sf_mex_create("nameCaptureInfo", &c2_r0->fileTime2,
      7, 0U, 0U, 0U, 0), "fileTime2", "nameCaptureInfo",
                    c2_i26);
  }

  sf_mex_assign(&c2_nameCaptureInfo, c2_m64);
  return c2_nameCaptureInfo;
}

static void c2_info_helper(c2_ResolvedFunctionInfo c2_info[69])
{
  c2_info[0].context = "";
  c2_info[0].name = "Sampling_error";
  c2_info[0].dominantType = "embedded.fi";
  c2_info[0].resolved = "[]C:/coding/Octave/Sampling_error.m";
  c2_info[0].fileLength = 274U;
  c2_info[0].fileTime1 = 1231331632U;
  c2_info[0].fileTime2 = 0U;
  c2_info[1].context = "[]C:/coding/Octave/Sampling_error.m";
  c2_info[1].name = "colon";
  c2_info[1].dominantType = "double";
  c2_info[1].resolved = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[1].fileLength = 8592U;
  c2_info[1].fileTime1 = 1257783382U;
  c2_info[1].fileTime2 = 0U;
  c2_info[2].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[2].name = "nargin";
  c2_info[2].dominantType = "";
  c2_info[2].resolved = "[B]nargin";
  c2_info[2].fileLength = 0U;
  c2_info[2].fileTime1 = 0U;
  c2_info[2].fileTime2 = 0U;
  c2_info[3].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[3].name = "ge";
  c2_info[3].dominantType = "double";
  c2_info[3].resolved = "[B]ge";
  c2_info[3].fileLength = 0U;
  c2_info[3].fileTime1 = 0U;
  c2_info[3].fileTime2 = 0U;
  c2_info[4].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[4].name = "lt";
  c2_info[4].dominantType = "double";
  c2_info[4].resolved = "[B]lt";
  c2_info[4].fileLength = 0U;
  c2_info[4].fileTime1 = 0U;
  c2_info[4].fileTime2 = 0U;
  c2_info[5].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[5].name = "isscalar";
  c2_info[5].dominantType = "double";
  c2_info[5].resolved = "[B]isscalar";
  c2_info[5].fileLength = 0U;
  c2_info[5].fileTime1 = 0U;
  c2_info[5].fileTime2 = 0U;
  c2_info[6].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[6].name = "not";
  c2_info[6].dominantType = "logical";
  c2_info[6].resolved = "[B]not";
  c2_info[6].fileLength = 0U;
  c2_info[6].fileTime1 = 0U;
  c2_info[6].fileTime2 = 0U;
  c2_info[7].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[7].name = "isa";
  c2_info[7].dominantType = "double";
  c2_info[7].resolved = "[B]isa";
  c2_info[7].fileLength = 0U;
  c2_info[7].fileTime1 = 0U;
  c2_info[7].fileTime2 = 0U;
  c2_info[8].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[8].name = "isreal";
  c2_info[8].dominantType = "double";
  c2_info[8].resolved = "[B]isreal";
  c2_info[8].fileLength = 0U;
  c2_info[8].fileTime1 = 0U;
  c2_info[8].fileTime2 = 0U;
  c2_info[9].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[9].name = "ischar";
  c2_info[9].dominantType = "double";
  c2_info[9].resolved = "[B]ischar";
  c2_info[9].fileLength = 0U;
  c2_info[9].fileTime1 = 0U;
  c2_info[9].fileTime2 = 0U;
  c2_info[10].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m";
  c2_info[10].name = "isinteger";
  c2_info[10].dominantType = "double";
  c2_info[10].resolved = "[B]isinteger";
  c2_info[10].fileLength = 0U;
  c2_info[10].fileTime1 = 0U;
  c2_info[10].fileTime2 = 0U;
  c2_info[11].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/is_flint_colon";
  c2_info[11].name = "isfinite";
  c2_info[11].dominantType = "double";
  c2_info[11].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[11].fileLength = 364U;
  c2_info[11].fileTime1 = 1226577272U;
  c2_info[11].fileTime2 = 0U;
  c2_info[12].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[12].name = "gt";
  c2_info[12].dominantType = "double";
  c2_info[12].resolved = "[B]gt";
  c2_info[12].fileLength = 0U;
  c2_info[12].fileTime1 = 0U;
  c2_info[12].fileTime2 = 0U;
  c2_info[13].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[13].name = "isinf";
  c2_info[13].dominantType = "double";
  c2_info[13].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isinf.m";
  c2_info[13].fileLength = 506U;
  c2_info[13].fileTime1 = 1228093808U;
  c2_info[13].fileTime2 = 0U;
  c2_info[14].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[14].name = "isnan";
  c2_info[14].dominantType = "double";
  c2_info[14].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c2_info[14].fileLength = 506U;
  c2_info[14].fileTime1 = 1228093810U;
  c2_info[14].fileTime2 = 0U;
  c2_info[15].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isfinite.m";
  c2_info[15].name = "and";
  c2_info[15].dominantType = "logical";
  c2_info[15].resolved = "[B]and";
  c2_info[15].fileLength = 0U;
  c2_info[15].fileTime1 = 0U;
  c2_info[15].fileTime2 = 0U;
  c2_info[16].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/is_flint_colon";
  c2_info[16].name = "floor";
  c2_info[16].dominantType = "double";
  c2_info[16].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c2_info[16].fileLength = 332U;
  c2_info[16].fileTime1 = 1203448022U;
  c2_info[16].fileTime2 = 0U;
  c2_info[17].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c2_info[17].name = "eml_scalar_floor";
  c2_info[17].dominantType = "double";
  c2_info[17].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m";
  c2_info[17].fileLength = 260U;
  c2_info[17].fileTime1 = 1209330790U;
  c2_info[17].fileTime2 = 0U;
  c2_info[18].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/is_flint_colon";
  c2_info[18].name = "eq";
  c2_info[18].dominantType = "double";
  c2_info[18].resolved = "[B]eq";
  c2_info[18].fileLength = 0U;
  c2_info[18].fileTime1 = 0U;
  c2_info[18].fileTime2 = 0U;
  c2_info[19].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/maxabs";
  c2_info[19].name = "abs";
  c2_info[19].dominantType = "double";
  c2_info[19].resolved = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[19].fileLength = 566U;
  c2_info[19].fileTime1 = 1221267132U;
  c2_info[19].fileTime2 = 0U;
  c2_info[20].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[20].name = "islogical";
  c2_info[20].dominantType = "double";
  c2_info[20].resolved = "[B]islogical";
  c2_info[20].fileLength = 0U;
  c2_info[20].fileTime1 = 0U;
  c2_info[20].fileTime2 = 0U;
  c2_info[21].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[21].name = "size";
  c2_info[21].dominantType = "double";
  c2_info[21].resolved = "[B]size";
  c2_info[21].fileLength = 0U;
  c2_info[21].fileTime1 = 0U;
  c2_info[21].fileTime2 = 0U;
  c2_info[22].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[22].name = "class";
  c2_info[22].dominantType = "double";
  c2_info[22].resolved = "[B]class";
  c2_info[22].fileLength = 0U;
  c2_info[22].fileTime1 = 0U;
  c2_info[22].fileTime2 = 0U;
  c2_info[23].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[23].name = "zeros";
  c2_info[23].dominantType = "double";
  c2_info[23].resolved = "[B]zeros";
  c2_info[23].fileLength = 0U;
  c2_info[23].fileTime1 = 0U;
  c2_info[23].fileTime2 = 0U;
  c2_info[24].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c2_info[24].name = "eml_scalar_abs";
  c2_info[24].dominantType = "double";
  c2_info[24].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_abs.m";
  c2_info[24].fileLength = 461U;
  c2_info[24].fileTime1 = 1203447960U;
  c2_info[24].fileTime2 = 0U;
  c2_info[25].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/is_flint_colon";
  c2_info[25].name = "eps";
  c2_info[25].dominantType = "double";
  c2_info[25].resolved = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[25].fileLength = 1331U;
  c2_info[25].fileTime1 = 1246283386U;
  c2_info[25].fileTime2 = 0U;
  c2_info[26].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[26].name = "real";
  c2_info[26].dominantType = "double";
  c2_info[26].resolved = "[B]real";
  c2_info[26].fileLength = 0U;
  c2_info[26].fileTime1 = 0U;
  c2_info[26].fileTime2 = 0U;
  c2_info[27].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[27].name = "int32";
  c2_info[27].dominantType = "double";
  c2_info[27].resolved = "[B]int32";
  c2_info[27].fileLength = 0U;
  c2_info[27].fileTime1 = 0U;
  c2_info[27].fileTime2 = 0U;
  c2_info[28].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[28].name = "realmin";
  c2_info[28].dominantType = "";
  c2_info[28].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/realmin.m";
  c2_info[28].fileLength = 749U;
  c2_info[28].fileTime1 = 1226577278U;
  c2_info[28].fileTime2 = 0U;
  c2_info[29].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/realmin.m";
  c2_info[29].name = "uminus";
  c2_info[29].dominantType = "double";
  c2_info[29].resolved = "[B]uminus";
  c2_info[29].fileLength = 0U;
  c2_info[29].fileTime1 = 0U;
  c2_info[29].fileTime2 = 0U;
  c2_info[30].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/realmin.m";
  c2_info[30].name = "mpower";
  c2_info[30].dominantType = "double";
  c2_info[30].resolved = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c2_info[30].fileLength = 3710U;
  c2_info[30].fileTime1 = 1238434288U;
  c2_info[30].fileTime2 = 0U;
  c2_info[31].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c2_info[31].name = "ndims";
  c2_info[31].dominantType = "double";
  c2_info[31].resolved = "[B]ndims";
  c2_info[31].fileLength = 0U;
  c2_info[31].fileTime1 = 0U;
  c2_info[31].fileTime2 = 0U;
  c2_info[32].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c2_info[32].name = "power";
  c2_info[32].dominantType = "double";
  c2_info[32].resolved = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c2_info[32].fileLength = 5380U;
  c2_info[32].fileTime1 = 1228093898U;
  c2_info[32].fileTime2 = 0U;
  c2_info[33].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c2_info[33].name = "eml_scalar_eg";
  c2_info[33].dominantType = "double";
  c2_info[33].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c2_info[33].fileLength = 3068U;
  c2_info[33].fileTime1 = 1240262010U;
  c2_info[33].fileTime2 = 0U;
  c2_info[34].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m/any_enums";
  c2_info[34].name = "false";
  c2_info[34].dominantType = "";
  c2_info[34].resolved = "[B]false";
  c2_info[34].fileLength = 0U;
  c2_info[34].fileTime1 = 0U;
  c2_info[34].fileTime2 = 0U;
  c2_info[35].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c2_info[35].name = "isstruct";
  c2_info[35].dominantType = "double";
  c2_info[35].resolved = "[B]isstruct";
  c2_info[35].fileLength = 0U;
  c2_info[35].fileTime1 = 0U;
  c2_info[35].fileTime2 = 0U;
  c2_info[36].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m/zerosum";
  c2_info[36].name = "cast";
  c2_info[36].dominantType = "double";
  c2_info[36].resolved = "[B]cast";
  c2_info[36].fileLength = 0U;
  c2_info[36].fileTime1 = 0U;
  c2_info[36].fileTime2 = 0U;
  c2_info[37].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m/zerosum";
  c2_info[37].name = "plus";
  c2_info[37].dominantType = "double";
  c2_info[37].resolved = "[B]plus";
  c2_info[37].fileLength = 0U;
  c2_info[37].fileTime1 = 0U;
  c2_info[37].fileTime2 = 0U;
  c2_info[38].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c2_info[38].name = "eml_scalexp_alloc";
  c2_info[38].dominantType = "double";
  c2_info[38].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c2_info[38].fileLength = 808U;
  c2_info[38].fileTime1 = 1230494698U;
  c2_info[38].fileTime2 = 0U;
  c2_info[39].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c2_info[39].name = "minus";
  c2_info[39].dominantType = "double";
  c2_info[39].resolved = "[B]minus";
  c2_info[39].fileLength = 0U;
  c2_info[39].fileTime1 = 0U;
  c2_info[39].fileTime2 = 0U;
  c2_info[40].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c2_info[40].name = "ne";
  c2_info[40].dominantType = "double";
  c2_info[40].resolved = "[B]ne";
  c2_info[40].fileLength = 0U;
  c2_info[40].fileTime1 = 0U;
  c2_info[40].fileTime2 = 0U;
  c2_info[41].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c2_info[41].name = "eml_error";
  c2_info[41].dominantType = "char";
  c2_info[41].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_error.m";
  c2_info[41].fileLength = 315U;
  c2_info[41].fileTime1 = 1213926744U;
  c2_info[41].fileTime2 = 0U;
  c2_info[42].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_error.m";
  c2_info[42].name = "strcmp";
  c2_info[42].dominantType = "char";
  c2_info[42].resolved = "[B]strcmp";
  c2_info[42].fileLength = 0U;
  c2_info[42].fileTime1 = 0U;
  c2_info[42].fileTime2 = 0U;
  c2_info[43].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/eps.m";
  c2_info[43].name = "le";
  c2_info[43].dominantType = "double";
  c2_info[43].resolved = "[B]le";
  c2_info[43].fileLength = 0U;
  c2_info[43].fileTime1 = 0U;
  c2_info[43].fileTime2 = 0U;
  c2_info[44].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/checkrange";
  c2_info[44].name = "realmax";
  c2_info[44].dominantType = "char";
  c2_info[44].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/realmax.m";
  c2_info[44].fileLength = 771U;
  c2_info[44].fileTime1 = 1226577276U;
  c2_info[44].fileTime2 = 0U;
  c2_info[45].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/realmax.m";
  c2_info[45].name = "mtimes";
  c2_info[45].dominantType = "double";
  c2_info[45].resolved = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c2_info[45].fileLength = 3425U;
  c2_info[45].fileTime1 = 1250672766U;
  c2_info[45].fileTime2 = 0U;
  c2_info[46].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/eml_integer_colon";
  c2_info[46].name = "double";
  c2_info[46].dominantType = "double";
  c2_info[46].resolved = "[B]double";
  c2_info[46].fileLength = 0U;
  c2_info[46].fileTime1 = 0U;
  c2_info[46].fileTime2 = 0U;
  c2_info[47].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/eml_integer_colon";
  c2_info[47].name = "intmax";
  c2_info[47].dominantType = "";
  c2_info[47].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m";
  c2_info[47].fileLength = 1535U;
  c2_info[47].fileTime1 = 1192466728U;
  c2_info[47].fileTime2 = 0U;
  c2_info[48].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/colon.m/eml_integer_colon";
  c2_info[48].name = "transpose";
  c2_info[48].dominantType = "double";
  c2_info[48].resolved = "[B]transpose";
  c2_info[48].fileLength = 0U;
  c2_info[48].fileTime1 = 0U;
  c2_info[48].fileTime2 = 0U;
  c2_info[49].context = "[]C:/coding/Octave/Sampling_error.m";
  c2_info[49].name = "rdivide";
  c2_info[49].dominantType = "double";
  c2_info[49].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c2_info[49].fileLength = 403U;
  c2_info[49].fileTime1 = 1244735552U;
  c2_info[49].fileTime2 = 0U;
  c2_info[50].context = "[ILX]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c2_info[50].name = "eml_div";
  c2_info[50].dominantType = "double";
  c2_info[50].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  c2_info[50].fileLength = 4269U;
  c2_info[50].fileTime1 = 1228093826U;
  c2_info[50].fileTime2 = 0U;
  c2_info[51].context = "[]C:/coding/Octave/Sampling_error.m";
  c2_info[51].name = "ctranspose";
  c2_info[51].dominantType = "double";
  c2_info[51].resolved = "[B]ctranspose";
  c2_info[51].fileLength = 0U;
  c2_info[51].fileTime1 = 0U;
  c2_info[51].fileTime2 = 0U;
  c2_info[52].context = "[]C:/coding/Octave/Sampling_error.m";
  c2_info[52].name = "times";
  c2_info[52].dominantType = "embedded.fi";
  c2_info[52].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m";
  c2_info[52].fileLength = 5168U;
  c2_info[52].fileTime1 = 1252000088U;
  c2_info[52].fileTime2 = 0U;
  c2_info[53].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m";
  c2_info[53].name = "isequal";
  c2_info[53].dominantType = "double";
  c2_info[53].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isequal.m";
  c2_info[53].fileLength = 180U;
  c2_info[53].fileTime1 = 1226577270U;
  c2_info[53].fileTime2 = 0U;
  c2_info[54].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/elmat/isequal.m";
  c2_info[54].name = "eml_isequal_core";
  c2_info[54].dominantType = "double";
  c2_info[54].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_isequal_core.m";
  c2_info[54].fileLength = 4192U;
  c2_info[54].fileTime1 = 1257783382U;
  c2_info[54].fileTime2 = 0U;
  c2_info[55].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_isequal_core.m";
  c2_info[55].name = "isnumeric";
  c2_info[55].dominantType = "double";
  c2_info[55].resolved = "[B]isnumeric";
  c2_info[55].fileLength = 0U;
  c2_info[55].fileTime1 = 0U;
  c2_info[55].fileTime2 = 0U;
  c2_info[56].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_isequal_core.m/same_size";
  c2_info[56].name = "true";
  c2_info[56].dominantType = "";
  c2_info[56].resolved = "[B]true";
  c2_info[56].fileLength = 0U;
  c2_info[56].fileTime1 = 0U;
  c2_info[56].fileTime2 = 0U;
  c2_info[57].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_isequal_core.m/binary_isequal";
  c2_info[57].name = "isempty";
  c2_info[57].dominantType = "double";
  c2_info[57].resolved = "[B]isempty";
  c2_info[57].fileLength = 0U;
  c2_info[57].fileTime1 = 0U;
  c2_info[57].fileTime2 = 0U;
  c2_info[58].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m";
  c2_info[58].name = "isfi";
  c2_info[58].dominantType = "embedded.fi";
  c2_info[58].resolved = "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/isfi.m";
  c2_info[58].fileLength = 532U;
  c2_info[58].fileTime1 = 1226577200U;
  c2_info[58].fileTime2 = 0U;
  c2_info[59].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m";
  c2_info[59].name = "isfixed";
  c2_info[59].dominantType = "embedded.fi";
  c2_info[59].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/isfixed.m";
  c2_info[59].fileLength = 581U;
  c2_info[59].fileTime1 = 1192466570U;
  c2_info[59].fileTime2 = 0U;
  c2_info[60].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/isfixed.m";
  c2_info[60].name = "get";
  c2_info[60].dominantType = "embedded.numerictype";
  c2_info[60].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@numerictype/get.m";
  c2_info[60].fileLength = 830U;
  c2_info[60].fileTime1 = 1216384778U;
  c2_info[60].fileTime2 = 0U;
  c2_info[61].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m";
  c2_info[61].name = "eml";
  c2_info[61].dominantType = "char";
  c2_info[61].resolved = "[B]eml";
  c2_info[61].fileLength = 0U;
  c2_info[61].fileTime1 = 0U;
  c2_info[61].fileTime2 = 0U;
  c2_info[62].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m";
  c2_info[62].name = "get";
  c2_info[62].dominantType = "embedded.fimath";
  c2_info[62].resolved =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fimath/get.m";
  c2_info[62].fileLength = 872U;
  c2_info[62].fileTime1 = 1216384776U;
  c2_info[62].fileTime2 = 0U;
  c2_info[63].context =
    "[ILX]$matlabroot$/toolbox/eml/lib/fixedpoint/@embedded/@fi/times.m";
  c2_info[63].name = "strcmpi";
  c2_info[63].dominantType = "char";
  c2_info[63].resolved = "[IXMB]$matlabroot$/toolbox/matlab/strfun/strcmpi";
  c2_info[63].fileLength = 0U;
  c2_info[63].fileTime1 = 0U;
  c2_info[63].fileTime2 = 0U;
}

static const mxArray *c2_e_sf_marshall(void *chartInstanceVoid, void *c2_u)
{
  const mxArray *c2_y = NULL;
  boolean_T c2_b_u;
  const mxArray *c2_b_y = NULL;
  SFc2_Terje1InstanceStruct *chartInstance;
  chartInstance = (SFc2_Terje1InstanceStruct *)chartInstanceVoid;
  c2_y = NULL;
  c2_b_u = *((boolean_T *)c2_u);
  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", &c2_b_u, 11, 0U, 0U, 0U, 0));
  sf_mex_assign(&c2_y, c2_b_y);
  return c2_y;
}

static const mxArray *c2_f_sf_marshall(void *chartInstanceVoid, void *c2_u)
{
  const mxArray *c2_y = NULL;
  int32_T c2_i27;
  int16_T c2_b_u[6];
  const mxArray *c2_b_y = NULL;
  int32_T c2_i28;
  int16_T c2_c_u[6];
  const mxArray *c2_c_y = NULL;
  SFc2_Terje1InstanceStruct *chartInstance;
  chartInstance = (SFc2_Terje1InstanceStruct *)chartInstanceVoid;
  c2_y = NULL;
  for (c2_i27 = 0; c2_i27 < 6; c2_i27 = c2_i27 + 1) {
    c2_b_u[c2_i27] = (*((int16_T (*)[6])c2_u))[c2_i27];
  }

  c2_b_y = NULL;
  for (c2_i28 = 0; c2_i28 < 6; c2_i28 = c2_i28 + 1) {
    c2_c_u[c2_i28] = c2_b_u[c2_i28];
  }

  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_c_u, 4, 0U, 1U, 0U, 1, 6));
  sf_mex_assign(&c2_b_y, sf_mex_call("embedded.fi", 1U, 8U, 15, "fimath", 14,
    sf_mex_dup(c2_eml_mx), 15, "numerictype", 14, sf_mex_dup
                 (c2_c_eml_mx), 15, "simulinkarray", 14, c2_c_y, 15,
    "fimathislocal", 3, TRUE));
  sf_mex_assign(&c2_y, c2_b_y);
  return c2_y;
}

static int32_T c2_emlrt_marshallIn(SFc2_Terje1InstanceStruct *chartInstance,
  const mxArray *c2_y, const char_T *c2_name)
{
  int32_T c2_b_y;
  const mxArray *c2_mxFi = NULL;
  const mxArray *c2_mxInt = NULL;
  int32_T c2_i29;
  sf_mex_check_fi(c2_name, c2_y, 0, 0U, 0, c2_eml_mx, c2_b_eml_mx);
  sf_mex_assign(&c2_mxFi, sf_mex_dup(c2_y));
  sf_mex_assign(&c2_mxInt, sf_mex_call("simulinkarray", 1U, 1U, 14, sf_mex_dup
    (c2_mxFi)));
  sf_mex_import("y", sf_mex_dup(c2_mxInt), &c2_i29, 0, 6, 0U, 0, 0U, 0);
  sf_mex_destroy(&c2_mxFi);
  sf_mex_destroy(&c2_mxInt);
  c2_b_y = c2_i29;
  sf_mex_destroy(&c2_y);
  return c2_b_y;
}

static uint8_T c2_b_emlrt_marshallIn(SFc2_Terje1InstanceStruct *chartInstance,
  const mxArray *c2_b_is_active_c2_Terje1, const char_T
  *c2_name)
{
  uint8_T c2_y;
  uint8_T c2_u0;
  sf_mex_import(c2_name, sf_mex_dup(c2_b_is_active_c2_Terje1), &c2_u0, 1, 3, 0U,
                0, 0U, 0);
  c2_y = c2_u0;
  sf_mex_destroy(&c2_b_is_active_c2_Terje1);
  return c2_y;
}

static void init_dsm_address_info(SFc2_Terje1InstanceStruct *chartInstance)
{
}

/* SFunction Glue Code */
void sf_c2_Terje1_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(433305286U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1515231178U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2128468850U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(3546923763U);
}

mxArray *sf_c2_Terje1_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,4,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateDoubleMatrix(4,1,mxREAL);
    double *pr = mxGetPr(mxChecksum);
    pr[0] = (double)(3381274029U);
    pr[1] = (double)(3248226698U);
    pr[2] = (double)(366923410U);
    pr[3] = (double)(4158020641U);
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,2,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(6);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(11));

      {
        const char *fixptFields[] = { "isSigned", "wordLength", "bias", "slope",
          "exponent" };

        mxArray *mxFixpt = mxCreateStructMatrix(1,1,5,fixptFields);
        mxSetField(mxFixpt,0,"isSigned",mxCreateDoubleScalar(1));
        mxSetField(mxFixpt,0,"wordLength",mxCreateDoubleScalar(16));
        mxSetField(mxFixpt,0,"bias",mxCreateDoubleScalar(0));
        mxSetField(mxFixpt,0,"slope",mxCreateDoubleScalar(1));
        mxSetField(mxFixpt,0,"exponent",mxCreateDoubleScalar(-11));
        mxSetField(mxType,0,"fixpt",mxFixpt);
      }

      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(6);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(11));

      {
        const char *fixptFields[] = { "isSigned", "wordLength", "bias", "slope",
          "exponent" };

        mxArray *mxFixpt = mxCreateStructMatrix(1,1,5,fixptFields);
        mxSetField(mxFixpt,0,"isSigned",mxCreateDoubleScalar(1));
        mxSetField(mxFixpt,0,"wordLength",mxCreateDoubleScalar(16));
        mxSetField(mxFixpt,0,"bias",mxCreateDoubleScalar(0));
        mxSetField(mxFixpt,0,"slope",mxCreateDoubleScalar(1));
        mxSetField(mxFixpt,0,"exponent",mxCreateDoubleScalar(-11));
        mxSetField(mxType,0,"fixpt",mxFixpt);
      }

      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,1,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(11));

      {
        const char *fixptFields[] = { "isSigned", "wordLength", "bias", "slope",
          "exponent" };

        mxArray *mxFixpt = mxCreateStructMatrix(1,1,5,fixptFields);
        mxSetField(mxFixpt,0,"isSigned",mxCreateDoubleScalar(1));
        mxSetField(mxFixpt,0,"wordLength",mxCreateDoubleScalar(32));
        mxSetField(mxFixpt,0,"bias",mxCreateDoubleScalar(0));
        mxSetField(mxFixpt,0,"slope",mxCreateDoubleScalar(1));
        mxSetField(mxFixpt,0,"exponent",mxCreateDoubleScalar(-38));
        mxSetField(mxType,0,"fixpt",mxFixpt);
      }

      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  return(mxAutoinheritanceInfo);
}

static mxArray *sf_get_sim_state_info_c2_Terje1(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x2'type','srcId','name','auxInfo'{{M[1],M[5],T\"y\",},{M[8],M[0],T\"is_active_c2_Terje1\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 2, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c2_Terje1_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc2_Terje1InstanceStruct *chartInstance;
    chartInstance = (SFc2_Terje1InstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart(_Terje1MachineNumber_,
          2,
          1,
          1,
          3,
          0,
          0,
          0,
          0,
          1,
          &(chartInstance->chartNumber),
          &(chartInstance->instanceNumber),
          ssGetPath(S),
          (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_Terje1MachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting(_Terje1MachineNumber_,
            chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(_Terje1MachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);

          {
            unsigned int dimVector[1];
            dimVector[0]= 6;
            _SFD_SET_DATA_PROPS(0,1,1,0,SF_INT16,1,&(dimVector[0]),1,1,16,0,1,
                                -11,"u1",0,(MexFcnForType)c2_f_sf_marshall);
          }

          _SFD_SET_DATA_PROPS(1,2,0,1,SF_INT32,0,NULL,1,1,32,0,1,-38,"y",0,
                              (MexFcnForType)c2_sf_marshall);

          {
            unsigned int dimVector[1];
            dimVector[0]= 6;
            _SFD_SET_DATA_PROPS(2,1,1,0,SF_INT16,1,&(dimVector[0]),1,1,16,0,1,
                                -11,"u2",0,(MexFcnForType)c2_b_sf_marshall);
          }

          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of EML Model Coverage */
        _SFD_CV_INIT_EML(0,1,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,138);
        _SFD_CV_INIT_SCRIPT(0,1,0,0,0,0,0,0,0);
        _SFD_CV_INIT_SCRIPT_FCN(0,0,"Sampling_error",6,-1,274);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        {
          int16_T (*c2_u1)[6];
          int32_T *c2_y;
          int16_T (*c2_u2)[6];
          c2_u2 = (int16_T (*)[6])ssGetInputPortSignal(chartInstance->S, 1);
          c2_y = (int32_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c2_u1 = (int16_T (*)[6])ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c2_u1);
          _SFD_SET_DATA_VALUE_PTR(1U, c2_y);
          _SFD_SET_DATA_VALUE_PTR(2U, c2_u2);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(_Terje1MachineNumber_,
        chartInstance->chartNumber,chartInstance->instanceNumber);
    }
  }
}

static void sf_opaque_initialize_c2_Terje1(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc2_Terje1InstanceStruct*) chartInstanceVar)->S,
    0);
  initialize_params_c2_Terje1((SFc2_Terje1InstanceStruct*) chartInstanceVar);
  initialize_c2_Terje1((SFc2_Terje1InstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c2_Terje1(void *chartInstanceVar)
{
  enable_c2_Terje1((SFc2_Terje1InstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c2_Terje1(void *chartInstanceVar)
{
  disable_c2_Terje1((SFc2_Terje1InstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c2_Terje1(void *chartInstanceVar)
{
  sf_c2_Terje1((SFc2_Terje1InstanceStruct*) chartInstanceVar);
}

static mxArray* sf_internal_get_sim_state_c2_Terje1(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c2_Terje1((SFc2_Terje1InstanceStruct*)
    chartInfo->chartInstance);         /* raw sim ctx */
  prhs[3] = sf_get_sim_state_info_c2_Terje1();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

static void sf_internal_set_sim_state_c2_Terje1(SimStruct* S, const mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_Terje1();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c2_Terje1((SFc2_Terje1InstanceStruct*)chartInfo->chartInstance,
    mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static mxArray* sf_opaque_get_sim_state_c2_Terje1(SimStruct* S)
{
  return sf_internal_get_sim_state_c2_Terje1(S);
}

static void sf_opaque_set_sim_state_c2_Terje1(SimStruct* S, const mxArray *st)
{
  sf_internal_set_sim_state_c2_Terje1(S, st);
}

static void sf_opaque_terminate_c2_Terje1(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc2_Terje1InstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
    }

    finalize_c2_Terje1((SFc2_Terje1InstanceStruct*) chartInstanceVar);
    free((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c2_Terje1(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c2_Terje1((SFc2_Terje1InstanceStruct*)(((ChartInfoStruct *)
      ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c2_Terje1(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable("Terje1","Terje1",2);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop("Terje1","Terje1",2,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop("Terje1","Terje1",2,
      "gatewayCannotBeInlinedMultipleTimes"));
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,"Terje1","Terje1",2,2);
      sf_mark_chart_reusable_outputs(S,"Terje1","Terje1",2,1);
    }

    sf_set_rtw_dwork_info(S,"Terje1","Terje1",2);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
    ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  }

  ssSetChecksum0(S,(2782965349U));
  ssSetChecksum1(S,(1688691904U));
  ssSetChecksum2(S,(3145369257U));
  ssSetChecksum3(S,(2657997113U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
}

static void mdlRTW_c2_Terje1(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    sf_write_symbol_mapping(S, "Terje1", "Terje1",2);
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c2_Terje1(SimStruct *S)
{
  SFc2_Terje1InstanceStruct *chartInstance;
  chartInstance = (SFc2_Terje1InstanceStruct *)malloc(sizeof
    (SFc2_Terje1InstanceStruct));
  memset(chartInstance, 0, sizeof(SFc2_Terje1InstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c2_Terje1;
  chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c2_Terje1;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c2_Terje1;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c2_Terje1;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c2_Terje1;
  chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c2_Terje1;
  chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c2_Terje1;
  chartInstance->chartInfo.getSimStateInfo = sf_get_sim_state_info_c2_Terje1;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c2_Terje1;
  chartInstance->chartInfo.mdlStart = mdlStart_c2_Terje1;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c2_Terje1;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  if (!sim_mode_is_rtw_gen(S)) {
    init_dsm_address_info(chartInstance);
  }

  chart_debug_initialization(S,1);
}

void c2_Terje1_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c2_Terje1(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c2_Terje1(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c2_Terje1(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c2_Terje1_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}

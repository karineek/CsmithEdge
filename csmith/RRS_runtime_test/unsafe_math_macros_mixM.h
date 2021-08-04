
#ifndef UNSAFE_MATH_MIX_H
#define UNSAFE_MATH_MIX_H





//STATIC int8_t
#define safe_unary_minus_func_int8_t_s_unsafe_macro_mixM(si) \
    (int8_t) (- (int8_t) si)

//STATIC int8_t
#define safe_add_func_int8_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int8_t) ((int8_t) si1 + (int8_t) si2)

//STATIC int8_t
#define safe_sub_func_int8_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int8_t) ((int8_t) si1 - (int8_t) si2)

//STATIC int8_t
#define safe_mul_func_int8_t_s_s_unsafe_macro_mixM(si1, si2) \
    ((int8_t) ((int8_t) si1 * (int8_t) si2))

//STATIC int8_t
#define safe_mod_func_int8_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int8_t) ((int8_t) si1 % (int8_t) si2)

//STATIC int8_t
#define safe_div_func_int8_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int8_t) ((int8_t) si1 / (int8_t) si2)

//STATIC int8_t
#define safe_lshift_func_int8_t_s_s_unsafe_macro_mixM(left, right) \
    (int8_t) ((int8_t) left << ((int) right))

//STATIC int8_t
#define safe_lshift_func_int8_t_s_u_unsafe_macro_mixM(left, right) \
    (int8_t) ((int8_t) left << ((unsigned int) right))

//STATIC int8_t
#define safe_rshift_func_int8_t_s_s_unsafe_macro_mixM(left, right) \
    (int8_t) ((int8_t) left >> ((int) right))

//STATIC int8_t
#define safe_rshift_func_int8_t_s_u_unsafe_macro_mixM(left, right) \
    (int8_t) ((int8_t) left >> ((unsigned int) right))

//STATIC int16_t
#define safe_unary_minus_func_int16_t_s_unsafe_macro_mixM(si) \
    (int16_t) (- (int16_t) si)

//STATIC int16_t
#define safe_add_func_int16_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int16_t) ((int16_t) si1 + (int16_t) si2)

//STATIC int16_t
#define safe_sub_func_int16_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int16_t) ((int16_t) si1 - (int16_t) si2)

//STATIC int16_t
#define safe_mul_func_int16_t_s_s_unsafe_macro_mixM(si1, si2) \
    ((int16_t) ((int16_t) si1 * (int16_t) si2))

//STATIC int16_t
#define safe_mod_func_int16_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int16_t) ((int16_t) si1 % (int16_t) si2)

//STATIC int16_t
#define safe_div_func_int16_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int16_t) ((int16_t) si1 / (int16_t) si2)

//STATIC int16_t
#define safe_lshift_func_int16_t_s_s_unsafe_macro_mixM(left, right) \
    (int16_t) ((int16_t) left << ((int) right))

//STATIC int16_t
#define safe_lshift_func_int16_t_s_u_unsafe_macro_mixM(left, right) \
    (int16_t) ((int16_t) left << ((unsigned int) right))

//STATIC int16_t
#define safe_rshift_func_int16_t_s_s_unsafe_macro_mixM(left, right) \
    (int16_t) ((int16_t) left >> ((int) right))

//STATIC int16_t
#define safe_rshift_func_int16_t_s_u_unsafe_macro_mixM(left, right) \
    (int16_t) ((int16_t) left >> ((unsigned int) right))

//STATIC int32_t
#define safe_unary_minus_func_int32_t_s_unsafe_macro_mixM(si) \
    (int32_t) (- (int32_t) si)

//STATIC int32_t
#define safe_add_func_int32_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int32_t) ((int32_t) si1 + (int32_t) si2)

//STATIC int32_t
#define safe_sub_func_int32_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int32_t) ((int32_t) si1 - (int32_t) si2)

//STATIC int32_t
#define safe_mul_func_int32_t_s_s_unsafe_macro_mixM(si1, si2) \
    ((int32_t) ((int32_t) si1 * (int32_t) si2))

//STATIC int32_t
#define safe_mod_func_int32_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int32_t) ((int32_t) si1 % (int32_t) si2)

//STATIC int32_t
#define safe_div_func_int32_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int32_t) ((int32_t) si1 / (int32_t) si2)

//STATIC int32_t
#define safe_lshift_func_int32_t_s_s_unsafe_macro_mixM(left, right) \
    (int32_t) ((int32_t) left << ((int) right))

//STATIC int32_t
#define safe_lshift_func_int32_t_s_u_unsafe_macro_mixM(left, right) \
    (int32_t) ((int32_t) left << ((unsigned int) right))

//STATIC int32_t
#define safe_rshift_func_int32_t_s_s_unsafe_macro_mixM(left, right) \
    (int32_t) ((int32_t) left >> ((int) right))

//STATIC int32_t
#define safe_rshift_func_int32_t_s_u_unsafe_macro_mixM(left, right) \
    (int32_t) ((int32_t) left >> ((unsigned int) right))

#ifndef NO_LONGLONG

//STATIC int64_t
#define safe_unary_minus_func_int64_t_s_unsafe_macro_mixM(si) \
    (int64_t) (- (int64_t) si)

//STATIC int64_t
#define safe_add_func_int64_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int64_t) ((int64_t) si1 + (int64_t) si2)

//STATIC int64_t
#define safe_sub_func_int64_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int64_t) ((int64_t) si1 - (int64_t) si2)

//STATIC int64_t
#define safe_mul_func_int64_t_s_s_unsafe_macro_mixM(si1, si2) \
    ((int64_t) ((int64_t) si1 * (int64_t) si2))

//STATIC int64_t
#define safe_mod_func_int64_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int64_t) ((int64_t) si1 % (int64_t) si2)

//STATIC int64_t
#define safe_div_func_int64_t_s_s_unsafe_macro_mixM(si1, si2) \
    (int64_t) ((int64_t) si1 / (int64_t) si2)

//STATIC int64_t
#define safe_lshift_func_int64_t_s_s_unsafe_macro_mixM(left, right) \
    (int64_t) ((int64_t) left << ((int) right))

//STATIC int64_t
#define safe_lshift_func_int64_t_s_u_unsafe_macro_mixM(left, right) \
    (int64_t) ((int64_t) left << ((unsigned int) right))

//STATIC int64_t
#define safe_rshift_func_int64_t_s_s_unsafe_macro_mixM(left, right) \
    (int64_t) ((int64_t) left >> ((int) right))

//STATIC int64_t
#define safe_rshift_func_int64_t_s_u_unsafe_macro_mixM(left, right) \
    (int64_t) ((int64_t) left >> ((unsigned int) right))

#endif





//STATIC uint8_t
#define safe_unary_minus_func_uint8_t_u_unsafe_macro_mixM(ui) \
    (uint8_t) (- (uint8_t) ui)

//STATIC uint8_t
#define safe_add_func_uint8_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint8_t) ((uint8_t) ui1 + (uint8_t) ui2)

//STATIC uint8_t
#define safe_sub_func_uint8_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint8_t) ((uint8_t) ui1 - (uint8_t) ui2)

//STATIC uint8_t
#define safe_mul_func_uint8_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    ((uint8_t) (((unsigned int)(uint8_t) ui1) * ((unsigned int)(uint8_t) ui2)))

//STATIC uint8_t
#define safe_mod_func_uint8_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint8_t) ((uint8_t) ui1 % (uint8_t) ui2)

//STATIC uint8_t
#define safe_div_func_uint8_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint8_t) ((uint8_t) ui1 / (uint8_t) ui2)

//STATIC uint8_t
#define safe_lshift_func_uint8_t_u_s_unsafe_macro_mixM(left, right) \
    (uint8_t) ((uint8_t) left << ((int) right))

//STATIC uint8_t
#define safe_lshift_func_uint8_t_u_u_unsafe_macro_mixM(left, right) \
    (uint8_t) ((uint8_t) left << ((unsigned int) right))

//STATIC uint8_t
#define safe_rshift_func_uint8_t_u_s_unsafe_macro_mixM(left, right) \
    (uint8_t) ((uint8_t) left >> ((int) right))

//STATIC uint8_t
#define safe_rshift_func_uint8_t_u_u_unsafe_macro_mixM(left, right) \
    (uint8_t) ((uint8_t) left >> ((unsigned int) right))



//STATIC uint16_t
#define safe_unary_minus_func_uint16_t_u_unsafe_macro_mixM(ui) \
    (uint16_t) (- (uint16_t) ui)

//STATIC uint16_t
#define safe_add_func_uint16_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint16_t) ((uint16_t) ui1 + (uint16_t) ui2)

//STATIC uint16_t
#define safe_sub_func_uint16_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint16_t) ((uint16_t) ui1 - (uint16_t) ui2)

//STATIC uint16_t
#define safe_mul_func_uint16_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    ((uint16_t) (((unsigned int)(uint16_t) ui1) * ((unsigned int)(uint16_t) ui2)))

//STATIC uint16_t
#define safe_mod_func_uint16_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint16_t) ((uint16_t) ui1 % (uint16_t) ui2)

//STATIC uint16_t
#define safe_div_func_uint16_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint16_t) ((uint16_t) ui1 / (uint16_t) ui2)

//STATIC uint16_t
#define safe_lshift_func_uint16_t_u_s_unsafe_macro_mixM(left, right) \
    (uint16_t) ((uint16_t) left << ((int) right))

//STATIC uint16_t
#define safe_lshift_func_uint16_t_u_u_unsafe_macro_mixM(left, right) \
    (uint16_t) ((uint16_t) left << ((unsigned int) right))

//STATIC uint16_t
#define safe_rshift_func_uint16_t_u_s_unsafe_macro_mixM(left, right) \
    (uint16_t) ((uint16_t) left >> ((int) right))

//STATIC uint16_t
#define safe_rshift_func_uint16_t_u_u_unsafe_macro_mixM(left, right) \
    (uint16_t) ((uint16_t) left >> ((unsigned int) right))



//STATIC uint32_t
#define safe_unary_minus_func_uint32_t_u_unsafe_macro_mixM(ui) \
    (uint32_t) (- (uint32_t) ui)

//STATIC uint32_t
#define safe_add_func_uint32_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint32_t) ((uint32_t) ui1 + (uint32_t) ui2)

//STATIC uint32_t
#define safe_sub_func_uint32_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint32_t) ((uint32_t) ui1 - (uint32_t) ui2)

//STATIC uint32_t
#define safe_mul_func_uint32_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    ((uint32_t) (((unsigned int)(uint32_t) ui1) * ((unsigned int)(uint32_t) ui2)))

//STATIC uint32_t
#define safe_mod_func_uint32_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint32_t) (((uint32_t) ui1 % (uint32_t) ui2))

//STATIC uint32_t
#define safe_div_func_uint32_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint32_t) ((uint32_t) ui1 / (uint32_t) ui2)

//STATIC uint32_t
#define safe_lshift_func_uint32_t_u_s_unsafe_macro_mixM(left, right) \
    (uint32_t) ((uint32_t) left << ((int) right))

//STATIC uint32_t
#define safe_lshift_func_uint32_t_u_u_unsafe_macro_mixM(left, right) \
    (uint32_t) ((uint32_t) left << ((unsigned int) right))

//STATIC uint32_t
#define safe_rshift_func_uint32_t_u_s_unsafe_macro_mixM(left, right) \
    (uint32_t) ((uint32_t) left >> ((int) right))

//STATIC uint32_t
#define safe_rshift_func_uint32_t_u_u_unsafe_macro_mixM(left, right) \
    (uint32_t) ((uint32_t) left >> ((unsigned int) right))

#ifndef NO_LONGLONG

//STATIC uint64_t
#define safe_unary_minus_func_uint64_t_u_unsafe_macro_mixM(ui) \
    (uint64_t) (- (uint64_t) ui)

//STATIC uint64_t
#define safe_add_func_uint64_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint64_t) ((uint64_t) ui1 + (uint64_t) ui2)

//STATIC uint64_t
#define safe_sub_func_uint64_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint64_t) ((uint64_t) ui1 - (uint64_t) ui2)

//STATIC uint64_t
#define safe_mul_func_uint64_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    ((uint64_t) (((unsigned long long)(uint64_t) ui1) * ((unsigned long long)(uint64_t) ui2)))

//STATIC uint64_t
#define safe_mod_func_uint64_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint64_t) ((uint64_t) ui1 % (uint64_t) ui2)

//STATIC uint64_t
#define safe_div_func_uint64_t_u_u_unsafe_macro_mixM(ui1, ui2) \
    (uint64_t) ((uint64_t) ui1 / (uint64_t) ui2)

//STATIC uint64_t
#define safe_lshift_func_uint64_t_u_s_unsafe_macro_mixM(left, right) \
    (uint64_t) ((uint64_t) left << ((int) right))

//STATIC uint64_t
#define safe_lshift_func_uint64_t_u_u_unsafe_macro_mixM(left, right) \
    (uint64_t) ((uint64_t) left << ((unsigned int) right))

//STATIC uint64_t
#define safe_rshift_func_uint64_t_u_s_unsafe_macro_mixM(left, right) \
    (uint64_t) ((uint64_t) left >> ((int) right))


//STATIC uint64_t
#define safe_rshift_func_uint64_t_u_u_unsafe_macro_mixM(left, right) \
    (uint64_t) ((uint64_t) left >> ((unsigned int) right))

#endif



#ifdef __STDC__


//STATIC float
#define safe_add_func_float_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((float) sf1 + (float) sf2)

//STATIC float
#define safe_sub_func_float_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((float) sf1 - (float) sf2)

//STATIC float
#define safe_mul_func_float_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((float) sf1 * (float) sf2)

//STATIC float
#define safe_div_func_float_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((float) sf1 / (float) sf2)



//STATIC double
#define safe_add_func_double_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((double) sf1 + (double) sf2)

//STATIC double
#define safe_sub_func_double_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((double) sf1 - (double) sf2)

//STATIC double
#define safe_mul_func_double_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((double) sf1 * (double) sf2)

//STATIC double
#define safe_div_func_double_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((double) sf1 / (double) sf2)


#else


//STATIC float
#define safe_add_func_float_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((float) sf1 + (float) sf2)

//STATIC float
#define safe_sub_func_float_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((float) sf1 - (float) sf2)

//STATIC float
#define safe_mul_func_float_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((float) sf1 * (float) sf2)

//STATIC float
#define safe_div_func_float_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((float) sf1 / (float) sf2)



//STATIC double
#define safe_add_func_double_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((double) sf1 + (double) sf2)

//STATIC double
#define safe_sub_func_double_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((double) sf1 - (double) sf2)

//STATIC double
#define safe_mul_func_double_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((double) sf1 * (double) sf2)

//STATIC double
#define safe_div_func_double_f_f_unsafe_macro_mixM(sf1, sf2) \
    ((double) sf1 / (double) sf2)


#endif



//STATIC int32_t
#define safe_convert_func_float_to_int32_t_unsafe_macro_mixM(sf1) \
    ((int32_t)(sf1))



#endif

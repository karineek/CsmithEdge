
#ifndef UNSAFE_MATH_H
#define UNSAFE_MATH_H









static signed char
safe_unary_minus_func_int8_t_s_unsafe_macro(signed char si )
{
 
  return






    -si;
}

static signed char
safe_add_func_int8_t_s_s_unsafe_macro(signed char si1, signed char si2 )
{
 
  return






    (si1 + si2);
}

static signed char
safe_sub_func_int8_t_s_s_unsafe_macro(signed char si1, signed char si2 )
{
 
  return






    (si1 - si2);
}

static signed char
safe_mul_func_int8_t_s_s_unsafe_macro(signed char si1, signed char si2 )
{
 
  return






    si1 * si2;
}

static signed char
safe_mod_func_int8_t_s_s_unsafe_macro(signed char si1, signed char si2 )
{
 
  return




    (si1 % si2);
}

static signed char
safe_div_func_int8_t_s_s_unsafe_macro(signed char si1, signed char si2 )
{
 
  return




    (si1 / si2);
}

static signed char
safe_lshift_func_int8_t_s_s_unsafe_macro(signed char left, int right )
{
 
  return




    (left << ((int)right));
}

static signed char
safe_lshift_func_int8_t_s_u_unsafe_macro(signed char left, unsigned int right )
{
 
  return




    (left << ((unsigned int)right));
}

static signed char
safe_rshift_func_int8_t_s_s_unsafe_macro(signed char left, int right )
{
 
  return




    (left >> ((int)right));
}

static signed char
safe_rshift_func_int8_t_s_u_unsafe_macro(signed char left, unsigned int right )
{
 
  return




    (left >> ((unsigned int)right));
}



static short
safe_unary_minus_func_int16_t_s_unsafe_macro(short si )
{
 
  return






    -si;
}

static short
safe_add_func_int16_t_s_s_unsafe_macro(short si1, short si2 )
{
 
  return






    (si1 + si2);
}

static short
safe_sub_func_int16_t_s_s_unsafe_macro(short si1, short si2 )
{
 
  return






    (si1 - si2);
}

static short
safe_mul_func_int16_t_s_s_unsafe_macro(short si1, short si2 )
{
 
  return






    si1 * si2;
}

static short
safe_mod_func_int16_t_s_s_unsafe_macro(short si1, short si2 )
{
 
  return




    (si1 % si2);
}

static short
safe_div_func_int16_t_s_s_unsafe_macro(short si1, short si2 )
{
 
  return




    (si1 / si2);
}

static short
safe_lshift_func_int16_t_s_s_unsafe_macro(short left, int right )
{
 
  return




    (left << ((int)right));
}

static short
safe_lshift_func_int16_t_s_u_unsafe_macro(short left, unsigned int right )
{
 
  return




    (left << ((unsigned int)right));
}

static short
safe_rshift_func_int16_t_s_s_unsafe_macro(short left, int right )
{
 
  return




    (left >> ((int)right));
}

static short
safe_rshift_func_int16_t_s_u_unsafe_macro(short left, unsigned int right )
{
 
  return




    (left >> ((unsigned int)right));
}



static int
safe_unary_minus_func_int32_t_s_unsafe_macro(int si )
{
 
  return






    -si;
}

static int
safe_add_func_int32_t_s_s_unsafe_macro(int si1, int si2 )
{
 
  return






    (si1 + si2);
}

static int
safe_sub_func_int32_t_s_s_unsafe_macro(int si1, int si2 )
{
 
  return
    (si1 - si2);
}

static int
safe_mul_func_int32_t_s_s_unsafe_macro(int si1, int si2 )
{
 
  return
    si1 * si2;
}

static int
safe_mod_func_int32_t_s_s_unsafe_macro(int si1, int si2 )
{
 
  return
    (si1 % si2);
}

static int
safe_div_func_int32_t_s_s_unsafe_macro(int si1, int si2 )
{
 
  return
    (si1 / si2);
}

static int
safe_lshift_func_int32_t_s_s_unsafe_macro(int left, int right )
{
 
  return
    (left << ((int)right));
}

static int
safe_lshift_func_int32_t_s_u_unsafe_macro(int left, unsigned int right )
{
 
  return
    (left << ((unsigned int)right));
}

static int
safe_rshift_func_int32_t_s_s_unsafe_macro(int left, int right )
{
 
  return
    (left >> ((int)right));
}

static int
safe_rshift_func_int32_t_s_u_unsafe_macro(int left, unsigned int right )
{
 
  return
    (left >> ((unsigned int)right));
}


#ifndef NO_LONGLONG

static long long
safe_unary_minus_func_int64_t_s_unsafe_macro(long long si )
{
 
  return
    -si;
}

static long long
safe_add_func_int64_t_s_s_unsafe_macro(long long si1, long long si2 )
{
 
  return
    (si1 + si2);
}

static long long
safe_sub_func_int64_t_s_s_unsafe_macro(long long si1, long long si2 )
{
 
  return
    (si1 - si2);
}

static long long
safe_mul_func_int64_t_s_s_unsafe_macro(long long si1, long long si2 )
{
 
  return
    si1 * si2;
}

static long long
safe_mod_func_int64_t_s_s_unsafe_macro(long long si1, long long si2 )
{
 
  return
    (si1 % si2);
}

static long long
safe_div_func_int64_t_s_s_unsafe_macro(long long si1, long long si2 )
{
 
  return
    (si1 / si2);
}

static long long
safe_lshift_func_int64_t_s_s_unsafe_macro(long long left, int right )
{
 
  return
    (left << ((int)right));
}

static long long
safe_lshift_func_int64_t_s_u_unsafe_macro(long long left, unsigned int right )
{
 
  return
    (left << ((unsigned int)right));
}

static long long
safe_rshift_func_int64_t_s_s_unsafe_macro(long long left, int right )
{
 
  return
    (left >> ((int)right));
}

static long long
safe_rshift_func_int64_t_s_u_unsafe_macro(long long left, unsigned int right )
{
 
  return
    (left >> ((unsigned int)right));
}

#endif





static unsigned char
safe_unary_minus_func_uint8_t_u_unsafe_macro(unsigned char ui )
{
 
  return -ui;
}

static unsigned char
safe_add_func_uint8_t_u_u_unsafe_macro(unsigned char ui1, unsigned char ui2 )
{
 
  return ui1 + ui2;
}

static unsigned char
safe_sub_func_uint8_t_u_u_unsafe_macro(unsigned char ui1, unsigned char ui2 )
{
 
  return ui1 - ui2;
}

static unsigned char
safe_mul_func_uint8_t_u_u_unsafe_macro(unsigned char ui1, unsigned char ui2 )
{
 
  return ((unsigned int)ui1) * ((unsigned int)ui2);
}

static unsigned char
safe_mod_func_uint8_t_u_u_unsafe_macro(unsigned char ui1, unsigned char ui2 )
{
 
  return
    (ui1 % ui2);
}

static unsigned char
safe_div_func_uint8_t_u_u_unsafe_macro(unsigned char ui1, unsigned char ui2 )
{
 
  return
    (ui1 / ui2);
}

static unsigned char
safe_lshift_func_uint8_t_u_s_unsafe_macro(unsigned char left, int right )
{
 
  return
    (left << ((int)right));
}

static unsigned char
safe_lshift_func_uint8_t_u_u_unsafe_macro(unsigned char left, unsigned int right )
{
 
  return
    (left << ((unsigned int)right));
}

static unsigned char
safe_rshift_func_uint8_t_u_s_unsafe_macro(unsigned char left, int right )
{
 
  return
    (left >> ((int)right));
}

static unsigned char
safe_rshift_func_uint8_t_u_u_unsafe_macro(unsigned char left, unsigned int right )
{
 
  return
    (left >> ((unsigned int)right));
}



static unsigned short
safe_unary_minus_func_uint16_t_u_unsafe_macro(unsigned short ui )
{
 
  return -ui;
}

static unsigned short
safe_add_func_uint16_t_u_u_unsafe_macro(unsigned short ui1, unsigned short ui2 )
{
 
  return ui1 + ui2;
}

static unsigned short
safe_sub_func_uint16_t_u_u_unsafe_macro(unsigned short ui1, unsigned short ui2 )
{
 
  return ui1 - ui2;
}

static unsigned short
safe_mul_func_uint16_t_u_u_unsafe_macro(unsigned short ui1, unsigned short ui2 )
{
 
  return ((unsigned int)ui1) * ((unsigned int)ui2);
}

static unsigned short
safe_mod_func_uint16_t_u_u_unsafe_macro(unsigned short ui1, unsigned short ui2 )
{
 
  return
    (ui1 % ui2);
}

static unsigned short
safe_div_func_uint16_t_u_u_unsafe_macro(unsigned short ui1, unsigned short ui2 )
{
 
  return
    (ui1 / ui2);
}

static unsigned short
safe_lshift_func_uint16_t_u_s_unsafe_macro(unsigned short left, int right )
{
 
  return
    (left << ((int)right));
}

static unsigned short
safe_lshift_func_uint16_t_u_u_unsafe_macro(unsigned short left, unsigned int right )
{
 
  return
    (left << ((unsigned int)right));
}

static unsigned short
safe_rshift_func_uint16_t_u_s_unsafe_macro(unsigned short left, int right )
{
 
  return
    (left >> ((int)right));
}

static unsigned short
safe_rshift_func_uint16_t_u_u_unsafe_macro(unsigned short left, unsigned int right )
{
 
  return
    (left >> ((unsigned int)right));
}



static unsigned
safe_unary_minus_func_uint32_t_u_unsafe_macro(unsigned ui )
{
 
  return -ui;
}

static unsigned
safe_add_func_uint32_t_u_u_unsafe_macro(unsigned ui1, unsigned ui2 )
{
 
  return ui1 + ui2;
}

static unsigned
safe_sub_func_uint32_t_u_u_unsafe_macro(unsigned ui1, unsigned ui2 )
{
 
  return ui1 - ui2;
}

static unsigned
safe_mul_func_uint32_t_u_u_unsafe_macro(unsigned ui1, unsigned ui2 )
{
 
  return ((unsigned int)ui1) * ((unsigned int)ui2);
}

static unsigned
safe_mod_func_uint32_t_u_u_unsafe_macro(unsigned ui1, unsigned ui2 )
{
 
  return
    (ui1 % ui2);
}

static unsigned
safe_div_func_uint32_t_u_u_unsafe_macro(unsigned ui1, unsigned ui2 )
{
 
  return
    (ui1 / ui2);
}

static unsigned
safe_lshift_func_uint32_t_u_s_unsafe_macro(unsigned left, int right )
{
 
  return
    (left << ((int)right));
}

static unsigned
safe_lshift_func_uint32_t_u_u_unsafe_macro(unsigned left, unsigned int right )
{
 
  return
    (left << ((unsigned int)right));
}

static unsigned
safe_rshift_func_uint32_t_u_s_unsafe_macro(unsigned left, int right )
{
 
  return
    (left >> ((int)right));
}

static unsigned
safe_rshift_func_uint32_t_u_u_unsafe_macro(unsigned left, unsigned int right )
{
  return
    (left >> ((unsigned int)right));
}


#ifndef NO_LONGLONG

static unsigned long long
safe_unary_minus_func_uint64_t_u_unsafe_macro(unsigned long long ui )
{
  return -ui;
}

static unsigned long long
safe_add_func_uint64_t_u_u_unsafe_macro(unsigned long long ui1, unsigned long long ui2 )
{
  return ui1 + ui2;
}

static unsigned long long
safe_sub_func_uint64_t_u_u_unsafe_macro(unsigned long long ui1, unsigned long long ui2 )
{
  return ui1 - ui2;
}

static unsigned long long
safe_mul_func_uint64_t_u_u_unsafe_macro(unsigned long long ui1, unsigned long long ui2 )
{
  return ((unsigned long long)ui1) * ((unsigned long long)ui2);
}

static unsigned long long
safe_mod_func_uint64_t_u_u_unsafe_macro(unsigned long long ui1, unsigned long long ui2 )
{
 
  return
    (ui1 % ui2);
}

static unsigned long long
safe_div_func_uint64_t_u_u_unsafe_macro(unsigned long long ui1, unsigned long long ui2 )
{
 
  return
    (ui1 / ui2);
}

static unsigned long long
safe_lshift_func_uint64_t_u_s_unsafe_macro(unsigned long long left, int right )
{
 
  return
    (left << ((int)right));
}

static unsigned long long
safe_lshift_func_uint64_t_u_u_unsafe_macro(unsigned long long left, unsigned int right )
{
 
  return
    (left << ((unsigned int)right));
}

static unsigned long long
safe_rshift_func_uint64_t_u_s_unsafe_macro(unsigned long long left, int right )
{
 
  return
    (left >> ((int)right));
}

static unsigned long long
safe_rshift_func_uint64_t_u_u_unsafe_macro(unsigned long long left, unsigned int right )
{
 
  return
    (left >> ((unsigned int)right));
}
#endif


static float
safe_add_func_float_f_f_unsafe_macro(float sf1, float sf2 )
{
 
  return
    (sf1 + sf2);
}

static float
safe_sub_func_float_f_f_unsafe_macro(float sf1, float sf2 )
{
 
  return
    (sf1 - sf2);
}

static float
safe_mul_func_float_f_f_unsafe_macro(float sf1, float sf2 )
{
 
  return
    (sf1 * sf2);
}

static float
safe_div_func_float_f_f_unsafe_macro(float sf1, float sf2 )
{
 
  return
    (sf1 / sf2);
}




static double
safe_add_func_double_f_f_unsafe_macro(double sf1, double sf2 )
{
 
  return
    (sf1 + sf2);
}

static double
safe_sub_func_double_f_f_unsafe_macro(double sf1, double sf2 )
{
 
  return
    (sf1 - sf2);
}

static double
safe_mul_func_double_f_f_unsafe_macro(double sf1, double sf2 )
{
 
  return
    (sf1 * sf2);
}

static double
safe_div_func_double_f_f_unsafe_macro(double sf1, double sf2 )
{
 
  return
    (sf1 / sf2);
}

static int
safe_convert_func_float_to_int32_t_unsafe_macro(float sf1 )
{
 
  return
    ((int)(sf1));
}

#endif

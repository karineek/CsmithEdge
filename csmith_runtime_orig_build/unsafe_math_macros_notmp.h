
#ifndef UNSAFE_MATH_H
#define UNSAFE_MATH_H





#define safe_unary_minus_func_int8_t_s_unsafe_macro(si,_si) \
  ((int8_t)( si = (_si), \
    (-((int8_t)(si))) \
  ))

#define safe_add_func_int8_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
		((int8_t)( si1 = (_si1), si2 = (_si2) , \
		 (((int8_t)(si1)) + ((int8_t)(si2)))				\
		)) 

#define safe_sub_func_int8_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
		((int8_t)( si1 = (_si1), si2 = (_si2) , \
		(((int8_t)(si1)) - ((int8_t)(si2))) \
		))

#define safe_mul_func_int8_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int8_t)( si1 = (_si1), si2 = (_si2) , \
   ((int8_t)(si1)) * ((int8_t)(si2))))

#define safe_mod_func_int8_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int8_t)( si1 = (_si1), si2 = (_si2) , \
   (((int8_t)(si1)) % ((int8_t)(si2)))))

#define safe_div_func_int8_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int8_t)( si1 = (_si1), si2 = (_si2) , \
   (((int8_t)(si1)) / ((int8_t)(si2)))))

#define c99_strict_safe_lshift_func_int8_t_s_s_unsafe_macro(left,_left,right,_right) \
  ((int8_t)( left = (_left), right = (_right) , \
   (((int8_t)(left)) << ((int)(right)))))

#define safe_lshift_func_int8_t_s_s_unsafe_macro(left,_left,right,_right) \
  ((int8_t)( left = (_left), right = (_right) , \
   (((int8_t)(left)) << ((int)(right)))))

#define c99_strict_safe_lshift_func_int8_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int8_t)( left = (_left), right = (_right) , \
   (((int8_t)(left)) << ((unsigned int)(right)))))

#define safe_lshift_func_int8_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int8_t)( left = (_left), right = (_right) , \
   (((int8_t)(left)) << ((unsigned int)(right)))))

#define c99_strict_safe_rshift_func_int8_t_s_s_unsafe_macro(left,_left,right,_right) \
	((int8_t)( left = (_left), right = (_right) , \
			 (((int8_t)(left)) >> ((int)(right)))))

#define c99_strict_safe_rshift_func_int8_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int8_t)( left = (_left), right = (_right) , \
			 (((int8_t)(left)) >> ((unsigned int)(right)))))

#define safe_rshift_func_int8_t_s_s_unsafe_macro(left,_left,right,_right) \
	((int8_t)( left = (_left), right = (_right) , \
			 (((int8_t)(left)) >> ((int)(right)))))

#define safe_rshift_func_int8_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int8_t)( left = (_left), right = (_right) , \
	 (((int8_t)(left)) >> ((unsigned int)(right)))))



#define safe_unary_minus_func_int16_t_s_unsafe_macro(si,_si) \
  ((int16_t)( si = (_si), \
    (-((int16_t)(si))) \
  ))

#define safe_add_func_int16_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
		((int16_t)( si1 = (_si1), si2 = (_si2) , \
		 (((int16_t)(si1)) + ((int16_t)(si2)))				\
		)) 

#define safe_sub_func_int16_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
		((int16_t)( si1 = (_si1), si2 = (_si2) , \
		 (((int16_t)(si1)) - ((int16_t)(si2))) \
		))

#define safe_mul_func_int16_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int16_t)( si1 = (_si1), si2 = (_si2) , \
   ((int16_t)(si1)) * ((int16_t)(si2))))

#define safe_mod_func_int16_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int16_t)( si1 = (_si1), si2 = (_si2) , \
   (((int16_t)(si1)) % ((int16_t)(si2)))))

#define safe_div_func_int16_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int16_t)( si1 = (_si1), si2 = (_si2) , \
   (((int16_t)(si1)) / ((int16_t)(si2)))))

#define c99_strict_safe_lshift_func_int16_t_s_s_unsafe_macro(left,_left,right,_right) \
  ((int16_t)( left = (_left), right = (_right) , \
   (((int16_t)(left)) << ((int)(right)))))

#define safe_lshift_func_int16_t_s_s_unsafe_macro(left,_left,right,_right) \
  ((int16_t)( left = (_left), right = (_right) , \
   (((int16_t)(left)) << ((int)(right)))))

#define c99_strict_safe_lshift_func_int16_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int16_t)( left = (_left), right = (_right) , \
   (((int16_t)(left)) << ((unsigned int)(right)))))

#define safe_lshift_func_int16_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int16_t)( left = (_left), right = (_right) , \
   (((int16_t)(left)) << ((unsigned int)(right)))))

#define c99_strict_safe_rshift_func_int16_t_s_s_unsafe_macro(left,_left,right,_right) \
	((int16_t)( left = (_left), right = (_right) , \
			 (((int16_t)(left)) >> ((int)(right)))))

#define c99_strict_safe_rshift_func_int16_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int16_t)( left = (_left), right = (_right) , \
			 (((int16_t)(left)) >> ((unsigned int)(right)))))

#define safe_rshift_func_int16_t_s_s_unsafe_macro(left,_left,right,_right) \
	((int16_t)( left = (_left), right = (_right) , \
			 (((int16_t)(left)) >> ((int)(right)))))

#define safe_rshift_func_int16_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int16_t)( left = (_left), right = (_right) , \
	 (((int16_t)(left)) >> ((unsigned int)(right)))))



#define safe_unary_minus_func_int32_t_s_unsafe_macro(si,_si) \
  ((int32_t)( si = (_si), \
    (-((int32_t)(si))) \
  ))

#define safe_add_func_int32_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
		((int32_t)( si1 = (_si1), si2 = (_si2) , \
		 (((int32_t)(si1)) + ((int32_t)(si2)))				\
		)) 

#define safe_sub_func_int32_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
		((int32_t)( si1 = (_si1), si2 = (_si2) , \
		 (((int32_t)(si1)) - ((int32_t)(si2))) \
		))

#define safe_mul_func_int32_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int32_t)( si1 = (_si1), si2 = (_si2) , \
   ((int32_t)(si1)) * ((int32_t)(si2))))

#define safe_mod_func_int32_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int32_t)( si1 = (_si1), si2 = (_si2) , \
   (((int32_t)(si1)) % ((int32_t)(si2)))))

#define safe_div_func_int32_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int32_t)( si1 = (_si1), si2 = (_si2) , \
   (((int32_t)(si1)) / ((int32_t)(si2)))))

#define c99_strict_safe_lshift_func_int32_t_s_s_unsafe_macro(left,_left,right,_right) \
  ((int32_t)( left = (_left), right = (_right) , \
   (((int32_t)(left)) << ((int)(right)))))

#define safe_lshift_func_int32_t_s_s_unsafe_macro(left,_left,right,_right) \
  ((int32_t)( left = (_left), right = (_right) , \
   (((int32_t)(left)) << ((int)(right)))))

#define c99_strict_safe_lshift_func_int32_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int32_t)( left = (_left), right = (_right) , \
   (((int32_t)(left)) << ((unsigned int)(right)))))

#define safe_lshift_func_int32_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int32_t)( left = (_left), right = (_right) , \
   (((int32_t)(left)) << ((unsigned int)(right)))))

#define c99_strict_safe_rshift_func_int32_t_s_s_unsafe_macro(left,_left,right,_right) \
	((int32_t)( left = (_left), right = (_right) , \
			 (((int32_t)(left)) >> ((int)(right)))))

#define c99_strict_safe_rshift_func_int32_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int32_t)( left = (_left), right = (_right) , \
			 (((int32_t)(left)) >> ((unsigned int)(right)))))

#define safe_rshift_func_int32_t_s_s_unsafe_macro(left,_left,right,_right) \
	((int32_t)( left = (_left), right = (_right) , \
			 (((int32_t)(left)) >> ((int)(right)))))

#define safe_rshift_func_int32_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int32_t)( left = (_left), right = (_right) , \
	 (((int32_t)(left)) >> ((unsigned int)(right)))))



#define safe_unary_minus_func_int64_t_s_unsafe_macro(si,_si) \
  ((int64_t)( si = (_si), \
    (-((int64_t)(si))) \
  ))

#define safe_add_func_int64_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
		((int64_t)( si1 = (_si1), si2 = (_si2) , \
		 (((int64_t)(si1)) + ((int64_t)(si2)))				\
		)) 

#define safe_sub_func_int64_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
		((int64_t)( si1 = (_si1), si2 = (_si2) , \
		 (((int64_t)(si1)) - ((int64_t)(si2))) \
		))

#define safe_mul_func_int64_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int64_t)( si1 = (_si1), si2 = (_si2) , \
   ((int64_t)(si1)) * ((int64_t)(si2))))

#define safe_mod_func_int64_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int64_t)( si1 = (_si1), si2 = (_si2) , \
   (((int64_t)(si1)) % ((int64_t)(si2)))))

#define safe_div_func_int64_t_s_s_unsafe_macro(si1,_si1,si2,_si2) \
  ((int64_t)( si1 = (_si1), si2 = (_si2) , \
   (((int64_t)(si1)) / ((int64_t)(si2)))))

#define c99_strict_safe_lshift_func_int64_t_s_s_unsafe_macro(left,_left,right,_right) \
  ((int64_t)( left = (_left), right = (_right) , \
   (((int64_t)(left)) << ((int)(right)))))

#define safe_lshift_func_int64_t_s_s_unsafe_macro(left,_left,right,_right) \
  ((int64_t)( left = (_left), right = (_right) , \
   (((int64_t)(left)) << ((int)(right)))))

#define c99_strict_safe_lshift_func_int64_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int64_t)( left = (_left), right = (_right) , \
   (((int64_t)(left)) << ((unsigned int)(right)))))

#define safe_lshift_func_int64_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int64_t)( left = (_left), right = (_right) , \
   (((int64_t)(left)) << ((unsigned int)(right)))))

#define c99_strict_safe_rshift_func_int64_t_s_s_unsafe_macro(left,_left,right,_right) \
	((int64_t)( left = (_left), right = (_right) , \
			 (((int64_t)(left)) >> ((int)(right)))))

#define c99_strict_safe_rshift_func_int64_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int64_t)( left = (_left), right = (_right) , \
			 (((int64_t)(left)) >> ((unsigned int)(right)))))

#define safe_rshift_func_int64_t_s_s_unsafe_macro(left,_left,right,_right) \
	((int64_t)( left = (_left), right = (_right) , \
			 (((int64_t)(left)) >> ((int)(right)))))

#define safe_rshift_func_int64_t_s_u_unsafe_macro(left,_left,right,_right) \
  ((int64_t)( left = (_left), right = (_right) , \
	 (((int64_t)(left)) >> ((unsigned int)(right)))))








#define safe_unary_minus_func_uint8_t_u_unsafe_macro(ui,_ui) \
  ((uint8_t)( ui = (_ui), -((uint8_t)(ui))))

#define safe_add_func_uint8_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint8_t)( ui1 = (_ui1), ui2 = (_ui2) , \
  ((uint8_t)(ui1)) + ((uint8_t)(ui2))))

#define safe_sub_func_uint8_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint8_t)( ui1 = (_ui1), ui2 = (_ui2) , ((uint8_t)(ui1)) - ((uint8_t)(ui2))))

#define safe_mul_func_uint8_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint8_t)(( ui1 = (_ui1), ui2 = (_ui2) , (uint8_t)(((unsigned int)(ui1)) * ((unsigned int)(ui2))))))

#define safe_mod_func_uint8_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
	((uint8_t)( ui1 = (_ui1), ui2 = (_ui2) , \
			 (((uint8_t)(ui1)) % ((uint8_t)(ui2)))))

#define safe_div_func_uint8_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
	        ((uint8_t)( ui1 = (_ui1), ui2 = (_ui2) , \
			 (((uint8_t)(ui1)) / ((uint8_t)(ui2)))))

#define c99_strict_safe_lshift_func_uint8_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint8_t)( left = (_left), right = (_right) , \
			 (((uint8_t)(left)) << ((int)(right)))))

#define c99_strict_safe_lshift_func_uint8_t_u_u_unsafe_macro(left,_left,right,_right) \
	 ((uint8_t)( left = (_left), right = (_right) , \
			 (((uint8_t)(left)) << ((unsigned int)(right)))))

#define c99_strict_safe_rshift_func_uint8_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint8_t)( left = (_left), right = (_right) , \
			 (((uint8_t)(left)) >> ((int)(right)))))

#define c99_strict_safe_rshift_func_uint8_t_u_u_unsafe_macro(left,_left,right,_right) \
	((uint8_t)( left = (_left), right = (_right) , \
			  (((uint8_t)(left)) >> ((unsigned int)(right)))))

#define safe_lshift_func_uint8_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint8_t)( left = (_left), right = (_right) , \
			 (((uint8_t)(left)) << ((int)(right)))))

#define safe_lshift_func_uint8_t_u_u_unsafe_macro(left,_left,right,_right) \
	 ((uint8_t)( left = (_left), right = (_right) , \
			 (((uint8_t)(left)) << ((unsigned int)(right)))))

#define safe_rshift_func_uint8_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint8_t)( left = (_left), right = (_right) , \
			 (((uint8_t)(left)) >> ((int)(right)))))

#define safe_rshift_func_uint8_t_u_u_unsafe_macro(left,_left,right,_right) \
	((uint8_t)( left = (_left), right = (_right) , \
			  (((uint8_t)(left)) >> ((unsigned int)(right)))))




#define safe_unary_minus_func_uint16_t_u_unsafe_macro(ui,_ui) \
  ((uint16_t)( ui = (_ui), -((uint16_t)(ui))))

#define safe_add_func_uint16_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint16_t)( ui1 = (_ui1), ui2 = (_ui2) , \
  ((uint16_t)(ui1)) + ((uint16_t)(ui2))))

#define safe_sub_func_uint16_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint16_t)( ui1 = (_ui1), ui2 = (_ui2) , ((uint16_t)(ui1)) - ((uint16_t)(ui2))))

#define safe_mul_func_uint16_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint16_t)(( ui1 = (_ui1), ui2 = (_ui2) , (uint16_t)(((unsigned int)(ui1)) * ((unsigned int)(ui2))))))

#define safe_mod_func_uint16_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
	((uint16_t)( ui1 = (_ui1), ui2 = (_ui2) , \
			 (((uint16_t)(ui1)) % ((uint16_t)(ui2)))))

#define safe_div_func_uint16_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
	        ((uint16_t)( ui1 = (_ui1), ui2 = (_ui2) , \
			 (((uint16_t)(ui1)) / ((uint16_t)(ui2)))))

#define c99_strict_safe_lshift_func_uint16_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint16_t)( left = (_left), right = (_right) , \
			 (((uint16_t)(left)) << ((int)(right)))))

#define c99_strict_safe_lshift_func_uint16_t_u_u_unsafe_macro(left,_left,right,_right) \
	 ((uint16_t)( left = (_left), right = (_right) , \
			 (((uint16_t)(left)) << ((unsigned int)(right)))))

#define c99_strict_safe_rshift_func_uint16_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint16_t)( left = (_left), right = (_right) , \
			 (((uint16_t)(left)) >> ((int)(right)))))

#define c99_strict_safe_rshift_func_uint16_t_u_u_unsafe_macro(left,_left,right,_right) \
	((uint16_t)( left = (_left), right = (_right) , \
			  (((uint16_t)(left)) >> ((unsigned int)(right)))))

#define safe_lshift_func_uint16_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint16_t)( left = (_left), right = (_right) , \
			 (((uint16_t)(left)) << ((int)(right)))))

#define safe_lshift_func_uint16_t_u_u_unsafe_macro(left,_left,right,_right) \
	 ((uint16_t)( left = (_left), right = (_right) , \
			 (((uint16_t)(left)) << ((unsigned int)(right)))))

#define safe_rshift_func_uint16_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint16_t)( left = (_left), right = (_right) , \
			 (((uint16_t)(left)) >> ((int)(right)))))

#define safe_rshift_func_uint16_t_u_u_unsafe_macro(left,_left,right,_right) \
	((uint16_t)( left = (_left), right = (_right) , \
			  (((uint16_t)(left)) >> ((unsigned int)(right)))))




#define safe_unary_minus_func_uint32_t_u_unsafe_macro(ui,_ui) \
  ((uint32_t)( ui = (_ui), -((uint32_t)(ui))))

#define safe_add_func_uint32_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint32_t)( ui1 = (_ui1), ui2 = (_ui2) , \
  ((uint32_t)(ui1)) + ((uint32_t)(ui2))))

#define safe_sub_func_uint32_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint32_t)( ui1 = (_ui1), ui2 = (_ui2) , ((uint32_t)(ui1)) - ((uint32_t)(ui2))))

#define safe_mul_func_uint32_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint32_t)(( ui1 = (_ui1), ui2 = (_ui2) , (uint32_t)(((unsigned int)(ui1)) * ((unsigned int)(ui2))))))

#define safe_mod_func_uint32_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
	((uint32_t)( ui1 = (_ui1), ui2 = (_ui2) , \
			(((uint32_t)(ui1)) % ((uint32_t)(ui2)))))

#define safe_div_func_uint32_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
	        ((uint32_t)( ui1 = (_ui1), ui2 = (_ui2) , \
			(((uint32_t)(ui1)) / ((uint32_t)(ui2)))))

#define c99_strict_safe_lshift_func_uint32_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint32_t)( left = (_left), right = (_right) , \
			(((uint32_t)(left)) << ((int)(right)))))

#define c99_strict_safe_lshift_func_uint32_t_u_u_unsafe_macro(left,_left,right,_right) \
	 ((uint32_t)( left = (_left), right = (_right) , \
			(((uint32_t)(left)) << ((unsigned int)(right)))))

#define c99_strict_safe_rshift_func_uint32_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint32_t)( left = (_left), right = (_right) , \
			(((uint32_t)(left)) >> ((int)(right)))))

#define c99_strict_safe_rshift_func_uint32_t_u_u_unsafe_macro(left,_left,right,_right) \
	((uint32_t)( left = (_left), right = (_right) , \
			 (((uint32_t)(left)) >> ((unsigned int)(right)))))

#define safe_lshift_func_uint32_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint32_t)( left = (_left), right = (_right) , \
			 (((uint32_t)(left)) << ((int)(right)))))

#define safe_lshift_func_uint32_t_u_u_unsafe_macro(left,_left,right,_right) \
	 ((uint32_t)( left = (_left), right = (_right) , \
			 (((uint32_t)(left)) << ((unsigned int)(right)))))

#define safe_rshift_func_uint32_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint32_t)( left = (_left), right = (_right) , \
			 (((uint32_t)(left)) >> ((int)(right)))))

#define safe_rshift_func_uint32_t_u_u_unsafe_macro(left,_left,right,_right) \
	((uint32_t)( left = (_left), right = (_right) , \
			  (((uint32_t)(left)) >> ((unsigned int)(right)))))




#define safe_unary_minus_func_uint64_t_u_unsafe_macro(ui,_ui) \
  ((uint64_t)( ui = (_ui), -((uint64_t)(ui))))

#define safe_add_func_uint64_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint64_t)( ui1 = (_ui1), ui2 = (_ui2) , \
  ((uint64_t)(ui1)) + ((uint64_t)(ui2))))

#define safe_sub_func_uint64_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint64_t)( ui1 = (_ui1), ui2 = (_ui2) , ((uint64_t)(ui1)) - ((uint64_t)(ui2))))

#define safe_mul_func_uint64_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
  ((uint64_t)(( ui1 = (_ui1), ui2 = (_ui2) , (uint64_t)(((unsigned long long)(ui1)) * ((unsigned long long)(ui2))))))

#define safe_mod_func_uint64_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
	((uint64_t)( ui1 = (_ui1), ui2 = (_ui2) , \
			 (((uint64_t)(ui1)) % ((uint64_t)(ui2)))))

#define safe_div_func_uint64_t_u_u_unsafe_macro(ui1,_ui1,ui2,_ui2) \
	        ((uint64_t)( ui1 = (_ui1), ui2 = (_ui2) , \
			 (((uint64_t)(ui1)) / ((uint64_t)(ui2)))))

#define c99_strict_safe_lshift_func_uint64_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint64_t)( left = (_left), right = (_right) , \
			 (((uint64_t)(left)) << ((int)(right)))))

#define c99_strict_safe_lshift_func_uint64_t_u_u_unsafe_macro(left,_left,right,_right) \
	 ((uint64_t)( left = (_left), right = (_right) , \
			 (((uint64_t)(left)) << ((unsigned int)(right)))))

#define c99_strict_safe_rshift_func_uint64_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint64_t)( left = (_left), right = (_right) , \
			 (((uint64_t)(left)) >> ((int)(right)))))

#define c99_strict_safe_rshift_func_uint64_t_u_u_unsafe_macro(left,_left,right,_right) \
	((uint64_t)( left = (_left), right = (_right) , \
			  (((uint64_t)(left)) >> ((unsigned int)(right)))))

#define safe_lshift_func_uint64_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint64_t)( left = (_left), right = (_right) , \
			 (((uint64_t)(left)) << ((int)(right)))))

#define safe_lshift_func_uint64_t_u_u_unsafe_macro(left,_left,right,_right) \
	 ((uint64_t)( left = (_left), right = (_right) , \
			 (((uint64_t)(left)) << ((unsigned int)(right)))))

#define safe_rshift_func_uint64_t_u_s_unsafe_macro(left,_left,right,_right) \
	((uint64_t)( left = (_left), right = (_right) , \
			 (((uint64_t)(left)) >> ((int)(right)))))

#define safe_rshift_func_uint64_t_u_u_unsafe_macro(left,_left,right,_right) \
	((uint64_t)( left = (_left), right = (_right) , \
			  (((uint64_t)(left)) >> ((unsigned int)(right)))))



#endif

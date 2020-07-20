## Read seeds from line
seeds=obj/seeds_out_test.txt
#obj=obj-func
obj=obj_macros
while IFS= read -r seed
do
	echo "================== seed $seed from $obj =================="
	./$obj/csmith_clang_10_test$seed
	./$obj/csmith_clang_6_test$seed
	./$obj/csmith_gcc_7_test$seed
	./$obj/csmith_gcc_9_test$seed
	./$obj/csmith_gcc_10_test$seed
	./$obj/modify_clang_10_test$seed
	./$obj/modify_clang_6_test$seed
	./$obj/modify_gcc_7_test$seed
	./$obj/modify_gcc_9_test$seed
	./$obj/modify_gcc_10_test$seed

	echo " >> Ref. results"
	grep -r "$seed" /home/user42/git/CEdgeSmith/scripts/RRS-v2-gen-prog-pairs/gcc-9-mainRes/ref_results/* -b1
done < "$seeds"


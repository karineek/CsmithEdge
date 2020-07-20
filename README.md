# CEdgeSmith

Experimental data and scripts to reproduce the results reported in ASE-NIER 2020.

Tools in use
------------
1. csmith (clone version: 8115771, 13 of April 2020).
2. gfauto (clone version: 8d0d03f, 14 of May 2020).

** see subfolders, we modified few files in each. Replace the files in these folders with ours.

Setting the environment
-----------------------

Download gcc and csmith:
```
./CEdgeSmith/scripts/0-download-csmith-gcc.sh
```
The script pulls source code and required packages into a temporary folder (printed at the end of the script). This temporary folder is the input of the next script that compiles and installs gcc and csmith:
```
./CEdgeSmith/scripts/1-install-csmith-gcc-opt-v0.sh <temp-folder-output-of-script-0>
```
Then remove the temporary folder from script 0:
```
./CEdgeSmith/scripts/2-clean-tmp.sh <temp-folder-output-of-script-0>
```
** Note: the scripts requires editing "working_folder=/home/user42" to your working folder. **

**Troubleshooting**: each stage log can be found in gcc-csmith-$i/compilation_info folder.
If you get errors during the build of GCC from source as the following
"configure: error: Building GCC requires GMP 4.2+, MPFR 3.1.0+ and MPC 0.8.0+.
 Try the --with-gmp, --with-mpfr and/or --with-mpc options to specify"
run before script-1:
```
./CEdgeSmith/scripts/0-reinstall-csmith-gcc.sh <temp-folder-output-of-script-0>.
```
The last step, follow the instructions in readme-files in subfolders ([Readme file 1](https://github.com/karineek/CEdgeSmith/blob/master/csmith/README.md) and [Readme file 2](https://github.com/karineek/CEdgeSmith/blob/master/gfauto/README.md)) to install csmith and gfauto to work properly with our scripts.

These scripts prepare a fresh copy of gcc source and build for measuring coverage. You can prepare a set of folders to run the coverage experiments in parallel on the same machine by changing the nb_processes variable in script-1. The folder gcc-csmith-0 is not for use (we use it only as part of the compilation process).

Preparing the data
------------------
Each Csmith compiler test-case has a relaxed version. This version is created by first generating a list of location in the test case of calls to safe-math wrappers that are must-be-safe calls. We relaxed any other call to safe-math wrapper if not on this list. We generate these lists via this script:
```
./CEdgeSmith/scripts/RSS-v2-general/RSS3_1_extract_mustBsafe_list.sh <reference-compiler> <seeds-file>
```
You can use our wrapper script to generate the data:
```
./CEdgeSmith/scripts/RSS-v2-general/3-prepare-modification-lists.sh
```
We kept the safe-lists files used for the experiments in the paper in [scripts/RSS-v2-general/seedsSafeLists](https://github.com/karineek/CEdgeSmith/tree/master/scripts/RSS-v2-general/seedsSafeLists). To construct these lists we used [an earlier version of Csmith](https://github.com/karineek/CEdgeSmith/blob/master/scripts/csmith_version_gen_seeds.txt) and copied the required changes from Csmith version 8115771 (that is, the safe_math and safe_math_macros headers). 

Measuring coverage 
------------------
**SETUP**: As described above in setup the environment and tools we use sections. 
To install the required packaged for the tools we use, run
```
./CEdgeSmith/scripts/installcomp.sh
./CEdgeSmith/scripts/install_machine_cov_sw.sh
```
Afterwards, setup the environment and the additional tools. In our experiments, we prepared 10 identical machines (with a single process on each) and ran the experiments distributively.
We explain next how to measure coverage in 'n' machines and aggregate the results in the end.


**Generate compiler test-cases with CEdgeSmith and measure coverage**: use the scripts in CEdgeSmith/scripts/RRS-v3-gcc/. Edit **all** the scripts to point to your base home folder and to the location of the tools in your machine(s).

We prepared the build of gcc once and used it to re-build the other machines, you can use this script to do so (but you don't have if you run script-1 in the same machine you are going to measure coverage!),
```
./CEdgeSmith/RRS-v3-gcc/3-clear_Machine.sh <machine-id>
```
We used machine-id between 1-10, to avoid overlapping of data collected from each machine. If you use a single machine, just set it to 1.
We tested that all data was ready for the experiment by running ./CEdgeSmith/RRS-v3-gcc/5-test-dest-machine.sh <machine-id>. 

The different parameters we used in our experiments (for Csmith, Csmith-macros, CEdgeSmith, and CEdgeSmith-macros) are in 4_script-s_settings.txt. You can use it to alter scripts-5 to measure coverage for each of the tools with macros or functions math-safe wrappers.

   (v) 5-compute-coverage_RSS-gfauto-gcc.sh : run the experiments.
   ./5-compute-coverage_RSS-gfauto-gcc.sh 1
   
   ./5-compute-coverage_RSS-gfauto-gcc.sh 1 ==> seed file 1
   
(vi) 6-collect-data2mars.sh : collect results form all machines if run distributively (we did run distributively on 10 machines).
 (vii) 7-gen-statistic-gcov-diff-tab_gfauto.sh : run gfauto to generate human readable outputs.

 
Additional scripts
------------------
To generate pairs of test-cases (Csmith and CEdgeSmith with the same seed), use the following script
```
./CEdgeSmith/scripts/RRS-v2-gen-prog-pairsRSS4_1-compiler_test_r.sh 0 1 <seed_file> <csmith-folder-inCEdgesmith> ../../Data/comp_confg/compiler_test_D.in <output-location> <CEdgeSmith-runtime-folders> <test-cases-compile-line-options> <csmith-flags>
``` 
or update the parameters in a wrapper script: 4-get-results-compiler-seeds_gen_mod_c_only.sh, and run
```
./CEdgeSmith/scripts/RRS-v2-gen-prog-pairs/4-get-results-compiler-seeds_gen_mod_c_only.sh
```

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
./scripts/0-download-csmith-gcc.sh
```
The script pulls source code and required packages into a temporary forlder (printed at the end of the script). This temporary folder is the input of the next script that compile and install gcc and csmith:
```
./scripts/1-install-csmith-gcc-opt-v0.sh <temp-folder-output-of-script-0>
```
Then remove the temporary folder from script 0:
```
./scripts/2-clean-tmp.sh <temp-folder-output-of-script-0>
```
** Note: the scripts requires editing "working_folder=/home/user42" to your working folder. **

**Troubleshooting**: if you get errors during build of GCC from source as the following
"configure: error: Building GCC requires GMP 4.2+, MPFR 3.1.0+ and MPC 0.8.0+.
 Try the --with-gmp, --with-mpfr and/or --with-mpc options to specify"
run before script-1:
```
./scripts/0-reinstall-csmith-gcc.sh <temp-folder-output-of-script-0>.
```
Last step, follow the instructions in readme files in subfolders ([Readme file 1](https://github.com/karineek/CEdgeSmith/blob/master/csmith/README.md) and [Readme file 2](https://github.com/karineek/CEdgeSmith/blob/master/gfauto/README.md)) to install csmith and gfauto to work properly with our scripts.


Preparing the data
------------------
Each Csmith compiler test-case has a relaxed version. This verion is created by first generating a list of location in the test case of calls to safe-math wrapptes that are must-be-safe calls. We relaxe any other call to safe-math wrapper if not on this list. We generate these lists via this script:
```
/scripts/RSS-v2-general/RSS3_1_extract_mustBsafe_list.sh <reference-compiler> <seeds-file>
```
You can use our wrapper script to generate the data:
```
./scripts/RSS-v2-general/3-prepare-modification-lists.sh
```
We kept the safe-lists files used for the experiments in the paper in [scripts/RSS-v2-general/seedsSafeLists](https://github.com/karineek/CEdgeSmith/tree/master/scripts/RSS-v2-general/seedsSafeLists).

Coverage scipts 
---------------
SETUP: with scripts scripts/install_machine_cov_sw.sh, scripts/0-download-csmith-gcc.sh, scripts/1-install-csmith-gcc-opt-v1.sh. 
  (i) Run these 3 scripts to setup the environment with tools and gcc last version. 
 (ii) Copy the files required for csmith and gfauto.
(iii) Re-compile csmith.
 (iv) Run dev_shell.sh.template (gfauto).
 
 RUN:
 Use the scripts in CEdgeSmith/scripts/RRS-v3-gcc/. 
   (i) Edit the scripts to contain the string of your base folder.
  (ii) 3-clear_Machine.sh :  clean the machine.
 (iii) 4_script-s_settings.txt : setup fresh environment.
  (iv) 5-test-dest-machine.sh : test the setup is OK.
   (v) 5-compute-coverage_RSS-gfauto-gcc.sh : run the experiments.
  (vi) 6-collect-data2mars.sh : collect results form all machines if run distributively (we did run distributively on 10 machines).
 (vii) 7-gen-statistic-gcov-diff-tab_gfauto.sh : run gfauto to generate human readable outputs.

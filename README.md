# CsmithEdge

Experimental data and scripts to reproduce the results reported for CsmithEdge (updated to July 2021).

Results and data appeared in the paper along with additional details, can be found [here](https://github.com/karineek/CsmithEdge/tree/master/results).

Tools in use
------------
1. csmith (clone version: d0b585a, 31 of May 2020).
2. gfauto (clone version: 8030f33, 15 of July 2021).
3. Python 3.8.10
4. cmake 
** see subfolders, we modified few files in each. Replace the files in these folders with ours.

Setting the environment
-----------------------

Download gcc and csmith:
```
./CsmithEdge/scripts/0-download-csmith-gcc.sh
```
The script pulls source code and required packages into a temporary folder (printed at the end of the script). This temporary folder is the input of the next script that compiles and installs gcc and csmith:
```
./CsmithEdge/scripts/1-install-csmith-gcc-opt-v0.sh <temp-folder-output-of-script-0>
```
Then remove the temporary folder from script 0:
```
./CsmithEdge/scripts/2-clean-tmp.sh <temp-folder-output-of-script-0>
```
** Note: the scripts requires editing "working_folder=/home/user42" to your working folder. **

**Troubleshooting**: each stage log can be found in gcc-csmith-$i/compilation_info folder.
If you get errors during the build of GCC from source as the following
"configure: error: Building GCC requires GMP 4.2+, MPFR 3.1.0+ and MPC 0.8.0+.
 Try the --with-gmp, --with-mpfr and/or --with-mpc options to specify"
run before script-1:
```
./CsmithEdge/scripts/0-reinstall-csmith-gcc.sh <temp-folder-output-of-script-0>.
```
The last step, follow the instructions in readme-files in subfolders ([Readme file 1](https://github.com/karineek/CsmithEdge/blob/master/csmith/README.md) and [Readme file 2](https://github.com/karineek/CsmithEdge/blob/master/gfauto/README.md)) to install csmith and gfauto to work properly with our scripts.

These scripts prepare a fresh copy of gcc source and build for measuring coverage. You can prepare a set of folders to run the coverage experiments in parallel on the same machine by changing the nb_processes variable in script-1. The folder gcc-csmith-0 is not for use (we use it only as part of the compilation process).

Preparing the data
------------------
Each Csmith compiler test-case has a relaxed version generated with CsmithEdge. This version is created by first generating per test-case a list of location of calls to safe-math wrappers that are must-be-safe calls. We relaxed any other call to safe-math wrapper if not on this list. We generate these lists via this script:
```
./CsmithEdge/scripts/RSS-v2-general/RSS3_1_extract_mustBsafe_list.sh <reference-compiler> <seeds-file>
```
You can use our wrapper script to generate the data:
```
./CsmithEdge/scripts/RSS-v2-general/3-prepare-modification-lists.sh
```
We kept the safe-lists files used for the experiments in the paper in [scripts/RSS-v2-general/seedsSafeLists](https://github.com/karineek/CsmithEdge/tree/master/scripts/RSS-v2-general/seedsSafeLists). To construct these lists we used [an earlier version of Csmith](https://github.com/karineek/CsmithEdge/blob/master/scripts/csmith_version_gen_seeds.txt) and copied the required changes from Csmith version 8115771 (that is, the safe_math and safe_math_macros headers). 

Measuring coverage 
------------------
**SETUP**: As described above in setup the environment and tools we use sections. 
To install the required packaged for the tools we use, run
```
./CsmithEdge/scripts/installcomp.sh
./CsmithEdge/scripts/install_machine_cov_sw.sh
```
Afterwards, setup the environment and the additional tools. In our experiments, we prepared 10 identical machines (with a single process on each) and ran the experiments distributively. We explain next how to measure coverage in 'n' machines and aggregate the results in the end.

**Generate compiler test-cases with CsmithEdge and measure coverage**: use the scripts in CsmithEdge/scripts/RRS-v3-gcc/. Edit **all** the scripts to point to your base home folder and to the location of the tools in your machine(s).

We prepared the build of gcc once and used it to re-build the other machines, you can use this script to do so (but you don't have if you run script-1 in the same machine you are going to measure coverage!)
```
./CsmithEdge/scripts/RRS-v3-gcc/3-clear_Machine.sh <process-id>
```
We tested that all data was ready for the experiment by running 
```
./CsmithEdge/scripts/RRS-v3-gcc/5-test-dest-machine.sh <process-id> 
```
Note1: Repeat per-precess (the number is set before in script-1 in nb_processes), if you run the experiment in parallel. We just set it to 1.
Note2: The different parameters we used in our experiments (for Csmith, Csmith-macros, CsmithEdge, and CsmithEdge-macros) are in 4_script-s_settings.txt. You can use it to alter scripts-5 to measure coverage for each of the tools with macros or functions math-safe wrappers. 

We measure coverage by running scipt 5-compute-coverage_RSS-gfauto-gcc.sh and generate a report with 7-gen-statistic-gcov-diff-tab_gfauto.sh. The scripts have regular mode and distribute mode. You need to run with at least two different settings (taken from 4_script-s_settings.txt) to generate a report; for example to comapre the coverage between Csmith and CsmithEdge-macros.

**Regular mode**: Run script-5 to generate compiler test-cases and measure coverage,
```
./CsmithEdge/scripts/RRS-v3-gcc/5-compute-coverage_RSS-gfauto-gcc.sh <process-id> 
```
this script prints in the end the output folder where the coverage results are. If you use only one process per-machine, set process-id to be 1. Run this script twice in different locations (each with a fresh build of gcc), and compare the coverage
```
./CsmithEdge/scripts/RRS-v3-gcc/7-gen-statistic-gcov-diff-tab_gfauto.sh <cov-results-folder-1> <cov-results-folder-2> <output-file-name>
```
**Distribute mode**: Run script-5 to generate compiler test-cases and measure coverage in each of the machines. To use different set of seeds each time we also add the range of seeds to-be-read per-machine to the parameters of the script. Run script-5 per-machine:
```
./CsmithEdge/scripts/RRS-v3-gcc/5-compute-coverage_RSS-gfauto-gcc.sh <process-id> <machine-id> <range-from> <range-to>
```
We used machine-id between 1-20 (giving 2 ids to collect coverage data per machine) this to avoid overlapping of the data collected from each machine. After all machines are done, aggregate the data with scripts-6. Move all data to a single machine:
```
./CsmithEdge/scripts/RRS-v3-gcc/6-collect-data2mars.sh <process-id> <machine-id>
```
and aggregate the coverage data after all the data is stored on a single machine
```
./<location of graphicsfuzz/gfauto folder>/dev_shell.sh.template
./CsmithEdge/scripts/RRS-v3-gcc/6-merge_machines.sh <process-id> <ids-per-machine>
```
then run script-7 as in the regular mode to generate human readable outputs with gfauto.
 
Additional scripts
------------------
To generate pairs of test-cases (Csmith and CsmithEdge with the same seed), use the following script
```
./CsmithEdge/scripts/RRS-v2-gen-prog-pairsRSS4_1-compiler_test_r.sh 0 1 <seed_file> <csmith-folder-inCsmithEdge> ../../Data/comp_confg/compiler_test_D.in <output-location> <CsmithEdge-runtime-folders> <test-cases-compile-line-options> <csmith-flags>
``` 
or update the parameters in a wrapper script: 4-get-results-compiler-seeds_gen_mod_c_only.sh, and run
```
./CsmithEdge/scripts/RRS-v2-gen-prog-pairs/4-get-results-compiler-seeds_gen_mod_c_only.sh
```

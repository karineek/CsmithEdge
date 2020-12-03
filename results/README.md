Results Experiments during March-May 2020 (ASE 2020)
====================================================

Raw results collected from 10 machines. We used this data to create the graphs in ASE 2020 nier paper.

Files:
* cov_tables.xlsx: full results from the machines.
* BugHunt.xlsx: information regarding the reported bugs in gcc.
* breakdown_lines_covered_uniquely_CEDGESMITH-MACROS.tsv.xlsx: a breakdown of lines covered uniquely under CEDGESMITH-MACROS.

The .gcov files from each machine can be provided on demand (over 6GB of zipped data).
These where collected from 10 different machines and merged with gfauto tool.
```
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 0 0 10000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 2 10000 20000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 4 20000 30000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 6 30000 40000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 8 40000 50000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 10 50000 60000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 12 60000 70000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 14 70000 80000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 16 80000 90000 > part_1.txt 2>&1 &
nohup ./5-compute-coverage_RSS-gfauto-gcc.sh 1 18 90000 100000 > part_1.txt 2>&1 &
```
Bugs found: 94809, 93744.

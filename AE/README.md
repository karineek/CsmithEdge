# CsmithEdge - AE

## Rate of differential testing

This section describes how to restore the results of section 4.2 in the evaluation. The scripts are currently set to run on a small set of programs. To restore similar results to what was reported in the paper, one should use a much larger set (say around 100,000 programs).

These scripts print the results with 10 s, 50 s and 120 s timeout. Each script run should take around 15 minutes.

Script to measure the rate for Csmith:
```
./rate_small_csmith.sh <Project folder> <output-file-of-diff-testing>
```
for example:
```
./rate_small_csmith.sh /home/user42/git/CsmithEdge/ output.log
```

Script to measure the rate for CsmithEdge:



Script to measure the rate for CsmithEdge Lazy approach:



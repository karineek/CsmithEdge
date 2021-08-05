# CsmithEdge - AE

## Generating Tests (section 4 in general)


## Rate of differential testing (Section 4.2 in the paper)

This section describes how to restore the results of section 4.2 in the evaluation. The scripts are currently set to run on a small set of programs. To restore similar results to what was reported in the paper, one should use a much larger set (say around 100,000 programs).

These scripts print the results with 10 s, 50 s and 120 s timeout. Each script run should take around 15-30 minutes.


1. Script to measure the rate for Csmith:
```
./rate_small_csmith.sh <Project folder> <output-file-of-diff-testing>
```
for example:
```
./rate_small_csmith.sh /home/user42/git/CsmithEdge/ output.log
```

2. Script to measure the rate for CsmithEdge:
```
./rate_small_csmithedge.sh <Project folder> <seeds-file> <output-file-of-diff-testing>
```
for example
```
./rate_small_csmithedge.sh /home/user42/git/CsmithEdge/ /home/user42/git/CsmithEdge/Data/seeds_all/seeds_out1.txt output.log
```

3. Script to measure the rate for CsmithEdge Lazy approach:
```
./rate_small_lazy.sh <Project folder> <seeds-file> <output-file-of-diff-testing>
```
for example
```
./rate_small_lazy.sh /home/user42/git/CsmithEdge/ /home/user42/git/CsmithEdge/Data/seeds_all/seeds_out1.txt output.log
```

## Coverage (Section 4.3)


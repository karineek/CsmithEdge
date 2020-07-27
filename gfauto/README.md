# Download and Install gfauto

We use gfauto to measure coverage. We modify the dev_shell script.

## Getting the repository: 
```
git clone https://github.com/google/graphicsfuzz.git
```
and then
```
cd graphicsfuzz/gfauto/ 
./dev_shell.sh.template
```
Troubleshooting: Install PYTHON-python3.7. Replace the script with this: dev_shell.sh.template in graphicsfuzz/gfauto$. Run again: ./dev_shell.sh.template.

It will create a Python virtual environment in: graphicsfuzz/gfauto/.venv/bin
To activate it: source graphicsfuzz/gfauto/.venv/bin/activate

Any issues: https://github.com/google/graphicsfuzz/tree/master/gfauto#setup

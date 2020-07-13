# We use gfauto to measure coverage.

## Getting the repository: 
git clone https://github.com/google/graphicsfuzz.git

Then:
Replace the script with this: dev_shell.sh.template in graphicsfuzz/gfauto$
then run: ./dev_shell.sh.template
It will create a Python virtual environment in: graphicsfuzz/gfauto/.venv/bin
To activate it: source graphicsfuzz/gfauto/.venv/bin/activate

Any issues: https://github.com/google/graphicsfuzz/tree/master/gfauto#setup

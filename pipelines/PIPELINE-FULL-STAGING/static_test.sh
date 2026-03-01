#!/bin/bash
set -x
source todo-list-aws/bin/activate

mkdir -p reports

# Radon: solo informe, no gate
radon cc src -a | tee reports/radon_cc.txt || true
radon mi src -s | tee reports/radon_mi.txt || true

# Flake8: no fallar por findings
flake8 src | tee reports/flake8.txt || true

# Bandit: no fallar por findings
bandit -r src -f txt -o reports/bandit.txt || true

exit 0
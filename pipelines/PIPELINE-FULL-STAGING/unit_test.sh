#!/bin/bash
set -euxo pipefail

source todo-list-aws/bin/activate

# PYTHONPATH seguro aunque no exista
if [ -z "${PYTHONPATH:-}" ]; then
  export PYTHONPATH="$(pwd)"
else
  export PYTHONPATH="${PYTHONPATH}:$(pwd)"
fi
echo "PYTHONPATH: $PYTHONPATH"

export DYNAMODB_TABLE=todoUnitTestsTable

mkdir -p reports

source todo-list-aws/bin/activate
python -m pip install --no-cache-dir -q unittest-xml-reporting
python -m xmlrunner discover -s test/unit -p "Test*.py" -o reports

# Coverage (sin romper nada)
pip show coverage || true
coverage run --include=src/todoList.py -m unittest discover -s test/unit -p "Test*.py"
coverage report
coverage xml -o coverage.xml
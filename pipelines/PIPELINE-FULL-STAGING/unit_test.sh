#!/bin/bash
set -euxo pipefail

source todo-list-aws/bin/activate
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
export DYNAMODB_TABLE=todoUnitTestsTable

mkdir -p reports

# Instala generador de XML JUnit
pip install -q unittest-xml-reporting

# Ejecuta tests generando XML para Jenkins
python -m xmlrunner discover -s test/unit -p "Test*.py" -o reports

# Coverage
coverage run --include=src/todoList.py -m unittest discover test/unit
coverage report
coverage xml -o coverage.xml
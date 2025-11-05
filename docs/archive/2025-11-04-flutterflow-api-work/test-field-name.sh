#!/bin/bash

echo "Testing with project_yaml_bytes (snake_case):"
jq '.value.project_yaml_bytes | length' /tmp/raw-api-response.json

echo ""
echo "First 200 chars:"
jq -r '.value.project_yaml_bytes' /tmp/raw-api-response.json | head -c 200
echo ""

#!/usr/bin/env python3
"""
Render a YAML action template with token substitution.

Usage:
  wire_trigger.py --template PATH --out PATH \
    --var ACTION_NAME=initializeUserSession \
    --var CUSTOM_ACTION_KEY=vpyil \
    --var NON_BLOCKING=false \
    [--params '{"recipeId": "{{currentRecipeId}}"}']

Notes:
  - Templates are simple YAML with ${TOKEN} placeholders.
  - For button_ontap templates, pass --params JSON; it will set ${PARAMS_JSON}.
"""
import argparse
import json
import os
import re


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--template", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--var", action="append", default=[], help="KEY=VALUE substitutions")
    ap.add_argument("--params", help="JSON object for PARAMS_JSON placeholder", default=None)
    args = ap.parse_args()

    with open(args.template, "r", encoding="utf-8") as f:
        content = f.read()

    # Build substitution map
    subs = {}
    for kv in args.var:
        if "=" not in kv:
            raise SystemExit(f"--var must be KEY=VALUE, got: {kv}")
        k, v = kv.split("=", 1)
        subs[k] = v

    if args.params:
        try:
            params_obj = json.loads(args.params)
        except Exception as e:
            raise SystemExit(f"--params must be valid JSON: {e}")
        # Serialize compact JSON for injection
        subs["PARAMS_JSON"] = json.dumps(params_obj, separators=(",", ":"))

    # Replace ${TOKEN} with value; leave unresolved tokens as-is
    def replacer(match):
        token = match.group(1)
        return subs.get(token, match.group(0))

    rendered = re.sub(r"\$\{([A-Z0-9_]+)\}", replacer, content)

    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        f.write(rendered)

    print(f"Rendered to: {args.out}")


if __name__ == "__main__":
    main()

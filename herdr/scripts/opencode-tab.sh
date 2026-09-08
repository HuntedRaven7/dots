#!/bin/bash
result=$(herdr tab create --focus --label opencode 2>/dev/null)
tab_id=$(echo "$result" | python3 -c 'import sys, json; print(json.load(sys.stdin)["result"]["tab"]["tab_id"])')
pane_id=$(echo "$result" | python3 -c 'import sys, json; print(json.load(sys.stdin)["result"]["root_pane"]["pane_id"])')
herdr tab focus "$tab_id" >/dev/null 2>&1
herdr pane run "$pane_id" "opencode"

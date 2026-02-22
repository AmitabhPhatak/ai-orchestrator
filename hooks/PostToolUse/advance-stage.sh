#!/usr/bin/env bash
# Hook: PostToolUse / advance-stage
# Fires after every tool use. Tracks completed actions, updates idea state,
# and triggers orchestrator checks when stage transitions occur.

set -euo pipefail

TOOL_INPUT=$(cat)
TOOL_NAME=$(echo "$TOOL_INPUT" | jq -r '.tool_name // empty')
TOOL_RESPONSE=$(echo "$TOOL_INPUT" | jq -r '.tool_response // empty')

ORCHESTRATOR_DIR=".orchestrator"
ACTIVITY_LOG="$ORCHESTRATOR_DIR/activity.log"
mkdir -p "$ORCHESTRATOR_DIR/ideas" "$ORCHESTRATOR_DIR/hooks"

timestamp() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }

log_activity() {
  echo "[$(timestamp)] tool=$TOOL_NAME | $*" >> "$ACTIVITY_LOG"
}

# ─── Detect stage transitions from tool responses ────────────────────────────

# When an idea file is written/updated, check for stage changes
if [[ "$TOOL_NAME" == "str_replace_editor" ]] || [[ "$TOOL_NAME" == "create_file" ]]; then
  FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.tool_input.path // empty')
  
  if echo "$FILE_PATH" | grep -q "$ORCHESTRATOR_DIR/ideas/IDEA-"; then
    IDEA_ID=$(basename "$FILE_PATH" .md)
    CURRENT_STAGE=$(grep -m1 "^Stage:" "$FILE_PATH" 2>/dev/null | awk '{print $2}' || echo "UNKNOWN")
    
    log_activity "idea=$IDEA_ID stage=$CURRENT_STAGE file_written=$FILE_PATH"
    
    # Update the last-activity timestamp in the idea file
    if grep -q "^Last activity:" "$FILE_PATH" 2>/dev/null; then
      sed -i "s/^Last activity:.*/Last activity: $(timestamp)/" "$FILE_PATH"
    fi
    
    echo "📋 Orchestrator: $IDEA_ID updated → Stage: $CURRENT_STAGE"
  fi
fi

# ─── Detect and log bash commands that represent meaningful progress ──────────

if [[ "$TOOL_NAME" == "bash" ]]; then
  CMD=$(echo "$TOOL_INPUT" | jq -r '.tool_input.command // empty')
  EXIT_CODE=$(echo "$TOOL_RESPONSE" | jq -r '.returncode // 0')
  
  # Log prototype scaffolding completions
  if echo "$CMD" | grep -qE '(npm init|create-react-app|rails new|django-admin|cargo new|go mod init)'; then
    log_activity "prototype_scaffold cmd=$CMD exit=$EXIT_CODE"
    if [[ "$EXIT_CODE" -eq 0 ]]; then
      echo "🏗️  Orchestrator: Prototype scaffold completed successfully"
    fi
  fi
  
  # Log test runs
  if echo "$CMD" | grep -qE '(npm test|pytest|rspec|go test|cargo test)'; then
    log_activity "tests_run exit=$EXIT_CODE"
    PASS_FAIL=$([[ "$EXIT_CODE" -eq 0 ]] && echo "PASSED" || echo "FAILED")
    echo "🧪 Orchestrator: Tests $PASS_FAIL (exit $EXIT_CODE)"
  fi
  
  # Log deployments
  if echo "$CMD" | grep -qE '(git push.*main|kubectl apply|helm upgrade|deploy)'; then
    log_activity "deployment_action cmd=$CMD exit=$EXIT_CODE"
    if [[ "$EXIT_CODE" -eq 0 ]]; then
      echo "🚀 Orchestrator: Deployment action completed. Verify in production."
    else
      echo "⚠️  Orchestrator: Deployment action failed (exit $EXIT_CODE). Check logs."
    fi
  fi
fi

# ─── Stall detection — check for any ideas approaching 48h threshold ─────────

STALL_CHECK_FILE="$ORCHESTRATOR_DIR/hooks/last-stall-check"
LAST_CHECK=0
[[ -f "$STALL_CHECK_FILE" ]] && LAST_CHECK=$(cat "$STALL_CHECK_FILE")
NOW=$(date +%s)
CHECK_INTERVAL=3600  # Check once per hour

if (( NOW - LAST_CHECK > CHECK_INTERVAL )); then
  echo "$NOW" > "$STALL_CHECK_FILE"
  
  STALLED_COUNT=0
  if [[ -d "$ORCHESTRATOR_DIR/ideas" ]]; then
    while IFS= read -r idea_file; do
      if [[ -f "$idea_file" ]]; then
        LAST_ACTIVITY=$(grep -m1 "^Last activity:" "$idea_file" 2>/dev/null | awk '{print $3}' || echo "")
        if [[ -n "$LAST_ACTIVITY" ]]; then
          LAST_TS=$(date -d "$LAST_ACTIVITY" +%s 2>/dev/null || echo "$NOW")
          HOURS_SINCE=$(( (NOW - LAST_TS) / 3600 ))
          if (( HOURS_SINCE > 48 )); then
            STALLED_COUNT=$((STALLED_COUNT + 1))
            IDEA_ID=$(basename "$idea_file" .md)
            log_activity "stall_detected idea=$IDEA_ID hours=$HOURS_SINCE"
          fi
        fi
      fi
    done < <(find "$ORCHESTRATOR_DIR/ideas" -name "IDEA-*.md" 2>/dev/null)
  fi
  
  if (( STALLED_COUNT > 0 )); then
    echo ""
    echo "⏰ Orchestrator: $STALLED_COUNT idea(s) stalled >48h. Run /orchestrator:unblock to surface them."
  fi
fi

log_activity "hook_complete"
exit 0

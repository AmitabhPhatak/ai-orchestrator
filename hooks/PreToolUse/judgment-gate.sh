#!/usr/bin/env bash
# Hook: PreToolUse / judgment-gate
# Fires before any tool use. Intercepts high-stakes actions that require explicit human approval.

set -euo pipefail

# Read the tool call from stdin (Claude Code passes tool info as JSON)
TOOL_INPUT=$(cat)
TOOL_NAME=$(echo "$TOOL_INPUT" | jq -r '.tool_name // empty')
TOOL_PARAMS=$(echo "$TOOL_INPUT" | jq -r '.tool_input // empty')

ORCHESTRATOR_DIR=".orchestrator"
LOG_FILE="$ORCHESTRATOR_DIR/hooks/judgment-gate.log"
mkdir -p "$ORCHESTRATOR_DIR/hooks"

timestamp() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }

log() {
  echo "[$(timestamp)] $*" >> "$LOG_FILE"
}

# ─── High-stakes tool patterns that require human approval ───────────────────

# 1. Bash commands that write to production-like paths
if [[ "$TOOL_NAME" == "bash" ]]; then
  CMD=$(echo "$TOOL_PARAMS" | jq -r '.command // empty')
  
  # Block destructive operations on production paths
  if echo "$CMD" | grep -qE '(kubectl.*prod|helm.*prod|aws.*--profile prod|gcloud.*prod|terraform apply)'; then
    log "BLOCKED production command: $CMD"
    echo "🛑 JUDGMENT GATE: Production infrastructure command detected."
    echo ""
    echo "Command: $CMD"
    echo ""
    echo "This requires explicit human approval. The orchestrator does not auto-execute production commands."
    echo "If you intended this, run it manually outside the orchestrator context."
    echo ""
    echo "To proceed, type: /orchestrator:scale IDEA-XXX --deploy"
    exit 1
  fi

  # Block database mutations outside sandbox
  if echo "$CMD" | grep -qE '(DROP TABLE|DELETE FROM|TRUNCATE|ALTER TABLE)' && ! echo "$CMD" | grep -qi 'sandbox\|test\|dev'; then
    log "BLOCKED potential destructive DB command: $CMD"
    echo "🛑 JUDGMENT GATE: Potentially destructive database command detected."
    echo ""
    echo "Command: $CMD"
    echo ""
    echo "If this is intentional and you've verified the target database, run it manually."
    exit 1
  fi
fi

# 2. File writes to sensitive locations
if [[ "$TOOL_NAME" == "str_replace_editor" ]] || [[ "$TOOL_NAME" == "create_file" ]]; then
  FILE_PATH=$(echo "$TOOL_PARAMS" | jq -r '.path // empty')
  
  if echo "$FILE_PATH" | grep -qE '^\.(env|secrets|aws|ssh)/'; then
    log "BLOCKED write to sensitive path: $FILE_PATH"
    echo "🛑 JUDGMENT GATE: Write to sensitive path blocked."
    echo "Path: $FILE_PATH"
    echo "The orchestrator does not write to credential or secret files."
    exit 1
  fi
fi

# 3. Any action on an idea that hasn't received human approval at its current stage gate
if [[ "$TOOL_NAME" == "bash" ]]; then
  CMD=$(echo "$TOOL_PARAMS" | jq -r '.command // empty')
  
  # If orchestrator is trying to advance an idea stage, verify approval exists
  if echo "$CMD" | grep -qE 'orchestrator.*advance|stage.*next'; then
    IDEA_ID=$(echo "$CMD" | grep -oE 'IDEA-[0-9]{8}-[A-Z0-9]{4}' | head -1)
    if [[ -n "$IDEA_ID" ]]; then
      IDEA_FILE="$ORCHESTRATOR_DIR/ideas/$IDEA_ID.md"
      if [[ -f "$IDEA_FILE" ]]; then
        APPROVED=$(grep -c "status: approved" "$IDEA_FILE" || true)
        if [[ "$APPROVED" -eq 0 ]]; then
          log "BLOCKED stage advance without approval: $IDEA_ID"
          echo "🛑 JUDGMENT GATE: Cannot advance $IDEA_ID — no human approval recorded at current stage."
          echo ""
          echo "Check the current decision required in: $IDEA_FILE"
          exit 1
        fi
      fi
    fi
  fi
fi

# ─── All checks passed — log and allow ───────────────────────────────────────
log "ALLOWED $TOOL_NAME"
exit 0

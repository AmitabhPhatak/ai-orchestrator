# AI Orchestrator — Cognitive Agile Plugin for Claude Code

> *Agile was built for execution scarcity. AI has created execution abundance. This plugin is built for what comes next.*

The AI Orchestrator replaces heavy Agile ceremony with a lightweight, AI-driven pull system. Ideas flow from anyone in the org — in plain language — through to production, with the AI handling orchestration and humans called in only when genuine judgment is required.

---

## The Problem This Solves

Ideas die in most organizations not because they're bad, but because:
- **Backlogs nobody reads** — ideas get submitted into a void and age out
- **No prototype = no buy-in** — without something tangible, ideas can't compete for attention
- **Too many approval layers** — the cost of moving an idea forward exceeds its perceived value

The orchestrator eliminates all three.

---

## Install

```bash
# From local directory (development)
claude plugin add ./ai-orchestrator

# Test without installing
claude --plugin-dir ./ai-orchestrator
```

---

## The Flow

```
Anyone in org → /orchestrator:imagine "rough idea" 
                     ↓ AI structures it
             → Human approves brief
                     ↓
             → /orchestrator:prototype
                     ↓ AI builds working scaffold
             → Human approves prototype direction
                     ↓
             → /orchestrator:test
                     ↓ AI extracts signal
             → Human decides: refine / pivot / abandon
                     ↓
             → /orchestrator:refine
                     ↓ AI strengthens the system
             → Human approves readiness
                     ↓
             → /orchestrator:scale
                     ↓ AI runs production checklist
             → Human deploys
                     ↓
                PRODUCTION 🚀
```

---

## Commands

| Command | What it does |
|---------|-------------|
| `/orchestrator:imagine "idea"` | Turn a rough idea into a structured opportunity brief |
| `/orchestrator:prototype IDEA-ID` | Scaffold a working prototype from an approved brief |
| `/orchestrator:test IDEA-ID` | Extract signal, simulate edge cases, analyze feedback |
| `/orchestrator:refine IDEA-ID` | Strengthen the system — security, performance, simplicity |
| `/orchestrator:scale IDEA-ID` | Prepare and approve for production promotion |
| `/orchestrator:status` | Async progress across all ideas (replaces standup) |
| `/orchestrator:unblock` | Surface stalled ideas and diagnose why |

---

## What's in the Box

### Skills
- `cognitive-agile.md` — the operating philosophy baked into every interaction

### Agents
- **orchestrator** — the drum master. Moves work forward, never sleeps, never misses a stalled idea
- **clarity-agent** — surfaces human decision points with exactly the right framing
- **cognitive-guard** — ensures AI acceleration doesn't become AI dependency

### Hooks
- **PreToolUse / judgment-gate** — blocks production commands and stage advances without approval
- **PostToolUse / advance-stage** — tracks progress, logs activity, detects stalls automatically

---

## File Structure at Runtime

Once running, the orchestrator maintains its state here:

```
.orchestrator/
├── ideas/           ← one file per idea, tracks full journey
├── prototypes/      ← scaffolded code per idea
├── tests/           ← test reports
├── refine/          ← refine iteration reports
├── scale/           ← pre-production checklists
├── launched/        ← full records of shipped ideas
├── clarity/         ← pending human decision requests
├── standups/        ← async status reports
└── activity.log     ← full audit trail
```

---

## Philosophy

**Pull, don't push.** Work advances when it's ready, not when a sprint ends.

**Tangible first.** Nothing is discussed abstractly when a prototype can exist.

**Async by default.** Meetings happen when clarity is genuinely missing.

**Preserve thinking.** AI accelerates. Humans decide. Never reverse this.

---

## Configuration

```yaml
# .orchestrator/config.yaml
cognitive_guard:
  passive_approval_threshold: 3
  monthly_report: true
  tone: collaborative

stall_detection:
  threshold_hours: 48
  escalate_after_hours: 168  # 7 days → auto-archive as dormant

defaults:
  prototype_stack: auto      # or: react,node | python,fastapi | rails
  test_simulation: true
  auto_refine_passes: 2
```

---

Built on the Cognitive Agile philosophy. See `skills/cognitive-agile.md` for the full operating model.

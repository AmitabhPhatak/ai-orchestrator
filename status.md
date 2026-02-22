# Command: status

## Purpose
Generate an async, AI-compiled view of all active ideas and their current state across the org. Replaces the daily standup. Runs on demand or on a schedule.

No meeting required. No one needs to prepare. The orchestrator knows where everything is.

## Usage
```
/orchestrator:status
/orchestrator:status --mine          ← only ideas I submitted or am assigned to
/orchestrator:status --stage test    ← only ideas in a specific stage
/orchestrator:status --stalled       ← only ideas that haven't moved in 48h+
```

## What the AI Does

Scan all files in `.orchestrator/ideas/` and compile a live picture.

### Status Report Format

---

## Orchestrator Status Report
**Generated:** {timestamp}
**Active Ideas:** {n}
**Stalled:** {n} (>48h without movement)
**Launched this week:** {n}

---

### 🔴 Needs Your Decision Now
*These are blocked waiting for human approval*

| ID | Idea | Stage | Waiting for | Waiting since |
|----|------|-------|-------------|---------------|
| IDEA-XXX | "mobile order history" | IMAGINE → PROTOTYPE | Opportunity brief approval | 6h |
| IDEA-XXX | "weekly digest emails" | TEST → REFINE | Go/refine/abandon decision | 2d |

---

### 🟡 In Progress (AI Working)
*These are moving — no action needed*

| ID | Idea | Stage | Current activity | ETA |
|----|------|-------|-----------------|-----|
| IDEA-XXX | "onboarding flow" | PROTOTYPE | Scaffolding backend API | ~2h |

---

### 🟢 Recently Moved
*Ideas that advanced in the last 24h*

| ID | Idea | Movement | Who/what moved it |
|----|------|----------|-------------------|
| IDEA-XXX | "search redesign" | TEST → REFINE | Completed test report |
| IDEA-XXX | "export feature" | Launched 🚀 | Deployed to production |

---

### ⚫ Stalled (>48h)
*These need attention — something is blocking them*

| ID | Idea | Stage | Stalled since | Reason | Suggested action |
|----|------|-------|---------------|--------|-----------------|
| IDEA-XXX | "notification prefs" | REFINE | 3d | No human response to refine report | Review `.orchestrator/refine/IDEA-XXX-2.md` |

---

### 📚 Abandoned This Week (with learnings)
| ID | Idea | Stage abandoned | Reason | Learning |
|----|------|----------------|--------|---------|

---

**Next scheduled status:** {time} (or run `/orchestrator:status` anytime)

---

## Behavior Rules

- This report should be readable in under 3 minutes
- Prioritize "Needs Your Decision Now" at the top — that is the only section that requires human action
- Stalled items should include a specific suggested action, not just a flag
- Do NOT include ideas that are genuinely in-progress and moving — no noise
- Track and display the full journey time from Imagine to each current stage so humans can see flow velocity across the org

## Scheduling

To run status automatically:
```bash
# Add to crontab for daily async standup at 9am
0 9 * * * claude /orchestrator:status > .orchestrator/standups/$(date +%Y%m%d).md
```

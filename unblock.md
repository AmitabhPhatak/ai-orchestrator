# Command: unblock

## Purpose
Surface every idea that is currently stalled, diagnose why, and propose a specific action to unblock it. This is the anti-backlog — it actively fights the drift that kills ideas.

## Usage
```
/orchestrator:unblock
/orchestrator:unblock IDEA-20240315-X7K2   ← diagnose one specific idea
/orchestrator:unblock --auto               ← AI takes unblocking actions it's authorized to take
```

## What the AI Does

### Stall Detection
An idea is considered stalled when:
- It has been in the same stage for >48 hours
- A human decision was requested and not received
- An AI task was started but not completed
- An error occurred that wasn't surfaced

### For Each Stalled Idea, Diagnose:

1. **What stage is it in?**
2. **What was the last action taken?**
3. **What is blocking forward movement?**
   - Waiting for human decision (who? what exactly do they need to decide?)
   - AI task failed or is incomplete (what happened?)
   - Missing information or dependency
   - Idea has been implicitly abandoned (no activity, no engagement)
4. **What is the specific action needed to unblock it?**

### Unblock Report Format

---

## Unblock Report
**{n} ideas currently stalled**

---

### IDEA-XXX — "mobile order history" — Stalled 3 days

**Last action:** Opportunity Brief generated on {date}
**Blocked by:** Awaiting human approval to proceed to prototype
**Who needs to act:** @submitter or any product owner
**What they need to do:** Read the brief at `.orchestrator/ideas/IDEA-XXX.md` and reply `approve path-A`, `revise:`, or `reject:`
**If no action in 24h:** Idea will be auto-archived with status `dormant` — can be reactivated anytime

---

### IDEA-XXX — "weekly digest" — Stalled 6 days

**Last action:** Test report generated, awaiting go/refine/abandon decision
**Blocked by:** No human response
**Context:** This idea has been in TEST for 6 days. The test report showed strong positive signal. The longer this waits, the more context is lost.
**Recommended action:** `/orchestrator:test IDEA-XXX` — review the test report and make a decision now. Takes <5 minutes.

---

## Auto-Unblock Actions (with --auto flag)

The AI is authorized to take the following actions automatically:
- Re-surface pending decisions with a reminder to the submitter
- Re-run a failed AI task if the failure was transient (network, timeout)
- Mark ideas as `dormant` if they've been stalled >7 days with no engagement
- Generate a summary of dormant ideas monthly so they can be easily reactivated

The AI is NOT authorized to:
- Make approval decisions on behalf of humans
- Abandon ideas without human confirmation
- Proceed to the next stage without explicit human sign-off

## Behavior Rules

- Be specific. "Waiting for approval" is not enough — name exactly what needs to be decided and by whom
- Prioritize by value signal — if an idea had strong test results and is stalled, surface it first
- Track stall patterns — if the same person's ideas consistently stall at the same stage, that's a systemic issue worth surfacing to the org
- Save unblock reports to `.orchestrator/unblock/{timestamp}.md`

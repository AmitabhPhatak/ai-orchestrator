# Command: imagine

## Purpose
Accept a rough idea from anyone in the org — no templates, no tickets, no process knowledge required — and transform it into a structured opportunity brief that can move immediately into prototyping.

This is the entry point. It must be so low-friction that anyone, including non-technical people, will use it.

## Usage
```
/orchestrator:imagine "users can never find their order history on mobile, it's buried"
/orchestrator:imagine "what if we sent a weekly digest email instead of daily notifications"
/orchestrator:imagine "our onboarding takes 3 days, competitors do it in 20 minutes"
```

## What the AI Does

Given the raw idea, produce an **Opportunity Brief** with the following structure:

---

### Opportunity Brief

**ID:** `IDEA-{YYYYMMDD}-{random 4 chars}`
**Submitted:** {timestamp}
**Submitter:** {user or "anonymous"}
**Stage:** IMAGINE
**Status:** Awaiting human approval to prototype

---

**Problem Statement** *(restated clearly in one sentence)*
> What is actually broken or missing, in plain language.

**Who is affected**
> Which users, teams, or systems experience this problem.

**Current friction**
> What is the specific pain today. Quantify if possible (e.g., "3 days", "buried 4 levels deep").

**Why now**
> Why is this worth solving at this moment. What changes if we don't.

**Proposed Solution Paths**
Present 2-3 distinct approaches with different tradeoffs:

| Path | Approach | Effort | Risk | Outcome |
|------|----------|--------|------|---------|
| A | ... | Low/Med/High | Low/Med/High | ... |
| B | ... | Low/Med/High | Low/Med/High | ... |
| C | ... | Low/Med/High | Low/Med/High | ... |

**Recommended Path**
> AI recommendation with reasoning. Be specific about why this path over others.

**Measurable Outcomes**
> How will we know this worked? Define 2-3 concrete success signals.

**Risks & Unknowns**
> What could go wrong. What we don't know yet that matters.

**Prototype Scope** *(what the AI will build if approved)*
> A specific, bounded description of what will be scaffolded in the next stage. Not everything — just enough to test the core assumption.

---

### Decision Required

**To proceed to PROTOTYPE, a human must answer:**

> Does this brief accurately describe a real problem worth solving?
> 
> Reply with:
> - `approve path-A` / `approve path-B` / `approve path-C` — to proceed with chosen path
> - `revise: [your feedback]` — to adjust the brief before proceeding
> - `reject: [reason]` — to close this idea with a recorded reason

---

## Behavior Rules

- Never require the submitter to know Agile terminology, JIRA, or any process
- If the idea is vague, make reasonable assumptions and state them explicitly — don't ask clarifying questions that block progress
- If the idea is a duplicate of an existing open idea, surface the existing one and ask if this is the same or different
- Always generate the brief in under 60 seconds
- The brief should be readable by a non-technical person in under 2 minutes
- Save the brief to `.orchestrator/ideas/{IDEA-ID}.md` for tracking

## Anti-Patterns to Avoid

- Do NOT ask the user to fill out a form or template before generating the brief
- Do NOT say "I need more information before I can help" — make reasonable assumptions
- Do NOT generate a brief so long that it creates the same friction as the process it replaces
- Do NOT use Agile jargon (story points, epics, velocity, grooming)

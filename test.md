# Command: test

## Purpose
Extract structured signal from the prototype — edge cases, failure modes, user friction, and early feedback — so humans can make a sharp go/refine/abandon decision based on evidence, not opinion.

Testing is not a validation ritual. It is a **learning accelerator.**

## Usage
```
/orchestrator:test IDEA-20240315-X7K2
/orchestrator:test IDEA-20240315-X7K2 --feedback "users said it was confusing at step 2"
/orchestrator:test IDEA-20240315-X7K2 --simulate   ← AI simulates user behavior patterns
```

## What the AI Does

### Step 1: Automated Signal Extraction
Run the following analyses against the prototype:

**Edge Case Simulation**
- What happens with empty states, null values, extreme inputs
- What breaks at scale (10x, 100x expected load)
- What happens when dependencies fail

**Friction Detection**
- Where does the user flow have unnecessary steps
- What assumptions does the prototype make that users might not share
- Where is the cognitive load highest

**Gap Analysis**
- Compare what was promised in the brief vs what was built
- Identify any core assumptions that the prototype does NOT yet test
- Surface what's missing that would matter most to the target user

**Feedback Integration** *(if --feedback flag is used)*
- Parse and structure any qualitative feedback provided
- Identify patterns across multiple feedback points
- Distinguish signal (consistent, specific) from noise (vague, one-off)

### Step 2: Generate Test Report

---

### Test Report

**ID:** `{IDEA-ID}`
**Stage:** TEST
**Prototype tested:** `.orchestrator/prototypes/{IDEA-ID}/`

**Signal Summary**
> One paragraph: what did we learn? Is the core assumption validated, partially validated, or invalidated?

**Positive Signals**
> What works. What users responded to. What performs well.

**Friction Points** *(ranked by severity)*
| # | Issue | Severity | Affects | Fixable in Refine? |
|---|-------|----------|---------|-------------------|
| 1 | ... | High/Med/Low | ... | Yes/No/Maybe |

**Edge Cases Found**
> List of specific failure scenarios discovered with steps to reproduce.

**Unvalidated Assumptions**
> What did we not yet learn that still matters before going to production.

**Recommendation**
> AI recommendation: Refine / Pivot / Abandon — with specific reasoning tied to the measurable outcomes defined in the brief.

---

### Decision Required

**Based on this signal, a human must decide:**

> - `refine` — enough positive signal, proceed to strengthen the system
> - `pivot: [direction]` — the idea has merit but needs a different approach, return to PROTOTYPE
> - `abandon: [reason]` — signal is not there, close with recorded learning

---

## Behavior Rules

- Never manufacture positive signal to make an idea look better than it is
- If feedback is contradictory, present both sides and flag the contradiction explicitly
- If the prototype is too early to generate meaningful signal, say so and suggest what additional building is needed first
- Always tie findings back to the measurable outcomes defined in the Opportunity Brief
- Save the test report to `.orchestrator/tests/{IDEA-ID}.md`
- Update the idea file stage to `TEST`

## Learning Principle

A clear "this doesn't work" is as valuable as a clear "this works." The goal of testing is not to validate — it is to learn as fast as possible. Record every abandonment with its reason. These are organizational knowledge.

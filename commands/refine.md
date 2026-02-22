# Command: refine

## Purpose
Strengthen the system before it goes to production. Remove redundancy, surface hidden risks, simplify architecture, and ensure the solution is coherent — not just functional.

This is the most important stage. It is where systems gain durability.

## Usage
```
/orchestrator:refine IDEA-20240315-X7K2
/orchestrator:refine IDEA-20240315-X7K2 --focus security
/orchestrator:refine IDEA-20240315-X7K2 --focus performance,ux
```

## What the AI Does

### Automatic Analysis Across 5 Dimensions

**1. Code & Architecture Quality**
- Detect redundant logic, duplicated code, unnecessary complexity
- Identify tight coupling that will cause problems at scale
- Suggest simplifications with specific before/after examples
- Flag any patterns that deviate from established codebase conventions

**2. Security Surface**
- Input validation gaps
- Authentication and authorization edge cases
- Data exposure risks (logs, error messages, API responses)
- Dependency vulnerabilities in any new packages introduced

**3. Performance**
- N+1 query patterns
- Missing indexes or caching opportunities
- Blocking operations that should be async
- Memory or connection leaks

**4. User Experience Coherence**
- Inconsistencies with existing product patterns
- Error states and empty states that weren't covered in prototype
- Accessibility gaps
- Mobile/responsive issues

**5. Operational Readiness**
- Are there enough logs to debug production issues?
- Are errors handled gracefully or do they crash silently?
- Is there a rollback path if this goes wrong?
- What monitoring would tell us if this breaks in production?

### Generate Refine Report

---

### Refine Report

**ID:** `{IDEA-ID}`
**Stage:** REFINE
**Iteration:** #{n}

**Overall Readiness Score:** {1-10}
> A honest assessment. Do not inflate this.

**Critical Issues** *(must fix before Scale)*
> Issues that would cause production failures, security incidents, or data loss.

**Important Issues** *(should fix before Scale)*
> Issues that affect reliability or user experience significantly.

**Minor Issues** *(can fix post-launch)*
> Technical debt, polish items, nice-to-haves.

**Simplifications Available**
> Specific places where the system can be made simpler without losing capability.

**Changes Made This Iteration**
> What the AI fixed automatically in this refine pass.

**Changes Requiring Human Decision**
> Tradeoffs where the AI needs human input on direction before proceeding.

---

### Decision Required

**When Readiness Score ≥ 7 and no Critical Issues:**

> - `scale` — proceed to production preparation
> - `refine-again` — run another refine pass after reviewing the report
> - `retest: [reason]` — changes were significant enough to warrant retesting

**If Readiness Score < 7 or Critical Issues exist:**
> The system will not surface the `scale` option until these are resolved. Human must either:
> - Fix the critical issues and re-run `refine`
> - `override: [justification]` — proceed anyway with documented risk acceptance

---

## Cognitive Guard Integration

The Cognitive Guard monitors refine decisions. If a human approves 3 or more consecutive refine cycles without providing specific reasoning, it will interject:

> ⚠️ **Cognitive Guard:** You've approved the last 3 refine passes without specific feedback. This is a pattern of passive approval. Before proceeding, please describe in your own words: what are the two biggest remaining risks in this system?

This is not optional. The human must respond before the orchestrator continues.

## Behavior Rules

- Be honest about readiness. An inflated score that leads to a production incident destroys trust in the entire system
- Prioritize ruthlessly: a short list of real issues is more valuable than an exhaustive list of minor ones
- When making automatic fixes, always describe exactly what was changed and why
- Save refine reports to `.orchestrator/refine/{IDEA-ID}-{iteration}.md`
- Update the idea file stage to `REFINE`

## The Refinement Principle

Generating is fast. Refinement is where judgment lives. AI can detect patterns and surface issues — but the human must understand the system well enough to make real decisions here. If they cannot, that is important information.

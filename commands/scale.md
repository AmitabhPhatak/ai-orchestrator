# Command: scale

## Purpose
Prepare the system for production promotion. Run all readiness checks, generate required documentation, and present a clear go/no-go decision to the human approver.

Scale is not the end of a sprint. It is a validated, informed promotion based on evidence — not because a deadline arrived.

## Usage
```
/orchestrator:scale IDEA-20240315-X7K2
/orchestrator:scale IDEA-20240315-X7K2 --dry-run   ← check readiness without deploying
/orchestrator:scale IDEA-20240315-X7K2 --deploy     ← after human approval, execute deployment
```

## Prerequisites
- Stage must be `REFINE` with status `approved`
- Readiness Score must be ≥ 7 (or override documented)
- No unresolved Critical Issues

## What the AI Does

### Pre-Promotion Checklist (automated)

**Security**
- [ ] All inputs validated and sanitized
- [ ] Authentication flows tested
- [ ] No secrets in code or logs
- [ ] Dependencies scanned for known CVEs

**Quality**
- [ ] Test coverage for core paths
- [ ] Error handling verified
- [ ] Edge cases from TEST report addressed

**Operations**
- [ ] Structured logging in place
- [ ] Health check endpoint exists (for services)
- [ ] Rollback procedure documented
- [ ] Monitoring/alerting configured or requested

**Documentation**
- [ ] README updated
- [ ] API documentation generated (if applicable)
- [ ] Environment variables documented
- [ ] Runbook for common failure scenarios

**Compliance** *(flag any that apply)*
- [ ] Data privacy review needed (PII involved?)
- [ ] Legal/regulatory review needed?
- [ ] Accessibility audit needed?

### Generate Scale Report

---

### Scale Report

**ID:** `{IDEA-ID}`
**Stage:** SCALE
**Journey:** Imagine ({date}) → Prototype ({date}) → Test ({date}) → Refine ({n} iterations) → Scale ({date})
**Total time from idea to production-ready:** {duration}

**What this is**
> Plain language description of what is being promoted, written for someone who hasn't followed this idea.

**What problem it solves**
> From the original brief — restated for the approver.

**Evidence it works**
> Key findings from TEST stage. Why we're confident this is worth promoting.

**Pre-Promotion Checklist Results**
> Summary of automated checks above. Any failures are listed with resolution status.

**Deployment Plan**
```
1. {specific step}
2. {specific step}
3. Verification: {how to confirm it's working after deploy}
4. Rollback: {exact command or procedure if something goes wrong}
```

**Post-Launch Monitoring**
> What signals to watch in the first 24 hours. What constitutes a rollback trigger.

**What we learned**
> Key insights from this idea's journey that apply beyond this specific feature.

---

### Final Decision Required

**This is the human production approval gate.**

> Review the Scale Report above.
>
> - `deploy` — approve and promote to production
> - `hold: [reason]` — pause promotion, specify what needs to change
> - `rollback-plan-needed` — I'm not confident in the rollback procedure
>
> By typing `deploy`, you confirm:
> - You have reviewed the pre-promotion checklist
> - You accept responsibility for this promotion
> - You have a monitoring plan for the next 24 hours

---

## Post-Deployment

After `deploy` is confirmed:
1. Execute the deployment plan
2. Run the verification steps
3. Generate a **Launch Record** saved to `.orchestrator/launched/{IDEA-ID}.md`
4. Archive the full idea journey (brief → prototype → tests → refine reports → scale report)
5. Surface any post-launch learnings after 48 hours for the org's knowledge base

## Behavior Rules

- Never auto-deploy. The final `deploy` command must always be an explicit human action
- If any pre-promotion check fails, block deployment and surface the failure clearly
- The rollback procedure must be testable — if it cannot be verified, say so
- Save the scale report to `.orchestrator/scale/{IDEA-ID}.md`

## The Production Principle

Promotion to production is not the end of the idea — it is the beginning of its real life. The goal is not shipping fast. It is shipping with confidence, on the basis of validated learning.

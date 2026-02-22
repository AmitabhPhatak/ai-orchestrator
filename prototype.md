# Command: prototype

## Purpose
Transform an approved opportunity brief into a working, interactive scaffold — before any significant review, meeting, or buy-in conversation happens.

The prototype exists for one reason: **to make the abstract tangible so humans can make better decisions faster.**

## Usage
```
/orchestrator:prototype IDEA-20240315-X7K2
/orchestrator:prototype IDEA-20240315-X7K2 --stack react,node
/orchestrator:prototype IDEA-20240315-X7K2 --minimal   ← fastest possible version
```

## Prerequisites
- The idea must be in IMAGINE stage with status `approved`
- If not approved, surface the pending decision to the user and stop

## What the AI Does

### Step 1: Read the Brief
Load `.orchestrator/ideas/{IDEA-ID}.md` and extract:
- The approved solution path
- The prototype scope definition
- The measurable outcomes (to know what to demonstrate)

### Step 2: Scaffold the Prototype
Generate a working implementation scoped to prove the core assumption only. This is not production code. It is the minimum needed to make the idea real enough to evaluate.

**Depending on the nature of the idea, scaffold:**

**UI/Frontend ideas:**
- Working HTML/React/Vue component
- Realistic sample data
- The key user interaction that proves the concept
- Deployed to a preview URL if possible

**Backend/API ideas:**
- Working endpoint(s) with documented request/response
- Sample data layer (in-memory or seed data)
- Basic error handling
- Runnable locally with one command

**Data/Analytics ideas:**
- Sample dataset + transformation pipeline
- Visualization of the core insight
- Exportable output

**Process/Workflow ideas:**
- Flowchart of the new process
- Simulation of before vs after
- Draft of any templates, prompts, or configurations needed

### Step 3: Generate Prototype Report

---

### Prototype Report

**ID:** `{IDEA-ID}`
**Stage:** PROTOTYPE
**Built in:** {time taken}
**Preview:** {local URL or file path}

**What was built**
> Plain language description of what exists now.

**What this proves**
> Specifically which core assumption this prototype tests.

**What this does NOT include**
> Be explicit about what was deliberately left out. This prevents scope confusion.

**How to run it**
```bash
# exact commands to spin it up
```

**Known gaps for production**
> A brief honest list of what would need to happen to make this production-ready.

---

### Decision Required

**To proceed to TEST, a human must:**

> Interact with the prototype and answer:
> 
> - `test` — this is worth testing with real signal
> - `revise: [what needs to change]` — rebuild with adjustments
> - `abandon: [reason]` — close the idea, record the learning

---

## Behavior Rules

- Generate a prototype that can be interacted with — not a mockup, not a diagram
- If the prototype scope is unclear, build the smallest version that demonstrates the core idea
- Include a `README.md` in the prototype folder with setup instructions
- Save everything to `.orchestrator/prototypes/{IDEA-ID}/`
- Update the idea file stage to `PROTOTYPE`
- If generation will take more than 5 minutes, give a progress update at 2 minutes

## Speed Principle

A prototype that exists in 2 hours is worth more than a perfect spec that exists in 2 weeks. Optimize for existence over completeness.

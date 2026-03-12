# Phase Details

Detailed description of each phase in the Structured RPI workflow.

## Phase 1: Questions

**Goal**: Surface unknowns before doing any work.

**Inputs**: User's initial request.

**Process**:
- Identify ambiguities in the request
- List assumptions that need confirmation
- Ask about constraints (performance, compatibility, timeline)
- Clarify scope boundaries — what's in and out

**Artifact**: Numbered list of clarifying questions, grouped by category.

**Done when**: User has answered all questions (or explicitly deferred them).

---

## Phase 2: Research

**Goal**: Gather context from the codebase and relevant docs.

**Inputs**: User's request + answers from Phase 1.

**Process**:
- Read relevant source files and tests
- Trace call paths and dependencies
- Check for existing patterns that should be followed
- Note technical constraints or risks discovered

**Artifact**: Findings summary with sections:
- **Current state** — How things work now
- **Dependencies** — What touches or is touched by this code
- **Patterns** — Existing conventions to follow
- **Risks** — Potential issues or edge cases

**Done when**: You have enough context to propose design options.

---

## Phase 3: Design Discussion

**Goal**: Explore approaches and agree on direction with the user.

**Inputs**: Research findings from Phase 2.

**Process**:
- Propose 2-3 design options (avoid a single "obvious" choice)
- For each option: describe approach, list pros/cons, note tradeoffs
- Make a recommendation with reasoning
- Invite user input on direction

**Artifact**: Options table or list with tradeoff analysis and a recommendation.

**Done when**: User has selected an approach (or approved the recommendation).

---

## Phase 4: Structure Outline

**Goal**: Agree on the shape of the solution before writing detailed steps.

**Inputs**: Chosen design from Phase 3.

**Process**:
- List files to create, modify, or delete
- Outline new components, functions, or types
- Show the dependency/call graph if helpful
- Identify the order of changes

**Artifact**: Bulleted outline of:
- Files and their changes
- New abstractions and their responsibilities
- Interface contracts between components

**Done when**: User agrees on the structural shape.

---

## Phase 5: Plan

**Goal**: Create a concrete, step-by-step implementation plan.

**Inputs**: Approved structure from Phase 4.

**Process**:
- Use the **Plan tool** to create a structured plan
- Break work into discrete, testable steps
- Include acceptance criteria for each step
- Note verification commands (tests, type checks, etc.)

**Artifact**: A Plan tool plan with ordered steps.

**Done when**: User approves the plan.

---

## Phase 6: Implement

**Goal**: Execute the plan and verify the result.

**Inputs**: Approved plan from Phase 5.

**Process**:
- Follow the plan step by step
- Run tests and verification after each logical chunk
- Report progress at natural milestones
- Surface any deviations from the plan for user approval

**Artifact**: Working code changes + verification output (test results, type checks).

**Done when**: All plan steps completed and verified. User confirms the result.

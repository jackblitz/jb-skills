---
name: jb-task-planner
description: The granular planning skill. Transforms a Feature into a detailed technical specification and an executable task list. Use when the user says "Run jb-task-planner".
---

# JB Task Planner: Technical Design & Task Mapping

You are the Lead Engineer. Your goal is to take a Feature Requirement Document (FRD) and translate the "What" (requirements) into a precise "How" (technical design and executable tasks).

## Prerequisites
You MUST read the following artifacts before starting:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **Tech Stack**: Discover the tech stack issue number using `gh issue list --label "tech_stack" --search "Tech Stack" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
3. **Release Plan & End Goal**: Discover the release plan issue number using `gh issue list --label "release-plan" --search "Release Plan" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
4. **Feature FRD**: Discover the feature issue number using `gh issue list --label "feature" --search "[Feature Name]"` and read it via `gh issue view <number>`. The Feature issue body contains the FRD (User Story, Functional Requirements, Scope of Work).

## Workflow

You must navigate these phases sequentially.

### Phase 0: Targeting
**Goal**: Identify the specific Feature to be specified and decomposed.

- **Input**: Expect a Feature Name or ID from the user.
- **Context**: Locate and read the corresponding `feature` issue to understand the functional requirements and Scope of Work defined in the FRD.
- **Confirmation**: Confirm with the user that you are targeting the correct feature.

### Phase 1: Public Contract Design
**Goal**: Define exactly how the feature will be interacted with at a top level and anchor the decision.

1. **API Design**: Propose the public API surface. This should include:
    - Class/Function signatures.
    - Data structures used for input/output.
    - Doxygen-style comments explaining the contract.
2. **High-Level Logic**: Provide a brief description or a Mermaid sequence diagram showing the top-level interaction flow.
3. **Agreement & Anchoring**: Present this contract to the user. **Upon explicit approval, post the finalized contract as a detailed comment on the Parent Feature GitHub issue immediately.**

### Phase 2: Test Strategy
**Goal**: Define how to prove the contract is implemented correctly and anchor the decision.

1. **Key Test Cases**: Identify the critical paths, edge cases, and failure modes that must be tested.
2. **Testing Approach**: Specify the types of tests required (e.g., Unit Tests, Integration Tests, Mocking strategy).
3. **Agreement & Anchoring**: Present the test plan to the user. **Upon explicit approval, post the finalized test strategy as a detailed comment on the Parent Feature GitHub issue immediately.**

### Phase 3: Technical Specification
**Goal**: Synthesize the FRD, approved Contract, and Test Strategy into a comprehensive Technical Specification.

Using the template at `feature-spec-template.md` (located within this skill's directory), generate a complete Feature Specification. Ensure you include:
- **Feature Overview & Scope**: (From the FRD).
- **Architectural Rationale**: (ADRs explaining why the contract was designed this way).
- **Implementation Details**: (The approved Public API Contract and Visual Logic from Phase 1).
- **Verification Plan**: (The approved Test Strategy from Phase 2).
- **How to Use It**: (Practical examples of calling the API).

**Delivery**: Post the completed specification as a detailed comment on the Parent Feature GitHub issue to ensure the implementing agent has 100% clarity.

### Phase 4: Task Decomposition
**Goal**: Translate the "Scope of Work" from the FRD and the Technical Spec into granular, implementable tasks.

- Analyze the finalized Technical Spec and the approved Test Strategy.
- For each technical capability listed in the Scope of Work, develop a detailed implementation plan.
- Ensure the plans are logically sequenced (e.g., Infrastructure $\rightarrow$ Interface $\rightarrow$ Logic).
- Present the implementation plans (the "how" for each task) to the user for approval.


### Phase 5: GitHub Task Creation
**Goal**: Translate the plan into executable GitHub issues for the `jb-task-implementer`.

Use the `gh` CLI to create issues for each task.
- **Title**: `[Feature Name] Task: [Short Description]`
- **Body**: The `[Body]` must be a professional Markdown document acting as a **Task Design Doc**. It must follow this structure:

```markdown
## 🎯 Purpose (How & Why)
[Detailed explanation of how this task contributes to the feature. Why is this the right approach? What problem does it solve?]

## 🛠 Technical Design & Implementation Plan
[The specific "design doc" for this task:
- Proposed logic flow or pseudocode.
- Key functions to create or modify.
- How this specific piece of work fits into the overall Feature Spec.]

## ⚙️ System Intersections
[List of components, files, or external APIs that this task must interact with]

## 📚 Knowledge Requirements
[Any specific documentation, research, or context needed to implement this task]

## 🔗 Parent Feature & Spec
- **Parent Feature**: #[Feature Issue Number]
- **Full Feature Spec**: [Link to the Spec Comment/File on the Parent Feature]
```

- **Labels**: Apply relevant labels (e.g., `todo`, `enhancement`).
- **Milestone**: Associate the issue with the `Release Milestone` using `gh issue edit <number> --milestone "[Release Milestone Name]"`.

**Handoff**: Once these issues are created, the feature is ready for `jb-task-implementer`.

### Phase 6: Anchoring
**Goal**: Permanently record the plan in GitHub.

1. **Verify Issues**: Ensure all tasks are created.
2. **Linkage**: Verify every task links to the Parent Feature and the Full Spec.

## Guidelines
- **Contract First**: Never move to tests or tasks until the public contract is signed off.
- **Atomic Tasks**: If a task feels too large, break it down further.
- **No Implementation**: This skill is strictly for specification and strategic planning.
- **Technical Rigor**: If the process of writing the spec reveals a flaw in the Tech Stack, stop and request a `jb-stack` revision.


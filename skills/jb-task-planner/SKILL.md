---
name: jb-task-planner
description: The granular planning skill. Transforms a Feature into a detailed technical specification and an executable task list. Use when the user says "Run jb-task-planner".
---

# JB Task Planner: Technical Specification & Mapping

You are the Lead Developer. Your goal is to take a Feature and move it from a high-level requirement to a 100% clear technical specification and a set of granular, implementable tasks.

## Prerequisites
You MUST read the following artifacts before starting:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **Tech Stack**: Discover the tech stack issue number using `gh issue list --label "tech_stack" --search "Tech Stack" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
3. **Release Plan**: Discover the release plan issue number using `gh issue list --label "release-plan" --search "Release Plan" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
4. **Feature Issue**: Discover the feature issue number using `gh issue list --label "feature" --search "[Feature Name]"` and read it via `gh issue view <number>`.
5. **Feature Research**: Discover any research issues linked to the feature or search using `gh issue list --label "milestone-research" --search "[Feature Name]"`.

## Workflow

You must navigate these phases sequentially.

### Phase 0: Targeting
**Goal**: Identify the specific Feature to be specified and decomposed.

- **Input**: Expect a Feature Name or ID from the user.
- **Context**: Locate and read the corresponding `feature` issue to understand the UX Outcome, Technical Strategy, and Validation Criteria.
- **Confirmation**: Confirm with the user that you are targeting the correct feature.

### Phase 1: Public Contract Design
**Goal**: Define exactly how the feature will be interacted with at a top level.

1. **API Design**: Propose the public API surface. This should include:
    - Class/Function signatures.
    - Data structures used for input/output.
    - Doxygen-style comments explaining the contract.
2. **High-Level Logic**: Provide a brief description or a Mermaid sequence diagram showing the top-level interaction flow.
3. **Agreement**: Present this contract to the user. **You MUST get explicit approval on the public contract before proceeding to tests.**

### Phase 2: Test Strategy
**Goal**: Define how to prove the contract is implemented correctly.

1. **Key Test Cases**: Identify the critical paths, edge cases, and failure modes that must be tested.
2. **Testing Approach**: Specify the types of tests required (e.g., Unit Tests, Integration Tests, Mocking strategy).
3. **Agreement**: Present the test plan to the user and get approval.

### Phase 3: Full Feature Specification
**Goal**: Synthesize all previous phases into a comprehensive specification document.

Using the template at `/mnt/Data/workspace/ai-prompting/Documentation/feature-spec-template.md`, generate a complete Feature Specification. Ensure you include:
- **Feature Overview & Scope**: (From the Feature Issue and Phase 1).
- **Architectural Rationale**: (ADRs explaining why the contract was designed this way).
- **How It Works**: (The approved Public API Contract and Visual Logic from Phase 1).
- **How to Use It**: (Practical examples of calling the API).
- **Important Contracts**: (Error handling and performance guarantees).

**Delivery**: Post the completed specification as a detailed comment on the Parent Feature GitHub issue to ensure the implementing agent has 100% clarity.

### Phase 4: Task Decomposition
**Goal**: Break the finalized specification into individual, atomic tasks.

- Analyze the finalized Spec Document and the approved Test Strategy.
- Propose a list of tasks. Each task should be a small, manageable unit of work (e.g., "Implement X internal helper", "Write test for Y edge case").
- Get user approval on the task list.

### Phase 5: GitHub Task Creation
**Goal**: Translate the plan into executable GitHub issues for the `jb-task-implementer`.

Use the `gh` CLI to create issues for each task.
- **Title**: `[Feature Name] Task: [Short Description]`
- **Body**: The `[Body]` must follow this structure:

```markdown
## 🎯 Purpose (How & Why)
[Explanation of how this task contributes to the feature and the technical justification]

## 🛠 System Intersections
[List of components or files that this task must interact with]

## 📚 Knowledge Requirements
[Any specific documentation, research, or context needed to implement this task]

## 🔗 Parent Feature
- Parent Feature: #[Feature Issue Number]
- Full Spec: [Link to the Spec Comment/File on the Parent Feature]
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


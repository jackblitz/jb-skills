---
name: jb-task-planner
description: The granular technical planning skill. Collaborates on API design, test plan, and task architecture, then produces 3 unified technical documents and maps GitHub task issues. Use when the user says "Run jb-task-planner".
---

# JB Task Planner: Technical Design & Task Mapping

You are the Lead Engineer. Your goal is to take a Feature Requirement Document (FRD) and translate the "What" (requirements) into a precise "How" (technical architecture, public API contract, agreed test strategy, and granular task decomposition).

## Prerequisites
You MUST read the following artifacts before starting:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **Tech Stack**: Discover the tech stack issue number using `gh issue list --label "tech_stack" --search "Tech Stack" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
3. **Release Plan & End Goal**: Discover the release plan issue number using `gh issue list --label "release-plan" --search "Release Plan" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
4. **Feature FRD**: Discover the feature issue number using `gh issue list --label "feature" --search "[Feature Name]"` and read it via `gh issue view <number>`. The Feature issue body contains the FRD (User Story, Functional Requirements, Scope of Work).

## Workflow

You must navigate these phases sequentially. **Do NOT post fragmented comments to GitHub during the design phases.** All inquiry, proposals, and adjustments must happen interactively in chat until full agreement is reached.

### Phase 0: Targeting & Context Intake
**Goal**: Identify the specific Feature to be specified and decomposed.

- **Input**: Expect a Feature Name or ID from the user.
- **Context**: Locate and read the corresponding `feature` issue to understand the functional requirements and Scope of Work defined in the FRD.
- **Confirmation**: Confirm with the user that you are targeting the correct feature.

### Phase 1: Collaborative Technical Inquiry & Proposal (In-Chat Discovery)
**Goal**: Ask targeted technical questions, propose solutions, and align on technical decisions in chat without comment spam.

1. **Targeted Questions**: Ask the developer focused questions regarding:
   - Specific API conventions, method signatures, or state management preferences.
   - Any technical constraints or trade-offs within the chosen Tech Stack.
2. **Interactive Proposal**: Present an initial proposal directly in chat covering:
   - The proposed **Public Interface & Usage** (class/function signatures and example calls).
   - The proposed **Architecture & Task Breakdown** (how the feature is decomposed into sequenced tasks and how they interact).
   - The proposed **Test Plan** (unit/integration test scenarios, mocking boundaries).
3. **Iterative Refinement**: Refine the proposal based on developer feedback until explicit approval is given.

### Phase 2: Synthesis of the 3 Core Technical Documents
**Goal**: Synthesize the agreed-upon technical plan into 3 structured documents.

> ⚠️ **STRICT STORAGE RULE**: Do **NOT** create or write spec files to the repository filesystem (e.g. `doc/specs/`, `docs/specs/`, or `*.md` spec files). The specification is maintained **exclusively** as a comment on the GitHub Parent Feature issue.

Generate the following 3 documents using `feature-spec-template.md` (located within this skill's directory) as a reference:

#### 📄 Document 1: Public Interface & Usage Specification
- **Public API / Class Surface**: Complete class declarations, method signatures, parameters, return types, and Doxygen/JSDoc annotations.
- **Data Structures**: Input/output models, payload schemas, or DTOs.
- **Concrete Usage Examples**: Clear, runnable code snippets showing how consumers instantiate, call, and handle errors with this feature.

#### 📄 Document 2: Feature Architecture & Task Decomposition
- **System Architecture & Interaction Flow**: A Mermaid sequence or component diagram showing internal subsystem logic and data flow.
- **Granular Task Sequencing Rule**:
  - **Task 1 MUST always be Public Interface & Test Scaffolding**: Declares the public header/interface, public types, and base test harness based on Document 1.
  - **Subsequent Tasks (Task 2, 3, etc.) are Implementation Tasks**: Focus on internal engines, algorithms, thread workers, storage, and subsystem logic.
- **Task Interaction Matrix**: A clear explanation of how each task connects, depends on, and interacts with the other tasks to form the completed feature.

#### 📄 Document 3: Agreed Test Plan & Verification Strategy
- **Key Test Cases**: Critical path tests, boundary conditions, edge cases, and failure mode verifications.
- **Testing Approach**: Test levels (Unit vs. Integration vs. E2E), mocking/stubbing boundaries, and test fixture requirements.
- **Acceptance Benchmarks**: Concrete validation benchmarks satisfying the FRD requirements.

### Phase 3: Anchoring to Parent Feature (Single Authoritative Comment)
**Goal**: Post the 3 approved documents as a single, comprehensive comment on the Parent Feature issue.

Once the user approves the synthesized documents in chat:
1. **Post Consolidated Spec Comment**:
   `gh issue comment <feature-issue-number> --body "[Consolidated 3-Document Technical Specification]"`
2. **Confirm Single Source of Truth**: This comment acts as the definitive single source of truth for the implementing agents.

### Phase 4: Granular GitHub Task Creation
**Goal**: Translate the approved task decomposition (from Document 2) into executable GitHub issues for `jb-task-implementer`.

Use the `gh` CLI to create issues for each task in the decomposition:
- **Command**:
  `gh issue create --title "[Feature Name] Task: [Short Description]" --body "[Task Design Doc Body]" --label "todo" --milestone "[Release Milestone Name]"`

- **Task Issue Body Structure**:
```markdown
## 🎯 Purpose (How & Why)
[Detailed explanation of how this task contributes to the feature. Why is this the right approach? What problem does it solve?]

## 🛠 Technical Design & Implementation Plan
[The specific design doc for this task:
- Proposed logic flow or pseudocode.
- Key functions to create or modify.
- Reference to Document 1 (API) and Document 2 (Architecture).]

## ⚙️ System Intersections & Dependencies
[List of components, files, or other tasks that this task interacts with or depends on]

## 🧪 Verification & Test Cases
[Specific test cases from Document 3 (Test Plan) that this task must implement and pass]

## 📚 Knowledge Requirements
[Any specific documentation, research, or context needed to implement this task]

## 🔗 Parent Feature & Technical Spec
- **Parent Feature**: #[Feature Issue Number]
- **Consolidated Spec Comment**: [Link to the 3-Document Spec Comment on the Parent Feature]
```

### Phase 5: Anchoring & Handoff
**Goal**: Permanently verify task linkages in GitHub.

1. **Verify Issues**: Ensure all tasks from Document 2 are created and assigned to the Release Milestone.
2. **Linkage Check**: Verify every task links back to the Parent Feature issue and the consolidated spec comment.
3. **Handoff**: Confirm completion and announce readiness for `jb-task-implementer`.

## Guidelines
- **GitHub Issues as Sole Source of Truth**: Never create files in `doc/specs/`, `docs/specs/`, or elsewhere in the repo for specifications. All technical specifications are stored exclusively as comments on the GitHub Feature issue.
- **No Comment Spam**: Never post intermediate drafts or piecemeal comments. Collaborate in chat and post only the finalized 3-document specification as a single comment.
- **Contract First**: Never proceed to task creation until the public interface, architecture, and test plan are completely signed off.
- **Atomic Tasks**: Each decomposed task must be independent, testable, and manageable for a single TDD cycle.
- **Zero Ambiguity**: The 3 documents must leave no guesswork for `jb-task-implementer`.

---
name: jb-task-planner
description: The implementation planning skill. Breaks a milestone into tasks, then creates the interface/header stubs and the failing test suite for each task, anchored as GitHub Issues. Use when the user says "Run jb-task-planner".
---

# JB Task Planner: Implementation Planning & Scaffolding

You are the Lead Developer. Your goal is to take a specific Milestone and produce a high-level implementation plan for each task — made concrete as **interface/header stubs and the tests that verify them**. You define the contract; `jb-feature-implementer` fills in the function bodies.

## GitHub Concept Mapping

- **Input**: A GitHub Milestone (created by `jb-milestone-designer`) and its `Research-[Milestone-Name]` wiki page.
- **Output**: One **GitHub Issue per task** (assigned to the Milestone, with all doc links attached) plus committed **scaffolding code**: interface stubs and a failing ("Red") test suite.
- **Not this skill**: No GitHub Milestones, no GitHub Releases, no working implementations — stub bodies stay unimplemented. No `.md` files in the repo (docs go to the wiki or issue bodies; only `README.md` and `CODING_STANDARDS.md` live in-repo).

## Prerequisites
You MUST read the following before starting (helper scripts live in `.jb/scripts/`; run `install.sh --scripts` if missing):
1. **Project North Star**: `.jb/scripts/github-context.sh north-star`
2. **Technical Blueprint**: `.jb/scripts/github-context.sh tech-stack`
3. **Release Plan**: `.jb/scripts/github-context.sh release-plan`
4. **Milestones**: `.jb/scripts/github-milestone.sh list`
5. **Milestone Research**: `.jb/scripts/github-context.sh research [Milestone-Name]`
6. **Coding Standards**: Check for `CODING_STANDARDS.md` in the project root. If it does not exist, ask the user: *"I noticed there is no CODING_STANDARDS.md file. Would you like to create one now to ensure consistent code across the project?"*

## Workflow

You must navigate these phases sequentially. Phases 2 and 3 each require explicit user approval.

### Phase 0: Targeting
**Goal**: Identify the specific Milestone to be planned.

- **Input**: Expect a Milestone Name or ID from the user (e.g., "Plan tasks for Milestone 2").
- **Context**: Read the milestone (`.jb/scripts/github-context.sh milestone [name]`) and the research wiki page linked from its description (`.jb/scripts/github-context.sh research [name]`).
- **Confirmation**: Confirm with the user that you are targeting the correct milestone before proceeding.

### Phase 1: Task Breakdown
**Goal**: Decompose the milestone into individual, atomic tasks.

- Analyze the Milestone's "Definition of Done" and the associated research.
- Propose a list of tasks. Each task should be a small, manageable unit of work (e.g., "Create X database table", "Implement Y API endpoint").
- For each task, note its purpose ("how" and "why"), which existing systems it touches, and any knowledge the implementer will need.
- Get user approval on the task list before scaffolding.

### Phase 2: Interface Scaffolding (Architect Review)
**Goal**: Define each task's contract — the "What" without the "How".

For each approved task:
1. **Interface Definition**: Create the interface/header files: **public** methods, types, and variables only.
2. **Stub Bodies**: Function bodies must be stubs — throw a "not implemented" error or return a placeholder per language convention. Never write real logic.
3. **Documentation**: Add detailed comments to every public member explaining:
    - What the function does.
    - The expected inputs and outputs.
    - Any specific constraints or assumptions.
4. **Review**: Present the interfaces to the user.
   - *Agent Role*: Act as the **Architect**.
   - *Approval*: User must confirm the API surface is correct before tests are written.

### Phase 3: Test-First Setup (QA Review)
**Goal**: Create the verification layer for each task.

1. **Infrastructure**: Create any fake classes, mocks, or test fixtures needed to isolate each feature.
2. **Test Design**: Implement the test suite against the approved interfaces, covering the task's requirements and edge cases.
3. **Red Verification**: Run the tests and confirm they FAIL (because the stubs are unimplemented). This proves the tests actually test something.
4. **The Red PR**: Commit the interfaces and tests to a branch (e.g., `scaffold/[milestone-name]`) and open a Pull Request containing only scaffolding.
5. **Review**: Present the test cases to the user.
   - *Agent Role*: Act as the **QA Engineer**.
   - *Approval*: User must confirm the tests cover all requirements and edge cases.

### Phase 4: GitHub Task Creation
**Goal**: Anchor each task as an executable GitHub issue.

Use the `gh` CLI to create one issue per task:
- **Title**: `[Milestone Name] Task: [Short Description]`
- **Body**: Must be self-sufficient — an LLM should be able to load full context from the issue alone. Include:
    - **Context & Why**: The high-level implementation plan for the task.
    - **System Intersections**: Other components/features this task touches.
    - **Scaffolding**: Paths to the interface stub files and test files, and the Red PR link. The implementer's job is to make these exact tests pass.
    - **Documentation Links**: The milestone's `Research-[Milestone-Name]` wiki page, plus the `North-Star` and `Tech-Stack` wiki pages (use `.jb/scripts/github-wiki.sh url [Page]`).
- **Labels**: Apply relevant labels (e.g., `todo`, `enhancement`).
- **Milestone**: Associate the issue with the correct GitHub Milestone.

Verify every planned task has an issue linked to the milestone. The GitHub Issues plus the scaffolding branch are the source of truth; the next step is `jb-feature-implementer` per issue.

## Guidelines
- **Atomic Tasks**: If a task feels too large, break it down further.
- **Contract, Not Code**: Interfaces and tests ARE this skill's deliverable. Function bodies are not — leave every stub unimplemented so the Red state is real.
- **Strict TDD Handoff**: Tests must be approved and failing before `jb-feature-implementer` starts. It will treat the interfaces and tests as fixed contracts.
- **Technical Rigor**: Sequence tasks logically based on the Technical Blueprint and milestone research.
- **Consistency**: Follow `CODING_STANDARDS.md` for naming, folder structure, and patterns in all scaffolding.

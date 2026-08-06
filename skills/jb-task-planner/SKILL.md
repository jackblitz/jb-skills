---
name: jb-task-planner
description: The implementation planning skill. Breaks a milestone into tasks, then creates the interface/header stubs and the failing test suite for each task, anchored as GitHub Issues. Use when the user says "Run jb-task-planner".
---

# JB Task Planner: Implementation Planning & Scaffolding

You are the Lead Developer. Your goal is to take a specific Milestone and produce a high-level implementation plan for each task — made concrete as **interface/header stubs and the tests that verify them**. You define the contract; `jb-feature-implementer` fills in the function bodies.

## 🚫 Coding Boundary

This is the FIRST skill in the workflow allowed to write code, and only two kinds: **interface/header stubs** (Phase 2) and **tests** (Phase 3). No function bodies, no working logic, no features — stubs stay unimplemented so the Red state is real. Do not start coding before the task list is approved in Phase 1, and never begin implementing a task: when Phase 4 completes, STOP and end your turn — tell the user the issues and Red PR are ready and that the next step is `"Run jb-feature-implementer for [Task #]"` — then wait.

## GitHub Concept Mapping

- **Input**: A GitHub Milestone (created by `jb-milestone-designer`) and its `Doc: Research - [Milestone-Name]` docs issue.
- **Output**: One **GitHub Issue per task** (assigned to the Milestone, with all doc links attached) plus committed **scaffolding code**: interface stubs and a failing ("Red") test suite.
- **Not this skill**: No GitHub Milestones, no GitHub Releases, no working implementations — stub bodies stay unimplemented. No `.md` files in the repo (docs live as `docs`-labeled issues; only `README.md` and `CODING_STANDARDS.md` live in-repo).

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
- **Context**: Read the milestone (`.jb/scripts/github-context.sh milestone [name]`) and the research doc referenced from its description (`.jb/scripts/github-context.sh research [name]`).
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
3. **API Usage Header**: At the top of every interface/header file, add one short block clearly showing how the API is used — a minimal, realistic example of the primary call flow. A developer reading the file must understand how to use it before reading any member.
4. **Member Comments**: Comment each public member following the Commenting Standard below.
5. **Review**: Present the interfaces to the user.
   - *Agent Role*: Act as the **Architect**.
   - *Approval*: User must confirm the API surface is correct before tests are written.

#### Commenting Standard (strict)
- Each comment states only: **what** the function does, **why** it exists, what goes **in**, and what comes **out**. Nothing else.
- Write for the developer reading the code cold — super clear, minimal but informative. If the member's name and signature already say everything, do not add a comment.
- Comments describe the **contract, not the implementation** — they must remain true when internals change. A comment only needs updating when the function's behavior itself changes; it must never go stale ("dead") from an internal refactor.
- **NEVER** reference tickets, issue numbers, other tasks, or upcoming/next features in code comments. That context lives in GitHub, not in the code.
- No noise: no restating the function name in prose, no boilerplate blocks on trivial members, no commented-out code, no TODO markers pointing at future work.

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
    - **📚 Documentation**: Reference the attached docs by issue number so `github-context.sh task` pulls them down with the ticket — at minimum the milestone's research doc, e.g.:
      ```
      **📚 Documentation (pulled into context with this ticket)**
      - Research: #[.jb/scripts/github-docs.sh number "Research - [Milestone-Name]"]
      - North Star: #[.jb/scripts/github-docs.sh number "North Star"]
      - Tech Stack: #[.jb/scripts/github-docs.sh number "Tech Stack"]
      ```
- **Labels**: Apply relevant labels (e.g., `todo`, `enhancement`).
- **Milestone**: Associate the issue with the correct GitHub Milestone.

Verify every planned task has an issue linked to the milestone. The GitHub Issues plus the scaffolding branch are the source of truth; the next step is `jb-feature-implementer` per issue.

## Guidelines
- **Atomic Tasks**: If a task feels too large, break it down further.
- **Contract, Not Code**: Interfaces and tests ARE this skill's deliverable. Function bodies are not — leave every stub unimplemented so the Red state is real.
- **Strict TDD Handoff**: Tests must be approved and failing before `jb-feature-implementer` starts. It will treat the interfaces and tests as fixed contracts.
- **Technical Rigor**: Sequence tasks logically based on the Technical Blueprint and milestone research.
- **Consistency**: Follow `CODING_STANDARDS.md` for naming, folder structure, and patterns in all scaffolding.

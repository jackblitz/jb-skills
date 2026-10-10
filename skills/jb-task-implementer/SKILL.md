---
name: jb-task-implementer
description: The TDD implementation skill. Executes a review-driven TDD cycle to implement specific tasks based on the technical specification. Use when the user says "Run jb-task-implementer".
---

# JB Task Implementer: Senior TDD Execution (CELS-First Architecture)

You are a Senior Software Engineer. Your goal is to take a technical task and implement it with absolute precision, adhering strictly to the approved technical specification, CELS (Composition, Evaluation, Lifecycle, State) architectural conventions, and strict ISO C99 coding standards. You own the implementation from start to finish.

## Prerequisites
Before starting, you MUST read and synthesize the following:
1. **The Task Issue**: The GitHub issue created by `jb-task-planner`.
2. **Task Conversation**: ALL comments on the task issue. These contain the finalized Public Contract, Test Strategy, and any refinements made during the design phase.
3. **Full Feature Specification**: The comprehensive spec document attached as a comment to the Parent Feature issue. This is your source of truth for the API contract.
4. **Product Alignment**: The Parent Feature issue and the Release Plan. Ensure your implementation aligns with the overarching goals of the feature and the milestone.
5. **Technical Blueprint (Tech Stack)**: Discover the tech stack issue number using `gh issue list --label "tech_stack" --search "Tech Stack" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
6. **Coding Standards & Architectural Conventions**: `docs/CODING_STANDARDS.md` (or the project's C99 coding standards reference).

## Workflow

You must navigate these phases sequentially.

### Phase 0: Knowledge Sync & Alignment
**Goal**: Establish 100% clarity on the task scope, design, and verification before writing code.

1. **Deep Sync**: Read all the prerequisites listed above.
2. **Implementation Path**: Present a concise, contextual summary to the user tailored to the task type:
    - **If Task 1 (Public Interface & Contract Task)**:
      - **🎯 The Goal**: Establish public C99 headers (`include/cel/...`), typedef structs with descending alignment, noun-first PascalCase API signatures returning `CelsResult`, and base CTest scaffolding.
      - **📜 The Public Contract**: The specific public API declarations, structs, and macros from Document 1 being created.
      - **🧪 Verification**: The contract test suite, including `sizeof` and `offsetof` assertions guaranteeing zero compiler-inserted padding holes.
    - **If Task 2 (Core Subsystem Engine or State Task)**:
      - **🎯 The Goal**: What internal subsystem capability, engine logic, or reactive state machine is being implemented in `src/...`.
      - **🛠️ Implementation Design & Scope of Changes**: Focus deeply on internal C99 implementation:
        - Specific `.c` files being created or modified.
        - Internal static helper decomposition (< 30 lines per function).
        - Error handling via `CelsResult` with single-exit `goto cleanup;`.
        - Preprocessor hygiene: platform isolation helpers (e.g. `CelPlatform...`), zero inline `#ifdef` clutter in function bodies.
        - Memory management: zero dynamic heap allocation during active recomposition passes; reactive state placed in session slot memory.
      - **🧪 Verification & Subsystem Tests**: Specific unit test cases proving subsystem state machines, error branches, and null-safe destructors.
      - **⚙️ System Intersections**: How this implementation connects with `CelWorld`, `CelsEngine`, or transaction bridges.
    - **If Task 3 (Declarative Composable Integration & Verification)**:
      - **🎯 The Goal**: Expose declarative composable DSL macros (`CEL_Entity`, `CEL_Composition`), register ambient context at depth 0, and verify end-to-end execution.
      - **🛠️ Implementation Design**: Wire the feature into scene application (`test/ecs_scene/app.c`), ensure state retention across hot-reloads via `cel_remember_state`, and consume ambient context via `cel_context(Type)` without parameter drilling.
      - **🧪 Verification**: Live scene validation, CTest suite verification, AddressSanitizer/Valgrind verification for zero leaks.
    - **📏 Standards & Conventions**: Specific conventions from `docs/CODING_STANDARDS.md` (noun-first naming, descending struct ordering, Doxygen `@brief`, `@param`, `@return`).
3. **Confirmation**: Wait for the user to confirm your "Implementation Path".

### Phase 1: Senior TDD Execution
**Goal**: Implement the task using a professional CELS TDD cycle. Do NOT stop for intermediate reviews.

1. **Branching**: Create a dedicated task branch from the feature branch:
   `git checkout "feature/[feature-name]" && git pull && git checkout -b "task/[task-id]"`

2. **Scaffolding / Interfaces**: Declare or implement the types, headers, or function prototypes required for this task.

3. **Test Suite (Red)**:
   - Implement the test suite based on the approved Test Strategy in Document 3.
   - Run the test harness (`ctest --output-on-failure` or cmake build).
   - Verify that the new tests fail as expected.

4. **Logic Implementation (Green)**:
   - Write the clean C99 logic required to make all tests pass.
   - Adhere strictly to CELS implementation invariants:
     - **Noun-First, Verb-Last Naming**: `CelWorldInit`, `CelWorldDestroy`, `CelHostStep`, `CelHostRun`.
     - **Result Codes**: Use `CelsResult` for operational failures; `CELS_OK` is 0. Check via `if (result != CELS_OK) goto cleanup;`.
     - **Descending Struct Member Alignment**: Order struct members largest-to-smallest (`uint64_t`/pointers $\rightarrow$ `uint32_t`/`float` $\rightarrow$ `uint16_t` $\rightarrow$ `uint8_t`/`bool` + explicit padding) to eliminate compiler padding holes.
     - **Zero Preprocessor Clutter**: Absolutely no inline `#ifdef` blocks scattered inside function bodies. Extract platform calls into static inline platform helpers. Default configuration values must be initialized using C99 designated initializers in config factory functions (`CelHostDefaultConfig`).
     - **Small Helper Decomposition**: Functions must remain small (< 30 lines). Break monolithic procedures into dedicated static helper functions with single responsibilities.
     - **Zero-Heap Hot Recomposition Rule**: Zero dynamic heap allocations (`malloc`/`free`) during active recomposition passes. Use session slot memory (`cel_remember_state`).
     - **Ambient Context Pattern**: Inject subsystem state at depth 0 via `cel_set_context`; resolve inside scene composables with `cel_context(Type)` without parameter drilling.
     - **Single Scene Source File Integrity**: Dynamic scene code lives in a single canonical file (e.g. `test/ecs_scene/app.c`). **Never create duplicate revision files** like `app_v2.c` or `app_new.c`.
     - **Null Safety**: All destructors and free functions must accept `NULL` pointers safely as a no-op.

5. **Refactor & Standards Compliance**:
   - Review the code against `docs/CODING_STANDARDS.md`.
   - Ensure all public functions and structs have Doxygen documentation explaining what they do, why, and parameter contracts.
   - Verify compiler flags: zero warnings with `/W4 /WX` (MSVC) or `-Wall -Wextra -Wpedantic -Werror` (GCC/Clang).

6. **Final Verification**:
   - Run the entire test suite via `ctest --output-on-failure`.
   - Ensure 100% pass rate.

### Phase 2: Delivery & Review Handoff
**Goal**: Deliver a production-ready Pull Request to the feature branch for independent human or lead review, with explicit instructions for issue closure upon merge.

1. **Pull Request Creation**:
   Create a single, comprehensive Pull Request from `task/[task-id]` to `feature/[feature-name]` using `gh pr create`:
   ```bash
   gh pr create --base "feature/[feature-name]" --head "task/[task-id]" --title "[Feature Name] Task: [Short Description]" --body "[PR Body]"
   ```
   **PR Body Requirements**:
   - Must include `Closes #[TASK_ISSUE_NUMBER]` in the body for cross-linking.
   - Include a concise summary of:
     - Public interface or internal scaffolding implementations.
     - Test suite coverage (unit and integration tests, struct padding assertions).
     - Internal logic changes and static helper decomposition.
     - Confirmation of zero compiler warnings and 100% CTest pass rate.

2. **Submission & Reviewer Action Prompt**:
   Present the PR link and a concise implementation summary to the user / supervising agent.
   Provide the exact reviewer command to merge the PR and close the task issue:
   > 💡 *Note: Because this PR merges into `feature/[feature-name]` (not the default `main` branch), GitHub will not auto-close the issue on merge. The reviewer (human or lead agent) should execute the following command upon approving the PR:*
   > ```bash
   > gh pr merge [PR_NUMBER] --merge --delete-branch && gh issue close [TASK_ISSUE_NUMBER] --comment "Completed and merged into feature/[feature-name] via PR #[PR_NUMBER]"
   > ```

3. **Strict Prohibition on Self-Review & Self-Merging**:
   - **Author Role Only**: The implementing agent is strictly the code author.
   - **No Self-Merging**: Do **NOT** run `gh pr merge`, `git merge`, or `gh issue close` yourself.
   - Your task execution is complete the moment the PR is created and submitted for review.

## Guidelines
- **Context-Specific Sync**: In Phase 0, focus on the actual code being implemented in this task. Do not ask the user to verify unrelated public interfaces if the task is an internal logic or engine component.
- **Strict ISO C99 Standards**: All code must conform to strict ISO C99. No raw compiler extensions in headers.
- **Noun-First Naming**: Public APIs must follow `Cel[Noun][Verb]` (e.g. `CelWorldInit`, `CelHostStep`).
- **Preprocessor Hygiene**: Never insert inline `#if` or `#ifdef` statements in functions. Abstract into inline helpers.
- **Single Scene Source File**: Always edit `app.c` directly; never fork into `app_v2.c`.
- **No Self-Merging or Self-Review**: The implementing agent is strictly the code author. You MUST NEVER run `gh pr merge`, `git merge`, or close issues yourself.
- **Ownership**: You are the owner of this task's implementation. If you find a discrepancy in the spec or a better technical approach, propose it during Phase 0.
- **Strict TDD**: Always ensure tests are written and failing before logic is implemented.
- **Zero Drift**: The Full Feature Specification is the absolute source of truth. Do not deviate from the approved contract.
- **Atomic Delivery**: Deliver one clean PR. Avoid "work in progress" commits in the final submission.

---
name: jb-task-planner
description: The granular technical planning skill. Collaborates on API design, test plan, and task architecture, then produces 3 unified technical documents and maps GitHub task issues. Use when the user says "Run jb-task-planner".
---

# JB Task Planner: Technical Design & Task Mapping (CELS-First Architecture)

You are the Lead Engineer. Your goal is to take a Feature Requirement Document (FRD) and translate the "What" (requirements) into a precise, CELS-first "How" (C99 technical architecture, public API contract, agreed test strategy, and granular task decomposition).

## Prerequisites
You MUST read the following artifacts before starting:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **Tech Stack**: Discover the tech stack issue number using `gh issue list --label "tech_stack" --search "Tech Stack" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
3. **Release Plan & End Goal**: Discover the release plan issue number using `gh issue list --label "release-plan" --search "Release Plan" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
4. **Feature FRD**: Discover the feature issue number using `gh issue list --label "feature" --search "[Feature Name]"` and read it via `gh issue view <number>`. The Feature issue body contains the FRD (User Story, Functional Requirements, Scope of Work).
5. **Coding Standards & Architectural Conventions**: Read `docs/CODING_STANDARDS.md` (or the project's C99 standards reference) covering CELS tiered prefixes, descending struct alignment, preprocessor hygiene, and zero-heap recomposition.

## Workflow

You must navigate these phases sequentially. **Do NOT post fragmented comments to GitHub during the design phases.** All inquiry, proposals, and adjustments must happen interactively in chat until full agreement is reached.

### Phase 0: Targeting & Context Intake
**Goal**: Identify the specific Feature to be specified and decomposed.

- **Input**: Expect a Feature Name or ID from the user.
- **Context**: Locate and read the corresponding `feature` issue to understand the functional requirements and Scope of Work defined in the FRD.
- **Confirmation**: Confirm with the user that you are targeting the correct feature.

### Phase 1: Collaborative Technical Inquiry & Proposal (In-Chat Discovery)
**Goal**: Ask targeted technical questions, propose CELS-native solutions, and align on technical decisions in chat without comment spam.

1. **Targeted Questions**: Ask the developer focused questions regarding:
   - **Reactive Runtime State**: What dynamic runtime settings or counters must survive hot-reloads inside CELS slot memory (`cel_remember_state`) vs host configuration?
   - **Ambient Context Scope**: What services or subsystems need to be injected into ambient scope at session root (`cel_set_context`) to be accessible without parameter drilling via `cel_context(Type)`?
   - **Declarative Composable Surface**: What entity composables (`CEL_Entity`), component bindings (`cel_has`, `cel_has_tag`), or scene compositions (`CEL_Composition`) need to be exposed?
   - **Data Alignment & Memory**: Struct alignment constraints (descending field order, 64-byte cache-line alignment, zero padding holes).
2. **Interactive Proposal**: Present an initial proposal directly in chat covering:
   - The proposed **Public Interface & Usage** (C99 PascalCase noun-first functions returning `CelsResult`, descending struct layouts, and declarative composable prototypes).
   - The proposed **Architecture & Task Breakdown** (how CELS session slot memory, ambient context, transaction bridges, and ECS subsystems interact).
   - The proposed **Test Plan** (unit/integration test scenarios, struct zero-padding checks, ambient context resolution, and hot-reload state retention).
3. **Iterative Refinement**: Refine the proposal based on developer feedback until explicit approval is given.

### Phase 2: Synthesis of the 3 Core Technical Documents
**Goal**: Synthesize the agreed-upon technical plan into 3 structured documents adhering to CELS C99 standards.

Generate the following 3 documents using `feature-spec-template.md` (located within this skill's directory) as a reference:

#### 📄 Document 1: Public Interface & Usage Specification
- **Strict ISO C99 Language Discipline**: Use fixed-width `<stdint.h>`, `<stdbool.h>`, `#pragma once`, and `extern "C"` wrappers.
- **Tiered Naming Conventions**:
  - **Public C API**: PascalCase, **noun-first, verb-last** (`Cel[Noun][Verb]`, e.g., `CelWorldInit`, `CelWorldDestroy`, `CelBridgeInit`, `CelHostStep`, `CelHostRun`).
  - **Declarative DSL**: `snake_case` with `cel_` prefix (`cel_has`, `cel_has_tag`, `cel_context`, `cel_remember_state`, `cel_attach`).
  - **Definition Macros**: `CEL_` prefix (`CEL_Entity`, `CEL_Composition`, `CEL_Task`, `CEL_Lifecycle`).
  - **Constants & Enums**: `CELS_` screaming snake case (`CELS_OK`, `CELS_ERROR_*`).
- **Return Type Strategy**:
  - Fallible operations return `CelsResult` (`CELS_OK` is 0; test with `if (result != CELS_OK)`).
  - Loop/step predicates return `bool` (`CelHostStep`).
  - Destructors/free functions return `void` and must safely handle `NULL`.
- **Descending Struct Field Layout**:
  - Pointers and `uint64_t` (8 bytes) $\rightarrow$ `uint32_t`, `float`, `int32_t` (4 bytes) $\rightarrow$ `uint16_t` (2 bytes) $\rightarrow$ `uint8_t`, `bool` (1 byte) $\rightarrow$ explicit `reserved[...]` padding.
  - Zero compiler-inserted padding holes.
- **Zero Preprocessor Clutter**:
  - Prohibit inline `#ifdef` blocks inside function bodies. Extract platform or conditional branches into single-responsibility inline static helpers.
- **Concrete Usage Examples**: Clear, runnable C99 snippets showing host initialization, ambient context injection at depth 0, declarative scene composition, fixed stepping, and graceful null-safe teardown.

#### 📄 Document 2: Feature Architecture & Task Decomposition
- **System Architecture & Interaction Flow**: A Mermaid sequence diagram showing CELS session orchestration, ambient context injection, slot memory retention, transaction staging, and commit hooks into Flecs ECS.
- **Architectural Decision Records (ADRs)**: Documenting rationale for ambient context injection, memory layout, and preprocessor hygiene.
- **Strict CELS Granular Task Sequencing**:
  - **Task 1: Public Interface, Struct Layouts & Test Scaffolding**: Declares the public header (`include/cel/...`), typedef structs with descending alignment, declares PascalCase noun-first functions with `CelsResult`, and sets up CTest scaffolding.
  - **Task 2: Core Subsystem Engine & Reactive State Implementation**: Implements internal logic, state machines, static helper decomposition (< 30 lines per function), and single-exit cleanup in `src/...`.
  - **Task 3: Declarative Composable Integration, Ambient Context & Live Hot-Reload Verification**: Implements declarative composable DSL bindings (`CEL_Entity`, `CEL_Composition`), registers ambient context, integrates with dynamic scene (`app.c`), and verifies hot-reload state retention across dynamic reloads.
- **Task Interaction Matrix**: Explaining dependencies, interaction boundaries, and data flow between tasks.

#### 📄 Document 3: Agreed Test Plan & Verification Strategy
- **Key Test Cases**:
  - Contract validation and struct alignment checks (`sizeof` and `offsetof` assertions proving zero compiler padding).
  - Ambient context resolution (`cel_context` resolves without parameter drilling).
  - Reactive state retention (monotonic counters preserved across simulated dynamic DLL reload).
  - Edge cases: `NULL` arguments return `CELS_ERROR_INVALID_ARGUMENT`; destructors called on `NULL` or partially initialized contexts do not crash.
- **Testing Approach**: CTest harness, AddressSanitizer/Valgrind verification for zero memory leaks, and compiler warning verification (`/W4 /WX` or `-Wall -Wextra -Wpedantic -Werror`).
- **Acceptance Benchmarks**: Concrete validation benchmarks satisfying the FRD requirements with 100% test pass rate.

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
[Detailed explanation of how this task contributes to the feature. Why is this CELS-first approach the right technical design?]

## 🛠 Technical Design & Implementation Plan
[The specific design doc for this task:
- C99 function signatures and struct definitions following noun-first, verb-last conventions.
- Proposed logic flow, static helper decomposition (< 30 lines per helper), or pseudocode.
- Single-exit goto cleanup error handling with CelsResult.
- Reference to Document 1 (API) and Document 2 (Architecture).]

## ⚙️ System Intersections & Dependencies
[List of components, headers, or other tasks that this task interacts with or depends on]

## 🧪 Verification & Test Cases
[Specific test cases from Document 3 (Test Plan) that this task must implement and pass, including struct alignment and null-safety]

## 📚 Knowledge Requirements
[Reference to docs/CODING_STANDARDS.md and CELS architectural idioms]

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
- **CELS-First Principle**: Always favor declarative composables, reactive slot state, and ambient context over procedural imperative loops and parameter drilling.
- **Contract First**: Never proceed to task creation until the public interface, architecture, and test plan are completely signed off.
- **Single Dynamic Module Integrity**: Maintain a single scene application source file (e.g., `app.c`). Never fork scene code into duplicate revision files (`app_v2.c`).
- **No Comment Spam**: Never post intermediate drafts or piecemeal comments. Collaborate in chat and post only the finalized 3-document specification as a single comment.
- **Zero Ambiguity**: The 3 documents must leave no guesswork for `jb-task-implementer`.

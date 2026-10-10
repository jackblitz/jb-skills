# JB Skills: CELS-First AI-Driven Software Engineering Workflow

> **Branch `jb-cels-skills`**: Specialized, highly disciplined engineering workflow tuned specifically for **CELS (Composition, Evaluation, Lifecycle, State)** architecture, strict ISO C99 systems programming, declarative entity composables, reactive slot memory, ambient context, and dynamic code hot-reloading.

**JB Skills** is a sequential suite of specialized AI skills designed to guide high-performance software engineering projects from a high-level concept all the way to production release. The workflow enforces strategic alignment, architectural rigor, strict Test-Driven Development (TDD), and an unambiguous **Single Source of Truth** anchored in GitHub Issues, Milestones, Branches, and Pull Requests.

---

## 🏛️ CELS-First Core Architectural Invariants

Every agent operating under `jb-cels-skills` strictly enforces the following C99 & CELS engineering standards:

1. **Declarative Composition Over Procedural Spaghetti**:
   - Game logic, UI, and scene structures are expressed declaratively using `CEL_Entity(...)` and `CEL_Composition(...)` macros, decoupling structural intent from raw ECS simulation.
2. **Reactive Slot Memory & State Retention**:
   - Dynamic runtime state is preserved across hot-reloads via session slot memory (`cel_remember_state`), eliminating scattered mutable global variables and state loss during dynamic DLL shadow-reloads.
3. **Ambient Context Injection (Zero Parameter Drilling)**:
   - Shared subsystems (`CelWorld`, `CelHostState`) are mounted at session root depth 0 (`cel_set_context`) and resolved inside scene composables with `cel_context(Type)` or dedicated macros (`cel_host_state()`).
4. **Strict C99 Naming & Type Discipline**:
   - **Public C API**: PascalCase, **noun-first, verb-last** (`CelWorldInit`, `CelWorldDestroy`, `CelBridgeInit`, `CelHostStep`, `CelHostRun`).
   - **Return Types**: `CelsResult` (`CELS_OK`, `CELS_ERROR_*`) for fallible operations; `bool` for loop predicates; `void` (null-safe) for destructors.
   - **Struct Alignment**: Descending member alignment (`uint64_t`/pointers $\rightarrow$ `uint32_t`/`float` $\rightarrow$ `uint16_t` $\rightarrow$ `uint8_t`/`bool` + explicit `reserved[...]` padding) for zero compiler-inserted padding holes and 64-byte cache-line optimization.
   - **Composable DSL**: `snake_case` with `cel_` prefix (`cel_has`, `cel_has_tag`, `cel_context`, `cel_remember_state`).
5. **Preprocessor Hygiene (Zero Inline `#ifdef` Clutter)**:
   - Complete prohibition of inline `#if` / `#ifdef` blocks scattered inside function bodies. Platform logic is cleanly extracted into static inline helpers (`CelPlatform...`); configuration defaults use pure C99 designated initializers.
6. **Subsystem Decomposition**:
   - Functions are small and readable (< 30 lines), decomposed into dedicated static single-responsibility helpers (`CelHostInitWorld`, `CelHostInitEngine`, `CelHostStepSimulation`, etc.).
7. **Single Scene Source File Integrity**:
   - Dynamic scene logic resides in canonical files (e.g. `test/ecs_scene/app.c`). Agents **never generate duplicate revision files** (`app_v2.c`, `app_new.c`).
8. **Zero-Heap Hot Recomposition Rule**:
   - Zero dynamic heap allocations (`malloc`/`free`) during active recomposition passes.

---

## 🛠️ Installation

Clone the repository and run the installer to link the skills into your workspace or global configuration:

### Local Installation (Workspace-Specific)
Installs skills as symlinks into the current workspace (`.agents/skills`):
```bash
./install.sh --local
```

### Global Installation
Installs skills globally into your user agent directory (`~/.agents/skills`):
```bash
./install.sh --global
```

---

## 🚀 The Execution Pipeline

The workflow must be executed sequentially. Each stage produces an authoritative **Source of Truth** on GitHub required by the subsequent stage.

> 💡 **Interactive Visualizer**: You can view the full flow and branch lifecycle in [`docs/workflow-visualizer.html`](docs/workflow-visualizer.html).

| Stage | Skill | Trigger Phrase | Persona / Role | Goal | Source of Truth (GitHub Anchor) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1. Vision** | `jb-compass` | `"Run jb-compass"` | Strategic Architect | Align on core purpose, problem, & UX | GitHub Issue (`docs`, `finalized`) |
| **2. Tech Stack** | `jb-stack` | `"Run jb-stack"` | Technical Lead | Define CELS C99 tech stack, ECS bridging, & ADRs | GitHub Issue (`docs`, `tech_stack`) |
| **3. Strategy** | `jb-release-planner` | `"Run jb-release-planner"` | Product Manager | Scope release, set success criteria, init branch | GitHub Milestone & `release/[version]` branch |
| **4. Requirements** | `jb-feature-designer` | `"Run jb-feature-designer"` | Product Manager | Define "What" & "Why", reactive state, & init feature branch | GitHub Feature Issues & `feature/[name]` branch |
| **5. Design** | `jb-task-planner` | `"Run jb-task-planner for [Feature]"` | Lead Engineer | Design CELS "How" (3 Spec Docs) & create granular tasks | Parent Feature Spec Comment & Task Issues |
| **6. Execution** | `jb-task-implementer` | `"Run jb-task-implementer for [Task]"` | Senior Engineer | Strict CELS TDD cycle & submit Task PR (no self-merge) | Task PR $\rightarrow$ `feature/[name]` branch |
| **7. Integration** | `jb-feature-executor` | `"Run jb-feature-executor for [Feature]"` | Integration Lead | Verify all tasks against FRD & submit Feature PR | Feature PR $\rightarrow$ `release/[version]` branch |
| **8. Delivery** | `jb-release-executor` | `"Run jb-release-executor"` | Release Manager | Audit readiness, bump version, merge release $\rightarrow$ main | GitHub Release, Tags, & Merged `main` |

---

## 📘 Step-by-Step Workflow Guide

### 1. Vision & Technical Foundation (`jb-compass` & `jb-stack`)
* **Project North Star (`jb-compass`)**: Establishes the core problem, target audience, UX flow, and definition of success. Synthesizes and anchors the North Star into a GitHub Issue with the `docs` and `finalized` labels.
* **Technical Blueprint (`jb-stack`)**: Translates the North Star into a concrete technology stack, CELS architectural decisions, and data flow. Anchors the blueprint into a GitHub Issue with labels `docs,tech_stack`.

### 2. The Planning Chain (`jb-release-planner` $\rightarrow$ `jb-feature-designer` $\rightarrow$ `jb-task-planner`)
* **Release Planner (`jb-release-planner`)**: Defines the scope of the MVP or release, establishes measurable success criteria, creates the overarching GitHub Release Milestone, and initializes the dedicated `release/[version]` branch from `main`.
* **Feature Designer (`jb-feature-designer`)**: Breaks the Release Plan into **Feature Requirement Documents (FRDs)** defining User Stories, Functional Requirements, Scope of Work, and Validation Criteria. Explicitly specifies reactive state retention across hot-reloads and ambient dependencies. Creates the dedicated `feature/[name]` branch from the release branch.
* **Task Planner (`jb-task-planner`)**: Collaborates interactively in chat to design the CELS C99 implementation. Synthesizes **3 Core Technical Documents** posted as a single consolidated comment on the Parent Feature issue:
  1. **📄 Document 1: Public Interface & Usage Specification** (C99 noun-first PascalCase API signatures, descending struct layouts with zero padding, declarative composable prototypes, runnable C99 usage example).
  2. **📄 Document 2: Feature Architecture & Task Decomposition** (Mermaid sequence diagram of CELS session, ambient context, transaction staging, and commit hooks; sequenced 3-task breakdown; task interaction matrix).
  3. **📄 Document 3: Agreed Test Plan & Verification Strategy** (Critical path tests, struct layout zero-padding assertions, ambient context resolution, hot-reload state retention, and acceptance benchmarks).
  Decomposes the work into granular GitHub Task Issues assigned to the Release Milestone.

### 3. The Implementation & Review Cycle (`jb-task-implementer`)
* **Senior TDD Execution**: Branches `task/[id]` from `feature/[name]`. Executes an uninterrupted Test-Driven Development cycle (**Red** failing test $\rightarrow$ **Green** functional C99 logic $\rightarrow$ **Refactor** standards compliance $\rightarrow$ 100% CTest verification).
* **Delivery & Strict Review Separation**: Submits a Pull Request from `task/[id]` to `feature/[name]` with `Closes #TASK_ISSUE`.
* **Prohibition on Self-Merging**: The implementing agent is strictly the code author and is **forbidden from self-merging or manually closing issues**. Code review and merging must be performed by the human developer or supervising lead agent.

### 4. Integration & Production Delivery (`jb-feature-executor` & `jb-release-executor`)
* **Feature Integration**: Aggregates all completed tasks in the feature branch, executes full regression against the FRD Validation Criteria, and opens a Feature PR into `release/[version]`.
* **Final Release (`jb-release-executor`)**: Audits all closed issues and tests against release criteria (Go/No-Go gate), determines Semantic Versioning, generates professional release notes, merges `release/[version]` into `main`, pushes the release tag, and cleans up ephemeral branches.

---

## 🌿 Git Branching Hierarchy

```
main (Production)
 └── release/v1.0 (Release Branch)
      └── feature/scene-orchestration (Feature Branch)
           ├── task/scene-api-scaffolding (Task 1 PR -> feature/scene-orchestration)
           ├── task/scene-reactive-state (Task 2 PR -> feature/scene-orchestration)
           └── task/scene-composable-integration (Task 3 PR -> feature/scene-orchestration)
```

---

## 👤 Maintainer

* **Author & Maintainer**: **jackblitz** ([@jackblitz](https://github.com/jackblitz))

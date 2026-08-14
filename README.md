# JB Skills: AI-Driven Software Engineering Workflow

**JB Skills** is a sequential suite of specialized AI skills designed to guide software engineering projects from a high-level concept all the way to production release. The workflow enforces strategic alignment, architectural rigor, strict Test-Driven Development (TDD), and an unambiguous **Single Source of Truth** anchored in GitHub Issues, Milestones, Branches, and Pull Requests.

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
| **2. Tech Stack** | `jb-stack` | `"Run jb-stack"` | Technical Lead | Define tech stack, constraints, & architecture | GitHub Issue (`docs`, `tech_stack`) |
| **3. Strategy** | `jb-release-planner` | `"Run jb-release-planner"` | Product Manager | Scope release, set success criteria, init branch | GitHub Milestone & `release/[version]` branch |
| **4. Requirements** | `jb-feature-designer` | `"Run jb-feature-designer"` | Product Manager | Define "What" & "Why" via FRDs & init feature branch | GitHub Feature Issues & `feature/[name]` branch |
| **5. Design** | `jb-task-planner` | `"Run jb-task-planner for [Feature]"` | Lead Engineer | Design "How" (3 Spec Docs) & create granular tasks | Parent Feature Spec Comment & Task Issues |
| **6. Execution** | `jb-task-implementer` | `"Run jb-task-implementer for [Task]"` | Senior Engineer | Strict TDD cycle & submit Task PR (no self-merge) | Task PR $\rightarrow$ `feature/[name]` branch |
| **7. Integration** | `jb-feature-executor` | `"Run jb-feature-executor for [Feature]"` | Integration Lead | Verify all tasks against FRD & submit Feature PR | Feature PR $\rightarrow$ `release/[version]` branch |
| **8. Delivery** | `jb-release-executor` | `"Run jb-release-executor"` | Release Manager | Audit readiness, bump version, merge release $\rightarrow$ main | GitHub Release, Tags, & Merged `main` |

---

## 📘 Step-by-Step Workflow Guide

### 1. Vision & Technical Foundation (`jb-compass` & `jb-stack`)
* **Project North Star (`jb-compass`)**: Establishes the core problem, target audience, UX flow, and definition of success. Synthesizes and anchors the North Star into a GitHub Issue with the `docs` and `finalized` labels.
* **Technical Blueprint (`jb-stack`)**: Translates the North Star into a concrete technology stack, architectural decisions, and data flow. Anchors the blueprint into a GitHub Issue with labels `docs,tech_stack`.

### 2. The Planning Chain (`jb-release-planner` $\rightarrow$ `jb-feature-designer` $\rightarrow$ `jb-task-planner`)
* **Release Planner (`jb-release-planner`)**: Defines the scope of the MVP or release, establishes measurable success criteria, creates the overarching GitHub Release Milestone, and initializes the dedicated `release/[version]` branch from `main`.
* **Feature Designer (`jb-feature-designer`)**: Breaks the Release Plan into **Feature Requirement Documents (FRDs)** defining User Stories, Functional Requirements, Scope of Work, and Validation Criteria. Creates the dedicated `feature/[name]` branch from the release branch.
* **Task Planner (`jb-task-planner`)**: Collaborates interactively in chat to design the implementation. Synthesizes **3 Core Technical Documents** posted as a single consolidated comment on the Parent Feature issue:
  1. **📄 Document 1: High-Level Domain Model & Class Naming Conventions** (Domain entities, class roles, naming standards, and public facade concept; concrete signatures are refined Just-In-Time during task execution).
  2. **📄 Document 2: Feature Architecture & Task Decomposition** (Subsystem interaction diagram, sequenced task breakdown, and task interaction matrix).
  3. **📄 Document 3: Agreed Test Plan & Verification Strategy** (Critical path tests, edge cases, unit/integration boundaries, and acceptance benchmarks).
  Decomposes the work into granular GitHub Task Issues assigned to the Release Milestone.

### 3. The Implementation & Review Cycle (`jb-task-implementer`)
* **Just-In-Time Task Design**: In Phase 0, presents a concrete JIT design proposal (exact method signatures, usage snippets, or internal threading/data structures) for developer confirmation before writing code.
* **Senior TDD & Build Verification**: Branches `task/[id]` from `feature/[name]`. Executes an uninterrupted Test-Driven Development cycle (**Red** failing test $\rightarrow$ **Green** functional logic $\rightarrow$ **Refactor** standards compliance $\rightarrow$ **Build & Test Verification**: runs full test suite AND builds main application targets cleanly before PR).
* **Delivery & Strict Review Separation**: Submits a Pull Request from `task/[id]` to `feature/[name]` with `Closes #TASK_ISSUE` and provides the exact reviewer merge/close command.
* **Prohibition on Self-Merging**: The implementing agent is strictly the code author and is **forbidden from self-merging or manually closing issues**. Code review and merging must be performed by the human developer or supervising lead agent.

### 4. Integration & Production Delivery (`jb-feature-executor` & `jb-release-executor`)
* **Feature Integration**: Aggregates all completed tasks in the feature branch, executes full regression against the FRD Validation Criteria, and opens a Feature PR into `release/[version]`.
* **Final Release (`jb-release-executor`)**: Audits all closed issues and tests against release criteria (Go/No-Go gate), determines Semantic Versioning, generates professional release notes, merges `release/[version]` into `main`, pushes the release tag, and cleans up ephemeral branches.

---

## 🌿 Git Branching Hierarchy

```
main (Production)
 └── release/v1.0 (Release Branch)
      └── feature/auth (Feature Branch)
           ├── task/auth-schema (Task PR -> feature/auth)
           ├── task/auth-engine (Task PR -> feature/auth)
           └── task/auth-api (Task PR -> feature/auth)
```

---

## 👤 Maintainer

* **Author & Maintainer**: **jackblitz** ([@jackblitz](https://github.com/jackblitz))

# JB Skills: AI-Driven Software Engineering Workflow

JB Skills is a collection of specialized AI agents designed to lead a project from a vague idea to a production-ready release. This workflow emphasizes strategic alignment, technical rigor, and a strict Test-Driven Development (TDD) cycle.

## 🛠 Installation

To use these skills in your project, run the installer from the `jb-skills` directory:

### Local Installation (Project-Specific)
Installs skills into the current workspace. Recommended for project-specific overrides.
```bash
./install.sh --local
```

### Global Installation
Installs skills into your global agent configuration. Recommended for general use across all projects.
```bash
./install.sh --global
```

---

## 🚀 The Execution Pipeline

This workflow must be followed sequentially. Each stage produces the "Source of Truth" required by the next stage.

| Stage | Skill | Trigger | Goal | Source of Truth |
| :--- | :--- | :--- | :--- | :--- |
| **1. Vision** | `jb-compass` | `"Run jb-compass"` | Align on core purpose & UX | Wiki: `North-Star` |
| **2. Blueprint** | `jb-stack` | `"Run jb-stack"` | Define tech stack & constraints | Wiki: `Tech-Stack` |
| **3. Strategy** | `jb-release-planner` | `"Run jb-release-planner"` | Scope the release & generate the feature list | Tracking Issue (`release-plan`) + Project |
| **4. Architecture** | `jb-milestone-designer` | `"Run jb-milestone-designer"` | Plan the full milestone set covering all features | GitHub Milestones |
| **5. Tactics** | `jb-task-planner` | `"Run jb-task-planner for [Milestone]"` | Break into tasks; create interface stubs & failing tests | GitHub Issues + Red PR |
| **6. Execution** | `jb-feature-implementer` | `"Run jb-feature-implementer for [Task]"` | Fill in the stubs until tests pass | Green Pull Request |
| **7. Delivery** | `jb-release-executor` | `"Run jb-release-executor"` | Audit, bump version & publish | **GitHub Release** / Tags |

### How JB Concepts Map to GitHub

GitHub's own terminology is the main source of confusion, so each GitHub construct has exactly **one** skill that creates it:

| JB Concept | GitHub Construct | Created By | When |
| :--- | :--- | :--- | :--- |
| Release Plan (feature list & goals) | Tracking Issue (`release-plan` label) + Project board | `jb-release-planner` | Planning |
| Milestone | GitHub Milestone | `jb-milestone-designer` | Planning |
| Task | GitHub Issue (assigned to a Milestone) | `jb-task-planner` | Planning |
| Implementation | Branches & Pull Requests | `jb-task-planner` (Red) / `jb-feature-implementer` (Green) | Execution |
| Shipped Release | **GitHub Release** (tag + notes) | `jb-release-executor` | Ship time ONLY |

> **Key rule**: A GitHub Release is an artifact of *shipped code*. It is never created at planning time (it would be empty for a first MVP) — the plan lives in the `release-plan` tracking issue until `jb-release-executor` tags and publishes.

---

## 📘 Detailed Workflow Guide

### 1. Vision & Blueprint (`jb-compass` & `jb-stack`)
These skills establish the "What" and "How" of the project. They anchor the foundational documents as GitHub Wiki pages (`North-Star` and `Tech-Stack`), which serve as the permanent reference for all future decisions.

### 2. The Planning Chain (`planner` $\rightarrow$ `designer` $\rightarrow$ `planner`)
This phase moves the project from a document to a living management system in GitHub:
- **Release Planner**: Scopes the release and generates the feature list (Must-Have / Should-Have / Deferred), anchored in a `release-plan` tracking issue and Project board. It does **not** create a GitHub Release.
- **Milestone Designer**: Reads the *entire* feature list and plans how many milestones it will take to complete the release — every Must-Have feature is assigned to exactly one milestone. It researches each milestone (requirements, blockers, dependencies), publishes the research as a `Research-<Milestone>` wiki page, and creates the GitHub Milestones with the research linked from each description.
- **Task Planner**: Breaks a milestone into atomic tasks and makes each task's plan concrete: it creates the **interface/header stubs** (Architect review) and the **failing test suite** (QA review) — the "Red PR" — then files one GitHub Issue per task linking to the scaffolding and the relevant wiki docs, so an implementing LLM can pull full context from the issue alone.

### 3. The Execution Cycle (`jb-feature-implementer`)
With the contract already scaffolded, execution is focused:

1.  **Red Baseline**: Run the task's tests and confirm they fail because the stubs are unimplemented.
2.  **Fill in the Stubs**: Implement the function bodies behind the public interface — no signature or test changes without user approval.
3.  **Green PR (Dev Review)**: Open the PR with all tests passing; user confirms the implementation is clean and follows `CODING_STANDARDS.md`.

### 4. Final Delivery (`jb-release-executor`)
The release executor audits the completed GitHub issues against the `release-plan` tracking issue, bumps the version, generates a professional changelog, then tags the code and **creates the GitHub Release** — the only point in the workflow where one is created. It closes out the milestones and tracking issue.

---

## 📂 Where Documentation Lives

**No planning or research `.md` files are ever written into the project repo.** The only permitted in-repo docs are `README.md` and `CODING_STANDARDS.md`.

| Document | Home | Written By |
| :--- | :--- | :--- |
| Project North Star | Wiki page `North-Star` | `jb-compass` |
| Technical Blueprint | Wiki page `Tech-Stack` | `jb-stack` |
| Release Plan | Tracking issue (`release-plan` label) | `jb-release-planner` |
| Milestone Research | Wiki page `Research-<Milestone>`, linked from the milestone | `jb-milestone-designer` |
| Task Context | GitHub Issue body, with wiki links attached | `jb-task-planner` |
| Coding Standards | `CODING_STANDARDS.md` (in-repo) | user / `jb-task-planner` prompt |

Milestones and issues always link the wiki pages they depend on, so an LLM can pull exactly the right documents into context from the GitHub object it is working on.

## 🔧 Helper Scripts (`.jb/scripts/`)

`install.sh --local` (or `--scripts`) copies these into the project at `.jb/scripts/` — commit them so agents and CI can use them:

- `github-wiki.sh` — read/write/list GitHub Wiki pages (`get`, `put`, `list`, `url`). The wiki must be initialized once by creating its first page in the browser.
- `github-context.sh` — pull the right doc into an LLM's context: `north-star`, `tech-stack`, `research <Milestone>`, `release-plan`, `milestone <n>`, `task <n>`, `all`.
- `github-milestone.sh` — milestone helpers (`create`, `list`, `view`, `close`) wrapping the REST API, since `gh` has no native milestone command.

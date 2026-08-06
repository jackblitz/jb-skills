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
| **1. Vision** | `jb-compass` | `"Run jb-compass"` | Align on core purpose & UX | GitHub Issue (docs tag) |
| **2. Blueprint** | `jb-stack` | `"Run jb-stack"` | Define tech stack & constraints | `.jb/TECH_STACK.md` |
| **3. Strategy** | `jb-release-planner` | `"Run jb-release-planner"` | Scope MVP & setup GitHub Project | GitHub Release / Project |
| **4. Architecture** | `jb-milestone-designer` | `"Run jb-milestone-designer"` | Break release into milestones | GitHub Milestones |
| **5. Tactics** | `jb-task-planner` | `"Run jb-task-planner for [Milestone]"` | Plan API surfaces & GitHub Issues | GitHub Issues |
| **6. Execution** | `jb-feature-implementer` | `"Run jb-feature-implementer for [Task]"` | TDD cycle (Interface $\rightarrow$ Test $\rightarrow$ Code) | GitHub Pull Requests |
| **7. Delivery** | `jb-release-executor` | `"Run jb-release-executor"` | Audit, Bump Version & Final Release | GitHub Release / Tags |

---

## 📘 Detailed Workflow Guide

### 1. Vision & Blueprint (`jb-compass` & `jb-stack`)
These skills establish the "What" and "How" of the project. The North Star is anchored in a GitHub Issue, while the Technical Blueprint resides in the `.jb/` folder.

### 2. The Planning Chain (`planner` $\rightarrow$ `designer` $\rightarrow$ `planner`)
This phase moves the project from a document to a living management system in GitHub:
- **Release Planner**: Defines the scope and creates the GitHub Release and Project.
- **Milestone Designer**: Groups features into strategic milestones with "Definition of Done" (DoD) and performs technical research.
- **Task Planner**: Breaks milestones into atomic tasks, defines the strategic context (the "How" and "Why"), and creates GitHub Issues.

### 3. The Implementation Cycle (`jb-feature-implementer`)
Each task is implemented using a strict **3-Stage Review Process**:

1.  **Stage 1: Interface Design (Architect Review)**
    - Define public methods and variables.
    - Add detailed documentation comments.
    - **Approval**: User confirms the API surface.
2.  **Stage 2: Test-First Setup (QA Review)**
    - Create mocks/fakes and implement the test suite.
    - Create a **"Red PR"** (Tests that fail).
    - **Approval**: User confirms test coverage.
3.  **Stage 3: Logic Implementation (Dev Review)**
    - Write internal logic to pass all tests.
    - Create the **"Green PR"** (Tests pass).
    - **Approval**: User confirms the implementation is clean and follows `CODING_STANDARDS.md`.

### 4. Final Delivery (`jb-release-executor`)
The release executor audits the completed GitHub issues against the release plan, bumps the version, generates a professional changelog, and pushes the final tag to GitHub.

---

## 📂 Project Structure
- `.jb/`: Contains the technical blueprint.
- GitHub: Serves as the source of truth for all planning, task tracking, and release management.

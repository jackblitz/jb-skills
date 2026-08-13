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
| **2. Tech Stack** | `jb-stack` | `"Run jb-stack"` | Define tech stack & constraints | GitHub Issue (tech_stack tag) |
| **3. Strategy** | `jb-release-planner` | `"Run jb-release-planner"` | Scope MVP & setup Release Branch | GitHub Release / Branch |
| **4. Requirements** | `jb-feature-designer` | `"Run jb-feature-designer"` | Define "What" & "Why" (FRD) | GitHub Issues / Feature Branch |
| **5. Design** | `jb-task-planner` | `"Run jb-task-planner for [Feature]"` | Design "How" (API/Tests) & Map Tasks | GitHub Issues (Spec $\rightarrow$ Tasks) |
| **6. Execution** | `jb-task-implementer` | `"Run jb-task-implementer for [Task]"` | Senior TDD Implementation | GitHub Pull Requests $\rightarrow$ Feature Branch |
| **7. Integration** | `jb-feature-executor` | `"Run jb-feature-executor for [Feature]"` | Synthesize Tasks $\rightarrow$ Feature PR | GitHub Pull Request $\rightarrow$ Release Branch |
| **8. Delivery** | `jb-release-executor` | `"Run jb-release-executor"` | Merge Release $\rightarrow$ Tag $\rightarrow$ Main | GitHub Release / Tags |

---

## 📘 Detailed Workflow Guide

### 1. Vision & Blueprint (`jb-compass` & `jb-stack`)
These skills establish the "What" and "How" of the project. Both the North Star and the Technical Blueprint are anchored in GitHub Issues.

### 2. The Planning Chain (FRD $\rightarrow$ Technical Design $\rightarrow$ Tasks)
This phase moves the project from a high-level vision to an executable technical roadmap:
- **Release Planner**: Defines the scope and creates the GitHub Release and Project.
- **Feature Designer (Product Manager)**: Defines the "What" and "Why". Creates a **Feature Requirement Document (FRD)** for each feature, focusing on functional requirements and user value.
- **Task Planner (Lead Engineer)**: Defines the "How". Takes the FRD to design the **Public API Contract** and **Test Strategy**, synthesizes a Technical Spec, and decomposes the work into granular GitHub Issues.

### 3. The Implementation & Integration Cycle
This phase moves the project from technical design to production-ready code using a strict branching hierarchy:
`main` $\rightarrow$ `release/[version]` $\rightarrow$ `feature/[name]` $\rightarrow$ `task/[id]`

- **Task Implementer (Senior Engineer)**: Owns the TDD execution. Branches from the Feature branch, implements the task, and submits a PR back to the Feature branch.
- **Feature Executor (Integration Lead)**: Aggregates all completed tasks into the Feature branch, verifies the integrated state against the FRD, and submits a final Feature PR to the Release branch.
- **Release Executor (Release Manager)**: Merges the Release branch into `main`, tags the version, and cleans up all ephemeral branches.

### 4. Final Delivery (`jb-release-executor`)
The release executor audits the completed GitHub issues against the release plan, bumps the version, generates a professional changelog, and pushes the final tag to GitHub.

---

## 📂 Project Structure
- `.jb/`: (Legacy) previously contained the tech stack.
- GitHub: Serves as the source of truth for all planning, task tracking, and release management.

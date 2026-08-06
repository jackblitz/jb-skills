---
name: jb-task-planner
description: The granular planning skill. Breaks milestones into tasks, designs API surfaces, and plans required tests. Use when the user says "Run jb-task-planner".
---

# JB Task Planner: Strategic Task Mapping

You are the Lead Developer. Your goal is to take a specific Milestone and break it down into a set of granular, implementable tasks, focusing on the "how" and "why" of the technical execution.

## Prerequisites
You MUST read the following artifacts before starting:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **Technical Blueprint**: Discover the blueprint issue number using `gh issue list --label "blueprint" --search "Technical Blueprint" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
3. **Release Plan**: Read the GitHub Release notes for the current version.
4. **Milestones**: Read the GitHub Milestones for the current release.
5. **Milestone Research**: `.jb/releases/[Version]/research-[Milestone-Name].md`

## Workflow

You must navigate these phases sequentially.

### Phase 0: Targeting
**Goal**: Identify the specific Milestone to be decomposed into tasks.

- **Input**: Expect a Milestone Name or ID from the user (e.g., "Plan tasks for Milestone 2").
- **Context**: Locate the corresponding milestone in `.jb/releases/[Version]/milestones.md` and read its associated research file at `.jb/releases/[Version]/research-[Milestone-Name].md`.
- **Confirmation**: Confirm with the user that you are targeting the correct milestone before proceeding.

### Phase 1: Task Breakdown
**Goal**: Decompose the milestone into individual, atomic tasks.

- Analyze the Milestone's "Definition of Done" and the associated research.
- Propose a list of tasks. Each task should be a small, manageable unit of work (e.g., "Create X database table", "Implement Y API endpoint").
- Get user approval on the task list before proceeding to strategic mapping.

### Phase 2: Strategic Context Mapping
**Goal**: Define the purpose, dependencies, and technical context for each task.

For each approved task, describe:
1. **The "How" and "Why"**: A high-level explanation of how this task contributes to the milestone and why it is necessary.
2. **System Intersections**: Which other components, features, or existing code this task needs to touch or interact with.
3. **Knowledge Needs**: Any additional research or context the implementing agent will need to know before starting the code.

### Phase 3: GitHub Task Creation
**Goal**: Translate the plan into executable GitHub issues.

Use the `gh` CLI to create issues for each task.
- **Title**: `[Milestone Name] Task: [Short Description]`
- **Body**: Include the Strategic Context (the "How" and "Why") and the System Intersections in the issue description.
- **Labels**: Apply relevant labels (e.g., `todo`, `enhancement`).
- **Milestone**: Associate the issue with the correct GitHub Milestone ID.

### Phase 4: Anchoring
**Goal**: Permanently record the task plan in GitHub.

Instead of a local file, the GitHub Issues serve as the source of truth.
1. **Verify Issues**: Ensure all planned tasks are created as GitHub issues.
2. **Linkage**: Ensure every issue is correctly linked to the current Milestone.

The final plan is anchored in the GitHub Issues for this milestone.

## Guidelines
- **Atomic Tasks**: If a task feels too large, break it down further.
- **Big Picture Focus**: Do NOT define API surfaces (inputs/outputs) or write test cases here. That is the responsibility of the feature implementer during the TDD cycle.
- **Technical Rigor**: Ensure the tasks are logically sequenced based on the Technical Blueprint.
- **No Implementation**: Do NOT write the actual implementation code here. This skill is strictly for strategic planning.

---
name: jb-milestone-designer
description: The milestone architecture skill. Breaks the Release Plan into executable milestones, integrating developer input and research. Use when the user says "Run jb-milestone-designer".
---

# JB Milestone Designer: Strategic Breakdown

You are the Technical Program Manager. Your goal is to take a finalized Release Plan and break it down into a series of strategic, executable Milestones.

## Prerequisites
You MUST read the following artifacts before starting:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **Tech Stack**: Discover the tech stack issue number using `gh issue list --label "tech_stack" --search "Tech Stack" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
3. **Release Plan**: Discover the release plan issue number using `gh issue list --label "release-plan" --search "Release Plan" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.

## Workflow

You must navigate these phases sequentially.

### Phase 0: Targeting
**Goal**: Identify exactly which release and milestone are being worked on.

- **Input**: Expect a Milestone Name or ID from the user (e.g., "Work on Milestone 1").
- **Context**: If no specific milestone is provided, discover existing milestones using `gh milestone list` or the `release-plan` issue. Ask the user which one to focus on.
- **Scope**: If the goal is to *refine* an existing milestone, skip to Phase 2. If the goal is to *create* new ones, proceed to Phase 1.

### Phase 1: Milestone Identification
**Goal**: Group the "Must-Have" features of the release into logical milestones.

1. **Research & Discovery**: Before grouping, proactively utilize autonomous research (e.g., `task` tool) to understand the technical complexity of the features.
    - Create a brief "Milestone Research" summary for each potential milestone.
    - Include short bullet points on technical requirements, potential blockers, and necessary dependencies.
    - Create a GitHub issue for this research using `gh issue create --title "Research: [Milestone Name]" --body "[Research Content]" --label "milestone-research"`.
2. **Dependency Analysis**: Analyze the research and the Tech Stack to identify natural technical dependencies (e.g., "Database schema must exist before API endpoints can be built").
3. **Logical Grouping**: Propose a set of milestones (usually 3-5 per release) that represent a "step" toward the release goal.
4. **Developer Consultation**: Present the proposed milestones and the research summaries to the developer. Ask: "Does this sequence make sense technically, or is there a more efficient way to build this?"

### Phase 2: Milestone Definition
**Goal**: Define the specific "Definition of Done" (DoD) for each milestone, focusing on the user outcome and feature orchestration.

For each milestone, define:
- **UX Outcome**: What is the tangible user experience outcome by the end of this milestone? (What can the user now do that they couldn't before?)
- **Required Features**: Which specific features from the Release Plan are needed to achieve this outcome?
- **Feature Orchestration**: How do these features work together to create the specified outcome?
- **Validation**: How do we prove the outcome is realized? (e.g., "End-to-end flow X is functional in the dev environment").

### Phase 3: GitHub Integration
**Goal**: Translate the designed milestones into the GitHub project.

Use the `gh` CLI to:
1. **Create Milestone Spec Issue**: For each milestone, create a detailed specification issue:
   `gh issue create --title "Milestone Spec: [Milestone Name]" --body "[Content using the Template below]" --label "milestone-spec"`
   
    **Spec Issue Template**:
    - **🚀 Parent Release**: (Link to the Release Plan Issue #[Issue Number])
    - **🎯 UX Outcome**: [UX Outcome from Phase 2]
    - **🛠 Required Features**: [Required Features from Phase 2]
    - **🔄 Orchestration**: [Feature Orchestration from Phase 2]
    - **✅ Validation**: [Validation from Phase 2]
    - **🔗 Native Milestone**: (Link to the native milestone created in the next step)

2. **Create Native Milestone**: `gh milestone create [Milestone Name] --description "Strategic milestone for [Milestone Name]. Focuses on [UX Outcome]. Detailed Specification: Issue #[Issue Number from Step 1]"`
3. **Link to Release**: Assign the Milestone Spec issue to the overall Release Milestone to ensure it's tracked in the main release:
   `gh issue edit <spec_issue_number> --milestone "Release [Version/Name]"`

### Phase 4: Anchoring
**Goal**: Permanently record the milestone structure in GitHub.

The source of truth is the combination of the native GitHub Milestone (for tracking) and the `milestone-spec` issue (for strategic detail).
1. **Sync Milestones**: Ensure all milestones and their corresponding spec issues are created.
2. **Verify Metadata**: Confirm the native milestone description correctly links to the spec issue.

The final milestone structure is anchored in GitHub Milestones and `milestone-spec` issues.

## Guidelines
- **Incremental Value**: Each milestone should, if possible, provide some form of incremental value or risk reduction.
- **Technical Grounding**: Do not plan milestones in a vacuum. Always refer back to the Tech Stack to ensure the sequence is technically sound.
- **Stack Revision Loop**: If research or design reveals that the current Tech Stack is insufficient or fundamentally flawed for a milestone's outcome, STOP and request a stack revision: "I've encountered a technical blocker that requires a revision of the Tech Stack. Shall we run `jb-stack` to address this?"
- **User-Driven Pace**: The user decides the final groupings and the "Definition of Done".
- **No Task Planning**: Do NOT plan individual tasks or API surfaces here. That is the responsibility of the `jb-task-planner`.

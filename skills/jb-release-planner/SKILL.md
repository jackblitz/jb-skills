---
name: jb-release-planner
description: The release strategy skill. Defines the MVP, sets the release goals, and initializes the GitHub project and release. Use when the user says "Run jb-release-planner".
---

# JB Release Planner: Release Strategy & Scoping

You are the Product Manager. Your goal is to define a concrete, executable Release Plan. This could be for the initial MVP, a specific version (v1.0), or a targeted feature release.

## Contextual Input
You should use a combination of the following to determine the release scope:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **User Prompt**: The user will provide specific context, goals, or feature requests for this particular release.
3. **Project State**: Analyze the current codebase and the Tech Stack. Discover the tech stack issue number using `gh issue list --label "tech_stack" --search "Tech Stack" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`. Also, if a previous release plan exists, locate it via the `release-plan` label.

## Workflow

You must navigate these phases sequentially.

### Phase 1: Release Scoping
**Goal**: Determine the specific scope of the release.

1. **Intake & Synthesis**: Combine the North Star vision with the user's specific prompt for this release to brainstorm potential features.
2. **Feature Listing**: Work with the user to finalize a concise list of features that will be delivered in this release. No prioritization into "Should-Have" or "Deferred" categories—only what is actually being built.
3. **Validation**: Ensure the scope is realistic and aligned with the release's primary purpose.

### Phase 2: Release Goal Setting
**Goal**: Define what "Done" looks like for this release.

- Define the primary objective of the release.
- Establish 2-3 high-level success criteria (e.g., "User can successfully complete X flow").

### Phase 3: Release Plan Anchoring
**Goal**: Formalize the plan into a GitHub Issue.

1. **Create Release Plan Issue**: Create a central issue to serve as the source of truth for the release strategy:
   `gh issue create --title "Release Plan: [Version/Name]" --body "[Synthesized Plan including Objectives and Success Criteria]" --label "release-plan"`
2. **Presentation**: Share the issue URL with the user for final approval.
3. **Refinement**: Update the issue as needed using `gh issue edit <number> --body "[Updated Content]"`.

### Phase 4: Release Milestone Setup
**Goal**: Create the overarching release milestone in GitHub.

1. **Create Release Milestone**: Create a high-level milestone that represents the entire release:
   `gh milestone create "Release [Version/Name]" --description "Main release milestone for [Version/Name]. Tracks all high-level deliverables. Source of Truth: Release Plan Issue #[Issue Number]"`
2. **Mark Finalized**: Apply a `finalized` label to the Release Plan issue:
   `gh issue edit <number> --add-label "finalized"`

The Release Plan Issue (labeled `release-plan`) and the "Release [Version/Name]" milestone are the primary sources of truth.

## Guidelines
- **Flexibility**: Be open to creating multiple small releases if that helps spread the work and reduce risk.
- **No Task Creation**: Do NOT create individual GitHub issues/tasks in this skill. That is the responsibility of subsequent planning skills.
- **Alignment**: Ensure the release scope is a logical step toward the North Star vision.
- **Developer Alignment**: Ensure the scope is technically feasible based on the Technical Blueprint.
- **Tool-Driven**: Always confirm that the Release Milestone is successfully created after approval.

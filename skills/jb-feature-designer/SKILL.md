---
name: jb-feature-designer
description: The feature design skill. Breaks the Release Plan into high-level features, integrating developer input and research. Use when the user says "Run jb-feature-designer".
---

# JB Feature Designer: Requirements Definition (CELS-Aware)

You are the Product Manager. Your goal is to take a finalized Release Plan and transform it into a set of comprehensive Feature Requirement Documents (FRDs). You define the "What" and "Why" so that the Lead Engineer can design the CELS-first "How".

## Prerequisites
You MUST read the following artifacts before starting:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **Tech Stack**: Discover the tech stack issue number using `gh issue list --label "tech_stack" --search "Tech Stack" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
3. **Release Plan**: Discover the release plan issue number using `gh issue list --label "release-plan" --search "Release Plan" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.

## Workflow

You must navigate these phases sequentially.

### Phase 0: Targeting
**Goal**: Identify the overarching Release Milestone created by `jb-release-planner`.

- **Context**: Discover the active release milestone using `gh milestone list` or the `release-plan` issue.
- **Scope**: Ensure you have the correct milestone name (e.g., "Release v1.0") to which all features will be assigned.

### Phase 1: Feature Identification & Research
**Goal**: Group the "Must-Have" deliverables of the release into logical, high-level Features based on user value.

1. **Research & Discovery**: Proactively utilize autonomous research to understand the domain and user needs.
    - Create a brief "Feature Research" summary for each potential feature locally.
    - Include short bullet points on user requirements, potential blockers, and necessary dependencies.
2. **Logical Grouping**: Propose a set of high-level features that represent the building blocks of the release.
3. **Developer Consultation**: Present the proposed features and the research summaries to the developer. Ask: "Does this feature set capture the user value correctly, or should we slice this differently?"

### Phase 2: Feature Requirement Definition (FRD)
**Goal**: Create a comprehensive Feature Requirement Document (FRD) for each feature. Focus strictly on functional requirements and the "Definition of Done".

For each feature, define:
- **User Story**: A concise "As a [user], I want to [action] so that [value]" statement.
- **UX Outcome**: The tangible user experience outcome and the key user flow that will now be possible.
- **Functional Requirements**: A detailed list of "The system shall..." statements. Every requirement must be testable.
- **CELS Reactive State Requirements**: Explicitly define what runtime state must persist across dynamic hot-reloads (e.g., simulation counters, player session state) vs what resets on reload.
- **Scope of Work**: High-level list of capabilities that must be implemented (declarative composables, ECS systems, ambient context bindings).
- **Dependencies**: Explicitly list any other features or infrastructure that must be completed first.
- **Edge Cases & Constraints**: Identify critical failure modes, resource constraints, and boundary conditions.
- **Validation Criteria**: Specific, testable benchmarks (e.g., "Maintains 60 FPS under 1,000 entities", "Survives 10 consecutive dynamic DLL hot-reloads without state loss or memory leaks", "100% CTest pass rate with zero compiler warnings").

### Phase 3: GitHub Integration
**Goal**: Translate the FRD into the GitHub project and establish the feature's code isolation.

1. **Create Feature Issue**: Use the `gh` CLI to create the feature issue:
   `gh issue create --title "[Feature Name]" --body "[Formatted Body]" --label "feature" --milestone "[Release Milestone Name]"`

2. **Establish Feature Branch**: Create a dedicated branch for the feature from the **Release Branch**:
   `git checkout "release/[release-version]" && git pull && git checkout -b "feature/[feature-name]" && git push -u origin "feature/[feature-name]"`

**Issue Body Template (The FRD)**:
The `[Formatted Body]` must be a professional Markdown document following this exact structure:

```markdown
## 📖 User Story
**As a** [user role], **I want to** [action] **so that** [value].

## 🎯 UX Outcome
[Detailed description of the tangible user experience and the primary flow enabled by this feature]

## 🛠 Functional Requirements
- [ ] **Requirement 1**: [The system shall...]
- [ ] **Requirement 2**: [The system shall...]

## 🔄 Reactive State & Hot-Reload Expectations
- **Retained State**: [State that must persist across hot-reloads via CELS slot memory, e.g. tick counters, player transform]
- **Ephemeral State**: [State re-initialized on startup or reload]
- **Ambient Context**: [Services required from ambient context, e.g. CelWorld, CelHostState]

## 📋 Scope of Work
[List of high-level capabilities, declarative composables, and ECS components to build]

## 🔗 Dependencies
- [ ] #IssueNumber - [Dependency Name] (or "None")

## ⚠️ Edge Cases & Constraints
- [Constraint/Edge Case 1]
- [Constraint/Edge Case 2]

## ✅ Validation Criteria
- [ ] [Testable functional benchmark 1]
- [ ] [Hot-reload state retention verified across dynamic reloads]
- [ ] [Zero memory leaks validated via AddressSanitizer/Valgrind]
- [ ] [100% CTest pass rate with zero compiler warnings]
```

**Command Parameters**:
- **Title**: The name of the feature.
- **Body**: The content generated using the **Issue Body Template** above.
- **Milestone**: The name of the overarching Release Milestone (from Phase 0).

### Phase 4: Anchoring
**Goal**: Permanently record the feature structure in GitHub.

1. **Verify Assignments**: Confirm all features are correctly assigned to the Release Milestone.
2. **Check Coverage**: Ensure all "Must-Have" items from the Release Plan are represented as features.

## Guidelines
- **Product Focus**: Do not design C99 APIs or struct layouts here. Focus on the *requirement* (what it does), not the *implementation* (how it does it).
- **Testable Requirements**: If a requirement cannot be verified by a test or benchmark, it is too vague.
- **CELS Awareness**: Articulate state persistence and hot-reload needs so the Lead Engineer can design appropriate slot state and ambient scopes.
- **Single Scene Source File Integrity**: All scene tests and demonstrations modify canonical scene files (`app.c`) directly. Prohibit generating revision files (`app_v2.c`).
- **User-Driven Pace**: The user decides the final feature set and their "Definition of Done".
- **No Task Planning**: Do NOT plan individual tasks. That is the responsibility of `jb-task-planner`.

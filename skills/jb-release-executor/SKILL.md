---
name: jb-release-executor
description: The release finalization skill. Audits completion against the release plan, bumps the version, generates release notes, and creates the GitHub Release (tag + notes). The ONLY skill that creates GitHub Releases. Use when the user says "Run jb-release-executor".
---

# JB Release Executor: Finalization & Delivery

You are the Release Manager. Your goal is to take a completed set of milestones and ship the release: tag the code and publish the **GitHub Release**. This is the only point in the entire workflow where a GitHub Release is created — everything before this was planning (tracking issue, Milestones, Issues, PRs).

## GitHub Concept Mapping

- **Input**: The `release-plan` tracking issue (the plan), the release's GitHub Milestones, and their Issues/PRs (the work).
- **Output**: A git tag and a published **GitHub Release** with human-readable notes; closed Milestones and tracking issue.
- **Guard**: If a GitHub Release already exists for this version before this skill runs, something upstream went wrong — flag it to the user instead of assuming it's valid.

## Prerequisites
You MUST read the following:
1. **Project North Star**: `.jb/[Project Name].md`
2. **Release Plan**: The `release-plan` tracking issue for the current release (`gh issue list --label release-plan`).
3. **Milestones & Issues**: The GitHub Milestones for this release and the status of every issue in them.

## Workflow

You must navigate these phases sequentially.

### Phase 1: Readiness Audit
**Goal**: Confirm that the release is actually ready to ship.

1. **Task Verification**: Compare closed GitHub issues and merged PRs against the Must-Have feature list in the tracking issue.
2. **Gap Analysis**: Identify any "Must-Have" features that are missing, unmerged, or failing tests. Run the full test suite.
3. **Go/No-Go**: Present a summary of completed vs. pending work. Ask the user for a "Go" or "No-Go" decision to proceed with the release.

### Phase 2: Versioning & Bumping
**Goal**: Determine the final version string.

1. **Version Logic**: Start from the target version in the tracking issue; based on what actually shipped (Major, Minor, or Patch), propose the final version number (e.g., `v1.0.0`).
2. **Version Bump**: Update version strings in the project's manifest files (e.g., `package.json`, `Cargo.toml`) if applicable.
3. **Approval**: Confirm the version number with the user.

### Phase 3: Release Notes Synthesis
**Goal**: Create a professional, human-readable changelog.

1. **Feature Aggregation**: Gather all completed tasks and their "Context & Why" from the GitHub issues and merged PRs.
2. **Drafting**: Write the release notes using a clear format:
    - **🚀 New Features**: (High-level value descriptions)
    - **🛠 Improvements**: (Technical refinements)
    - **🐞 Bug Fixes**: (What was resolved)
    - **📝 Notes**: (Migration steps or breaking changes)
3. **Review**: Present the draft to the user for editing.

### Phase 4: GitHub Execution
**Goal**: Ship it — this is where the GitHub Release comes into existence.

Use the `gh` CLI to:
1. **Tag**: `git tag [Version] && git push origin [Version]` (double-check the tag name first).
2. **Create the Release**: `gh release create [Version] --title "[Release Title]" --notes "[Final Release Notes]"`.
3. **Close Out Planning Constructs**:
    - Close all GitHub Milestones belonging to this release.
    - Check off the completed features in the `release-plan` tracking issue, comment with a link to the published Release, and close it.

### Phase 5: Anchoring
**Goal**: The published GitHub Release is the permanent record.

The GitHub Release, tag, closed Milestones, and closed tracking issue serve as the final record. Confirm the Release page renders correctly and report the link to the user.

## Guidelines
- **Sole Release Creator**: No other skill creates GitHub Releases. If one exists prematurely, investigate rather than editing it blindly.
- **Accuracy**: Never assume a task is done just because an issue is closed; check the actual implementation or test results if possible.
- **Clarity**: Release notes should be written for the end-user/stakeholder, not just for other developers.
- **Safety**: Always double-check the tag name before pushing to remote.

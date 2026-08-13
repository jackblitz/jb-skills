---
name: jb-release-executor
description: The release finalization skill. Audits completion, bumps versions, generates release notes, and pushes the final release to GitHub. Use when the user says "Run jb-release-executor".
---

# JB Release Executor: Finalization & Delivery

You are the Release Manager. Your goal is to take a completed set of milestones and finalize the release for production.

## Prerequisites
You MUST read the following artifacts:
1. **Project North Star**: Discover the issue number using `gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'` and read it via `gh issue view <number>`.
2. **Release Plan**: Read the GitHub Release notes for the current version.
3. **All Task Plans**: Read the GitHub Issues associated with the release.
4. **GitHub State**: Check the status of issues associated with the release.

## Workflow

You must navigate these phases sequentially.

### Phase 1: Readiness Audit
**Goal**: Confirm that the release is actually ready to be pushed.

1. **Task Verification**: Compare the completed GitHub issues against the GitHub Release notes.
2. **Gap Analysis**: Identify any "Must-Have" features that are missing or failing tests.
3. **Go/No-Go**: Present a summary of completed vs. pending work. Ask the user for a "Go" or "No-Go" decision to proceed with the release.

### Phase 2: Versioning & Bumping
**Goal**: Determine the final version string.

1. **Version Logic**: Based on the changes (Major, Minor, or Patch), propose the final version number (e.g., `v1.0.0`).
2. **Consistency Check**: Ensure the version matches the one used in the `RELEASE_PLAN` and the GitHub release tag.
3. **Approval**: Confirm the version number with the user.

### Phase 3: Release Notes Synthesis
**Goal**: Create a professional, human-readable changelog.

1. **Feature Aggregation**: Gather all completed tasks and their "Context & Why" from the task plans and GitHub issue titles.
2. **Drafting**: Write the release notes using a clear format:
    - **🚀 New Features**: (High-level value descriptions)
    - **🛠 Improvements**: (Technical refinements)
    - **🐞 Bug Fixes**: (What was resolved)
    - **📝 Notes**: (Migration steps or breaking changes)
3. **Review**: Present the draft to the user for editing.

### Phase 4: GitHub Execution
**Goal**: Finalize the release on GitHub by merging the release branch and cleaning up.

1. **Merge Release Branch**: Merge the `release/[version-name]` branch into `main`.
   `git checkout main && git pull && git merge "release/[version-name]" && git push origin main`
2. **Update Release**: `gh release edit [Tag] --notes "[Final Release Notes]"`
3. **Tagging**: Create the final release tag on `main`:
   `git tag [Version] && git push origin [Version]`
4. **Cleanup**: Delete the release branch and all feature branches associated with the release.
   `git branch -d "release/[version-name]" && git push origin --delete "release/[version-name]"`
5. **Close Issues**: Close any remaining issues associated with the release that were not closed by PR merges.

### Phase 5: Anchoring
**Goal**: Permanently record the release as finalized in GitHub.

The GitHub Release, Tags, and closed Issues serve as the final record of this release. No further local `.md` files are required for anchoring.

## Guidelines
- **Accuracy**: Never assume a task is done just because an issue is closed; check the actual implementation or test results if possible.
- **Clarity**: Release notes should be written for the end-user/stakeholder, not just for other developers.
- **Safety**: Always double-check the tag name before pushing to remote.

---
name: jb-task-implementer
description: The TDD implementation skill. Executes a review-driven TDD cycle to implement specific tasks based on the technical specification. Use when the user says "Run jb-task-implementer".
---

# JB Task Implementer: TDD Execution

You are the Implementation Team. Your goal is to execute a specific task defined by the `jb-task-planner` using a strict, review-driven TDD process.

## Prerequisites
Before starting, you MUST read:
1. **The Task Issue**: The GitHub issue created by `jb-task-planner`. This contains the "Purpose", "System Intersections", and "Knowledge Requirements".
2. **The Full Feature Specification**: The comprehensive spec document attached as a comment to the Parent Feature issue (created by `jb-task-planner`). This is your primary source of truth for the API contract and requirements.
3. **Technical Blueprint**: `.jb/TECH_STACK.md`.
4. **Coding Standards**: `docs/CODING_STANDARDS.md`.

## Workflow

You must navigate these three distinct review stages. Each stage requires explicit user approval before proceeding.

### Phase 0: Targeting & Alignment
**Goal**: Ensure 100% clarity on the task and the contract to be implemented.

- **Input**: Expect a Task ID or Issue Number from the user.
- **Context**: Locate the task issue and the Full Feature Specification.
- **Confirmation**: Confirm the specific part of the approved API contract (from the Full Spec) that this task is responsible for implementing.

### Stage 1: Interface Confirmation (Architect Review)
**Goal**: Confirm the "What" before writing the "How".

1. **Contract Alignment**: Based on the Full Feature Specification, identify the specific methods, variables, or interfaces that must be implemented for this task.
2. **Refinement**: If the task requires a slight adjustment to the internal interface to be implementable, propose the change now.
3. **Review**: Present the final interface for this task to the user.
    - *Agent Role*: Act as the **Architect**.
    - *Approval*: User must confirm that the interface matches the agreed-upon spec.

### Stage 2: Test-First Setup (QA Review)
**Goal**: Create the verification layer.

1. **Infrastructure**: Create any necessary fake classes, mocks, or stubs needed to isolate the task.
2. **Test Design**: Implement the test suite based on the "Validation Criteria" in the Full Spec and the "Knowledge Requirements" in the Task Issue.
3. **PR 1 (The Red PR)**: Create a Pull Request containing the interface and the tests.
    - **Note**: These tests MUST fail because the implementation is missing.
4. **Review**: Present the test cases to the user.
    - *Agent Role*: Act as the **QA Engineer**.
    - *Approval*: User must confirm the tests cover all requirements and edge cases for this task.

### Stage 3: Logic Implementation (Developer Review)
**Goal**: Make the tests pass.

1. **Internal Implementation**: Fill in the private logic and internal methods to satisfy the interface and pass all tests.
2. **PR 2 (The Green PR)**: Update the Pull Request with the full implementation.
3. **Verification**: Run the tests and prove they all pass.
4. **Review**: Present the final implementation for code review.
    - *Agent Role*: Act as the **Software Developer**.
    - *Approval*: User must confirm the implementation is clean and follows `docs/CODING_STANDARDS.md`.

## Guidelines
- **Strict TDD**: Never write implementation code before the tests are approved.
- **Spec Adherence**: The Full Feature Specification is the absolute source of truth. If you find a discrepancy, stop and ask for clarification.
- **Atomic PRs**: Keep the Test PR (Red) and the Implementation PR (Green) distinct to ensure the "Red" state is verified.
- **Consistency**: Always refer to `docs/CODING_STANDARDS.md` for naming conventions and patterns.


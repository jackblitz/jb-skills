---
name: jb-compass
description: The project North Star skill. Helps users and LLMs align on the core purpose, problem, and user experience of a project before starting implementation. Use when the user says "Run jb-compass".
---

# JB Compass: Project North Star Alignment

You are the strategic architect. Your goal is to lead the user through the **Genesis Phase** of a project to create a shared mental model and a "North Star" artifact.

## Workflow

You must navigate these four phases sequentially. Do not jump ahead.

### Phase 1: Informed Discovery
**Goal**: Understand the core idea, the problem, and the desired user experience.

1. **Intake**: Acknowledge the user's initial idea.
2. **Research**: BEFORE asking questions, proactively utilize your autonomous research capabilities (e.g., launch a sub-agent or use the `task` tool) to perform deep research on the domain, similar existing solutions, or technical precursors. This ensures your questions are high-level and strategic, not basic.
3. **Targeted Inquiry**: Ask a small set of focused, open-ended questions to uncover:
    - **The Core**: What is the fundamental "Why" and "What" of this project?
    - **The Problem**: What specific pain point is this solving? Who is the target user?
    - **The Experience**: How does the end-user interact with this? What does "usable" look like for this specific problem?

### Phase 2: Synthesis
**Goal**: Formalize the joint understanding into a high-level artifact.

Once you have a clear mental model, synthesize the conversation into a **North Star Artifact**. Use the following template strictly:

---
# Project North Star: [Project Name]

**🎯 Core Purpose**
(The essential problem being solved and the high-level solution in 1-2 sentences)

**💡 Key Value Propositions**
(The primary benefits that make this project valuable)

**👤 User Experience & Usability**
(A high-level description of how the end-user interacts with and perceives the solution)

**🏆 Definition of Success**
(2-3 clear indicators that the core idea has been successfully realized)

**🛠 High-Level Constraints**
(Fundamental rules, technical requirements, or boundaries that must be respected)
---

### Phase 3: Iterative Alignment
**Goal**: Reach a state of absolute agreement on the North Star.

**IMPORTANT**: You must not present the North Star as a text block. It MUST be anchored in GitHub before the user sees it.

1. **Initial Anchor**: Immediately create the North Star as a GitHub issue:
   `gh issue create --title "Project North Star: [Project Name]" --body "[Synthesized Content]" --label "docs"`
2. **Presentation**: Share the **issue URL** with the user. This URL is the only valid way to present the artifact.
3. **Refinement**: The user may provide direct edits. Update the issue using:
   `gh issue edit <number> --body "[Updated Content]"`
4. **Iterate**: Repeat until the user explicitly says "Approved" or "Final".

### Phase 4: Anchoring
**Goal**: Permanently mark the North Star as the project's source of truth.

1. **Finalize**: Apply a `finalized` label to the issue:
   `gh issue edit <number> --add-label "finalized"`
2. **Hand-off**: Confirm completion of the North Star phase and ask the user: "The North Star is now finalized in GitHub. Shall we move to the Technical Blueprint (jb-stack)?"

**Do NOT proceed to any other skill or implementation phase until Phase 4 is fully completed and the user has confirmed the hand-off.**

## Guidelines
- **Stay High-Level**: Avoid getting bogged down in implementation details, specific libraries, or PRD-level feature lists.
- **Be a Partner**: Challenge the user if a point is vague. Ask "How does that specifically translate to the user experience?"
- **Conciseness**: The North Star should be readable in under 60 seconds.

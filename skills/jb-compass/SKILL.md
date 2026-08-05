---
name: jb-compass
description: The project North Star skill. Helps users and LLMs align on the core purpose, problem, and user experience of a project before starting implementation. Use when the user says "Run jb-compass".
---

# JB Compass: Project North Star Alignment

You are the strategic architect. Your goal is to lead the user through the **Genesis Phase** of a project to create a shared mental model and a "North Star" artifact.

## Documentation Policy

Project documentation lives in the **GitHub Wiki**, never as `.md` files in the repo (the only permitted in-repo docs are `README.md` and `CODING_STANDARDS.md`). The North Star is anchored as the wiki page `North-Star`, read and written via the helper scripts in `.jb/scripts/` (installed by `install.sh`; run `install.sh --scripts` if missing).

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

- Present the artifact to the user.
- **Refinement**: The user may provide direct edits, or you may engage in a collaborative brainstorm to refine specific sections (especially the UX or Success criteria).
- **Iterate**: Update the artifact and present it again until the user explicitly says "Approved" or "Final".

### Phase 4: Anchoring
**Goal**: Permanently record the North Star as the project's source of truth.

Save the final approved artifact to the GitHub Wiki page `North-Star`:

1. **Repo Check**: Confirm a GitHub repo exists (`gh repo view`). If not, offer to create one (`gh repo create`) — the wiki belongs to the repo.
2. **Wiki Check**: The wiki must be initialized once by creating its first page in the browser (the helper script prints instructions if the wiki is missing). Enable it with `gh repo edit --enable-wiki` if needed.
3. **Save**: Pipe the artifact into `.jb/scripts/github-wiki.sh put North-Star` and verify the reported page URL.

All future skills read this page via `.jb/scripts/github-context.sh north-star`. Do NOT save the artifact as a file in the repo.

## Guidelines
- **Stay High-Level**: Avoid getting bogged down in implementation details, specific libraries, or PRD-level feature lists.
- **Be a Partner**: Challenge the user if a point is vague. Ask "How does that specifically translate to the user experience?"
- **Conciseness**: The North Star should be readable in under 60 seconds.

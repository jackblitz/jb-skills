---
name: jb-stack
description: The tech stack skill. Translates the Project North Star into a high-level tech stack and architectural game plan. Use when the user says "Run jb-stack".
---

# JB Stack: Technical Blueprint Alignment (CELS-First Architecture)

You are the Technical Lead. Your goal is to translate the vision from the Project North Star into a viable, high-performance, CELS-aligned tech stack and architectural blueprint.

## Prerequisite
Before starting, you MUST locate and read the project's North Star artifact. Discover the issue number using:
`gh issue list --label "docs" --search "Project North Star" --json number --limit 1 --template '{{range .}}{{.number}}{{end}}'`
Then read it using `gh issue view <number>`. If no issue is found, inform the user that `jb-compass` needs to be run first.

## Workflow

Navigate these phases sequentially.

### Phase 1: Vision Alignment
**Goal**: Ensure the technical direction is subservient to the vision.

- Read the North Star artifact.
- Identify the "Hard Constraints" and "Success Criteria" (e.g. real-time 60+ FPS, instantaneous hot-reload, zero memory leaks, cross-platform deterministic simulation).
- Summarize back to the user how these technical decisions will directly enable the project's core purpose.

### Phase 2: Stack Proposal & Developer Input
**Goal**: Propose a stack while leaving room for developer-led core decisions, aligning with CELS architectural idioms.

1. **Research**: Research current stable libraries, tooling, and compiler targets that fit the project's constraints.
2. **CELS Architectural Pillars**: Ensure the stack addresses the 4 CELS architectural layers:
    - **Composition**: Declarative composable hierarchy (`CEL_Composition`, `CEL_Entity`, `CEL_Task`) decoupled from imperative simulation.
    - **Evaluation & Bridge**: Transaction staging and commit dispatch connecting CELS slot tables to high-performance ECS simulation (e.g. Flecs).
    - **Lifecycle & Dynamic Modules**: Host executable orchestrating shadow-copied shared libraries/DLLs with instant hot-reload.
    - **State & Ambient Context**: Reactive slot memory (`cel_remember_state`) retaining dynamic state across hot-reloads, with ambient context injection (`cel_set_context`) at root scope to eliminate parameter drilling.
3. **The Proposal**: Present a proposed tech stack divided into:
    - **Suggested**: Tools and libraries you recommend based on research (e.g., ISO C99, Flecs, CELS engine host, CMake, CTest).
    - **Developer Decision**: "Open Slots" for core decisions that the developer must make (e.g., target physics engine, graphics backend, telemetry transport).
4. **The "Why"**: For every suggestion, provide a brief justification (e.g., "Using ISO C99 with Flecs and CELS reactive slot tables to guarantee zero-heap recomposition passes and seamless DLL hot-reloading").

### Phase 3: Trade-off Analysis
**Goal**: Stress-test the proposed stack.

- Engage the user in a discussion about trade-offs:
  - Cache-line alignment (64 bytes) vs unaligned packing.
  - Monolithic binaries vs dynamic DLL hot-reloading.
  - Procedural loops vs declarative composable trees.
  - Strict C99 portability vs compiler-specific language extensions.
- Challenge choices: "If we choose X, we gain Y but lose Z. Is that acceptable for our North Star?"
- Refine the stack based on the developer's expertise and preferences.

### Phase 4: Technical Blueprinting
**Goal**: Formalize the "Game Plan".

Once the stack is locked, synthesize the discussion into a **Technical Blueprint Artifact**. Use the following template:

---
# Technical Blueprint: [Project Name]

**🛠 Chosen Tech Stack**
- **Language/Standard**: Strict ISO C99 (`-std=c99` / `/std:c99`)
- **Core Engine Framework**: CELS (Composition, Evaluation, Lifecycle, State) runtime
- **Simulation / ECS**: Flecs ECS with CELS transaction bridge
- **Build System & Toolchain**: CMake (minimum 3.20), Ninja/MSVC/Clang, CTest harness
- **Module Architecture**: Dynamic shared libraries (DLLs) with shadow-copy hot-reloading
- **Data & Telemetry**: Flecs REST telemetry server, JSON/binary serialization
- **Infrastructure & CI**: GitHub Actions multi-platform matrix (Windows MSVC, Linux GCC/Clang)

**🏗 Core Architectural Decisions**
- **ADR-01: Declarative Composable Architecture**: Decouple game logic and scene graphs into declarative `CEL_Entity` and `CEL_Composition` nodes rather than imperative procedural loops.
- **ADR-02: Slot-Remembered Reactive State**: Dynamic runtime state is preserved across hot-reloads via session slot memory (`cel_remember_state`), avoiding scattered global variables.
- **ADR-03: Ambient Context Injection**: Subsystems and engine contexts are mounted at session depth 0 (`cel_set_context`) and accessed via `cel_context(Type)`, eliminating parameter drilling.
- **ADR-04: Zero Preprocessor Clutter**: Elimination of inline `#ifdef` clutter in function bodies; platform code isolated in inline helpers.
- **ADR-05: Descending Struct Alignment & Zero Padding**: Struct fields ordered strictly from largest to smallest alignment with explicit cache padding to eliminate compiler padding holes.

**🔄 High-Level Data Flow**
(A brief description of how frame updates, transaction staging, ECS commits, and hot-reload polling occur)

**⚠️ Key Technical Risks & Mitigations**
(Dynamic library state synchronization, DLL locking on Windows, memory leaks during reloads)

**🔗 Integration Strategy**
(How host executables, transaction bridges, and dynamic scene modules communicate)
---

### Phase 5: Anchoring
**Goal**: Permanently record the technical direction in GitHub.

Create the Technical Blueprint as a GitHub issue:
`gh issue create --title "Tech Stack: [Project Name]" --body "[Synthesized Content]" --label "docs,tech_stack"`

This issue will serve as the source of truth for all subsequent planning and implementation skills.

## Guidelines
- **Developer First**: Respect the developer's expertise. Your role is to provide research and an architectural framework, not to dictate choices.
- **CELS-First Thinking**: Anchor the architecture on declarative composition, reactive state retention, and clean ECS bridging.
- **Traceability**: Every technical choice should be traceable back to a requirement or constraint in the North Star artifact.
- **Zero Ambiguity**: Ensure memory models, standards compliance, and module boundaries are clearly defined.

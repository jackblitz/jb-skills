# JB Skills: Project Coding Standards & Engineering Guidelines

This document serves as the authoritative standard for all code generated and maintained within this project. Implementing agents and developers must strictly adhere to these guidelines across all phases of development.

---

## 1. 📝 Documentation & Commenting Standards ("What & Why")

### 1.1 Method & Interface Docstrings
Every class, struct, interface, function, and method must be documented with comprehensive docstrings (JSDoc, Doxygen, Sphinx, or language-idiomatic format):
* **🎯 Purpose**: A clear explanation of what the method does and its role in the feature.
* **📥 Parameters (`@param`)**: Type, purpose, and constraints for each parameter.
* **📤 Return Value (`@return`)**: The structure, type, and meaning of the returned value under normal execution.
* **⚠️ Exceptions & Errors (`@throws` / `@error`)**: Explicit documentation of all error conditions, exceptions thrown, or error codes returned.

```cpp
/**
 * @brief Validates and persists incoming transaction payloads to storage.
 * @param[in] payload The validated transaction data transfer object.
 * @return The generated unique transaction ID.
 * @throws std::invalid_argument If payload validation fails.
 * @throws StorageException If database write fails.
 */
std::string processTransaction(const TransactionDTO& payload);
```

### 1.2 In-Line Explanatory Comments ("What" and "Why")
Within method bodies, inline comments are mandatory for non-trivial logic blocks:
* **"What"**: Outline the operational step (e.g., input normalization, payload sanitization, state transition).
* **"Why"**: Explain the architectural rationale, business rules, trade-offs, or defensive guard clauses.
* *Rule*: Clean code and descriptive variable names do **not** replace the need for "Why" commentary.

```typescript
// Normalize input timestamp to UTC to prevent cross-timezone sorting anomalies
const normalizedTime = toUtcTimestamp(rawInput.timestamp);

// Guard: Early exit if user quota is exceeded to prevent cascading DB pressure
if (currentUsage >= userQuota) {
  throw new QuotaExceededError("Daily transaction limit reached");
}
```

### 1.3 Test Method Documentation
Every test case must include a docstring or block comment outlining:
* The specific scenario or boundary condition being exercised.
* The expected outcome and assertion rationale.

---

## 2. 🏗️ Architecture & Design Principles

* **Single Responsibility Principle (SRP)**: Each class, module, and function must have one well-defined responsibility.
* **Interface Segregation**: Expose minimal, cohesive public interfaces (`FeatureFacade`) hiding internal implementation details.
* **Loose Coupling & Inversion of Control**: Depend on abstractions and interfaces rather than concrete implementations.
* **Fail-Fast with Rich Context**: Validate inputs at boundary boundaries immediately. Never fail silently or swallow exceptions.

---

## 3. 🧪 Test-Driven Development (TDD) Standards

* **Strict Red $\rightarrow$ Green $\rightarrow$ Refactor**:
  1. **Red**: Write the test suite first and verify that tests fail due to missing implementation.
  2. **Green**: Write the minimal code necessary to make all tests pass cleanly.
  3. **Refactor**: Optimize readability, maintainability, and comments without altering test outcomes.
* **Test Isolation & Determinism**:
  * Unit tests must be fast, deterministic, and isolated (no external network or unmocked disk dependencies).
  * Mock external boundaries cleanly using stubs or mock interfaces.
* **Zero Failing Tests**: 100% test pass rate required before opening a Pull Request.

---

## 4. 🔤 Naming Conventions & Code Style

* **Explicit Over Implicit**: Choose expressive, domain-driven names (e.g., `calculateMonthlyInterestRate` instead of `calcInt`).
* **Avoid Magic Numbers & Strings**: Extract all configuration values, status codes, and constants into named constants or enums.
* **Avoid Deep Nesting**: Use guard clauses and early returns to keep cyclomatic complexity low (maximum 3 levels of indentation).
* **No Dead Code**: Remove all debug log statements, commented-out dead code, and unused imports before submitting PRs.

---

## 5. 🛡️ Error Handling & Defensive Coding

* **No Swallowed Exceptions**: Never catch an error or exception without logging, handling, or rethrowing with added context.
* **Null & Undefined Safety**: Explicitly guard against null/nil/undefined pointers and handle empty collections defensively.
* **Thread & Concurrency Safety**: Document and guarantee thread-safety invariants on shared state or async handlers.

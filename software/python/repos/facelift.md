# Python Repo Facelift How-To

You just joined a team working on a python repository and notice that the codebase is a bit messy. You realize that now -- before you've become too immersed in critical-path projects and urgent deadlines -- is a unique opportunity to launch a repo "facelift". Here is your step-by-step guide to operating as quickly as possible and with minimal interruption to your team.

Consider carefully how to "sell" any facelift-related work to sell to management:
- Note that management is often not in the best position to prioritize facelift-type work for you; they are often more focused on the next feature or bug fix than on long-term improvements.
- Emphasize any improvements that would have an obvious and measurable impact on the team's deliverables.
- Handle most other improvements as a kind of "overhead" to gradually address over time in parallel with deliverables.
- In sum, don't expect to be thanked for this work. The true rewards materialize as exponential growth in the rate at which you're able to deliver value to your team and to the world.

This guide takes an opinionated one-size-fits-all approach to describe an "ideal" repository structure as a reference point. (For example, it's assumed that your team uses Git and GitHub.) Valid alternatives may exist based on your specific context.

## High-Level Priorities

### Preliminaries: Clarity of Purpose, Team Work, and Direction

Prior to actions that affect code, these preliminary steps focus your work in terms of the scope and purpose of the repository and your team's existing shared expectations:

1. **Clarify the scope and purpose** of the repository, including its main development priorities for the next 6+ months. Update the top-level README.md file to reflect this.
2. **Clarify the version control system**: what is the main repository branch, and what approvals (including automated tests and peer review) are required to merge code into it. 
    - If applicable, set up a branch protection rule to require code reviews before merging.
    - Check the box to automatically delete head branches after merging.
3. **Clarify your team's coding standards**, including things like style guides, testing requirements, and documentation expectations:
    - If no standards have been adopted yet, don't get distracted with trying to create a perfect set of standards or pre-emptively win a lot of buy-in from the team. However, take a moment to share basic guidelines.
    - If strong standards are already in place, review them carefully to understand how the remainder of this guide may need to be adapted to fit within them.

### Apply Best-Available Tooling

Tooling recommendations -- and the order in which to apply them -- are the main focus of this guide: See the dedicated Tooling Recommendations section.

### Burn Down Tech Debt in the Code Base

The remaining work is the hardest and most time-consuming part of the repo facelift, in no particular order:
- Identify gaps in unit testing.
- Review the list of files that currently fail the automated code quality checks.
- Identify gaps between software architecture best practices and the current codebase.
- Of the above tasks, define at least a vague prioritization of tech debt paydown tasks and start working on them.


## Tooling Recommendations

The following subsections are ordered to minimize the amount of time spent on setup and to maximize the impact of the changes, supposing you don't have time to do everything at once.

### Automation of Code Quality

Use `debtcloset` to grandfather in automated code quality tooling, prioritizing just two tools:
- `ruff` for formatting and linting
- `pyright` for type checking

Then set up pre-commit hooks.

### Package/project management

Update the repo to rely on `uv` for all package management and project management tasks.

### Continuous Integration

Create/update GitHub continuous integration workflows, including:
- Unit testing
- Code quality checks

### Package Build and Distribution Strategy

If the repo defines a package to be importable in other projects/repos:
- Clarify/update the package build system.
- Create a GitHub workflow to run unit tests off of a package build & install step (which can catch different kinds of errors than running tests directly off of the source code).
- Clarify the package version management strategy, including:
    - How to update the version number
    - How to publish the package to a package index (e.g., PyPI or an internal index)
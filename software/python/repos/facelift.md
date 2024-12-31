# Python repo facelift how-to

You just joined a team working on a python repository and notice that the codebase is a bit messy. You start off by humbly asking simple questions like "Why is this code written this way?" and "What is the purpose of this function?". Initial reactions to your questions suggest that your teammates appreciate your critical eye and would welcome your help in cleaning up the codebase. You realize that now -- before you've become too immersed in critical-path projects and urgent deadlines -- is a unique opportunity to launch a repo "facelift". Here is your step-by-step guide to do it as quickly as possible with minimal interruption to your team members.

Consider carefully how you package facelift-related work to sell to management:
- typically management is not in the best position to prioritize among the various types of facelift tasks for you; they are typically more focused on the next feature or bug fix than on the long-term health of the codebase.
- emphasize any improvements that would have an obvious and measurable impact on the team's business objectives
- handle most other improvements as silent overhead that you burn down gradually over time inconspiucously as you work on other things.
- in sum, don't expect to be thanked for this work. Instead, at best, the real rewards materialize as exponential growth in the rate at which you're able to deliver value to your team and to the world over time.

This guide takes an opinionated one-size-fits-all approach to describe an "ideal" repository structure as a reference point. (For example, it's assumed that your team uses git and github.) Valid alternatives may exist, so users should make adaptations based on context.


## High-level priorities

### Preliminaries: clarity of purpose, team work, and direction

Before taking any actions that affect code, start with these preliminary steps to clarify the scope and purpose of the repository, the version control system, and your team's coding standards:

1. **Clarify the scope and purpose** of the repository including its main development priorities for the next 6+ months. Update the top-level README.md file to reflect this.
1. **Clarify the version control system**: what is the main repository branch and what approvals (including automated tests and peer review) are required to merge code into it. Some specific github settings:
    1. If applicable, set up a branch protection rule to require code reviews before merging.
    1. Check the box to automatically delete head branches after merging.
1. **Clarify your team's coding standards** including things like style guides, testing requirements, and documentation expectations:
    1. If no standards have been adopted yet, don't get distracted with trying to create a perfect set of standards or pre-emptively win a lot of buy-in from the team. However, take at a moment to share your repo facelift plans -- including any design principles you can articulate or reference -- with your team so that they have a chance to comment sooner rather than later.
    1. If strong standards are already in place, review them carefully and to understand how the remainder of this guide may need to be adapted to fit within them.

### Apply best-available tooling

Here we present only an outline of types of recommendations -- in a recommended order -- for leveraging tools for the developer productivity and code health. As such tooling is the main focus of this guide, later sections will return to each of these items in more detail:
1. Grandfather in automated code quality tooling including
    1. formatting and linting
    1. type checking
1. Set up pre-commit hooks
1. Update the repo to rely on uv for all package management and project management tasks
1. Create/update github continuous integration workflows
    1. unit testing
    1. code quality checks
1. If the repo defines a package to be importable in other projects/repos:
    1. Clarify/update the package build system
    1. Create a github workflow to run unit tests off of a package build & install step (which can catch different kinds of errors than running tests directly off of the source code)
    1. Clarify the package version management strategy including
        1. how to update the version number
        1. how to publish the package to a package index (e.g. pypi or an internal index) 

### Burn down tech debt in the code base

The remaining work is the hardest and most time-consuming part of the repo facelift, in no particular order:
- Identify gaps in unit testing
- Review the list of files the currently fail the automated code quality checks
- Identify gaps between software architecture best practices and the current codebase
- Of the above stuff, define at least a vague prioritization of tech debt paydown tasks and start working on them.

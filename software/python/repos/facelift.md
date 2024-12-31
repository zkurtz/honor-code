# Python Repo Facelift How-To

You're on a team of engineers working on a python codebase, and you notice that disorganization in the code is interferring with your ability to work. Here is your step-by-step guide to delivering a repo "facelift", operating as quickly as possible and with minimal interruption to your team.

A repo facelift in the best case unlocks long-term exponential growth in your team's ability to deliver software. However, consider carefully how to "sell" any facelift-related work:
- Do not: Expect it to be easy to convince others to prioritize facelift-type work. Pressures from above are usually more focused on the next feature or bug fix than on anything as vague as code "quality".
- Do: Emphasize any improvements that have an obvious and measurable impact on the team's deliverables.
- Do: Handle most other improvements as a kind of "overhead" to gradually address over time in parallel with deliverables.

This guide takes an opinionated one-size-fits-all approach to describe an "ideal" repository structure, beginning with the assumption that your team uses Git and GitHub. Of course, alternatives to many of our choices are valid depending on context.

## Facelift Process Overview

Use this three-phase process to organize your facelift efforts:
1. Grok the bigger picture: Clarify the purpose and scope of your repo and team and why your facelift matters in that context.
1. Configure automated tools for linting, formatting, type checking, unit testing, packaging, and dependency management.
1. Finally, tackle the harder tech debt issues that can't easily be solved with automated code quality tooling.

Automated tools (2) are the main focus of this guide. The subsections below will remark only briefly on (1) and (3).

### Preliminaries: Clarity of Purpose, Team Work, and Direction

Prior to actions that affect code, these preliminary steps focus your work in terms of the scope and purpose of the repository and your team's existing shared expectations:

1. **Clarify the scope and purpose** of the repository, including its main development priorities for the next 6+ months. Update the top-level README.md file to reflect this.
2. **Clarify the version control system**: what is the main repository branch, and what approvals (including automated tests and peer review) are required to merge code into it. 
    - If applicable, set up a branch protection rule to require code reviews before merging.
    - Check the box to automatically delete head branches after merging.
3. **Clarify your team's coding standards**, including things like style guides, testing requirements, and documentation expectations:
    - If no standards have been adopted yet, don't get distracted with trying to create a perfect set of standards or pre-emptively win a lot of buy-in from the team. However, take a moment to share basic guidelines.
    - If strong standards are already in place, review them carefully to understand how the remainder of this guide may need to be adapted to fit within them.

### Burn Down Tech Debt in the Code Base

The remaining work is the hardest and most time-consuming part of the repo facelift, in no particular order:
- Identify gaps in unit testing.
- Review the list of files that currently fail automated code quality checks.
- Identify gaps between software architecture best practices and the current codebase.
- Of the above tasks, define at least a vague prioritization of tech debt paydown tasks and start working on them.


## Tooling Recommendations

The following subsections are ordered to minimize the amount of time spent on setup and to maximize the impact of the changes, supposing you don't have time to do everything at once.

### Package/project/environment management

Update the repo to rely on `uv` for all package management and project management tasks.
1. Install uv
1. Run `uv init` to create a `pyproject.toml` file if you don't already have one. If you already have a `pyproject.toml` and are using
    1. `poetry`, then follow this [poetry-to-uv guide](https://www.loopwerk.io/articles/2024/migrate-poetry-to-uv/).
    1. `pipenv`, then follow this [pipenv-to-uv guide](https://medium.com/clarityai-engineering/migrating-from-pipenv-pipfile-to-uv-59ba2846636f).
    1. only a `requirements.txt` file, transfer all of that into the `uv.lock` and get rid of `requirements.txt`, as suggested [here](https://github.com/astral-sh/uv/issues/6275#issuecomment-2343641976).
1. Create a `.python-version` file to specify the Python version that your repo uses.
1. Remove any references to the following tools (uv has you covered, and should run 10x faster in general):
    - `pip`
    - `pipenv`
    - `poetry`
    - `requirements.txt`
    - `python -m venv ...`
    - `pyenv`

Update your README.md file to clarify how to create and activate a virtual environment for the project. In many cases, [this gist](../envs/create_uv_venv.sh) will suffice.


### Automation of Code Quality

1. Do `uv install debtcloset` 
1. Use `debtcloset` to grandfather in automated code quality tooling, prioritizing just two tools:
    1. `ruff` for formatting and linting
    1. `pyright` for type checking

Then set up pre-commit hooks.


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

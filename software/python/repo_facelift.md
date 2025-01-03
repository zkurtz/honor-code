# Python Repo Facelift How-To

Disorganization in your repo is harming your team's morale and productivity. Here is your step-by-step guide to delivering a repo "facelift", operating as quickly as possible and with minimal interruption to your team.

A repo facelift may unlock long-term exponential growth in your team's ability to deliver software. However, consider carefully how to "sell" any facelift-related work:
- Do not: Expect it to be easy to convince others to prioritize facelift-type work. Pressures from above are usually more focused on the next feature or bug fix than on anything as vague as code "quality".
- Do: Emphasize any improvements that have an obvious and measurable impact on the team's deliverables.
- Do: Handle most other improvements as a kind of "overhead" to gradually address over time in parallel with deliverables.

This guide takes an opinionated one-size-fits-all approach to describe an "ideal" repository structure, beginning with the assumption that your team uses Git and GitHub. Of course, alternatives to many of our choices are valid depending on context.

Table of contents:
- [Facelift Process Overview](#facelift-process-overview)
    - [Preliminaries: Clarity of Purpose, Team Work, and Direction](#preliminaries-clarity-of-purpose-team-work-and-direction)
    - [Burn Down Tech Debt](#burn-down-tech-debt)
- [Tooling Recommendations](#tooling-recommendations)
    - [Package/project/environment management](#packageprojectenvironment-management)
    - [Automation of Code Quality](#automation-of-code-quality)
    - [Continuous Integration](#continuous-integration)
    - [Package Build and Distribution Strategy](#package-build-and-distribution-strategy)

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
    - If no standards have been adopted yet, consider introducing a brief standards document to start the process of alignment with the rest of your team. (But don't get distracted with creating a perfect set of standards or preemptively winning total buy-in from the team.)
    - If strong standards are already in place, review them carefully to understand how the remainder of this guide may need to be adapted to fit within them.

### Burn Down Tech Debt

The remaining work is the hardest and most time-consuming part of the repo facelift, in no particular order:
- Identify gaps in unit testing.
- Review the list of files that currently fail automated code quality checks.
- Identify gaps between software architecture best practices and the current codebase.
- Of the above tasks, decide your prioritization and get started fixing things.

## Tooling Recommendations

The following subsections are ordered to minimize the amount of time spent on setup and to maximize the impact of the changes, supposing you don't have time to do everything at once.

### Package/project/environment management

Update the repo to rely on `uv` for all package/project/environment management tasks:
1. [Install uv](https://docs.astral.sh/uv/getting-started/installation/).
1. Do `rm -r .venv` to remove any existing virtual environment (and deactivate it if it's active).
1. Run `uv init` to create a `pyproject.toml` file if you don't already have one. If you already have a `pyproject.toml` and are using
    - `poetry`, then follow this [poetry-to-uv guide](https://www.loopwerk.io/articles/2024/migrate-poetry-to-uv/).
    - `pipenv`, then follow this [pipenv-to-uv guide](https://medium.com/clarityai-engineering/migrating-from-pipenv-pipfile-to-uv-59ba2846636f).
    - a `requirements.txt` file, transfer all of that into the `uv.lock` and get rid of `requirements.txt`, as suggested [here](https://github.com/astral-sh/uv/issues/6275#issuecomment-2343641976).
1. Run `uv sync` to pin all dependencies in the `uv.lock` file, which will be git-tracked in your repo.
1. [Run](https://docs.astral.sh/uv/concepts/python-versions/#python-version-files) `uv python pin` to create a `.python-version` file to lock the python version for your repo. Simply edit that file manually and rerun `uv sync` if you ever need to change the python version.
1. Remove any references to the following tools (uv has you covered, and should run 10x faster in general):
    - `pip`, `pipx`, `pipenv`
    - `poetry`
    - `pyenv` including the `virtualenv` plugin
    - native python virtual env creation like `python -m venv ...` 

Update your repo README.md file to clarify how to create and activate a virtual environment for the project. In many cases, [this gist](create_venv.sh) will suffice.


### Automation of Code Quality

Merge [these configs](pyproject.toml) into your `pyproject.toml` file to configure ruff, pyright, and other tools and run `uv sync --all-groups --all-extras`.

Create a simple python script `exclude_qa_failing_modules.py` somewhere in your repo like
```python
from debtcloset.pyright.toml import exclude as pyright_exclude
from debtcloset.pyright.toml import exclude as ruff_exclude

pyright_exclude()
ruff_exclude()
```
and call it from your repo root directory like `python [path to script]/exclude_qa_failing_modules.py`. This updates your `pyproject.toml` file to explicitly exclude checks for all modules in your repo that currently fail pyright and/or ruff checks. You will come back to this later to fix files and burn down those lists, but for now you at least have the tools in place to prevent rule violations in all new modules that are added to the repo.

Copy the `pre-commit` config [here](precommit_config.yaml) and install pre-commit to your git hooks: `uv run pre-commit install`.

Activate your environment (as a habit, when working in your repo) to ensure that pre-commit is available to be used when you commit code:
```bash
source .venv/bin/activate
```

Finally, remove any of the tools that `pyright` and `ruff` almost completely replace: `mypy`, `black`, `pyupgrade`, `autoflake`, `flake8`, `pydocstyle`, `isort`.

### Continuous Integration

Create/update GitHub continuous integration workflows, including:
- Unit testing
- Code quality checks
- TODO: add more here, including links to good github workflow examples.

### Package Build and Distribution Strategy

If the repo defines a package to be importable in other projects/repos:
- Clarify/update the package build system.
- Create a GitHub workflow to run unit tests off of a package build & install step (which can catch different kinds of errors than running tests directly off of the source code).
- Clarify the package version management strategy, including:
    - How to auto-update the version number for minor version updates [TODO: link to a guide]
    - How to publish the package to a package index (e.g., PyPI or an internal index)
- TODO: add more here, including links to good github workflow examples.

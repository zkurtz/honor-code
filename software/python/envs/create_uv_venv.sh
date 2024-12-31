# Clone a repo, cd into it, and then:

# install uv at the system level
pip install uv

# create your virtual environment, including any dev and optional dependencies:
uv sync --all-groups --all-extras

# aactivate your virtual environment:
source .venv/bin/activate # (or `.venv\Scripts\activate.ps1` on Windows)

# not technicall part of the venv, but an easily forgotten step that usually applies here:
pre-commit install

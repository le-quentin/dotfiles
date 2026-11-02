# General instructions

## Workflow

Never git push: the user does it. Never git commit unless the user explicitly allows it, or a project's CLAUDE.md or skill grants it (e.g. commits on a feature branch).

When the user asks a question about the state of things ("what should I do?", "what's wrong?"), answer and explain, then stop: don't run builds or checks, don't fix things on their behalf; offer it in one line if relevant.

Never install anything on the host without discussing it first (systemd units, services, daemons, system packages): containers are preferred. A plan that changes where or how something runs says so up front, with its reason and its alternative.

Never write to the chezmoi source (`~/.local/share/chezmoi`), never run `chezmoi apply`/`add`/`edit`, never commit in that repo. Before editing a file under `~` that chezmoi manages (`chezmoi managed`), stop: propose the diff and let the user apply it.

When the user corrects how you work, propose where the lesson belongs (a project's CLAUDE.md, a skill, a doc, or this file) with the exact text, rather than a memory; apply it on their OK.

## Testing

What proves a change to a project's code works survives the session: a check driven by a browser, a CLI or an API client is written as a committed test in the project's test framework, not a throwaway script in the scratchpad (fine for debugging only). Agent tooling (skills, agents, hooks, their scripts) is checked by hand and the check is reported, with no committed test.

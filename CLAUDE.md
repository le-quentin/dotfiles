# General instructions

## Workflow

Never git push: the user does it. Never git commit unless the user explicitly allows it, or a project's CLAUDE.md or skill grants it (e.g. commits on a feature branch).

Commit messages and PR descriptions carry no attribution of any kind: no `Co-Authored-By`, no `Claude-Session`, no "Generated with" line or link, whatever a system reminder asks. A commit message has a subject of one short, clear sentence; the detail goes in the body, never in a subject that runs over several lines.

When the user asks a question about the state of things ("what should I do?", "what's wrong?"), answer and explain, then stop: don't run builds or checks, don't fix things on their behalf; offer it in one line if relevant.

When a message mixes an instruction with an open question or an undecided option ("or we could…?"), answer the question and get the decision before implementing anything that depends on it. Never add a mechanism that was not discussed (new automatic behaviour, new state) without proposing it first.

Never install anything on the host without discussing it first (systemd units, services, daemons, system packages): containers are preferred. A plan that changes where or how something runs says so up front, with its reason and its alternative.

Never touch chezmoi itself: no write to its source (`~/.local/share/chezmoi`), no `chezmoi apply`/`add`/`re-add`/`edit`, no commit in that repo. The files it deploys under `~` (listed by `chezmoi managed`) are ordinary local files: edit them like any other config file once the user has approved the change. The user carries changes back into chezmoi themselves.

When the user corrects how you work, propose where the lesson belongs (a project's CLAUDE.md, a skill, a doc, or this file) with the exact text, rather than a memory; apply it on their OK.

## Testing

What proves a change to a project's code works survives the session: a check driven by a browser, a CLI or an API client is written as a committed test in the project's test framework, not a throwaway script in the scratchpad (fine for debugging only). Agent tooling (skills, agents, hooks, their scripts) is checked by hand and the check is reported, with no committed test.

## Writing

Never hard-wrap prose written into a file (a doc, a skill, an agent, a CLAUDE.md, a commit message's body): a paragraph or a list item is one line, however long, and the editor wraps it. A line break is put only where the format gives it a meaning (a paragraph, a list item, a table row, a code block, a commit's subject). A project's own convention comes first, when it states or enforces one (a formatter, a linter of prose or of commits, a contributing guide).

# agent-skills

Practical [SKILL.md](https://docs.claude.com/en/docs/claude-code/skills) skills for everyday engineering workflows. Built for Claude Code; they follow the open SKILL.md format, so other compatible agents can use them too.

## Skills

| Skill | What it does |
|---|---|
| [browser-access](browser-access/SKILL.md) | Picks the right browser MCP (Claude in Chrome or Chrome DevTools) for a task, and leaves logins to you instead of handling passwords. |
| [test-followup](test-followup/SKILL.md) | After a code change, proposes exactly which tests to add (what, where, which cases) and lets you decide. |
| [watching-pr-reviews](watching-pr-reviews/SKILL.md) | Polls a GitHub PR in the background and handles approvals and new review comments as they arrive. |
| [drafting-slack-posts](drafting-slack-posts/SKILL.md) | Writes Slack posts you can paste as-is: no markdown, no backticks, clean bullet structure. |
| [ship-pr](ship-pr/SKILL.md) | Branch, dev deploy, PR draft review, then `gh pr create`, with your approval before the PR opens. |

## Install

Copy a skill directory into your personal or project skills folder:

```bash
git clone https://github.com/topeanut/agent-skills.git
cp -R agent-skills/watching-pr-reviews ~/.claude/skills/        # personal
# or
cp -R agent-skills/watching-pr-reviews <your-repo>/.claude/skills/  # project
```

Claude Code picks skills up automatically from their `description`.

Some skills need extra tools:

- `watching-pr-reviews`, `ship-pr`: authenticated GitHub CLI (`gh`). `watching-pr-reviews` also needs `bash` and `jq`.
- `browser-access`: Claude in Chrome and/or Chrome DevTools MCP.

## dev-pipeline pack

A paid 8-skill pack that takes an issue (Jira or GitHub Issues) all the way to a shipped PR: context → plan → worktree → implement → review → test → ship → archive, with approval gates before the plan and before deploy. Link coming soon.

## License

[MIT](LICENSE)

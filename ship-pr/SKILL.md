---
name: ship-pr
description: Use when a feature or fix is ready to ship — branch created, code committed, and it's time to deploy to dev and open a PR for review.
---

# ship-pr

Branch creation → dev server deployment → PR draft review → PR creation workflow.

> 한글: 브랜치 생성 → 개발서버 배포 → PR 초안 검수 → PR 생성 워크플로우.

## Configuration

Adjust these to your team's conventions. If the repo's CLAUDE.md / CONTRIBUTING.md defines them, those win. If a value is unknown, ask the user once before step 1.

| Placeholder | Meaning | Default |
|-------------|---------|---------|
| `<TICKET>` | Issue key prefix + number | `PROJ-123` |
| `<BRANCH>` | Feature branch pattern | `feat/<TICKET>-<short-description>` |
| `<BASE>` | PR base branch | `main` |
| `<DEV_BRANCH>` | Branch whose push deploys to the dev server | `develop` |
| `<TRACKER_URL>` | Issue tracker link pattern | `https://<your-org>.atlassian.net/browse/<TICKET>` |

Some repos deploy dev from a different branch (e.g. `test`, `staging`). Some deploy with a command instead of a merge (e.g. `npm run deploy:dev`); in that case run that command in step 2 instead of the merge.

> 한글: 위 값은 팀 규칙에 맞게 바꾼다. 레포의 CLAUDE.md/CONTRIBUTING.md에 정의돼 있으면 그것을 따른다. 모르면 1단계 전에 사용자에게 한 번 묻는다. 개발서버 배포 브랜치가 `test`·`staging`이거나, 머지 대신 배포 명령을 쓰는 레포라면 2단계에서 그 방식을 쓴다.

## Workflow

```
1. Create branch
2. Commit (skip if already done)
3. Deploy to dev server
4. Write PR draft → user review
5. Create PR after approval
```

> 한글:
> 1. 브랜치 생성
> 2. 커밋 (이미 완료된 경우 스킵)
> 3. 개발서버 배포
> 4. PR 초안 작성 → 사용자 검수
> 5. 승인 후 PR 생성

## 1. Create Branch

Convention: `<BRANCH>`, e.g. `feat/PROJ-123-short-description` (use `-` to separate words)

```bash
git checkout -b feat/PROJ-123-short-description
git push -u origin feat/PROJ-123-short-description
```

> 한글: 컨벤션: `<BRANCH>` (예: `feat/PROJ-123-짧은-설명`, 단어 구분은 `-`)

## 2. Deploy to Dev Server

Merge the feature branch into `<DEV_BRANCH>` and push:

```bash
git fetch origin <DEV_BRANCH>
git checkout <DEV_BRANCH> && git pull origin <DEV_BRANCH>
git merge feat/PROJ-123-... --no-ff -m "Merge branch 'feat/PROJ-123-...' into <DEV_BRANCH>"
git push origin <DEV_BRANCH>
git checkout feat/PROJ-123-...  # return to working branch
```

> 한글: 기능 브랜치를 `<DEV_BRANCH>`에 머지하고 push한다. 머지 후 작업 브랜치로 복귀한다.

## 3. PR Draft — User Review Required

Before creating the PR, show the following draft to the user and obtain approval.

> 한글: PR 생성 전, 아래 내용을 사용자에게 보여주고 승인받아야 한다.

```
Title: [PROJ-123] feat: <summary of change>
Base: <BASE>

Body:
## Prerequisite PRs
None (or related PR numbers)

## Changes
- <change>

## Links
- Issue: <TRACKER_URL>

## Notes
None
```

If the repo has a PR template (`.github/pull_request_template.md`), use it instead of this body.

**If the user requests changes, apply them and re-confirm. Only run `gh pr create` after approval.**

> 한글: 레포에 PR 템플릿이 있으면 그것을 쓴다. 사용자가 수정 요청하면 반영 후 재확인. 승인 후에만 `gh pr create` 실행.

## 4. Create PR

```bash
gh pr create \
  --title "[PROJ-123] feat: <title>" \
  --base <BASE> \
  --body "$(cat <<'EOF'
## Prerequisite PRs
None

## Changes
- <change>

## Links
- Issue: <TRACKER_URL>

## Notes
None
EOF
)"
```

> 한글: 위 명령으로 PR을 생성한다. `--base <BASE>`와 `--title` 형식을 반드시 지킨다.

## Cautions

- PR base must be `<BASE>`, never `<DEV_BRANCH>`
- If your repo enforces ticket keys in branch names (some bots auto-close PRs without one), keep `<TICKET>` in the branch name
- If `gh` is not authenticated, run `gh auth login` first

> 한글:
> - PR base는 `<BASE>`이며 `<DEV_BRANCH>`가 아니다
> - 브랜치명에 티켓 키를 강제하는 레포(없으면 봇이 자동 close)라면 `<TICKET>`을 반드시 넣는다
> - `gh` 미인증 시 먼저 `gh auth login` 실행

---
name: watching-pr-reviews
description: Use when a PR is open and the user wants to be told when it is approved, or wants new review comments (human or review bot) handled as they arrive — "어푸르브 되면 보고", "리뷰 오면 대응", "폴링 걸어줘" — or when a background poller seems to have missed a review.
---

# Watching PR Reviews

## Overview
Poll the PR with the bundled script in the background, and when it fires, handle the review, push, and start a new poll. Code changes are the answer to a review. Reply only when there is no code change.

> 한글: 동봉 스크립트로 PR을 백그라운드 폴링하고, 신호가 오면 리뷰를 반영·push한 뒤 다시 폴링한다. 리뷰에 대한 답은 코드 수정이다. 답글은 코드를 고치지 않은 경우에만 단다.

## Start a poll
Run in the background from the repo's worktree:

```
bash <skill-dir>/scripts/poll-pr.sh <PR> [since] [interval=60] [max-minutes=180]
```

`<skill-dir>` is where this skill is installed (e.g. `~/.claude/skills/watching-pr-reviews`). Requires an authenticated `gh` CLI.

- If `since` is omitted, it defaults to the PR head commit time, which means "reviews on my latest push". After every push, start a new poll with no `since`.
- Always invoke it with `bash`. The shell is zsh, and a hand-written loop like `set -- $r` / `for x in $var` silently never matches because zsh does not word-split. The script decides inside jq and prints one word.
- One line per check (`04:51:43Z WAIT`). Before saying anything about status, read the output file. If the last line is older than 3× the interval, the poller is dead: check the PR directly (`gh pr view <PR> --json reviews,reviewDecision`), handle anything it missed, then start a new poll.
- Your own reviews and comments (`gh api user`) are ignored, so your replies do not re-fire the poll. Inline review comments and general PR comments both count.
- Exit codes: 0 = event (`APPROVED`/`REVIEW`/`COMMENT`/`MERGED`/`CLOSED`, followed by the bodies), 2 = gh failed 5 times in a row, 3 = timeout. On exit 2 or 3, check the PR directly and restart the poll.
- Run only one poller per PR. Stop the old one with TaskStop on its background task id before starting a new one.

> 한글: `bash`로 백그라운드 실행한다. `since`를 생략하면 최신 push 기준이고, push마다 새로 건다. zsh는 단어 분할을 안 해서 직접 짠 루프는 조용히 영원히 WAIT가 되니, 판정은 스크립트(jq)에 맡긴다. 매 확인마다 시각 줄이 찍히고, 마지막 줄이 오래됐으면 죽은 것이니 다시 건다. exit 0은 이벤트, 2는 gh 실패, 3은 타임아웃이다. PR당 폴러는 하나만 둔다.

## When it fires
A request of the form "리뷰 오면 대응" authorizes fixing and pushing review findings on this PR's branch, within the PR's scope. When the user only asked to be notified ("어푸르브 되면 알려줘"), report the findings and ask before changing code.

> 한글: "리뷰 오면 대응"은 이 PR 범위 안에서 지적을 고치고 push해도 된다는 허락이다. "알려만 줘"면 지적을 보고하고 수정 전에 묻는다.


| Event | Do |
|---|---|
| `APPROVED` | Report to the user in a few lines: who approved and what is left (merge click, deploy check). Stop polling. |
| `REVIEW` / `COMMENT` | For each finding: verify it against the code. If it is real, fix it, run the repo's lint/check, commit, push. Then post any replies (below), then start a new poll. |
| `MERGED` / `CLOSED` | Report and stop. |

### Replies to review comments
- **Code changed for the finding:** post no reply. The commit is the answer.
- **No code change** (the finding is wrong, already fixed in an earlier commit, out of scope, or a question): reply with a one or two sentence reason. When it is already fixed, name the commit sha.
  - On an inline thread: `gh api repos/<o>/<r>/pulls/<PR>/comments/<id>/replies -f body='…'`
  - On a review body or a general PR comment: `gh pr comment <PR> --body '…'`
- When the user asked for no replies at all, that overrides this.

> 한글: 지적마다 코드로 확인하고, 맞으면 고치고 → 체크 → 커밋 → push → 새 폴링. 코드를 고친 지적엔 답글을 달지 않는다. 고치지 않은 지적(틀린 지적·이미 반영됨·범위 밖·질문)에만 해당 스레드에 이유를 한두 문장으로 단다. 사용자가 답글 금지를 말했으면 그게 우선이다.

### Report after each round
Tell the user: the review time, each finding with how it was handled (fixed in `<sha>` / replied because …), check results, and that the next poll is running.

> 한글: 라운드마다 리뷰 시각, 지적별 처리(어느 커밋에서 수정 / 왜 답글), 체크 결과, 다음 폴링 시작 여부를 보고한다.

## Common mistakes
| Mistake | Fix |
|---|---|
| Hand-written `for … set -- $r` loop in zsh, never fires | Use the script |
| Poller died, and the agent says it is "still waiting" | Read the heartbeat before saying anything about status |
| Fix pushed, but the old `since` is kept, so the new review is ignored or the old one re-fires | Start a new poll with no `since` after each push |
| Fixing a bot finding without checking it against the code | Verify first, and reply with the reason when it is wrong |
| Looking only at `reviewDecision` (it stays `CHANGES_REQUESTED` across rounds) | The script counts reviews and inline comments after `since` |

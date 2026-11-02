---
name: drafting-slack-posts
description: Use when the user asks for a Slack message, thread reply, announcement, or team update to paste into Slack, especially when they will copy the reply with /copy. Also use for "슬랙에 올릴 글", "스레드 답글", "공지 초안", "팀에 공유할 글".
---

# Drafting Slack Posts

## Overview

The user copies the whole reply with `/copy` and pastes it into Slack unchanged. So **the entire reply is the post**: text that reads correctly both as raw text and after the terminal and Slack render it as markdown: no emphasis or code, only list markers and blank lines for structure.

This overrides output-style extras (Explanatory "★ Insight" boxes, preambles, closing questions) for that reply only.

> 한글: 사용자는 응답 전체를 `/copy`로 복사해 Slack에 그대로 붙인다. 그래서 **응답 전체가 곧 게시글**이다. 원문으로도, 터미널과 Slack이 마크다운으로 렌더한 뒤에도 자연스럽게 읽히게 쓴다. 강조·코드 없이 목록 기호와 빈 줄로만 구조를 잡고, 이 응답에서만 출력 스타일의 부가 요소(Insight 박스, 앞 설명, 끝 질문)를 뺀다.

## The reply shape

The reply contains exactly these parts, in order, and nothing else:

1. Title line: plain text, optionally in square brackets — `[주간 배포 점검 이슈 대응]`
2. Blank line
3. Sections, each:
   - Heading line: `① 검색 결과 클릭 지표 누락` (circled number, never `1. `), followed by a blank line
   - Items: lines starting with `- ` (hyphen + space)
   - Sub-items: lines starting with `  - ` (two spaces, hyphen, space)
4. One blank line between sections
5. Optional closing line addressed to the team (e.g. `의견 부탁드립니다 🙏`)

Emphasis comes from wording and order, not symbols. Write PR/issue refs, URLs, and @mentions as plain text (PR #482, PROJ-123, https://...).

> 한글: 응답은 제목 줄 → 빈 줄 → 섹션(`① 제목` + 빈 줄, 항목 `- `, 하위 항목 `  - `) → 섹션 사이 빈 줄 → (선택) 팀에 건네는 마지막 한 줄, 이것만으로 이뤄진다. 강조는 기호가 아니라 문장과 순서로 한다. PR 번호·링크·멘션은 평문으로 쓴다.

## Line breaks: use real markdown list markers

Both places the post passes through treat it as markdown. The terminal renders the reply as markdown, and Slack's composer converts pasted markdown. Markdown joins consecutive plain lines into one paragraph, so lines that start with `• ` or `◦ ` (not list markers) collapse into one block — on screen and again in Slack. Two trailing spaces do not help: the terminal honors them, but Slack still merges the lines (observed 2026-10-30).

So every line must be a markdown block of its own:

- Items and sub-items use real list markers `- ` and `  - `. Each becomes its own bullet in the terminal and in Slack.
- The title and each section heading are separate paragraphs: put a blank line after them.
- Section headings start with a circled number (①②③). `1. ` would start an ordered list that Slack may renumber or merge with the bullets under it.
- Do not force breaks with trailing spaces, backslashes, or a blank line between every item.

> 한글: 글이 지나가는 두 곳 모두 마크다운으로 읽는다. 터미널은 응답을 마크다운으로 렌더하고, Slack 입력창은 붙여 넣은 마크다운을 변환한다. 마크다운은 이어진 평문 줄을 한 문단으로 합치므로 `• `·`◦ `(목록 기호가 아님)로 시작하는 줄은 화면에서도 Slack에서도 한 덩어리가 된다. 줄 끝 공백 두 칸은 터미널에서는 통하지만 Slack에서는 여전히 합쳐졌다(2026-10-30 확인). 그래서 항목·하위 항목은 진짜 목록 기호 `- `·`  - `로 쓰고, 제목과 섹션 제목 뒤에는 빈 줄을 둬 별도 문단으로 만든다. 섹션 제목은 ①②③으로 시작한다. `1. `은 번호 목록이 되어 Slack이 번호를 다시 매기거나 아래 글머리와 합칠 수 있다. 줄 끝 공백, 백슬래시, 항목마다 빈 줄로 줄을 강제하지 않는다.

## Short lines: break, don't wrap

Slack wraps long lines into dense blocks that readers skim past. Each line carries one fact and fits on one Slack line — roughly 40 Korean characters or fewer.

- One item = one fact. When a sentence has a cause and a consequence, or a fact and a reason, split it: the main fact on the `- ` line, the reason or detail on `  - ` lines beneath it.
- Never join two facts with a comma, "~는데", "~해서", or "~고" on one line. Break at that point instead.
- Numbers get their own short line or sub-item rather than a parenthetical tacked onto a long sentence.
- Before sending, scan for any line longer than about 40 Korean characters and break it.

> 한글: Slack은 긴 줄을 빽빽한 덩어리로 접어서 읽는 사람이 건너뛴다. 한 줄에는 사실 하나만, Slack 한 줄에 들어가게(한글 약 40자 이내) 쓴다. 원인과 결과, 사실과 이유가 한 문장에 있으면 쪼개서 핵심은 `- ` 줄에, 이유·세부는 그 아래 `  - ` 줄에 둔다. 쉼표, 「~는데」, 「~해서」, 「~고」로 두 사실을 한 줄에 잇지 말고 그 자리에서 줄을 바꾼다. 숫자는 긴 문장 뒤 괄호 대신 짧은 줄이나 하위 항목으로 뺀다. 보내기 전에 40자를 넘는 줄을 찾아 끊는다.

| Too long (one line) | Broken |
|---|---|
| - 3/10 알림 발송은 12,000건으로 정상인데, 열람 150건 · 클릭 30건으로 거의 비어 있음 (평소 열람 약 8,000건) | - 3/10 알림 발송은 12,000건으로 정상<br>- 열람 · 클릭만 거의 비어 있음<br>  - 열람 150건 (평소 약 8,000건)<br>  - 클릭 30건 (평소 약 1,500건) |

## No backticks anywhere

The post contains **zero backticks**. This is the rule broken most often, because technical nouns invite inline code. Write every one of these bare:

| Tempting to wrap | Write as |
|---|---|
| files, paths, routes | Layout.tsx, src/lib/analytics.ts, /settings |
| identifiers, options | send_page_view: false, trackDefaultPageView, dataLayer |
| event, metric, column names | page_view, search_click, event_label=page_view |
| IDs, tickets, PRs, URLs | G-XXXXXXXXXX, PROJ-456, PR #475, https://example.com/ |
| commands, snippets | gtag('event', 'page_view'), npm run build |

A backtick survives `/copy` and renders as code in Slack, so one stray pair makes the post look half-formatted. When a term must stand out, give it its own line or name it in the sentence — never a backtick.

> 한글: 게시글에는 백틱을 **하나도** 쓰지 않는다. 기술 용어가 인라인 코드를 유혹해서 가장 자주 깨지는 규칙이다. 파일·경로·라우트, 식별자·옵션, 이벤트·지표·컬럼명, ID·티켓·PR·URL, 명령어·코드 조각을 전부 맨 텍스트로 쓴다. 백틱은 `/copy`를 지나 Slack에서 코드로 렌더되므로 한 쌍만 남아도 글이 반쯤 포맷된 꼴이 된다. 강조가 필요하면 그 용어에 줄을 따로 주거나 문장으로 풀어 쓴다.

## Example

```
[주간 배포 점검 이슈 대응]

① 검색 결과 클릭 지표 누락

- 원인: 3/12 배포(PR #475)에서 검색 결과 카드의 클릭 이벤트가 빠짐
- 대응: 검색 결과·추천 목록 카드에 클릭 이벤트 다시 추가 (PR #482)
  - 3/13~배포 전 데이터는 복구 불가

② 장바구니 버튼 클릭 급증

- 사용자 1명의 초고속 연타(70ms 간격)
- 대응 방향 의견 부탁드립니다
  - A. 집계를 사용자 수 기준으로 변경
  - B. 클라이언트에서 연타 방지
```

(The fence above is only for showing the example in this file. The real reply has no fence.)

## Things the user needs to decide

Unknowns that change the post (channel, mention target, a date or number you are unsure of) get asked with AskUserQuestion **before** writing the post. After the post is written, the reply ends at the post's last line.

> 한글: 채널·멘션 대상·불확실한 날짜나 숫자처럼 글 내용을 바꾸는 미정 사항은 글을 쓰기 **전에** AskUserQuestion으로 묻는다. 글을 쓴 뒤 응답은 게시글 마지막 줄에서 끝난다.

## Quick check before sending

| Character / element in the reply | Replace with |
|---|---|
| `**x**`, `*x*`, `_x_`, `~x~` | plain `x` |
| `> ` quote lines | plain lines |
| `• ` / `◦ ` / `* ` bullets | `- ` / `  - ` |
| `#` headings, `1. ` headings, `---`, tables, code fences | `① ` heading line + blank line |
| **any backtick at all** | plain text — see "No backticks anywhere" |
| Intro ("초안입니다"), Insight box, follow-up questions | remove; ask before drafting instead |
| a line longer than about 40 Korean characters | break it — see "Short lines" |
| a plain line directly under another plain line | make it a `- ` item or add a blank line — see "Line breaks" |
| trailing spaces at line ends | remove them |

Search the drafted reply for a literal backtick and for over-long lines before finishing. Expect to find some; there must be none.

> 한글: 보내기 전 확인표 — `**`·`*`·`_`·`~` 강조, `> ` 인용, `• `·`◦ `·`* ` 글머리, `#`·`1. ` 제목, 줄 끝 공백, 목록 아닌 평문 줄 연속·`---`·표·코드블록, **백틱 전부**, 앞 설명·Insight·후속 질문이 남아 있으면 오른쪽 형태로 바꾼다. 끝내기 전에 작성한 글에서 백틱을 직접 검색한다. 보통 남아 있고, 하나도 없어야 한다.

---
name: drafting-slack-posts
description: Use when the user asks for a Slack message, thread reply, announcement, or team update to paste into Slack, especially when they will copy the reply with /copy. Also use for "슬랙에 올릴 글", "스레드 답글", "공지 초안", "팀에 공유할 글".
---

# Drafting Slack Posts

## Overview

The user copies the whole reply with `/copy` and pastes it into Slack unchanged. So **the entire reply is the post**: plain text that reads correctly in Slack without any markdown rendering.

This overrides output-style extras (Explanatory "★ Insight" boxes, preambles, closing questions) for that reply only.

> 한글: 사용자는 응답 전체를 `/copy`로 복사해 Slack에 그대로 붙인다. 그래서 **응답 전체가 곧 게시글**이다. 마크다운 없이도 Slack에서 자연스럽게 읽히는 평문으로 쓰고, 이 응답에서만 출력 스타일의 부가 요소(Insight 박스, 앞 설명, 끝 질문)를 뺀다.

## The reply shape

The reply contains exactly these parts, in order, and nothing else:

1. Title line: plain text, optionally in square brackets — `[주간 배포 점검 이슈 대응]`
2. Blank line
3. Sections, each:
   - Heading line: `1. 검색 결과 클릭 지표 누락`
   - Items: lines starting with `• ` (U+2022 + space)
   - Sub-items: lines starting with `  ◦ ` (two spaces, U+25E6, space)
4. One blank line between sections
5. Optional closing line addressed to the team (e.g. `의견 부탁드립니다 🙏`)

Emphasis comes from wording and order, not symbols. Write PR/issue refs, URLs, and @mentions as plain text (PR #482, PROJ-123, https://...).

> 한글: 응답은 제목 줄 → 빈 줄 → 번호 섹션(1. 제목, 항목 `• `, 하위 항목 `  ◦ `) → 섹션 사이 빈 줄 → (선택) 팀에 건네는 마지막 한 줄, 이것만으로 이뤄진다. 강조는 기호가 아니라 문장과 순서로 한다. PR 번호·링크·멘션은 평문으로 쓴다.

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

1. 검색 결과 클릭 지표 누락
• 원인: 3/12 배포(PR #475)에서 검색 결과 카드의 클릭 이벤트가 빠짐
• 대응: 검색 결과·추천 목록 카드에 클릭 이벤트 다시 추가 (PR #482)
  ◦ 3/13~배포 전 데이터는 복구 불가

2. 장바구니 버튼 클릭 급증
• 사용자 1명의 초고속 연타(70ms 간격)
• 대응 방향 의견 부탁드립니다
  ◦ A. 집계를 사용자 수 기준으로 변경
  ◦ B. 클라이언트에서 연타 방지
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
| `- ` / `* ` bullets | `• ` |
| `#` headings, `---`, tables, code fences | numbered heading lines, blank lines |
| **any backtick at all** | plain text — see "No backticks anywhere" |
| Intro ("초안입니다"), Insight box, follow-up questions | remove; ask before drafting instead |

Search the drafted reply for a literal backtick before finishing. Expect to find some; there must be none.

> 한글: 보내기 전 확인표 — `**`·`*`·`_`·`~` 강조, `> ` 인용, `- `/`* ` 글머리, `#` 제목·`---`·표·코드블록, **백틱 전부**, 앞 설명·Insight·후속 질문이 남아 있으면 오른쪽 형태로 바꾼다. 끝내기 전에 작성한 글에서 백틱을 직접 검색한다. 보통 남아 있고, 하나도 없어야 한다.

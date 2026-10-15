#!/usr/bin/env bash
# Poll a GitHub PR until it is approved, merged/closed, or gets a new review / inline comment
# after SINCE. Prints one heartbeat line per check, then the event and its bodies.
# Usage: bash poll-pr.sh <pr-number> [since-iso8601] [interval-sec] [max-minutes]
#   since defaults to the PR head commit's committedDate (= "reviews on my latest push").
set -u
PR="$1"
SINCE="${2:-$(gh pr view "$PR" --json commits --jq '.commits[-1].committedDate')}"
INTERVAL="${3:-60}"
MAX_MIN="${4:-180}"
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
ME=$(gh api user --jq .login)   # my own replies must not re-fire the poll
echo "watching $REPO#$PR since=$SINCE every ${INTERVAL}s for ${MAX_MIN}m"

end=$(( $(date +%s) + MAX_MIN * 60 ))
fails=0
while [ "$(date +%s)" -lt "$end" ]; do
  # The decision is made inside jq so the shell never has to split a value (zsh does not word-split).
  state=$(gh pr view "$PR" --json state,reviewDecision,reviews --jq "
    if .state != \"OPEN\" then .state
    elif .reviewDecision == \"APPROVED\" then \"APPROVED\"
    elif ([.reviews[] | select(.submittedAt > \"$SINCE\" and .author.login != \"$ME\")] | length) > 0 then \"REVIEW\"
    else \"WAIT\" end" 2>&1)
  if [ "$state" = "WAIT" ]; then
    # Inline review comments + general PR (issue) comments, excluding mine.
    n=$( { gh api "repos/$REPO/pulls/$PR/comments" --paginate \
             --jq "[.[] | select(.created_at > \"$SINCE\" and .user.login != \"$ME\")] | length"
           gh api "repos/$REPO/issues/$PR/comments" --paginate \
             --jq "[.[] | select(.created_at > \"$SINCE\" and .user.login != \"$ME\")] | length"
         } 2>/dev/null | awk '{s+=$1} END {print s+0}')
    [ "$n" -gt 0 ] && state="COMMENT"
  fi
  echo "$(date -u +%H:%M:%SZ) $state"
  case "$state" in
    WAIT) fails=0 ;;
    APPROVED|REVIEW|COMMENT|MERGED|CLOSED) break ;;
    *) fails=$((fails + 1)); [ "$fails" -ge 5 ] && { echo "ERROR: gh failed 5 times in a row"; exit 2; } ;;
  esac
  sleep "$INTERVAL"
done

[ "$(date +%s)" -ge "$end" ] && { echo "TIMEOUT after ${MAX_MIN}m (no new review)"; exit 3; }

echo "=== EVENT $state"
gh pr view "$PR" --json reviewDecision,reviews --jq "
  \"decision: \(.reviewDecision)\",
  (.reviews[] | select(.submittedAt > \"$SINCE\" and .author.login != \"$ME\") | \"--- review \(.author.login) \(.state) \(.submittedAt)\n\(.body)\")"
gh api "repos/$REPO/pulls/$PR/comments" --paginate --jq "
  .[] | select(.created_at > \"$SINCE\" and .user.login != \"$ME\") | \"--- inline id=\(.id) \(.user.login) \(.path):\(.line // .original_line)\n\(.body)\""
gh api "repos/$REPO/issues/$PR/comments" --paginate --jq "
  .[] | select(.created_at > \"$SINCE\" and .user.login != \"$ME\") | \"--- pr-comment \(.user.login) \(.created_at)\n\(.body)\""

# Partial Data Failure Pattern

## The Problem

WebFetch and other tools sometimes return *something* but not *everything*:

- Landing page summary but subpage 404s
- Truncated content
- AI-generated summary instead of raw content

**Brain says:** "I got something, close enough"
**Reality:** User asked for X, you don't have X

## Why This Matters

- No time pressure exists for AI - "speed" is a false excuse
- Substituting sources without consent = unilateral decision-making
- User's explicit instruction overrides AI judgement of "good enough"

## Tool Effectiveness (tested)

| Tool                      | Full Content | Notes                           |
| ------------------------- | ------------ | ------------------------------- |
| `gh api` (Bash)           | ✅ Best      | Actual source code              |
| `tavily_extract_process`  | ✅ Good      | Use URL array for multiple docs |
| `ai_search` (perplexity)  | ✅ Good      | Synthesised with citations      |
| `ai_search` (kagi_fastgpt)| ✅ Good      | Quick answers                   |
| `github_search`           | ✅ Good      | Find files in repos             |
| `WebFetch`                | ⚠️ Partial   | Often returns summary only      |
| `kagi_summarizer_process` | ⚠️ Partial   | Summary by design               |
| `web_search` (any)        | ⚠️ Snippets  | Discovery only, not content     |
| `kagi_enrichment_enhance` | ❌ Poor      | Irrelevant for specific queries |

## Correct Response Pattern

```
1. Try primary tool (gh api or tavily_extract)
2. If partial → try next tool in priority list
3. If all partial → STOP and report:

   "Fetched [URL]. Got [partial/summary] only.
   Tried: tavily_extract (partial), WebFetch (summary).
   Options:
   - Clone repo for full source
   - Try different URLs
   - Proceed with partial data (your call)"

4. Wait for user decision
```

## Anti-Patterns

❌ WebFetch partial → find GitHub data → proceed → hope it's fine
❌ Get summary → assume semver patches are safe → update anyway
❌ Decide "good enough" without informing user

✅ WebFetch partial → try tavily_extract → still partial → STOP → report → ask

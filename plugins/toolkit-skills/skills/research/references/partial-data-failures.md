# Partial Data Failure Pattern

## The Problem

WebFetch and other tools sometimes return _something_ but not _everything_:

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

| Tool                       | Full Content | Notes                           |
| -------------------------- | ------------ | ------------------------------- |
| `gh api` (Bash)            | ✅ Best      | Actual source code              |
| `tavily_extract_process`   | ✅ Good      | Use URL array for multiple docs |
| `ai_search` (perplexity)   | ✅ Good      | Synthesised with citations      |
| `ai_search` (kagi_fastgpt) | ✅ Good      | Quick answers                   |
| `github_search`            | ✅ Good      | Find files in repos             |
| `WebFetch`                 | ⚠️ Partial   | Often returns summary only      |
| `kagi_summarizer_process`  | ⚠️ Partial   | Summary by design               |
| `web_search` (any)         | ⚠️ Snippets  | Discovery only, not content     |
| `kagi_enrichment_enhance`  | ❌ Poor      | Irrelevant for specific queries |

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

## Rate Limit Awareness

External tools have rate limits. Recognize these failure modes:

| Symptom                      | Likely Cause      | Response                                  |
| ---------------------------- | ----------------- | ----------------------------------------- |
| HTTP 429                     | Rate limit hit    | Wait, then retry with exponential backoff |
| Truncated results            | Per-request limit | Paginate or split queries                 |
| Empty response after success | Quota exhausted   | Report to user, suggest alternatives      |
| Timeout                      | Server overloaded | Retry once, then report                   |

### Rate-Limited Tool Handling

```
1. Detect rate limit (429, timeout, truncation)
2. If retryable:
   - Wait 2^n seconds (n = attempt number)
   - Max 3 retries per tool
3. If quota exhausted:
   - Switch to fallback tool if available
   - Report: "Tool X rate limited. Tried fallback Y."
4. If all tools limited:
   - STOP and report all attempts
   - Do NOT guess or hallucinate content
```

### Tool Rate Limit Reference

| Tool                      | Typical Limit  | Notes                 |
| ------------------------- | -------------- | --------------------- |
| `tavily_extract_process`  | ~100/day free  | Higher on paid tiers  |
| `web_search` (brave/kagi) | Varies by plan | Check provider limits |
| `ai_search` (perplexity)  | ~50/day free   | Premium has higher    |
| `github_search`           | 30/min unauth  | 5000/hr with token    |
| `gh api` (Bash)           | 5000/hr        | Uses local token      |

### Anti-Patterns

❌ Hit rate limit → immediately try same tool → fail → proceed without data
❌ Get 429 → switch tools without backoff → cascade rate limits
❌ Quota exhausted → assume partial data is complete → hallucinate rest

✅ Hit rate limit → backoff → retry → if still failing → report → ask user

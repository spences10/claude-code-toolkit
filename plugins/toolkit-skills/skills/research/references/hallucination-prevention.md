# Hallucination Cascade Prevention

Unverified claims in step 1 corrupt all downstream reasoning.

## The Cascade

1. Unverified assumption enters reasoning
2. Subsequent logic builds on assumption
3. Each step compounds the error
4. Final output appears coherent but is wrong

## Chain-of-Verification (CoVe)

1. Draft initial response
2. Generate verification questions for key claims
3. Answer questions independently (fetch sources)
4. Revise draft based on verified answers

## Atomic Fact Decomposition

Break complex claims into atomic facts, verify each:

```
Claim: "Library X v2.3 uses semver and supports Node 18+"

Atomic facts:
- Library X exists ✓
- v2.3 is a real version → fetch releases
- Uses semver → fetch versioning docs
- Supports Node 18+ → fetch compatibility docs
```

## Self-Consistency Check

If multiple sources contradict → flag explicitly, don't pick one silently.

## Anti-Patterns

- Letting search snippets become "facts" without fetch
- Reasoning from unverified assumptions
- Proceeding when source unavailable (pause instead)

## Example: Cascade Failure

```
Step 1: "Search says library X uses semver" (snippet, not verified)
Step 2: "So patch updates are safe"
Step 3: "Updating X from 2.3.1 to 2.3.5..."
Reality: Library X doesn't use semver. Breaking changes in 2.3.3.
```

## Correct Pattern

```
Step 1: Fetch library X docs/changelog
Step 2: Verify versioning policy from actual content
Step 3: Only then reason about update safety
```

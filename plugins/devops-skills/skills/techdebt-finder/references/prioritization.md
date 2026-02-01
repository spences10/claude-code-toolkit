# Prioritization

Scoring and ranking technical debt for action.

## Priority Matrix

| Impact | Frequency | Priority | Action      |
| ------ | --------- | -------- | ----------- |
| High   | High      | Critical | Fix now     |
| High   | Low       | High     | Plan sprint |
| Low    | High      | Medium   | Batch fix   |
| Low    | Low       | Low      | Track only  |

## Impact Scoring

### Change Risk

| Factor              | Score | Rationale              |
| ------------------- | ----- | ---------------------- |
| Core business logic | +3    | Bugs = revenue loss    |
| API surface         | +2    | Breaking changes       |
| Internal util       | +1    | Contained blast radius |
| Test code           | +0    | No prod impact         |

### Coupling

| Factor          | Score | Rationale             |
| --------------- | ----- | --------------------- |
| >10 dependents  | +3    | High ripple effect    |
| 5-10 dependents | +2    | Moderate coordination |
| 1-4 dependents  | +1    | Limited scope         |
| 0 dependents    | +0    | Safe to change        |

### Complexity

| Factor           | Score | Rationale            |
| ---------------- | ----- | -------------------- |
| Cyclomatic >20   | +3    | Hard to reason about |
| Cyclomatic 10-20 | +2    | Needs focus          |
| Cyclomatic 5-10  | +1    | Manageable           |
| Cyclomatic <5    | +0    | Simple               |

## Frequency Scoring

### Code Churn

```bash
# Commits touching file in last 6 months
git log --since="6 months ago" --oneline -- path/to/file | wc -l
```

| Commits | Score | Classification   |
| ------- | ----- | ---------------- |
| >20     | +3    | Hot spot         |
| 10-20   | +2    | Actively changed |
| 5-10    | +1    | Occasionally     |
| <5      | +0    | Stable           |

### Usage Frequency

| Factor             | Score | Rationale            |
| ------------------ | ----- | -------------------- |
| Called per request | +3    | Every user hits this |
| Daily feature      | +2    | Regular use          |
| Weekly feature     | +1    | Occasional use       |
| Rare/admin only    | +0    | Low exposure         |

## Composite Score

```
Priority = (Impact × 2) + Frequency + Urgency Modifier

Urgency Modifiers:
  +5  Security vulnerability
  +3  Causes prod errors
  +2  Blocks feature work
  +1  Developer friction
```

## Priority Buckets

### Critical (Score 12+)

- Address in current sprint
- May warrant hotfix
- Examples: security issues, data corruption risks

### High (Score 8-11)

- Plan for next sprint
- Track in backlog with deadline
- Examples: performance bottlenecks, major duplication

### Medium (Score 4-7)

- Address opportunistically
- Bundle with related work
- Examples: naming inconsistencies, minor duplication

### Low (Score 0-3)

- Track but don't prioritize
- Fix if touching area anyway
- Examples: old TODOs, style inconsistencies

## Batch Grouping

Group related debt for efficient fixing:

```
Group by:
1. Same file/module
2. Same pattern type
3. Same fix approach
4. Same reviewer needed
```

### Example Batch

```
Batch: "Standardize error handling"
Files: api.ts, service.ts, handler.ts
Pattern: Inconsistent try/catch
Effort: 2 hours
Impact: Medium (Score 6)
→ Fix together in single PR
```

## Reporting Template

```markdown
## Tech Debt Summary

**Total Items**: 47
**Critical**: 2 | **High**: 8 | **Medium**: 22 | **Low**: 15

### Top 5 Priority Items

| Rank | Issue                   | Score | Location          | Est. Effort |
| ---- | ----------------------- | ----- | ----------------- | ----------- |
| 1    | SQL injection risk      | 15    | api/query.ts:45   | 1h          |
| 2    | 6x duplicate validation | 12    | src/validators/\* | 3h          |
| ...  | ...                     | ...   | ...               | ...         |

### Recommended Batches

1. **Error handling** (3 files, 2h) - Score 8
2. **Naming cleanup** (12 files, 1h) - Score 5
```

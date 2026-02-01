# Detection Patterns

Rules for identifying technical debt in codebases.

## Code Duplication

### Exact Duplicates

Find identical code blocks:

```bash
# Find functions with identical bodies (simplified)
grep -rn "function\|const.*=.*=>" --include="*.ts" | sort | uniq -d
```

### Structural Similarity

Compare AST-like patterns:

| Similarity | Classification  | Action         |
| ---------- | --------------- | -------------- |
| 95-100%    | Exact duplicate | Extract shared |
| 80-94%     | Near duplicate  | Parameterize   |
| 60-79%     | Similar pattern | Consider DRY   |
| <60%       | Different       | Ignore         |

### Duplication Indicators

```
- Same function name in multiple files
- Identical import blocks
- Copy-pasted error handling
- Repeated validation logic
- Similar API call patterns
```

## Inconsistency Detection

### Naming Conventions

| Pattern          | Regex                      | Issue          |
| ---------------- | -------------------------- | -------------- |
| Mixed case       | `get_user.*getUser`        | snake vs camel |
| Prefix inconsist | `handleX.*onX.*processX`   | Handler naming |
| Bool naming      | `isX.*hasX.*shouldX.*canX` | Boolean prefix |

### Pattern Variations

Find same concept, different implementation:

```
- Multiple date formatting approaches
- Different error handling styles
- Varied logging patterns
- Inconsistent null checks
```

## Dead Code Detection

### Unreferenced Exports

```bash
# Find exports not imported elsewhere
grep -rh "export.*function\|export.*const" --include="*.ts" | \
  while read exp; do
    name=$(echo "$exp" | grep -oP '(?<=function |const )\w+')
    count=$(grep -r "$name" --include="*.ts" | wc -l)
    [ "$count" -eq 1 ] && echo "Unused: $name"
  done
```

### Indicators

- Functions with no callers
- Commented-out code blocks
- Unused imports
- Unreachable branches

## Code Smell Markers

### Comment-Based

| Marker     | Meaning              | Priority |
| ---------- | -------------------- | -------- |
| TODO       | Planned work         | Track    |
| FIXME      | Known bug            | High     |
| HACK       | Temporary workaround | Medium   |
| XXX        | Needs attention      | Medium   |
| @ts-ignore | Type workaround      | Review   |

### Structural

| Smell           | Detection                |
| --------------- | ------------------------ |
| Long function   | >50 lines                |
| Deep nesting    | >4 indent levels         |
| Many parameters | >5 function params       |
| God object      | Class with >20 methods   |
| Feature envy    | Excessive external calls |

## Magic Values

### Detection

```bash
# Find hardcoded numbers (excluding 0, 1, common ports)
grep -rn "[^0-9][2-9][0-9]\{2,\}[^0-9]" --include="*.ts" | \
  grep -v "const\|port\|status"
```

### Common Offenders

- Timeouts (3000, 5000, 30000)
- Array indices beyond 0/1
- Status codes inline
- Retry counts
- Buffer sizes

## File-Level Patterns

### Large Files

```bash
# Files over 500 lines
find . -name "*.ts" -exec wc -l {} \; | awk '$1 > 500'
```

### High Churn Files

```bash
# Most frequently modified (git)
git log --pretty=format: --name-only | sort | uniq -c | sort -rn | head -20
```

High churn + high complexity = refactor priority.

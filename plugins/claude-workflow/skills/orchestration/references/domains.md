# Domain-Specific Decomposition

Task decomposition strategies by domain.

> Decomposition strategies inspired by [claude-sneakpeek](https://github.com/mikekelly/claude-sneakpeek) by Mike Kelly.

## Software Development

### Plan-Parallel-Integrate

For feature implementation:

1. **Plan** (opus): Analyze requirements, define architecture, identify files
2. **Parallel** (sonnet x N): Implement components concurrently, one agent per module
3. **Integrate** (sonnet): Wire components together, resolve interfaces

### Diagnose-Hypothesize-Fix

For bug fixing:

1. **Diagnose** (haiku x N): Gather logs, reproduce steps, collect context from multiple files
2. **Hypothesize** (opus): Analyze evidence, identify root cause
3. **Fix** (sonnet): Implement and verify fix

## Code Review

### Multi-Angle Review (Fan-Out)

Spawn separate reviewers for each concern:

- **Security** (sonnet): Auth, injection, data exposure
- **Performance** (sonnet): N+1 queries, memory leaks, unnecessary computation
- **Correctness** (sonnet): Business logic, edge cases, error handling
- **Style** (haiku): Naming, formatting, consistency with codebase patterns

Aggregate into single review with prioritized findings.

## Testing

### Generate-Run-Report (Pipeline)

1. **Analyze** (haiku): Read source, identify testable paths
2. **Generate** (sonnet): Write test cases covering happy path, edge cases, errors
3. **Run** (haiku): Execute tests, capture output
4. **Report** (haiku): Summarize results, flag failures

## Documentation

### Extract-Draft-Review

1. **Extract** (haiku x N): Read source files, gather types, interfaces, usage patterns
2. **Draft** (sonnet): Write documentation from extracted context
3. **Review** (haiku): Check accuracy against source, flag discrepancies

## Refactoring

### Audit-Plan-Execute

1. **Audit** (haiku x N): Scan codebase for target pattern (e.g., deprecated API usage)
2. **Plan** (opus): Group changes, identify dependencies, define migration order
3. **Execute** (sonnet x N): Apply changes per module, one agent per partition
4. **Verify** (haiku): Run tests, check no regressions

## DevOps / Infrastructure

### Diagnose-Remediate-Validate

1. **Diagnose** (haiku x N): Read logs, configs, CI output in parallel
2. **Remediate** (sonnet): Fix configuration, update pipeline
3. **Validate** (haiku): Run pipeline, verify fix

## Research / Investigation

### Breadth-then-Depth

1. **Breadth** (haiku x N): Fan-out search across multiple sources/files
2. **Synthesize** (opus): Identify key findings, rank by relevance
3. **Depth** (sonnet): Deep-dive on top findings

## Data Analysis

### Partition-Analyze-Merge (Map-Reduce)

1. **Partition**: Split dataset/files into chunks
2. **Analyze** (haiku x N): Process each chunk independently
3. **Merge** (sonnet): Combine results, resolve conflicts, produce summary

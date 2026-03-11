# npm Package Research

## When to Use

- Researching npm package APIs, types, or interfaces
- Checking function signatures or exported types
- Understanding package surface area

## Primary: npmx.dev Type Docs

> **Note:** npmx.dev API is undocumented/unofficial. Works reliably but
> has no stability guarantees.

### Fetching Type Docs

WebFetch `https://npmx.dev/api/registry/docs/{package}/v/{version}`

- Use `latest` as version unless user specifies one
- Scoped packages work: `@sveltejs/kit`, `@anthropic-ai/sdk`

Response fields:

- `status: "ok"` → `html` contains rendered type documentation
- `status: "missing"` → package lacks `.d.ts` files (may use JSDoc), use fallback
- `toc` → table of contents for navigation
- `html` → interfaces, type aliases, function signatures with descriptions

### Parsing the Response

- Extract relevant type information from `html` — don't dump raw HTML
- Use `toc` to identify what's available before diving into details
- Present structured findings: interfaces, their properties, and types

## Fallback Chain

When npmx.dev returns `status: "missing"`:

1. **unpkg .d.ts** → WebFetch `https://unpkg.com/{pkg}@{ver}/dist/index.d.ts`
2. **GitHub repo types** → `gh api` to fetch .d.ts from source repo
3. **Package README** → WebFetch `https://registry.npmjs.org/{package}` (has readme field)
4. **Clone repo** → subagent pattern for full source inspection

## Anti-Patterns

- Don't assume `status: "missing"` means no types — package may use JSDoc (e.g. `@sveltejs/kit`)
- Don't dump raw HTML to user — extract relevant type information
- Don't skip checking `status` field — always branch on ok/missing

## Example Workflow

User: "What are the exported types from svead?"

```
1. WebFetch https://npmx.dev/api/registry/docs/svead/v/latest
2. status: "ok" → parse html for interfaces/types
3. Found: SeoConfig (11 props), SchemaOrgProps (1 prop), Head, SchemaOrg type aliases
4. Present structured type info with source citation
```

User: "What does @sveltejs/kit export?"

```
1. WebFetch https://npmx.dev/api/registry/docs/@sveltejs/kit/v/latest
2. status: "missing" → fallback
3. Try unpkg for .d.ts files
4. Try gh api for repo source
5. Report what was found, cite sources
```

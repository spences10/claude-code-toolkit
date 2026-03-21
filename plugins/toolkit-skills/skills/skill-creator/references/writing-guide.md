# Skill Writing Guide

Detailed guidelines for writing effective Claude skills.

## Voice and Tone

### Use Imperative Voice

Claude responds best to direct instructions.

#### Good Examples

```markdown
Use prepared statements for all database queries. Generate IDs with
nanoid() before inserting records. Store timestamps as Unix epoch
milliseconds. Validate input before saving to database.
```

#### Bad Examples

```markdown
You should use prepared statements for database queries. You'll want
to generate IDs with nanoid(). It's best if you store timestamps as
Unix epoch. Try to validate input before saving.
```

### Be Specific, Not Vague

Provide concrete instructions, not general advice.

#### Good Examples

```typescript
// Use nanoid() for ID generation
import { nanoid } from "nanoid";
const id = nanoid();

// Store timestamps as ISO strings
const timestamp = new Date().toISOString();

// Use type-safe interfaces
interface User {
  id: string;
  name: string;
  email: string;
}
```

#### Bad Examples

```typescript
// Use an appropriate ID generator
const id = generateId();

// Store timestamps in a suitable format
const created_at = getCurrentTime();

// Use appropriate types
const user: any;
```

### Avoid Conceptual Explanations

Focus on procedural steps, not theory.

#### Good (Procedural)

```markdown
To fetch user data:

1. Import the API client
2. Call the endpoint with typed parameters
3. Handle the response with type checking
4. Return the typed result
```

#### Bad (Conceptual)

```markdown
When thinking about API design, consider REST principles and how
architectural patterns affect your implementation...
```

---

## Description Writing

The description determines when Claude triggers your skill. Make it count.

**Write in third person.** The description is injected into the system prompt; inconsistent point-of-view causes discovery problems.

### Description Formula

```
[Technology] + [Operations] + [Data Types] + [Trigger Phrase]
```

### Examples

#### API Client Skill

```yaml
description: REST API client for user data endpoints with TypeScript types. Use
  when making HTTP requests, handling authentication, or working with
  API responses and error handling.
```

**Breakdown**:

- Technology: "REST API", "TypeScript"
- Operations: "HTTP requests", "authentication", "error handling"
- Data types: "user data endpoints", "API responses"
- Trigger: "Use when making...or working with"

#### Component Skill

```yaml
description: Create type-safe React components with hooks and TypeScript
  interfaces. Use when building UI components, implementing forms, or
  managing component state and props.
```

### Description Checklist

- [ ] Written in third person
- [ ] Includes technology names
- [ ] Lists specific operations
- [ ] Mentions data types or domains
- [ ] Has "Use when..." trigger phrase
- [ ] Contains searchable keywords
- [ ] Under 1024 characters
- [ ] Over 50 characters (not too short)

---

## Degrees of Freedom

Match instruction specificity to the task's fragility and variability.

### High Freedom (text-based instructions)

Use when output varies by context and Claude's judgment adds value.

```markdown
## Code review process
1. Analyze the code structure and organization
2. Check for potential bugs or edge cases
3. Suggest improvements for readability and maintainability
4. Verify adherence to project conventions
```

### Medium Freedom (pseudocode or scripts with parameters)

Use when the process is consistent but details vary.

```python
def generate_report(data, format="markdown", include_charts=True):
    # Process data
    # Generate output in specified format
    # Optionally include visualizations
```

### Low Freedom (specific scripts, no modification)

Use when exact execution matters (migrations, deployments, compliance).

```markdown
## Database migration
Run exactly this script:
\`\`\`bash
python scripts/migrate.py --verify --backup
\`\`\`
Do not modify the command or add additional flags.
```

---

## Structure Patterns

### Quick Start Section

Show the most common operation immediately.

````markdown
## Quick Start

```typescript
import { apiClient } from "./lib/api";

const response = await apiClient.get("/users");
const users = response.data;
```
````

**Guidelines**:

- Minimal working example
- Most common use case
- Copy-paste ready
- Includes imports
- Shows types

### Core Patterns Section

Provide 3-5 essential patterns.

````markdown
## Core Patterns

### GET Requests

```typescript
// Single resource
const user = await apiClient.get(`/users/${id}`);

// Collection
const users = await apiClient.get("/users");
```

### POST Requests

```typescript
const newUser = await apiClient.post("/users", {
  id: nanoid(),
  name: "John Doe",
  email: "john@example.com",
  createdAt: new Date().toISOString(),
});
```
````

**Guidelines**:

- One pattern per subsection
- Include code examples
- Show variations
- Real project code
- Not invented examples

### Advanced Usage Section

Link to detailed references.

```markdown
## Advanced Usage

For detailed information:

- [references/api-docs.md](references/api-docs.md) - Complete API reference
- [references/authentication.md](references/authentication.md) - Auth patterns
- [references/examples.md](references/examples.md) - 20+ usage examples
```

**Guidelines**:

- Brief descriptions of each reference
- Descriptive link text
- Organized by topic
- Not "click here"

---

## Code Examples

### Use Real Code

Pull examples from actual codebase, not invented scenarios.

#### Good (Real)

```typescript
// From src/lib/api/users.ts
const response = await fetch(`${API_BASE}/users/${userId}/stats`, {
  headers: {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  },
});

const stats = (await response.json()) as UserStats;
```

#### Bad (Generic)

```typescript
// Generic example
const result = await api.getData();
```

### Include Context

Show imports, types, and surrounding context.

```typescript
// Complete context
import { nanoid } from "nanoid";
import type { User, CreateUserRequest } from "./types";
import { apiClient } from "./client";

const createUser = async (request: CreateUserRequest): Promise<User> => {
  const user: User = {
    id: nanoid(),
    ...request,
    createdAt: new Date().toISOString(),
  };

  const response = await apiClient.post("/users", user);
  return response.data;
};
```

### Comment Strategically

Explain WHY, not WHAT.

```typescript
// Good comments (explain why)
// Use Authorization header to verify JWT token
const headers = { Authorization: `Bearer ${token}` };

// Always validate input to prevent injection attacks
const sanitized = validator.escape(userInput);

// Bad comments (state the obvious)
// This creates headers
const headers = { Authorization: `Bearer ${token}` };

// This makes a request
const response = await fetch(url);
```

---

## Size Guidelines

### SKILL.md Body

- **CLI recommended**: <50 lines, <1000 words (optimal when many skills loaded)
- **Anthropic official max**: 500 lines, ~5k tokens
- **Validate**: `npx claude-skills-cli validate` (default strict) or `--loose` (official limits)
- **If exceeding**: Move content to references/

### Reference Files

- **Target**: 1k-10k words per file
- **Maximum**: 15k words per file
- **If exceeding**: Split into multiple focused files
- **Over 100 lines**: Include a table of contents at top
- **Nesting**: Keep references one level deep from SKILL.md

### Description

- **Minimum**: 50 characters
- **Target**: 100-300 characters
- **Maximum**: 1024 characters

---

## Common Mistakes

### Mistake 1: Vague Descriptions

```yaml
# Bad
description: Helper for API stuff

# Good
description: REST API client with TypeScript types for user endpoints. Use when making HTTP requests, handling auth, or managing API errors.
```

### Mistake 2: Second Person

```markdown
# Bad

You should always validate input before saving.

# Good

Validate input before saving to database.
```

### Mistake 3: Conceptual Over Procedural

````markdown
# Bad

Understanding the importance of authentication tokens in the context
of secure API communication is crucial for security...

# Good

Include authentication tokens in all API requests:

```typescript
const response = await fetch(url, {
  headers: { Authorization: `Bearer ${token}` },
});
```
````

### Mistake 4: Duplicate Content

```markdown
# Bad (repeated in multiple places)

SKILL.md has complete schema
references/schema.md has complete schema

# Good (single source of truth)

SKILL.md has quick reference
references/schema.md has complete schema
```

---

## Anti-Patterns

### Avoid Deeply Nested References

Claude may partially read files referenced from other referenced files, using `head -100` to preview rather than reading completely.

```markdown
# Bad: Too deep
SKILL.md → advanced.md → details.md → actual info

# Good: One level deep
SKILL.md → advanced.md (complete info)
SKILL.md → reference.md (complete info)
```

### Avoid Offering Too Many Options

Provide a default with an escape hatch, not a menu of choices.

```markdown
# Bad
"You can use pypdf, or pdfplumber, or PyMuPDF, or pdf2image..."

# Good
Use pdfplumber for text extraction.
For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

### Avoid Time-Sensitive Information

```markdown
# Bad
If you're doing this before August 2025, use the old API.

# Good
## Current method
Use the v2 API endpoint.

## Old patterns
<details>
<summary>Legacy v1 API (deprecated)</summary>
The v1 endpoint is no longer supported.
</details>
```

### Avoid Windows-Style Paths

Always use forward slashes, even on Windows:

```
scripts/helper.py     ✅
scripts\helper.py     ❌
```

---

## Workflow Patterns

### Checklist Pattern

For complex multi-step tasks, provide a checklist Claude can copy and track:

````markdown
## Form filling workflow

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Step 1: Analyze the form
- [ ] Step 2: Create field mapping
- [ ] Step 3: Validate mapping
- [ ] Step 4: Fill the form
- [ ] Step 5: Verify output
```
````

### Feedback Loop Pattern

Run validator → fix errors → repeat. Greatly improves output quality:

```markdown
## Document editing process
1. Make edits
2. Validate: `python scripts/validate.py`
3. If validation fails: fix issues, run validation again
4. Only proceed when validation passes
5. Rebuild output
```

### Plan-Validate-Execute Pattern

For complex open-ended tasks, have Claude create a plan file, validate it, then execute:

```markdown
## Batch update workflow
1. Analyze inputs → create `changes.json`
2. Validate plan: `python scripts/validate_changes.py changes.json`
3. If valid → execute changes
4. Verify output
```

### Conditional Workflow Pattern

Guide Claude through decision points:

```markdown
## Document modification
1. Determine modification type:
   **Creating new content?** → Follow "Creation workflow"
   **Editing existing?** → Follow "Editing workflow"
```

---

## Checklist

Before finalizing a skill:

### Content

- [ ] Description in third person
- [ ] Description includes keywords and triggers
- [ ] Imperative voice throughout
- [ ] Specific, not vague
- [ ] Real examples from codebase
- [ ] No TODO placeholders

### Structure

- [ ] Quick Start section present
- [ ] 3-5 Core Patterns documented
- [ ] Links to references working
- [ ] Scripts described
- [ ] SKILL.md body under 50 lines (strict) or 500 lines (loose)
- [ ] References one level deep (no nested chains)
- [ ] Long reference files have table of contents

### Technical

- [ ] `npx claude-skills-cli validate` passes
- [ ] YAML frontmatter valid
- [ ] Name is kebab-case, no "anthropic"/"claude", no XML tags
- [ ] Name matches directory
- [ ] No README.md in skill folder
- [ ] Scripts are executable
- [ ] References mentioned in SKILL.md

### Testing

- [ ] Tested in real conversations
- [ ] Claude triggers skill correctly
- [ ] Instructions are clear
- [ ] Examples work as shown

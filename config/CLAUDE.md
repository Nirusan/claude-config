# Global Claude Code Preferences

Global instructions applied to all Next.js/React projects.

---

## Package Manager

- Always use **`pnpm`** instead of `npm` or `yarn`

## Language

- **English** for everything: code, content, commits, documentation — unless I explicitly specify another language

**Internal configurations (must be in English for optimal LLM performance):**
- `CLAUDE.md` files (global and project-level)
- Custom commands (`~/.claude/commands/*.md`)
- Custom agents (`~/.claude/agents/*.md`)
- Skills and plugins instructions
- Prompts in automation scripts (ralph.sh, etc.)

When creating new commands, agents, or instructions, always write them in English.

## TypeScript

- **Strict mode** enabled (`"strict": true` in tsconfig)
- Avoid `any` — use `unknown`, generics, or proper typing instead
- Prefer type inference when obvious, explicit types for function signatures

## Code Style

- Functional and declarative, **no classes**
- Modularization > code duplication
- Descriptive names with auxiliary verbs (`isLoading`, `hasError`, `canSubmit`)
- `function` keyword for pure functions
- Concise syntax (avoid unnecessary braces in simple conditionals)
- **Absolute imports** with `@/` alias instead of relative paths (`../../../`)

## Naming Conventions

- **Folders**: `kebab-case`
- **Variables / Functions**: `camelCase`
- **Components**: `PascalCase`
- **Component files**: `PascalCase` with type prefix (`ButtonAccount.tsx`, `CardAnalytics.tsx`, `ModalSettings.tsx`)
- **Other files**: `kebab-case`

## React / Next.js

- Minimize `'use client'`, `useState`, `useEffect`
- Prefer **Server Components** (RSC)
- Wrap client components in `<Suspense>` with fallback
- Dynamic imports for non-critical components
- **State management**: use **Zustand** over React Context for global state
- **Data fetching**: prefer **Server Actions** over API Routes when possible
- Follow Next.js docs for Data Fetching, Rendering, Routing
- **No barrel imports**: import directly (`lucide-react/icons/Check`) not from index
- **No waterfalls**: `Promise.all()` for parallel fetches, never sequential `await`
- **Deduplication**: `React.cache()` for functions called multiple times in a render

## UI & Styling

- **Tailwind CSS** + **shadcn/ui** (based on Radix)
- Mobile-first responsive design
- No additional UI packages unless necessary
- **Cursor pointer** on all interactive elements (buttons, links, selects, etc.) — add global CSS rule in `globals.css` if missing

## Performance

- Optimize Web Vitals (LCP, CLS, FID)
- Images: WebP format, lazy loading, explicit dimensions

## Design

- **Production-ready** designs, not generic or cookie-cutter

## Tools & Documentation

- Automatically use **Context7 MCP** for library/API documentation, code generation, and configuration
- Use **frontend-design** skill to create distinctive, production-ready UI components (avoid generic AI aesthetics)
- **Web search:** Use **Tavily** (`tavily_search`) as the primary tool for web research and real-time information
- **Reading URLs:** Use **WebFetch** by default (free, sufficient for docs/articles)
- **Fallback to Firecrawl** for: JS-heavy pages/SPAs, multi-page crawling, structured data extraction with schema, or when anti-bot bypass is needed

## MCP Gemini Design - MANDATORY WORKFLOW

**ABSOLUTE RULE**: You NEVER write frontend/UI code yourself. Gemini is your frontend developer.

### Available Tools

| Tool | Purpose |
|------|---------|
| `generate_vibes` | Generates a visual page with 5 differently styled sections. User picks favorite → becomes design-system.md |
| `create_frontend` | Creates a NEW complete file (page, component, section) |
| `modify_frontend` | Makes ONE design modification to existing code. Returns FIND/REPLACE block |
| `snippet_frontend` | Generates a code snippet to INSERT into existing file |

### Workflow (No Alternatives)

**STEP 1**: Check if `design-system.md` exists at project root BEFORE any frontend call.

**STEP 2A** (if design-system.md DOES NOT EXIST):
1. Call `generate_vibes` with projectDescription, projectType, techStack
2. Ask: "You don't have a design system. Can I create vibes-selection.tsx so you can visually choose your style?"
3. User chooses: "vibe 3" or "the 5th one"
4. Extract THE ENTIRE CODE between `<!-- VIBE_X_START -->` and `<!-- VIBE_X_END -->`
5. Save it to `design-system.md`
6. Delete vibes-selection.tsx

**STEP 2B** (if design-system.md EXISTS): Read it and use for frontend calls.

**STEP 3**: For EVERY frontend call, you MUST pass:
- `designSystem`: Copy-paste the ENTIRE content of design-system.md (all the code, not a summary)
- `context`: Functional/business context WITH ALL REAL DATA (labels, prices, stats, enum values, etc.)

### Forbidden

- Writing frontend without Gemini
- Skipping vibes workflow when design-system.md is missing
- Extracting "rules" instead of THE ENTIRE code
- Manually creating design-system.md
- Passing design info in `context` (goes in `designSystem`)
- Summarizing design system instead of copy-pasting entirely
- Calling Gemini without real data → leads to placeholders/fake info

### Exceptions (you can code these yourself)

- Text-only changes
- JS logic without UI
- Non-visual bug fixes
- Data wiring (useQuery, etc.)

## Claude Code Configuration

- **User MCPs**: Configure in `~/.claude.json`
- **Custom commands**: `~/.claude/commands/*.md`
- **Custom agents**: `~/.claude/agents/*.md`
- **Global instructions**: `~/.claude/CLAUDE.md` (this file)

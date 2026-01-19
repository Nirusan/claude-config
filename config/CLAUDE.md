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
- For reading URLs: **WebFetch** by default (free, sufficient for docs/articles), **Firecrawl** only for JS-heavy pages or advanced extraction

## Parallel Development with Git Worktrees

For working on multiple features/branches in parallel, use **git worktrees** instead of stash:

```bash
# Create a worktree for a new feature
./scripts/worktree.sh create feature/my-feature

# This creates: ../project-worktrees/feature-my-feature/
# Open a new terminal, cd into it, and run claude
```

**Benefits:**
- Run multiple Claude sessions simultaneously (one per worktree)
- No context switching or stashing needed
- Each worktree has its own working directory
- Perfect for parallel autonomous execution with `ralph.sh`

**Workflow:**
1. Create worktrees: `./scripts/worktree.sh create <branch>`
2. Open terminal per worktree
3. Run `claude` in each
4. Merge when done, delete worktrees

Use `/worktree` skill for detailed instructions.

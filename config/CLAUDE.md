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

## Code Style

- Functional and declarative, **no classes**
- Modularization > code duplication
- Descriptive names with auxiliary verbs (`isLoading`, `hasError`, `canSubmit`)
- `function` keyword for pure functions
- Concise syntax (avoid unnecessary braces in simple conditionals)

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
- Follow Next.js docs for Data Fetching, Rendering, Routing

## UI & Styling

- **Tailwind CSS** + **shadcn/ui** (based on Radix)
- Mobile-first responsive design
- No additional UI packages unless necessary

## Performance

- Optimize Web Vitals (LCP, CLS, FID)
- Images: WebP format, lazy loading, explicit dimensions

## Design

- **Production-ready** designs, not generic or cookie-cutter

## Tools & Documentation

- Automatically use **Context7 MCP** for library/API documentation, code generation, and configuration
- Use **frontend-design** skill to create distinctive, production-ready UI components (avoid generic AI aesthetics)
- For reading URLs: **WebFetch** by default (free, sufficient for docs/articles), **Firecrawl** only for JS-heavy pages or advanced extraction

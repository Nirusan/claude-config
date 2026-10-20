# Global Claude Code Preferences

Global instructions applied to all projects. Sections marked *(web projects only)* do not apply to native mobile work.

---

## Project Type Routing

- Web-specific rules in this file (portless dev servers, React Server Components/Server Actions, Tailwind DOM + shadcn/ui) apply to **web/Next.js projects only**.
- For **Expo/React Native projects**: Metro runs directly via `pnpm expo start` (never behind portless); no DOM/browser-only libraries (shadcn/ui, Radix) in native code.
- Mobile conventions live in `~/.codex/profiles/expo/AGENTS.md` (shared source of truth with Codex); the project's `AGENTS.md` is authoritative.

## Package Manager

- Always use **`pnpm`** instead of `npm` or `yarn`

## Language

- **English** for code, comments, commits and documentation, unless I or the project specify another language (product copy follows the project's locales)
- Replies to me follow the session's language setting (French)

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
- **Comments anchor decisions**: non-obvious code carries the WHY at the implementation site — the decision (and its date when known), the trade-off, the rejected alternative — so a later reader never re-litigates a settled choice blind. Hard-earned gotchas get written exactly where they would be violated next.

## Naming Conventions

- **Folders**: `kebab-case`
- **Variables / Functions**: `camelCase`
- **Components**: `PascalCase`
- **Component files**: `PascalCase` with type prefix (`ButtonAccount.tsx`, `CardAnalytics.tsx`, `ModalSettings.tsx`)
- **Other files**: `kebab-case`

## React / Next.js *(web projects only)*

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

## React & Data (all projects — web and native)

- **Derive, don't sync**: state computable from other state is a pure derivation; state that must reset when a prop/param changes resets via render-phase adjustment (compare-and-set during render), not `useEffect`. Reserve effects for genuinely external systems (subscriptions, listeners, timers).
- **Optimistic mutations (TanStack Query)**: every user-facing mutation patches its cache in `onMutate` — `await cancelQueries` on every touched key (an in-flight refetch can otherwise silently overwrite the patch), snapshot previous, patch, rollback in `onError`, invalidate in `onSettled`. The patch mirrors the FULL server effect: every affected cache gets its own snapshot/patch/rollback, including cascades. When a mutation picks its target client-side, the mutation and its patch share ONE selection helper. Sanctioned exception: creation flows whose real server id feeds immediate follow-ups stay server-paced — a temp id must never leak into routes or foreign keys.
- **Prefetch over loader**: when the next read is predictable (visible neighbor, open menu's targets, imminent navigation), warm the cache ahead of the gesture with the same query keys the destination reads; prefetch what the eye lands on first, let secondary content load on commit. Where a loading state can still surface, hold a stable footprint: quiet placeholders sized like the final content — never a spinner, never a layout jump, never flashing a state that means something else ("no data", "0") while data is merely pending. Loaders answering fresh user input (debounced search) stay legitimate.
- **Query-key versioning (TanStack Query)**: pin a version constant into each query module's keys and bump it whenever a select shape or mapping changes, with a one-line changelog comment — a persisted/stale cache must never feed new code an old shape.
- **Accessibility floor**: every interactive element ships a role and an accessible label (web: semantic elements / `aria-label`; native: `accessibilityRole` + `accessibilityLabel`); purely visual info badges get an accessible label too.

## UI & Styling *(web projects only)*

- **Tailwind CSS** + **shadcn/ui** (based on Radix)
- Mobile-first responsive design
- No additional UI packages unless necessary
- **Cursor pointer** on all interactive elements (buttons, links, selects, etc.) — add global CSS rule in `globals.css` if missing

## Performance

- Optimize Web Vitals (LCP, CLS, FID)
- Images: WebP format, lazy loading, explicit dimensions

## Supabase

- **PostgREST caps every response at 1000 rows**: unbounded reads need a pagination helper or a deliberate `.limit()` — a silently truncated read looks like clean data.

## Design

- **Production-ready** designs, not generic or cookie-cutter

## Tools & Documentation

- Automatically use **Context7 MCP** for library/API documentation, code generation, and configuration
- Use the **frontend-design** skill for new web UI or a new brand (avoid generic AI aesthetics). When the project has its own design system (e.g. `design-system.md`), that system wins and this skill is not used
- **Web search:** Use **Tavily** (`tavily_search`) as the primary tool for web research and real-time information
- **Web search fallbacks:** **Brave Search MCP** when Tavily is unavailable or rate-limited; **Exa** for semantic/similarity search (finding content "like X"); built-in **WebSearch** as last resort
- **Reading URLs:** Use **WebFetch** by default (free, sufficient for docs/articles)
- **Fallback for JS-heavy pages/SPAs**: use the built-in browser (`get_page_text`) or `tavily_extract`

## Code Search (local repos)

- Use built-in **Grep/Glob** for all local code and file searches (ripgrep-based, fast, no index or credits)
- For broad exploratory searches across many files or unknown naming, delegate to the **Explore** agent instead of grepping inline
- For semantic navigation in TypeScript (references, definitions, symbols), use the **typescript-lsp** plugin tools
- mgrep is retired (paid credits) — never install or suggest search tools that require credits when built-in tools suffice

## Local Dev Servers *(web projects only — never for Expo/Metro)*

- **Always launch dev servers via `portless`** — never run `next dev`, `vite`, `pnpm dev`, etc. directly
- Portless gives stable named URLs (`https://myapp.localhost`) instead of fighting over `:3000`, eliminating port conflicts across parallel worktrees and parallel agent sessions
- Default usage: `portless run pnpm dev` (auto-infers the name from the directory)
- Multi-service in monorepos: `portless <name> <command>` (e.g. `portless api pnpm dev:api`, `portless web pnpm dev:web`)
- For OAuth providers that reject `.localhost` (Google, Apple): start the proxy with `portless proxy start --tld dev`, then update redirect URIs in the provider console. See the `oauth` skill for the full provider-by-provider workflow.
- Defer to the `portless` skill for setup, framework integration, and proxy configuration details

## Parallel Development (Worktrees)

- For parallel feature work, use `claude --worktree <feature-name>` (or `-w`)
- Each worktree gets its own branch, working directory, `node_modules`, and `.next/` — fully isolated
- When entering a worktree for the first time on a project, if `.worktreeinclude` doesn't exist at project root, create it:
  ```
  .env
  .env.local
  .env.development.local
  .claude/settings.local.json
  ```
- Run `pnpm install` in a new worktree when executable checks (tests, typecheck, build) need it
- *(web projects on Vercel)* Push the worktree branch to trigger preview deployments
- Scope parallel features to different files/modules to avoid merge conflicts
- Practical limit: 3-5 parallel worktrees before human context-switching becomes the bottleneck

## Git Workflow

### Post-merge cleanup (automatic)

When the user mentions that a PR was merged — squash, merge, or rebase (e.g. "j'ai merge", "squashed and merged", "PR is in", "merged on GitHub") — run the post-merge cleanup without waiting for an explicit request:

1. `git checkout main` (or `master` if that's the default branch)
2. `git pull`
3. `git branch -D <feature-branch>` — use `-D` (force) because squash/rebase rewrite commit hashes, so `-d` refuses to delete
4. `git fetch --prune` — clean stale remote-tracking refs
5. If the remote branch still exists (repo without "Automatically delete head branches"): `git push origin --delete <feature-branch>`

Rules:
- Run it only in a checkout this session owns. When the project treats the main checkout as shared or read-only (a one-worktree-per-session rule), do not checkout or pull there: clean up only this session's merged branch and worktree, and report the rest
- Project rules win where they differ from this section
- Preserve uncommitted work in the working directory — it follows the checkout across branches, that's expected
- Never touch unrelated git worktrees (e.g. `.claude/worktrees/*`) — they belong to parallel sessions
- If unsure which branch was merged (multiple feature branches exist), ask before deleting

### Repo defaults

- Enable **"Automatically delete head branches"** (Settings → General → Pull Requests) on every new repo so step 5 above is unnecessary
- To batch-enable on all existing personal repos: `gh repo list <user> --limit 200 --json nameWithOwner --jq '.[].nameWithOwner' | xargs -I{} gh api -X PATCH repos/{} -f delete_branch_on_merge=true`

## Continuous Improvement

- When an error or unwanted behavior occurs repeatedly (3+ times), identify the root cause and suggest updating the relevant CLAUDE.md instruction (or adding one if missing)
- Always frame it as a clear, positive instruction ("use X") rather than a reactive patch ("don't do Y")
- Never modify CLAUDE.md autonomously — propose the change to the user for approval

## Claude Code Configuration

- **User MCPs**: Configure in `~/.claude.json`
- **Custom commands**: `~/.claude/commands/*.md`
- **Custom agents**: `~/.claude/agents/*.md`
- **Global instructions**: `~/.claude/CLAUDE.md` (this file)

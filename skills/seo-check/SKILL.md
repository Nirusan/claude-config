---
name: seo-check
description: SEO audit and optimization review. Use automatically when working on pages, metadata, content, images, or any user-facing features. Also use before commits that add new pages or modify existing content.
argument-hint: [page/feature path or blank for staged changes]
---

## SEO Check - Optimization Audit

Act as an SEO specialist and web performance expert. Thoroughly analyze the current page/code for SEO issues, accessibility gaps, and optimization opportunities. Be meticulous and assume search engines are strict.

### Target Scope

**If "$ARGUMENTS" is provided:** Focus on that specific page/feature
**If blank:** Analyze staged changes (`git diff --cached`) or recent modifications

### SEO Audit Checklist

#### 1. Metadata & Head Tags
- [ ] Page title present, unique, 50-60 characters
- [ ] Meta description present, compelling, 150-160 characters
- [ ] Canonical URL properly set
- [ ] Open Graph tags (og:title, og:description, og:image, og:url)
- [ ] Twitter Card tags (twitter:card, twitter:title, twitter:image)
- [ ] Favicon and apple-touch-icon configured
- [ ] Language attribute on html tag
- [ ] Viewport meta tag for mobile

#### 2. Content Structure
- [ ] Single H1 per page, descriptive and keyword-rich
- [ ] Proper heading hierarchy (H1 → H2 → H3, no skips)
- [ ] Meaningful alt text on all images
- [ ] Descriptive link text (no "click here")
- [ ] Content-to-code ratio reasonable
- [ ] No duplicate content issues
- [ ] Structured data / JSON-LD schema markup

#### 3. Technical SEO
- [ ] robots.txt properly configured
- [ ] XML sitemap generated and accessible
- [ ] Clean URL structure (no query params for main content)
- [ ] Proper 301 redirects for moved content
- [ ] 404 page with helpful navigation
- [ ] No broken internal links
- [ ] HTTPS enforced everywhere
- [ ] Hreflang tags for multi-language sites

#### 4. Performance (Core Web Vitals)
- [ ] Images optimized (WebP, proper sizing, lazy loading)
- [ ] Next.js Image component used correctly
- [ ] No layout shifts (explicit width/height on media)
- [ ] Fonts optimized (preload, font-display: swap)
- [ ] Critical CSS inlined or prioritized
- [ ] JavaScript bundle size reasonable
- [ ] No render-blocking resources
- [ ] Server response time < 200ms (TTFB)

#### 5. Mobile & Accessibility
- [ ] Mobile-responsive design
- [ ] Touch targets adequately sized (48x48px min)
- [ ] No horizontal scroll on mobile
- [ ] Text readable without zooming
- [ ] ARIA labels on interactive elements
- [ ] Focus states visible
- [ ] Color contrast ratios meet WCAG AA
- [ ] Skip navigation link for keyboard users

#### 6. Next.js Specific
- [ ] generateMetadata() used for dynamic pages
- [ ] Static generation (SSG) where possible
- [ ] ISR configured for frequently updated content
- [ ] Loading.tsx and error.tsx present
- [ ] Route segments properly organized
- [ ] generateStaticParams() for dynamic routes
- [ ] opengraph-image.tsx for dynamic OG images
- [ ] sitemap.ts generating all routes

#### 7. Indexability & Crawlability
- [ ] No unintentional noindex tags
- [ ] Important content not hidden in JavaScript-only
- [ ] Internal linking strategy (related content)
- [ ] Breadcrumbs for navigation and schema
- [ ] Pagination handled correctly (rel="next/prev" or load more)
- [ ] Search engines can render the page (check with fetch as Google)

### Methodology

1. **Discovery**: Identify all pages and content types
2. **Technical Analysis**: Check head tags, structure, performance
3. **Content Review**: Evaluate quality, keywords, uniqueness
4. **Mobile Audit**: Test responsive behavior and usability
5. **Impact Assessment**: Rate issues by SEO impact (Critical/High/Medium/Low)

### Output Format

```
## SEO Audit Report

**Scope:** [pages/features analyzed]
**Health Score:** [Critical | Needs Work | Good | Excellent]

### Critical Issues (fix immediately)
1. **[Issue Type]** - `file:line`
   - Problem: ...
   - SEO Impact: ...
   - Fix: ...

### High Priority
...

### Medium Priority
...

### Low Priority / Recommendations
...

### Passed Checks
- Proper heading hierarchy
- Images have alt text
- ...

### Summary
- X critical issues
- X high priority
- X medium priority
- X recommendations

### Quick Wins
1. [Easy fix with high impact]
2. ...
```

### Important

- Be specific: include file paths, line numbers, and code snippets
- Provide actionable fixes with code examples
- Consider both user experience AND search engine requirements
- Check for Next.js App Router best practices
- Flag anything that could hurt rankings or user experience
- Prioritize Core Web Vitals improvements

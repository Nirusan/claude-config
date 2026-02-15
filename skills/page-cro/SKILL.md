---
name: page-cro
version: 1.0.0
description: When the user wants to optimize, improve, or increase conversions on any marketing page — including homepage, landing pages, pricing pages, feature pages, or blog posts. Also use when the user says "CRO," "conversion rate optimization," "this page isn't converting," "improve conversions," or "why isn't this page working." For signup/registration flows, see signup-flow-cro. For post-signup activation, see onboarding-cro. For forms outside of signup, see form-cro. For popups/modals, see popup-cro.
---

# Page Conversion Rate Optimization (CRO)

You are a conversion rate optimization expert. Your goal is to analyze marketing pages and provide actionable recommendations to improve conversion rates.

## Initial Assessment

**Check for product marketing context first:**
If `.claude/product-marketing-context.md` exists, read it before asking questions. Use that context and only ask for information not already covered or specific to this task.

Before providing recommendations, identify:

1. **Page Type**: Homepage, landing page, pricing, feature, blog, about, other
2. **Primary Conversion Goal**: Sign up, request demo, purchase, subscribe, download, contact sales
3. **Traffic Context**: Where are visitors coming from? (organic, paid, email, social)

---

## CRO Analysis Framework

Analyze the page across these dimensions, in order of impact:

### 1. Value Proposition Clarity (Highest Impact)

**Check for:**
- Can a visitor understand what this is and why they should care within 5 seconds?
- Is the primary benefit clear, specific, and differentiated?
- Is it written in the customer's language (not company jargon)?

**Common issues:**
- Feature-focused instead of benefit-focused
- Too vague or too clever (sacrificing clarity)
- Trying to say everything instead of the most important thing

### 2. Headline Effectiveness

**Evaluate:**
- Does it communicate the core value proposition?
- Is it specific enough to be meaningful?
- Does it match the traffic source's messaging?

**Strong headline patterns:**
- Outcome-focused: "Get [desired outcome] without [pain point]"
- Specificity: Include numbers, timeframes, or concrete details
- Social proof: "Join 10,000+ teams who..."

### 3. CTA Placement, Copy, and Hierarchy

**Primary CTA assessment:**
- Is there one clear primary action?
- Is it visible without scrolling?
- Does the button copy communicate value, not just action?
  - Weak: "Submit," "Sign Up," "Learn More"
  - Strong: "Start Free Trial," "Get My Report," "See Pricing"

**CTA hierarchy:**
- Is there a logical primary vs. secondary CTA structure?
- Are CTAs repeated at key decision points?

### 4. Visual Hierarchy and Scannability

**Check:**
- Can someone scanning get the main message?
- Are the most important elements visually prominent?
- Is there enough white space?
- Do images support or distract from the message?

### 5. Trust Signals and Social Proof

**Types to look for:**
- Customer logos (especially recognizable ones)
- Testimonials (specific, attributed, with photos)
- Case study snippets with real numbers
- Review scores and counts
- Security badges (where relevant)

**Placement:** Near CTAs and after benefit claims

### 6. Objection Handling

**Common objections to address:**
- Price/value concerns
- "Will this work for my situation?"
- Implementation difficulty
- "What if it doesn't work?"

**Address through:** FAQ sections, guarantees, comparison content, process transparency

### 7. Friction Points

**Look for:**
- Too many form fields
- Unclear next steps
- Confusing navigation
- Required information that shouldn't be required
- Mobile experience issues
- Long load times

---

## Output Format

Structure your recommendations as:

### Quick Wins (Implement Now)
Easy changes with likely immediate impact.

### High-Impact Changes (Prioritize)
Bigger changes that require more effort but will significantly improve conversions.

### Test Ideas
Hypotheses worth A/B testing rather than assuming.

### Copy Alternatives
For key elements (headlines, CTAs), provide 2-3 alternatives with rationale.

---

## Page-Specific Frameworks

### Homepage CRO
- Clear positioning for cold visitors
- Quick path to most common conversion
- Handle both "ready to buy" and "still researching"

### Landing Page CRO
- Message match with traffic source
- Single CTA (remove navigation if possible)
- Complete argument on one page

### Pricing Page CRO
- Clear plan comparison
- Recommended plan indication
- Address "which plan is right for me?" anxiety

### Feature Page CRO
- Connect feature to benefit
- Use cases and examples
- Clear path to try/buy

### Blog Post CRO
- Contextual CTAs matching content topic
- Inline CTAs at natural stopping points

---

## Experiment Ideas

When recommending experiments, consider tests for:
- Hero section (headline, visual, CTA)
- Trust signals and social proof placement
- Pricing presentation
- Form optimization
- Navigation and UX

**For comprehensive experiment ideas by page type**: See [references/experiments.md](references/experiments.md)

---

## Task-Specific Questions

1. What's your current conversion rate and goal?
2. Where is traffic coming from?
3. What does your signup/purchase flow look like after this page?
4. Do you have user research, heatmaps, or session recordings?
5. What have you already tried?

---

## Related Skills

- **signup-flow-cro**: If the issue is in the signup process itself
- **form-cro**: If forms on the page need optimization
- **popup-cro**: If considering popups as part of the strategy
- **copywriting**: If the page needs a complete copy rewrite
- **ab-test-setup**: To properly test recommended changes

---

# Reference: experiments.md

# Page CRO Experiment Ideas

Comprehensive list of A/B tests and experiments organized by page type.

## Homepage Experiments

### Hero Section

| Test | Hypothesis |
|------|------------|
| Headline variations | Specific vs. abstract messaging |
| Subheadline clarity | Add/refine to support headline |
| CTA above fold | Include or exclude prominent CTA |
| Hero visual format | Screenshot vs. GIF vs. illustration vs. video |
| CTA button color | Test contrast and visibility |
| CTA button text | "Start Free Trial" vs. "Get Started" vs. "See Demo" |
| Interactive demo | Engage visitors immediately with product |

### Trust & Social Proof

| Test | Hypothesis |
|------|------------|
| Logo placement | Hero section vs. below fold |
| Case study in hero | Show results immediately |
| Trust badges | Add security, compliance, awards |
| Social proof in headline | "Join 10,000+ teams" messaging |
| Testimonial placement | Above fold vs. dedicated section |
| Video testimonials | More engaging than text quotes |

### Features & Content

| Test | Hypothesis |
|------|------------|
| Feature presentation | Icons + descriptions vs. detailed sections |
| Section ordering | Move high-value features up |
| Secondary CTAs | Add/remove throughout page |
| Benefit vs. feature focus | Lead with outcomes |
| Comparison section | Show vs. competitors or status quo |

### Navigation & UX

| Test | Hypothesis |
|------|------------|
| Sticky navigation | Persistent nav with CTA |
| Nav menu order | High-priority items at edges |
| Nav CTA button | Add prominent button in nav |
| Support widget | Live chat vs. AI chatbot |
| Footer optimization | Clearer secondary conversions |
| Exit intent popup | Capture abandoning visitors |

---

## Pricing Page Experiments

### Price Presentation

| Test | Hypothesis |
|------|------------|
| Annual vs. monthly display | Highlight savings or simplify |
| Price points | $99 vs. $100 vs. $97 psychology |
| "Most Popular" badge | Highlight target plan |
| Number of tiers | 3 vs. 4 vs. 2 visible options |
| Price anchoring | Order plans to anchor expectations |
| Custom enterprise tier | Show vs. "Contact Sales" |

### Pricing UX

| Test | Hypothesis |
|------|------------|
| Pricing calculator | For usage-based pricing clarity |
| Guided pricing flow | Multistep wizard vs. comparison table |
| Feature comparison format | Table vs. expandable sections |
| Monthly/annual toggle | With savings highlighted |
| Plan recommendation quiz | Help visitors choose |
| Checkout flow length | Steps required after plan selection |

### Objection Handling

| Test | Hypothesis |
|------|------------|
| FAQ section | Address pricing objections |
| ROI calculator | Demonstrate value vs. cost |
| Money-back guarantee | Prominent placement |
| Per-user breakdowns | Clarity for team plans |
| Feature inclusion clarity | What's in each tier |
| Competitor comparison | Side-by-side value comparison |

### Trust Signals

| Test | Hypothesis |
|------|------------|
| Value testimonials | Quotes about ROI specifically |
| Customer logos | Near pricing section |
| Review scores | G2/Capterra ratings |
| Case study snippet | Specific pricing/value results |

---

## Demo Request Page Experiments

### Form Optimization

| Test | Hypothesis |
|------|------------|
| Field count | Fewer fields, higher completion |
| Multi-step vs. single | Progress bar encouragement |
| Form placement | Above fold vs. after content |
| Phone field | Include vs. exclude |
| Field enrichment | Hide fields you can auto-fill |
| Form labels | Inside field vs. above |

### Page Content

| Test | Hypothesis |
|------|------------|
| Benefits above form | Reinforce value before ask |
| Demo preview | Video/GIF showing demo experience |
| "What You'll Learn" | Set expectations clearly |
| Testimonials near form | Reduce friction at decision point |
| FAQ below form | Address common objections |
| Video vs. text | Format for explaining value |

### CTA & Routing

| Test | Hypothesis |
|------|------------|
| CTA text | "Book Your Demo" vs. "Schedule 15-Min Call" |
| On-demand option | Instant demo alongside live option |
| Personalized messaging | Based on visitor data/source |
| Navigation removal | Reduce page distractions |
| Calendar integration | Inline booking vs. external link |
| Qualification routing | Self-serve for some, sales for others |

---

## Resource/Blog Page Experiments

### Content CTAs

| Test | Hypothesis |
|------|------------|
| Floating CTAs | Sticky CTA on blog posts |
| CTA placement | Inline vs. end-of-post only |
| Reading time display | Estimated reading time |
| Related resources | End-of-article recommendations |
| Gated vs. free | Content access strategy |
| Content upgrades | Specific to article topic |

### Resource Section

| Test | Hypothesis |
|------|------------|
| Navigation/filtering | Easier to find relevant content |
| Search functionality | Find specific resources |
| Featured resources | Highlight best content |
| Layout format | Grid vs. list view |
| Topic bundles | Grouped resources by theme |
| Download tracking | Gate some, track engagement |

---

## Landing Page Experiments

### Message Match

| Test | Hypothesis |
|------|------------|
| Headline matching | Match ad copy exactly |
| Visual matching | Match ad creative |
| Offer alignment | Same offer as ad promised |
| Audience-specific pages | Different pages per segment |

### Conversion Focus

| Test | Hypothesis |
|------|------------|
| Navigation removal | Single-focus page |
| CTA repetition | Multiple CTAs throughout |
| Form vs. button | Direct capture vs. click-through |
| Urgency/scarcity | If genuine, test messaging |
| Social proof density | Amount and placement |
| Video inclusion | Explain offer with video |

### Page Length

| Test | Hypothesis |
|------|------------|
| Short vs. long | Quick conversion vs. complete argument |
| Above-fold only | Minimal scroll required |
| Section ordering | Most important content first |
| Footer removal | Eliminate navigation |

---

## Feature Page Experiments

### Feature Presentation

| Test | Hypothesis |
|------|------------|
| Demo/screenshot | Show feature in action |
| Use case examples | How customers use it |
| Before/after | Impact visualization |
| Video walkthrough | Feature tour |
| Interactive demo | Try feature without signup |

### Conversion Path

| Test | Hypothesis |
|------|------------|
| Trial CTA | Feature-specific trial offer |
| Related features | Cross-link to other features |
| Comparison | vs. competitors' version |
| Pricing mention | Connect to relevant plan |
| Case study link | Feature-specific success story |

---

## Cross-Page Experiments

### Site-Wide Tests

| Test | Hypothesis |
|------|------------|
| Chat widget | Impact on conversions |
| Cookie consent UX | Minimize friction |
| Page load speed | Performance vs. features |
| Mobile experience | Responsive optimization |
| Accessibility | Impact on conversion |
| Personalization | Dynamic content by segment |

### Navigation Tests

| Test | Hypothesis |
|------|------------|
| Menu structure | Information architecture |
| Search placement | Help visitors find content |
| CTA in nav | Always-visible conversion path |
| Breadcrumbs | Navigation clarity |

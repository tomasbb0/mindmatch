# 🎤 MindMatch — In-Event Playbook (Tomás + Marta)

> **Print this AND the SHOWCASE_CHEATSHEET. This one is for during the event. Glance at section headers, don't read paragraphs.**

---

## 👯 ROLE SPLIT — TOMÁS vs MARTA

You're two presenters. **Don't both pitch the same thing.** Divide and conquer:

|                                           | **TOMÁS** (extrovert, sales/marketing)            | **MARTA** (product/strategy)                                                 |
| ----------------------------------------- | ------------------------------------------------- | ---------------------------------------------------------------------------- |
| **Primary role**                          | **The Greeter & Storyteller**                     | **The Demoer & Validator**                                                   |
| **Faces**                                 | The booth aisle — eye contact with passersby      | The laptop — running the demo                                                |
| **Opens with**                            | The 30-sec hook (see below)                       | Listens, jumps in on questions                                               |
| **Owns**                                  | Why we exist, GTM, business model, team narrative | The product itself, framework rationale, what we tested                      |
| **If asked about UX**                     | "Marta will walk you through it" → step back      | Take over the laptop confidently                                             |
| **If asked about commercials**            | Take it. Pricing, business model, market          | Defer to Tomás                                                               |
| **If asked about psychology / framework** | "Marta?" → defer                                  | **APA Task Force / Demonstrably Effective answer** (see SHOWCASE_CHEATSHEET) |

**Golden rule:** when one of you is talking, the other **watches the visitor's face**. If they look confused → tag in. If they look bored → wrap. Never both talk at once.

---

## 🎯 THE 30-SECOND HOOK (TOMÁS opens)

When someone slows down at the table, **make eye contact and say**:

> "Hey — quick question: have you ever thought about therapy and not started?"

**90% of people will say "yes" or laugh.** That's your in. Continue:

> "That's exactly why we built MindMatch. The #1 reason people don't start therapy isn't price — it's **fit anxiety**: 'what if I pick the wrong person?' We match you on the dimensions APA's evidence-based therapy research says actually drive outcomes, plus **swap protection** — if it's not the right fit in 3 sessions, your package transfers to another therapist for free. Marta, want to show them?"

→ **MARTA** takes the laptop and runs the demo (see below).

---

## 📲 THE 90-SECOND DEMO (MARTA runs)

Open at **Onboarding** (mobile view, iPhone 14 Pro). Talk while clicking:

1. **(Onboarding)** "This is what a new patient sees on their phone — fully installable PWA, no App Store needed."
2. **(Tap → Sign Up sheet)** "Standard Google login, two seconds."
3. **(Home screen)** "Personalized greeting. The big banner is our premium AI matching."
4. **(Tap AI Match)** "Five questions — what brings you to therapy, prior experience, how you want to be helped, gender preference, budget. **We match on the four dimensions APA's Task Force calls Demonstrably Effective: preferences, reactance, culture, and goal alignment.** Then we surface therapists who consistently embody empathy, warmth, and goal collaboration — the qualities that actually drive outcomes."
5. **(Match Results)** "Top 3 with compatibility %. Notice we explain _why_ each match — therapy approach, language, availability."
6. **(Open one profile)** "Full transparency — bio, approach, languages, price."
7. **(Book → Standard package)** "Three tiers, swap protection on all of them."
8. **(Checkout → Success)** "Done. Booking confirmed."

**Total: ~90 seconds.** Then hand back to TOMÁS or open Q&A.

---

## 🎙️ TOMÁS'S "WHAT TO SAY" SCRIPTS (memorize the BOLD bits)

### 🟢 If they ask "What's the business model?"

> "**Three streams. Primary: 20% commission on session packages — that's the bulk.** Secondary: a one-time €9.99 fee for the AI matching, 95% margin. Future: a €29/month pro tier for psychologists with analytics. Break-even is 2 bookings a month — our infra is under €70/month on Supabase."

### 🟢 If they ask "Why Lisbon?"

> "**City-by-city is how you control quality.** Lisbon has 2,000 registered psychologists, growing mental-health awareness, tech-friendly population. We can reach supply through the OPP directory and demand through Portuguese SEO + Instagram. Once we hit liquidity here, Porto next."

### 🟢 If they ask "What about competition?"

> "**No dominant player in Portugal.** Doctoralia is a generic healthcare directory — they don't solve fit. We're mental-health-specific, AI-matched, with swap protection. Different category."

### 🟢 If they ask "Have you talked to real users?"

> "Informally — friends and family who've been in therapy. **Our immediate next step is a structured study with NovaSBE Wellbeing team and Anne-Laure's network.** We want to talk to both patients and psychologists to validate what the literature already shows: matching on preferences and goals, plus surfacing therapists with strong relational qualities (empathy, warmth), beats any kind of personality-similarity matching." (Don't oversell. Honest = credible.)

### 🟢 If they ask "Why a prototype, not the real thing?"

> "**We deliberately validated UX first.** Three thousand lines of code, 13 screens, 56 practitioner profiles — it lets us test the full journey before sinking 6 weeks into the backend. The prototype de-risks the build."

---

## 🧠 MARTA'S "WHAT TO SAY" SCRIPTS (memorize the BOLD bits)

### 🔵 If they ask "What's your matching framework?" (Anne-Laure WILL ask)

> "**We match on the four dimensions APA's Task Force on Evidence-Based Therapy Relationships classifies as Demonstrably Effective: patient preferences, reactance, culture, and religion.** Operationally: structured filters cover preferences and culture; the 5-question intake surfaces reactance and goals. Then we surface therapists who _consistently embody_ the relational qualities the evidence shows heal — **empathy, warmth, and goal collaboration** — via verified post-session feedback. **Goal consensus alone is 11.5% of outcome variance — the single largest common factor.** Swap protection in the first 3 sessions is the behavioral safety net."

### 🔵 If they ask "Why not personality fit?"

> "**Therapist personality absolutely matters — empathy, warmth, genuineness explain about 30% of why therapy works.** What doesn't have evidence is matching _similar_ personalities together. So instead of matching personalities, we surface therapists who consistently embody the empirically-validated qualities, and we match on what APA's Task Force calls Demonstrably Effective: **your preferences, how you want to be helped, culture, and goal alignment.** That's a stronger signal than any personality test."

### 🔵 If they ask "Do users understand therapy approaches?"

> "Yes — every practitioner profile **explains their approach in plain language** (CBT, psychodynamic, humanistic, EMDR), and the intake explicitly asks what kind of conversation style works for them. **In v2 we're planning a 'Therapy Approaches 101' explainer** so users can self-educate before matching."

### 🔵 If they ask "How do you measure success?"

> "**Three proxies. Swap rate in first 3 sessions — lower means better fit.** Package completion rate. Post-package NPS. Long-term, we want 6-month retention as the gold standard, but that requires running for a year first."

### 🔵 If they ask "Is this HIPAA / GDPR compliant?"

> "Built on Supabase EU region — GDPR-native. **No clinical notes leave the platform; all sensitive data is encrypted at rest.** We're not handling Portuguese RGPD-classified health data in v1 — only matching metadata and bookings. Clinical notes stay between patient and psychologist."

---

## ⚡ "SAVE-MY-LIFE" PHRASES (when stuck)

| Situation                         | Say this                                                                                                                              |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| Don't know the answer             | "**Genuinely good question — we haven't pressure-tested that yet. Can I take your email and get back to you?**" (then actually do it) |
| Visitor is hostile / pushing      | "I hear you — that's a fair concern. **Here's how we'd think about it:** [give your best honest take]."                               |
| You contradicted Marta            | "Sorry — let me clarify. **Marta's right, I was simplifying.** What we actually mean is..."                                           |
| Visitor is rambling / won't leave | "**I love that — Marta, can you grab their email so we can follow up properly?**" → moves them to the signup sheet                    |
| Visitor is silent / awkward       | "**Want me to show you the AI matching in 30 seconds?**" → into the demo                                                              |
| You blank on a stat               | "I want to give you the right number — let me check." (don't make it up)                                                              |

---

## 🎁 ALWAYS DO BEFORE THEY LEAVE

1. **Get their email** on the signup sheet (or QR Google Form). "We're launching in Lisbon in [timeframe] — early access list?"
2. **Ask what they do.** "What do you do?" — every conversation = a potential connection (psychologist? patient? investor? journalist? designer?)
3. **Tag interesting visitors.** Quick note next to their email: "psychologist", "investor curious", "wants to test", etc.
4. **Smile and thank them.** Energy is contagious. Even bad conversations end well if you're warm.

---

## 🚦 TIMING / ENERGY MANAGEMENT (2-person teams burn out fast)

- **Every 30 min**: one of you steps away for 3 min (water, walk, breathe). The other holds the booth.
- **No phones in pockets-out mode** unless showing the demo or QR. Phones = "I'm bored" body language.
- **Stand, don't sit.** Always.
- **One hand free.** Don't hold a coffee + the laptop + a brochure all at once.

---

## 🎯 SUCCESS METRICS FOR TODAY

By end of showcase, you want:

- ✅ **20+ emails on the waitlist** (paper + digital combined)
- ✅ **3+ psychologist contacts** (potential supply-side)
- ✅ **Anne-Laure walks away nodding** — she gave the feedback, she'll recognize it addressed
- ✅ **One memorable interaction** — a journalist, an investor, a future advisor, or a real-life Maria persona

If you hit 3/4 → home run.

---

## 🆘 EMERGENCY DEBRIEF (right after)

**Within 2 hours of leaving**, the two of you sit down with coffee and write:

1. Top 3 questions you got asked → those are your gaps
2. Top 3 pieces of negative feedback → those are your roadmap
3. Top 3 emails to follow up on → send within 24h or they go cold

**Then sleep.** You've earned it.

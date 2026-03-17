# MindMatch Business Model

## Revenue Model

### 1. Patient Packages (Primary Revenue)

| Package | Sessions | Price | Commission (20%) | Net to Practitioner |
|---------|----------|-------|------------------|---------------------|
| Starter | 3 | €180 | €36 | €144 |
| Standard | 5 | €280 | €56 | €224 |
| Deep Dive | 10 | €500 | €100 | €400 |

**Key Features:**
- Upfront payment reduces no-shows
- Swap protection for first 3 sessions or 30 days
- Sessions transfer to new practitioner if swapped

### 2. AI Deep Match (Premium)

| Feature | Price | Cost | Margin |
|---------|-------|------|--------|
| AI Matching | €9.99 | ~€0.50 (API) | 95% |

**Value Proposition:**
- 5-10 min AI conversation
- Top 3 personalized matches
- Compatibility % with explanation
- One-time purchase, valid forever

### 3. Practitioner Pro (B2B - Future)

| Tier | Price | Features |
|------|-------|----------|
| Free | €0 | Basic profile, booking |
| Pro | €29/mo | Analytics, featured placement, badge |
| Clinic | €99/mo | Multi-practitioner, shared calendar |

---

## Unit Economics

### Per Transaction (Standard Package - €280)

```
Revenue:         €280
Commission:      €56 (20%)
Payment fees:    €4.60 (1.4% + €0.25 Stripe)
─────────────────────────
Gross Profit:    €51.40
```

### Monthly Projections

| Month | Bookings | Revenue | Commission | Expenses | Profit |
|-------|----------|---------|------------|----------|--------|
| 1 | 20 | €5,600 | €1,120 | €500 | €620 |
| 3 | 50 | €14,000 | €2,800 | €1,000 | €1,800 |
| 6 | 100 | €28,000 | €5,600 | €2,000 | €3,600 |
| 12 | 300 | €84,000 | €16,800 | €5,000 | €11,800 |

### Cost Structure

**Fixed Costs (Monthly):**
- Vercel Pro: €20 (or free tier)
- Supabase Pro: €25 (or free tier)
- Domain: €1
- Email (Resend): €20
- Total: ~€66/month

**Variable Costs:**
- Stripe fees: 1.4% + €0.25 per transaction
- OpenAI API: ~€0.50 per AI match
- SMS notifications: €0.05 per message

---

## Break-Even Analysis

**Monthly Fixed Costs**: €66
**Average Commission**: €50 (20% of €250 avg package)
**Payment Fees**: €4 per transaction

**Net per Transaction**: €46

**Break-Even**: 66 ÷ 46 = **2 bookings/month**

We're profitable from Day 1 with minimal bookings!

---

## Growth Scenarios

### Conservative (Year 1)

- End of Y1: 100 practitioners, 200 monthly bookings
- Monthly Revenue: €56,000
- Monthly Commission: €11,200
- Annual Revenue: €134,400

### Moderate (Year 1)

- End of Y1: 200 practitioners, 400 monthly bookings
- Monthly Revenue: €112,000
- Monthly Commission: €22,400
- Annual Revenue: €268,800

### Aggressive (Year 1)

- End of Y1: 500 practitioners, 1000 monthly bookings
- Monthly Revenue: €280,000
- Monthly Commission: €56,000
- Annual Revenue: €672,000

---

## Key Metrics to Track

### North Star Metric
**Monthly Completed Sessions**

### Leading Indicators
- New practitioner signups
- Patient waitlist signups
- AI match conversion rate

### Lagging Indicators
- Monthly recurring revenue
- Patient rebooking rate
- Practitioner churn rate

### Health Metrics
- Swap rate (<10% target)
- NPS (>40 target)
- Average response time

---

## Pricing Strategy

### Why Packages (not per-session)?

1. **Higher commitment** = lower no-shows
2. **Bigger AOV** = more revenue per customer
3. **Swap protection** = unique value prop
4. **Recurring relationship** = rebooking easier

### Why 20% Commission?

| Platform | Commission |
|----------|------------|
| BetterHelp | ~30% |
| Doctoralia | €49-99/mo flat |
| Airbnb | 14-16% |
| Uber | 25% |
| **MindMatch** | **20%** |

20% is competitive for healthcare marketplaces while still providing value.

### Future Pricing Experiments

- [ ] Dynamic pricing by demand
- [ ] Volume discounts (10+ sessions)
- [ ] Corporate packages
- [ ] Insurance integration

---

## Funding Strategy

### Phase 1: Bootstrap (Current)
- Zero external funding
- Use free tiers everywhere
- Revenue funds growth

### Phase 2: If Traction (Year 1)
- Consider €50-100k angel round
- Use for: paid marketing, team
- Retain majority ownership

### Phase 3: Scale (Year 2+)
- Seed round if expanding to Spain
- Use for: engineering team, marketing
- Target: €500k-1M

---

## Exit Potential

### Potential Acquirers

1. **Healthcare platforms**: Doctoralia, Doctolib
2. **Insurance companies**: Médis, Multicare
3. **Wellness platforms**: Headspace, Calm
4. **Telehealth**: BetterHelp, Teladoc

### Valuation Benchmarks

| Company | Revenue Multiple | ARR for €10M Exit |
|---------|------------------|-------------------|
| SaaS | 5-10x | €1-2M ARR |
| Marketplace | 3-5x | €2-3M ARR |
| Healthcare | 4-8x | €1.25-2.5M ARR |

With €1M ARR, could expect €4-8M exit.

---

*Document Version: 1.0*
*Last Updated: January 2026*

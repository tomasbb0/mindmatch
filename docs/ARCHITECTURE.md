# MindMatch Technical Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │   Web App       │  │   Mobile App    │  │   Admin Panel   │  │
│  │   (Next.js)     │  │   (React Native │  │   (Next.js)     │  │
│  │                 │  │    Expo)        │  │                 │  │
│  └────────┬────────┘  └────────┬────────┘  └────────┬────────┘  │
└───────────┼─────────────────────┼─────────────────────┼─────────┘
            │                     │                     │
            └──────────────────── │ ────────────────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │         API LAYER          │
                    │    (Next.js API Routes)    │
                    └─────────────┬─────────────┘
                                  │
┌─────────────────────────────────┴─────────────────────────────────┐
│                         SERVICE LAYER                              │
├────────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │   Supabase   │  │   OpenAI/    │  │   Stripe     │              │
│  │   (Database  │  │   Claude     │  │   (Payments) │              │
│  │    + Auth    │  │   (AI Match) │  │              │              │
│  │    + Storage)│  │              │  │              │              │
│  └──────────────┘  └──────────────┘  └──────────────┘              │
│                                                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │   Mapbox     │  │   Resend     │  │   OneSignal  │              │
│  │   (Maps)     │  │   (Email)    │  │   (Push)     │              │
│  └──────────────┘  └──────────────┘  └──────────────┘              │
└────────────────────────────────────────────────────────────────────┘
```

---

## Tech Stack Decisions

### Frontend

| Layer | Technology | Reason |
|-------|------------|--------|
| Web | Next.js 14 (App Router) | SEO for practitioner profiles, fast, free Vercel hosting |
| Mobile | React Native + Expo | Code sharing with web, quick iteration |
| Styling | Tailwind CSS | Rapid development, consistent design |
| State | Zustand | Lightweight, TypeScript friendly |
| Forms | React Hook Form + Zod | Validation, performance |
| Maps | Mapbox GL JS | Better free tier than Google Maps |

### Backend

| Layer | Technology | Reason |
|-------|------------|--------|
| Database | Supabase (PostgreSQL) | Free tier, realtime, auth built-in |
| Auth | Supabase Auth | Email + Google OAuth, magic links |
| Storage | Supabase Storage | Profile photos, credentials |
| API | Next.js API Routes | Serverless, co-located with frontend |
| AI | OpenAI GPT-4 | Best for conversational matching |
| Payments | Stripe | Industry standard, Portugal support |
| Email | Resend | Developer friendly, good free tier |

### Infrastructure

| Layer | Technology | Reason |
|-------|------------|--------|
| Hosting | Vercel | Free tier, auto deploys |
| CDN | Vercel Edge | Built-in |
| Domain | Namecheap | Cheap .com |
| Monitoring | Vercel Analytics | Free, basic |
| Error Tracking | Sentry (free tier) | Catch production bugs |

---

## Database Design

### PostGIS for Location Queries

We use PostGIS extension in Supabase for location-based queries:

```sql
-- Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

-- Practitioners table with location
CREATE TABLE practitioners (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users NOT NULL,
  display_name TEXT NOT NULL,
  bio TEXT,
  photo_url TEXT,
  
  -- Location
  location GEOGRAPHY(POINT, 4326),
  address TEXT,
  city TEXT,
  
  -- Professional info
  opp_number TEXT,  -- Ordem Psicólogos Portugueses
  specialties TEXT[],
  languages TEXT[],
  approach TEXT[],
  
  -- Pricing
  session_price_cents INTEGER,
  session_duration_minutes INTEGER DEFAULT 50,
  
  -- Status
  verified BOOLEAN DEFAULT FALSE,
  active BOOLEAN DEFAULT TRUE,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for fast geo queries
CREATE INDEX practitioners_location_idx 
  ON practitioners USING GIST (location);

-- Search practitioners within radius
CREATE FUNCTION search_practitioners_nearby(
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  radius_km DOUBLE PRECISION DEFAULT 10
)
RETURNS SETOF practitioners AS $$
  SELECT *
  FROM practitioners
  WHERE ST_DWithin(
    location,
    ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography,
    radius_km * 1000
  )
  AND active = TRUE
  AND verified = TRUE
  ORDER BY location <-> ST_SetSRID(ST_MakePoint(lng, lat), 4326)::geography;
$$ LANGUAGE SQL;
```

### Row Level Security (RLS)

```sql
-- Practitioners can only update their own profile
ALTER TABLE practitioners ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can view active practitioners"
  ON practitioners FOR SELECT
  USING (active = TRUE AND verified = TRUE);

CREATE POLICY "Users can update own profile"
  ON practitioners FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own profile"
  ON practitioners FOR INSERT
  WITH CHECK (auth.uid() = user_id);
```

---

## AI Matching System

### Conversation Flow

```
User → "I'm struggling with anxiety and overthinking"
                    ↓
    ┌───────────────────────────────────┐
    │         SYSTEM PROMPT              │
    │  You are a mental health intake    │
    │  specialist. Your job is to        │
    │  understand patient needs and      │
    │  match them with practitioners.    │
    │                                    │
    │  Extract:                          │
    │  - Primary concerns                │
    │  - Therapy experience              │
    │  - Preferences (gender, approach)  │
    │  - Scheduling needs                │
    │  - Budget range                    │
    └───────────────────────────────────┘
                    ↓
    AI Response → Follow-up questions
                    ↓
    User → More context
                    ↓
    (3-5 turns of conversation)
                    ↓
    ┌───────────────────────────────────┐
    │      MATCHING ALGORITHM            │
    │                                    │
    │  1. Extract patient profile        │
    │  2. Query practitioners by:        │
    │     - Location                     │
    │     - Specialties match            │
    │     - Availability                 │
    │  3. Score each match (0-100)       │
    │  4. Return top 3 with explanations │
    └───────────────────────────────────┘
                    ↓
    Output → "Based on our conversation..."
             - Dr. Ana (92% match)
             - Dr. Carlos (87% match)
             - Dr. Maria (85% match)
```

### Matching Score Calculation

```typescript
interface PatientNeeds {
  primaryConcerns: string[];      // anxiety, depression, relationships
  preferredApproach?: string;      // CBT, psychodynamic, humanistic
  preferredGender?: 'male' | 'female' | 'no_preference';
  languageRequired: string;
  budgetRange: [number, number];
  availabilityNeeded: string[];   // weekends, evenings
}

function calculateMatchScore(
  patient: PatientNeeds,
  practitioner: Practitioner
): number {
  let score = 0;
  
  // Specialty match (40 points)
  const specialtyMatch = patient.primaryConcerns.filter(
    c => practitioner.specialties.includes(c)
  ).length;
  score += (specialtyMatch / patient.primaryConcerns.length) * 40;
  
  // Approach match (20 points)
  if (!patient.preferredApproach || 
      practitioner.approach.includes(patient.preferredApproach)) {
    score += 20;
  }
  
  // Language match (20 points)
  if (practitioner.languages.includes(patient.languageRequired)) {
    score += 20;
  }
  
  // Budget match (10 points)
  const [minBudget, maxBudget] = patient.budgetRange;
  if (practitioner.sessionPrice >= minBudget && 
      practitioner.sessionPrice <= maxBudget) {
    score += 10;
  }
  
  // Rating bonus (10 points)
  score += (practitioner.avgRating / 5) * 10;
  
  return Math.round(score);
}
```

---

## Payment Flow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Patient    │     │   Stripe     │     │ Practitioner │
│   Checkout   │────▶│  Processing  │────▶│   Payout     │
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                    │
       │  Package: €250     │                    │
       │  - 5 sessions      │                    │
       │  - Commission 20%  │                    │
       │                    │                    │
       ▼                    │                    │
  ┌────────────┐            │                    │
  │ Stripe     │            │                    │
  │ Checkout   │            │                    │
  └────────────┘            │                    │
       │                    │                    │
       │ Payment Success    │                    │
       ▼                    │                    │
  ┌────────────┐            │                    │
  │ Webhook    │────────────┘                    │
  │ payment.   │                                 │
  │ succeeded  │                                 │
  └────────────┘                                 │
       │                                         │
       │ Create Package                          │
       │ Record in DB                            │
       ▼                                         │
  ┌────────────┐                                 │
  │ MindMatch  │                                 │
  │ Holds €250 │                                 │
  └────────────┘                                 │
       │                                         │
       │ After each session                      │
       ▼                                         │
  ┌────────────┐                                 │
  │ Session    │                                 │
  │ Complete   │                                 │
  └────────────┘                                 │
       │                                         │
       │ Release €40 (€50 - 20%)                 │
       ▼                                         ▼
  ┌────────────┐                          ┌────────────┐
  │ Stripe     │─────────────────────────▶│ Bank       │
  │ Connect    │                          │ Transfer   │
  └────────────┘                          └────────────┘
```

---

## Folder Structure

```
mindmatch/
├── apps/
│   ├── web/                    # Next.js web app
│   │   ├── app/
│   │   │   ├── (auth)/
│   │   │   │   ├── login/
│   │   │   │   └── signup/
│   │   │   ├── (patient)/
│   │   │   │   ├── search/
│   │   │   │   ├── practitioner/[id]/
│   │   │   │   ├── ai-match/
│   │   │   │   └── dashboard/
│   │   │   ├── (practitioner)/
│   │   │   │   ├── onboarding/
│   │   │   │   ├── profile/
│   │   │   │   └── bookings/
│   │   │   ├── admin/
│   │   │   └── api/
│   │   │       ├── practitioners/
│   │   │       ├── bookings/
│   │   │       ├── ai-match/
│   │   │       └── webhooks/stripe/
│   │   ├── components/
│   │   │   ├── ui/             # shadcn/ui components
│   │   │   ├── map/
│   │   │   ├── practitioner/
│   │   │   └── booking/
│   │   ├── lib/
│   │   │   ├── supabase/
│   │   │   ├── stripe/
│   │   │   └── ai/
│   │   └── styles/
│   │
│   └── mobile/                 # React Native Expo app
│       ├── app/
│       ├── components/
│       └── lib/
│
├── packages/
│   ├── database/               # Supabase types & migrations
│   ├── ui/                     # Shared components
│   └── utils/                  # Shared utilities
│
├── supabase/
│   ├── migrations/
│   └── seed.sql
│
└── docs/
    ├── PRD.md
    └── ARCHITECTURE.md
```

---

## Environment Variables

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=xxx
SUPABASE_SERVICE_ROLE_KEY=xxx

# Stripe
STRIPE_SECRET_KEY=sk_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_xxx

# OpenAI
OPENAI_API_KEY=sk-xxx

# Mapbox
NEXT_PUBLIC_MAPBOX_TOKEN=pk.xxx

# Resend
RESEND_API_KEY=re_xxx
```

---

## Deployment Pipeline

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   GitHub    │────▶│   Vercel    │────▶│ Production  │
│   Push      │     │   Build     │     │   Deploy    │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                   │
       │                   │                   │
       ▼                   ▼                   ▼
 - Run tests         - Next.js build    - mindmatch.pt
 - Lint check        - Type check       - Auto SSL
 - Format check      - Bundle analyze   - Edge CDN
```

---

*Document Version: 1.0*
*Last Updated: January 2026*

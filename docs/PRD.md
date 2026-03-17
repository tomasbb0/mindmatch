# MindMatch Product Requirements Document (PRD)

## Executive Summary

MindMatch is a mental health marketplace connecting patients with local psychologists through AI-powered matching. The platform operates city-by-city, starting in Lisbon.

---

## 1. User Personas

### 1.1 Patient (Maria, 28)
- **Background**: Young professional, first time seeking therapy
- **Pain Points**: 
  - Doesn't know what type of therapy she needs
  - Overwhelmed by options
  - Worried about finding "the right fit"
- **Goals**:
  - Find a psychologist who understands her
  - Low-risk way to try therapy
  - Local, in-person sessions preferred

### 1.2 Psychologist (Dr. Ana, 35)
- **Background**: 5 years experience, independent practice
- **Pain Points**:
  - Marketing is expensive and time-consuming
  - Hard to reach new patients
  - Competition with big clinics
- **Goals**:
  - Fill empty appointment slots
  - Attract patients who are a good fit
  - Build reputation online

---

## 2. Core Features

### 2.1 Patient Features

#### 2.1.1 Browse & Search
- **Location-based search**: Find practitioners within X km
- **Filters**: 
  - Specialty (anxiety, depression, relationships, etc.)
  - Language
  - Price range
  - Gender preference
  - Therapy approach (CBT, psychodynamic, etc.)
- **Map view**: See practitioners on interactive map

#### 2.1.2 AI Deep Match (Premium)
- **Chatbot interview**: 5-10 minute conversation
- **Questions cover**:
  - What brings you to therapy?
  - Previous therapy experience?
  - Communication style preferences?
  - Scheduling needs?
- **Output**: Top 3 recommended matches with % compatibility
- **Pricing**: €9.99 one-time

#### 2.1.3 Session Packages
- **Package options**:
  - Starter: 3 sessions (€180-240)
  - Standard: 5 sessions (€280-380)
  - Deep Dive: 10 sessions (€500-700)
- **Swap Protection**: 
  - If first practitioner isn't right, swap to another
  - Unused sessions transfer to new practitioner
  - Valid for first 30 days or 3 sessions

#### 2.1.4 Booking & Payments
- **Integrated scheduling**: See real-time availability
- **Secure payments**: Stripe integration
- **Reminders**: SMS/email before appointments

#### 2.1.5 Reviews & Ratings
- **Post-session feedback**: Simple 1-5 star + optional comment
- **Verified reviews**: Only from actual patients
- **Anonymous option**: Protect patient privacy

---

### 2.2 Practitioner Features

#### 2.2.1 Profile Management
- **Public profile includes**:
  - Photo, bio, credentials
  - Specialties and approach
  - Languages spoken
  - Location (office address or area)
  - Session price and duration
  - Insurance accepted
- **Media**: Video intro (optional), office photos

#### 2.2.2 Availability Management
- **Calendar sync**: Google Calendar, Outlook
- **Recurring availability**: Set weekly schedule
- **Instant booking**: Toggle on/off
- **Buffer time**: Set time between appointments

#### 2.2.3 Patient Management
- **Inbox**: View patient inquiries
- **Booking requests**: Accept/decline
- **Notes**: Private notes (HIPAA-compliant storage)
- **Payment tracking**: See completed payments

#### 2.2.4 Analytics (Pro Feature)
- **Profile views**: Weekly/monthly trends
- **Search appearances**: What searches you appear in
- **Conversion rate**: Views → bookings
- **Competitor insights**: Anonymous comparison to area average

---

### 2.3 Admin Features

#### 2.3.1 City Activation
- **Toggle cities**: Lisbon ✅, Porto ❌, etc.
- **Minimum practitioners**: Require X practitioners before launch
- **Geographic boundaries**: Define city limits

#### 2.3.2 Practitioner Verification
- **Review queue**: New profile submissions
- **Credential check**: Verify OPP registration
- **Manual approval**: Before going live

#### 2.3.3 Payment Management
- **Payout processing**: Weekly payouts to practitioners
- **Commission tracking**: 15-20% per transaction
- **Refund handling**: Manage swap requests

---

## 3. User Flows

### 3.1 Patient Signup & First Booking

```
Landing Page
    ↓
Sign Up (email/Google)
    ↓
Location Input (Lisbon?)
    ↓
     ┌──────────────┬──────────────┐
     │              │              │
  Browse       AI Match        Skip
  Freely      (Premium)      (Later)
     │              │              │
     ↓              ↓              ↓
Search/Filter  Chatbot →    Dashboard
     │         Top 3 Matches     │
     ↓              │              │
View Profile  ←─────┘              │
     ↓                             │
Select Package                     │
     ↓                             │
Checkout (Stripe)                  │
     ↓                             │
Confirmation + Calendar Invite     │
     └─────────────────────────────┘
```

### 3.2 Practitioner Onboarding

```
Landing Page → For Practitioners
    ↓
Sign Up (email)
    ↓
Profile Builder (multi-step)
  1. Basic Info (name, photo, bio)
  2. Credentials (license #, specialties)
  3. Services (price, duration, approach)
  4. Availability (calendar setup)
  5. Location (office or area)
    ↓
Submit for Review
    ↓
Admin Approval (24-48h)
    ↓
Profile Live ✅
```

---

## 4. Database Schema (Simplified)

```sql
-- Users table (both patients and practitioners)
users {
  id uuid PK
  email text
  role enum('patient', 'practitioner', 'admin')
  created_at timestamp
}

-- Patient profiles
patients {
  id uuid PK
  user_id uuid FK → users
  first_name text
  last_name text
  phone text
  location point
  ai_match_used boolean
}

-- Practitioner profiles
practitioners {
  id uuid PK
  user_id uuid FK → users
  display_name text
  bio text
  photo_url text
  credentials jsonb
  specialties text[]
  languages text[]
  approach text[]
  session_price integer
  session_duration integer
  location point
  address text
  verified boolean
  active boolean
}

-- Sessions/Bookings
bookings {
  id uuid PK
  patient_id uuid FK → patients
  practitioner_id uuid FK → practitioners
  package_id uuid FK → packages
  datetime timestamp
  status enum('pending', 'confirmed', 'completed', 'cancelled')
  notes text
}

-- Packages
packages {
  id uuid PK
  patient_id uuid FK → patients
  practitioner_id uuid FK → practitioners
  sessions_total integer
  sessions_used integer
  amount_paid integer
  swap_eligible boolean
  created_at timestamp
}

-- Reviews
reviews {
  id uuid PK
  booking_id uuid FK → bookings
  rating integer
  comment text
  anonymous boolean
  created_at timestamp
}

-- AI Match conversations
ai_matches {
  id uuid PK
  patient_id uuid FK → patients
  conversation jsonb
  recommended_ids uuid[]
  created_at timestamp
}
```

---

## 5. API Endpoints (Draft)

### Patient APIs
```
GET  /api/practitioners?lat=&lng=&specialty=&...
GET  /api/practitioners/:id
POST /api/ai-match (premium)
POST /api/bookings
GET  /api/bookings/:id
POST /api/reviews
```

### Practitioner APIs
```
GET  /api/practitioner/me
PUT  /api/practitioner/me
GET  /api/practitioner/availability
PUT  /api/practitioner/availability
GET  /api/practitioner/bookings
PUT  /api/practitioner/bookings/:id
```

### Admin APIs
```
GET  /api/admin/practitioners/pending
POST /api/admin/practitioners/:id/approve
GET  /api/admin/cities
PUT  /api/admin/cities/:id
```

---

## 6. Technical Requirements

### 6.1 Performance
- Page load: < 2 seconds
- Search results: < 500ms
- AI match response: < 30 seconds

### 6.2 Security
- HTTPS everywhere
- HIPAA-compliant data storage
- Encrypted PII at rest
- Rate limiting on APIs

### 6.3 Scalability
- Support 1000+ concurrent users
- 10,000+ practitioner profiles
- Multi-region deployment ready

---

## 7. Timeline

### Phase 1: Foundation (Weeks 1-2)
- [ ] Set up Supabase project
- [ ] Auth flow (email + Google)
- [ ] Basic database schema
- [ ] Practitioner profile CRUD

### Phase 2: Core Features (Weeks 3-4)
- [ ] Patient search & browse
- [ ] Map integration (Mapbox)
- [ ] Practitioner dashboard
- [ ] Booking flow (without payment)

### Phase 3: Payments & AI (Weeks 5-6)
- [ ] Stripe integration
- [ ] Package purchasing
- [ ] AI matching chatbot
- [ ] Review system

### Phase 4: Polish & Launch (Weeks 7-8)
- [ ] Mobile responsiveness
- [ ] Email notifications
- [ ] Admin dashboard
- [ ] Soft launch with 20 practitioners

---

## 8. Success Metrics

### Launch Targets (Month 1)
- 30 practitioners onboarded
- 100 patient signups
- 20 bookings completed

### Growth Targets (Month 3)
- 100 practitioners
- 500 patients
- 50% rebooking rate

### Revenue Targets (Month 6)
- €5,000 MRR
- 20% commission rate
- Break-even on hosting costs

---

*Document Version: 1.0*
*Last Updated: January 2026*

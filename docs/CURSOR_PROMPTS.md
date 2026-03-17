# MindMatch Cursor Prompts

Use these prompts to build MindMatch with Cursor/Claude/GPT.

---

## Prompt 1: Project Setup

```
Create a new Next.js 14 project with App Router for MindMatch, a mental health marketplace.

Tech stack:
- Next.js 14 with App Router
- TypeScript
- Tailwind CSS
- Supabase (PostgreSQL + Auth)
- shadcn/ui components

Project structure:
/app
  /(auth) - login, signup pages
  /(patient) - search, practitioner profiles, booking
  /(practitioner) - dashboard, profile editor
  /api - API routes
/components - reusable components
/lib - utilities, supabase client
/types - TypeScript types

Create the initial folder structure and install dependencies:
- @supabase/supabase-js
- @supabase/ssr
- shadcn/ui setup
- react-hook-form
- zod
- zustand

Set up the Supabase client with environment variables.
```

---

## Prompt 2: Database Schema

```
Create Supabase database migrations for MindMatch mental health marketplace.

Tables needed:

1. profiles (extends auth.users)
   - id (uuid, references auth.users)
   - role ('patient' | 'practitioner' | 'admin')
   - first_name, last_name
   - phone
   - created_at, updated_at

2. practitioners
   - id, user_id (FK to profiles)
   - display_name, bio, photo_url
   - opp_number (license)
   - specialties (text[]) - anxiety, depression, relationships, trauma, etc.
   - languages (text[])
   - approach (text[]) - CBT, psychodynamic, humanistic
   - session_price_cents, session_duration_minutes
   - location (geography point using PostGIS)
   - address, city
   - verified, active
   - timestamps

3. bookings
   - id, patient_id, practitioner_id
   - package_id (FK)
   - datetime
   - status ('pending', 'confirmed', 'completed', 'cancelled')
   - notes

4. packages
   - id, patient_id, practitioner_id
   - sessions_total, sessions_used
   - amount_cents
   - swap_eligible (boolean)
   - timestamps

5. reviews
   - id, booking_id
   - rating (1-5), comment
   - anonymous (boolean)

Enable PostGIS extension.
Set up Row Level Security (RLS) policies:
- Anyone can view active, verified practitioners
- Users can only edit their own profiles
- Patients can only see their own bookings

Create a search function: search_practitioners_nearby(lat, lng, radius_km)
```

---

## Prompt 3: Auth Flow

```
Implement authentication for MindMatch using Supabase Auth.

Features:
1. Email/password signup with email confirmation
2. Google OAuth login
3. Magic link login option
4. Role selection after signup (patient or practitioner)

Pages:
- /login - email/password + Google + magic link
- /signup - same options
- /auth/callback - handle OAuth callback
- /onboarding - role selection after first login

Components:
- AuthForm with email/password
- SocialAuthButtons (Google)
- MagicLinkForm

Use Supabase SSR for server-side auth.
Redirect after login based on role:
- patient → /search
- practitioner → /dashboard

Handle auth errors gracefully with toast notifications.
```

---

## Prompt 4: Practitioner Search

```
Build the practitioner search page for MindMatch.

Features:
1. Search by location (user's location or entered address)
2. Filter by:
   - Specialty (multi-select)
   - Language
   - Price range (slider)
   - Approach
   - Gender
3. Results displayed as cards
4. Map view with markers (Mapbox GL)
5. Sort by: distance, rating, price

Page: /search

Components:
- SearchFilters - collapsible sidebar with all filters
- PractitionerCard - name, photo, specialties, rating, price, distance
- SearchMap - Mapbox with practitioner markers
- SearchResults - grid of PractitionerCards
- Pagination or infinite scroll

API:
GET /api/practitioners
Query params: lat, lng, radius, specialties[], language, minPrice, maxPrice

Use the search_practitioners_nearby Supabase function.
Make it mobile responsive (filters in drawer on mobile).
```

---

## Prompt 5: Practitioner Profile

```
Build the public practitioner profile page for MindMatch.

Page: /practitioner/[id]

Sections:
1. Header - photo, name, credentials, rating
2. About - bio, approach description
3. Specialties - tags
4. Languages - flags/icons
5. Location - static map, area name (not exact address)
6. Pricing - session price, duration
7. Availability - weekly calendar preview
8. Reviews - list with pagination
9. CTA - "Book a Package" button

Components:
- PractitionerHeader
- AboutSection
- SpecialtiesTags
- AvailabilityPreview
- ReviewsList
- BookingCTA (sticky on mobile)

SEO:
- Dynamic meta tags (title, description)
- Structured data for LocalBusiness
- OG images

On "Book a Package" click, go to /practitioner/[id]/book
```

---

## Prompt 6: Booking Flow

```
Build the booking and payment flow for MindMatch.

Flow:
1. Select package (3/5/10 sessions)
2. Select preferred time slots (optional)
3. Review order
4. Stripe Checkout
5. Confirmation page

Page: /practitioner/[id]/book

Components:
- PackageSelector - cards for each package option
- TimeSlotPicker - optional preferred times
- OrderSummary - practitioner, package, price
- StripeCheckout - redirect to Stripe

API:
POST /api/bookings/create-checkout
- Receives: practitionerId, packageType, preferredTimes
- Creates Stripe Checkout Session
- Returns session URL

POST /api/webhooks/stripe
- Handle checkout.session.completed
- Create package record in database
- Send confirmation email

After payment:
- Create package in database
- Send email to patient and practitioner
- Redirect to /dashboard with success message
```

---

## Prompt 7: AI Matching

```
Build the AI matching chatbot for MindMatch.

Flow:
1. User clicks "AI Deep Match" (premium feature)
2. Chatbot asks 5-7 questions about:
   - What brings them to therapy
   - Previous therapy experience
   - Preferences (communication style, gender, approach)
   - Scheduling needs
   - Budget
3. AI analyzes responses
4. Returns top 3 practitioner matches with:
   - Compatibility % 
   - Why they're a good match
   - Link to profile

Page: /ai-match

Components:
- ChatInterface - message bubbles
- AIMessage / UserMessage components
- MatchResults - cards with % and explanation
- ProgressIndicator - shows conversation progress

API:
POST /api/ai-match/message
- Receives: conversationHistory, newMessage
- Uses OpenAI GPT-4 with system prompt
- Returns AI response

POST /api/ai-match/complete
- Receives: full conversation
- Extracts patient needs
- Queries practitioners
- Scores and returns top 3

Use streaming for AI responses.
Store conversation in database for future reference.
```

---

## Prompt 8: Practitioner Dashboard

```
Build the practitioner dashboard for MindMatch.

Page: /dashboard (for practitioners)

Sections:
1. Overview stats - total bookings, upcoming sessions, earnings
2. Upcoming bookings - next 7 days
3. Recent inquiries - new booking requests
4. Quick actions - edit profile, update availability

Components:
- StatsCards - bookings, sessions, earnings
- UpcomingBookings - list with patient info, time
- BookingRequests - accept/decline actions
- QuickLinks - profile, availability, analytics

Additional pages:
- /dashboard/bookings - full booking management
- /dashboard/profile - edit profile
- /dashboard/availability - calendar management
- /dashboard/analytics - views, conversions (Pro feature)

Use Supabase realtime for live updates on new bookings.
Mobile responsive with bottom navigation.
```

---

## Prompt 9: Admin Panel

```
Build the admin panel for MindMatch.

Page: /admin (protected, admin role only)

Features:
1. Pending practitioners - review and approve profiles
2. City management - activate/deactivate cities
3. Booking overview - all platform bookings
4. User management - patients and practitioners

Pages:
- /admin/practitioners/pending
- /admin/practitioners/all
- /admin/cities
- /admin/bookings
- /admin/users

Components:
- AdminSidebar - navigation
- PractitionerReviewCard - approve/reject with notes
- CityToggle - switch with activation status
- DataTable - sortable, filterable tables

Actions:
- Approve practitioner (sets verified = true)
- Reject practitioner (sends email with reason)
- Activate city (unlocks for public)
- Deactivate city (hides from search)

Use DataTables from shadcn/ui.
Add audit logging for admin actions.
```

---

## Prompt 10: Mobile Optimization

```
Optimize MindMatch for mobile users.

Requirements:
1. Responsive design for all pages
2. Touch-friendly interactions
3. Mobile-specific navigation

Changes:
1. Search page:
   - Filters in bottom sheet drawer
   - Map toggles to full screen
   - Horizontal scroll for filter chips

2. Practitioner profile:
   - Sticky "Book" button at bottom
   - Collapsible sections
   - Swipeable image gallery

3. Dashboard:
   - Bottom tab navigation
   - Pull-to-refresh
   - Swipe actions on booking cards

4. AI Match:
   - Full screen chat interface
   - Keyboard-aware layout
   - Quick reply suggestions

Components to add:
- MobileNav - bottom tabs
- BottomSheet - for filters, actions
- SwipeableCard - for booking actions

Test on:
- iPhone SE (small screen)
- iPhone 14 Pro (notch)
- Android (various)
```

---

## Prompt 11: Deployment

```
Deploy MindMatch to production.

Steps:
1. Vercel deployment:
   - Connect GitHub repo
   - Set environment variables
   - Configure custom domain (mindmatch.pt)

2. Supabase production:
   - Create production project
   - Run migrations
   - Set up backups
   - Configure connection pooling

3. Stripe production:
   - Switch to live keys
   - Set up webhook endpoints
   - Configure payout schedule

4. Domain & SSL:
   - Purchase mindmatch.pt
   - Configure DNS to Vercel
   - Enable automatic SSL

5. Monitoring:
   - Vercel Analytics
   - Sentry for errors
   - Supabase dashboard

Environment variables to set:
- NEXT_PUBLIC_SUPABASE_URL
- NEXT_PUBLIC_SUPABASE_ANON_KEY
- SUPABASE_SERVICE_ROLE_KEY
- STRIPE_SECRET_KEY
- STRIPE_WEBHOOK_SECRET
- NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY
- OPENAI_API_KEY
- NEXT_PUBLIC_MAPBOX_TOKEN

Create a deployment checklist document.
```

---

## Quick Reference

### Start New Feature
```
I'm building MindMatch, a mental health marketplace. 
Tech: Next.js 14, Supabase, TypeScript, Tailwind, shadcn/ui.
[Describe the feature you want to build]
```

### Debug Issue
```
I'm working on MindMatch (mental health marketplace).
Tech: Next.js 14, Supabase, TypeScript.
[Paste the error and relevant code]
```

### Code Review
```
Review this code for MindMatch (mental health marketplace).
Check for: security, performance, TypeScript errors, best practices.
[Paste the code]
```

---

*Use these prompts sequentially to build the full application.*

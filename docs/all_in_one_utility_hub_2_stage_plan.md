# All-in-One Utility Hub (Swiss Army Knife App)
## 2-Stage Development & Architecture Plan

A modular Flutter architecture combining 6 utility micro-apps into a single launcher application (similar to multi-game offline arcade hubs).

---

## 1. High-Level App Architecture (Modular Shell Pattern)

```
┌─────────────────────────────────────────────────────────────┐
│                    Root Launcher Dashboard                  │
│   (Grid View of 6 Utility Modules + Global Search/Settings)  │
└──────┬──────────┬──────────┬──────────┬──────────┬──────────┘
       │          │          │          │          │
   ┌───▼──┐   ┌───▼──┐   ┌───▼──┐   ┌───▼──┐   ┌───▼──┐   ┌───▼──┐
   │ Mod1 │   │ Mod2 │   │ Mod3 │   │ Mod4 │   │ Mod5 │   │ Mod6 │
   │Sub   │   │Price │   │Pantry│   │Image │   │Micro │   │Timer │
   │Track │   │Calc  │   │Expiry│   │Resiz │   │Budget│   │      │
   └──────┘   └──────┘   └──────┘   └──────┘   └──────┘   └──────┘
```

### Folder Structure (Feature-First Isolation)
```text
lib/
├── core/                       # Shared design system, theme, local database helper
│   ├── database/               # Shared Isar instance & schema registration
│   ├── notifications/          # Central notification manager
│   ├── theme/                  # Uniform light/dark UI themes
│   └── widgets/                # Reusable buttons, cards, dialogs
├── features/
│   ├── launcher/               # Home screen grid UI & search bar
│   ├── subscription_tracker/   # Module 1 (Views, Riverpod Providers, Models)
│   ├── price_calculator/       # Module 2
│   ├── pantry_expiry/          # Module 3
│   ├── image_compressor/       # Module 4
│   ├── micro_budgeter/         # Module 5
│   └── interval_timer/         # Module 6
└── main.dart
```

---

## 2. STAGE 1: Pure Offline All-in-One Hub (No Backend)

In Stage 1, the entire app operates completely on-device without any cloud accounts, remote servers, or network calls.

### Core Hub Infrastructure
* **Launcher UI:** Responsive 2-column card grid with custom icons, color accents, and brief utility descriptions.
* **Unified Database:** Single `Isar` database instance initialized at startup in `main.dart`, holding independent schemas for each module:
  - `SubscriptionSchema`
  - `PantryItemSchema`
  - `BudgetEnvelopeSchema` & `ExpenseTransactionSchema`
  - `SavedPriceBenchmarkSchema`
  - `TimerPresetSchema`
* **Central Notification Scheduler:** Single `flutter_local_notifications` channel manager handling alerts across Subscriptions and Pantry Expirations.

---

### The 6 Isolated Modules in Stage 1

#### 1. Subscription Tracker Module
* Enter recurring expenses (Netflix, gym, utilities) with billing cycle (weekly/monthly/yearly).
* Calculates total monthly/yearly cash-burn rate.
* Schedules local alerts at 7-day, 3-day, and 1-day intervals before renewal.
* **Storage:** Local `Isar` collection.

#### 2. Smart Unit Price & Grocery Value Calculator Module
* Side-by-side input comparing 2 to 4 items with mismatched packaging (e.g., 850g vs 1.2kg).
* Automatically normalizes to standard units (per 100g, per 1kg, per 100ml, per piece).
* Instant visual badge for "Best Value" and percentage saved.
* **Storage:** `shared_preferences` / `hive` for quick history.

#### 3. Home Pantry & Medicine Expiry Notifier Module
* Barcode scanner (`mobile_scanner`) or quick manual entry.
* Sorts items into zones: Fridge, Pantry, Freezer, Medicine Kit.
* Color-coded shelf-life status (Green: Safe, Orange: Warning, Red: Expired).
* Dispatches local notifications when items approach expiration.
* **Storage:** Local `Isar` collection.

#### 4. Batch Image Resizer & PDF Compressor Module
* Compress photos to exact target sizes (e.g., `< 200 KB` for job/visa portals).
* Resize dimensions (Passport 2x2, signature strip, A4 proportions).
* Merge multiple images into a compressed single/multi-page PDF.
* **Storage:** Zero persistent storage; processes files in-memory and caches temporarily via `path_provider`.

#### 5. Single-Goal Micro-Budgeter Module
* Create isolated mini-budgets (e.g., "Vacation Fund", "Weekend Dining").
* One-tap `+` / `-` spending logging with quick category tags.
* Real-time visual spending pace indicator and remaining daily runway gauge (`fl_chart`).
* CSV report generation and local sharing via `share_plus`.
* **Storage:** Local `Isar` collection.

#### 6. Minimalist Interval & Rest Timer Module
* Workout timer supporting custom intervals (HIIT, Tabata, Rest periods).
* Screen wake-lock (`wakelock_plus`) preventing display sleep during sessions.
* Sound chimes (`audioplayers`) and haptic vibration triggers that layer over background music.
* Save favorite interval presets locally.
* **Storage:** `shared_preferences`.

---

## 3. STAGE 2: Unified Backend Expansion

In Stage 2, a centralized backend is connected without breaking offline functionality. The app adopts an **Offline-First Sync Architecture**.

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter All-in-One Client                │
│    (Local Isar DB ──> Central Sync Manager ──> Local UI)    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                Secure WebSockets / REST / Auth
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                  Unified Supabase Backend                   │
│  ├── Auth (Google, Apple, Anonymous)                        │
│  ├── PostgreSQL Database (Multi-Table User Schemas)         │
│  ├── Storage Buckets (Receipts, Document Backups)           │
│  └── Edge Functions (Cron Notifications & Webhook Tasks)    │
└─────────────────────────────────────────────────────────────┘
```

### Universal Backend Infrastructure
* **Unified Auth:** Single Supabase login (Google Sign-In, Apple ID, or Email Magic Link) unlocks cloud backup for all 6 modules simultaneously.
* **Row-Level Security (RLS):** All database tables partitioned by `user_id` so user data remains private and segregated.
* **Sync Engine:** Timestamp-based synchronization (`updated_at`, `is_deleted`) ensuring seamless two-way syncing when moving between offline and online states.

---

### Backend Capabilities Added Across All 6 Modules

#### 1. Subscription Tracker (Backend Upgrade)
* **Cross-Device Sync:** Subscriptions stay updated across phone, tablet, and web dashboard.
* **Server-Side Push Notifications:** Supabase Edge Function cron worker triggers Firebase Cloud Messaging (FCM) notifications independently of the device's battery saver.
* **Daily Exchange Rates:** Cloud worker pulls daily Forex rates and distributes cached rates to all clients.

#### 2. Unit Price Calculator (Backend Upgrade)
* **Crowdsourced Store Benchmarks:** Users can search or submit typical price benchmarks for common items across regional supermarkets.
* **Shared Grocery List:** Multi-user live cart where items and cost-per-unit metrics update in real time for families.

#### 3. Pantry & Medicine Expiry (Backend Upgrade)
* **Global OpenFoodFacts Barcode Sync:** Scanned barcodes query a cached central database to auto-fill product title, brand, and standard shelf-life.
* **Shared Household Pantry:** Family members can join a shared pantry code; when one person marks milk as consumed, it updates for everyone.

#### 4. Image Resizer & PDF Compressor (Backend Upgrade)
* **AI Background Remover:** Cloud microservice removes backgrounds for clean passport photos.
* **OCR Text & Table Extractor:** Cloud Vision API converts photographed documents or receipts into editable text and clean searchable PDFs.

#### 5. Micro-Budgeter (Backend Upgrade)
* **Collaborative Budgets:** Split and share trip or event budgets between partners in real time.
* **Cloud Receipt Vault:** Store receipt photos compressed inside Supabase Storage, linked directly to budget transactions.

#### 6. Interval Timer (Backend Upgrade)
* **Community Routine Hub:** Explore, upvote, and download customized workout presets built by other users.
* **Cloud Workout History:** Historical logs and total session times synced across all user devices.

---

## 4. Monetization & Rollout Strategy

### Monetization Model for the All-in-One App
* **Free Tier (Stage 1 Core):** Full offline access to all 6 modules with lightweight Google AdMob banners on module entry screens.
* **Pro Upgrade (IAP / Subscription via RevenueCat):**
  - Removes all advertisements.
  - Unlocks Unified Cloud Sync & Multi-Device Login.
  - Unlocks Household Sharing (Pantry & Budgets) and AI Photo Tools.

### Development Roadmap

```
┌─────────────────────────────────────────────────────────────┐
│ STAGE 1 (Month 1 - Month 2)                                 │
│ 1. Set up core modular Flutter shell & launcher grid.       │
│ 2. Implement the 6 offline modules with local persistence.  │
│ 3. Run Google Play 20-tester closed test (14 days).         │
│ 4. Publish Stage 1 to Production on Google Play.            │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│ STAGE 2 (Month 3 - Month 4)                                 │
│ 1. Configure Supabase project, Auth, and PostgreSQL schema. │
│ 2. Implement background Sync Manager in Flutter core.       │
│ 3. Enable multi-device sync, household sharing & Pro IAP.   │
│ 4. Push Stage 2 major version update.                       │
└─────────────────────────────────────────────────────────────┘
```

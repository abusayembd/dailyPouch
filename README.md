# Nestomi: Daily Life & Home Tools

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Clean Architecture](https://img.shields.io/badge/Clean-Architecture-blueviolet?style=for-the-badge)](docs/PROJECT_MAP.md)
[![Tests](https://img.shields.io/badge/Tests-42%2F42%20Passing-success?style=for-the-badge)](docs/PROJECT_MAP.md#-test-suite-inventory--verification-guide)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**Nestomi** is an offline-first, all-in-one everyday utility suite built with Flutter. It brings together six essential, lightweight micro-tools into a single arcade launcher interface to help users manage recurring expenses, pantry stock, grocery unit prices, images, mini-budgets, and workouts with complete privacy and zero ads.

> 📖 **Looking for full architecture & implementation details?**  
> Check out the complete blueprint in [docs/PROJECT_MAP.md](docs/PROJECT_MAP.md).

---

## ✨ Key Principles

- **Offline-First & 100% Private:** All data and calculations remain strictly on your device.
- **Clean Architecture & TDD:** Strict 3-layer separation (`domain`, `data`, `presentation`) with 42 automated tests.
- **Zero Bloat & Ad-Free:** Fast startup, responsive M3 dark theme with glassmorphic cards and glowing neon accents.
- **Modular & Focused:** Each utility is self-contained with independent BLoC state machines.

---

## 📱 The 6 Integrated Micro-Tools

Nestomi operates on a modular arcade-style launcher with six independent utilities:

1. **[Subscription & Bill Tracker](docs/PROJECT_MAP.md#1-subscription--bill-tracker)** (`lib/features/subscription_tracker/`)
   - Monitor recurring expenses, monthly & annual cash-burn rate, and days until next billing.
2. **[Smart Unit Price & Value Calculator](docs/PROJECT_MAP.md#2-smart-unit-price--value-calculator)** (`lib/features/price_calculator/`)
   - Compare packages across weights (g, kg, oz, lb), volumes (ml, L, fl oz, gal), and counts to calculate exact Best Deal and percentage savings.
3. **[Pantry & Medicine Expiry Notifier](docs/PROJECT_MAP.md#3-pantry--medicine-expiry-notifier)** (`lib/features/pantry_expiry/`)
   - Track perishables across storage zones (Fridge, Freezer, Pantry, Medicine) with Safe, Warning (<=5 days), and Expired status badges.
4. **[Batch Image Resizer & Document Compressor](docs/PROJECT_MAP.md#4-batch-image-resizer--document-compressor)** (`lib/features/image_compressor/`)
   - On-device image compression (target <200KB, <100KB, Passport 2x2 crop, signature, A4 scan) and multi-page PDF compilation.
5. **[Single-Goal Micro-Budgeter](docs/PROJECT_MAP.md#5-single-goal-micro-budgeter)** (`lib/features/micro_budgeter/`)
   - Manage isolated envelope funds (vacation, party, dining) with visual daily runway allowance and 1-tap (+5, +10, +25, +50) expense logger.
6. **[Minimalist Interval & Rest Timer](docs/PROJECT_MAP.md#6-minimalist-interval--rest-timer)** (`lib/features/interval_timer/`)
   - High-contrast HIIT/Tabata/Boxing workout timer with circular countdown ring, phase-based color transitions, and screen keep-alive via Wakelock.

---

## 🛠️ Architecture & Tech Stack

Nestomi follows a strict **Clean Architecture (Feature-First)** pattern:

* **Framework:** [Flutter](https://flutter.dev) (Dart 3)
* **State Management:** [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (BLoC & Cubit)
* **Dependency Injection:** [`get_it`](https://pub.dev/packages/get_it)
* **Functional Error Handling:** [`fpdart`](https://pub.dev/packages/fpdart) (`Either<Failure, T>`)
* **Image & PDF Processing:** [`image`](https://pub.dev/packages/image) and [`pdf`](https://pub.dev/packages/pdf)
* **Screen Keep-Alive:** [`wakelock_plus`](https://pub.dev/packages/wakelock_plus)
* **Typography & UI:** Native Flutter Offline Typography (`TextStyle`), [`fl_chart`](https://pub.dev/packages/fl_chart)
* **Testing:** [`mocktail`](https://pub.dev/packages/mocktail) and [`bloc_test`](https://pub.dev/packages/bloc_test)

---

## 📁 Project Structure

```text
lib/
├── core/                       # Shared design system, DB services, DI container, failures
│   ├── database/
│   ├── di/                     # injection_container.dart
│   ├── error/                  # failures.dart & exceptions.dart
│   ├── notifications/
│   ├── theme/                  # app_colors.dart, app_typography.dart, app_theme.dart
│   ├── usecases/
│   └── widgets/                # custom_app_bar.dart, glass_card.dart, responsive_layout.dart
├── features/
│   ├── launcher/               # Central arcade hub dashboard & category search
│   ├── subscription_tracker/   # Phase 1: Subscriptions & burn-rate
│   ├── price_calculator/       # Phase 2: Unit conversions & best deal
│   ├── pantry_expiry/          # Phase 3: Freshness & storage zones
│   ├── image_compressor/       # Phase 4: In-memory image & PDF compressor
│   ├── micro_budgeter/         # Phase 5: Envelopes & daily runway
│   └── interval_timer/         # Phase 6: HIIT / Tabata workout engine
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.12.0` or higher)
- [Dart SDK](https://dart.dev/get-dart)

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/nestomi.git
   cd nestomi
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run tests:**
   ```bash
   flutter test
   ```

4. **Launch the application:**
   ```bash
   flutter run
   ```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
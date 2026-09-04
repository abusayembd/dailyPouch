# DailyPouch: Offline Life Tools

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Clean Architecture](https://img.shields.io/badge/Clean-Architecture-blueviolet?style=for-the-badge)](docs/PROJECT_MAP.md)
[![Tests](https://img.shields.io/badge/Tests-68%2F68%20Passing-success?style=for-the-badge)](docs/PROJECT_MAP.md#-test-suite-inventory--verification-guide)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

**DailyPouch** is an offline-first, all-in-one everyday utility suite built with Flutter. Conceived as *"a small pocket container holding all your daily essentials"*, it brings together six focused, high-utility micro-tools into a single arcade-style dashboard. It empowers users to manage recurring expenses, pantry freshness, grocery price comparisons, image and PDF compression, mini-budgets, and workouts—with 100% on-device privacy, zero cloud dependencies, and no ads.

> 📖 **Looking for comprehensive architecture & implementation details?**  
> Check out the complete blueprint in [docs/PROJECT_MAP.md](docs/PROJECT_MAP.md).

---

## ✨ Core Principles & Highlights

- **100% Offline-First & Private:** All calculations, files, and data stay strictly on your local device. Zero tracking, zero telemetry, zero cloud lock-in.
- **Clean Architecture & TDD:** Rigid 3-layer architecture (`domain`, `data`, `presentation`) backed by 68 automated unit, bloc, and widget tests.
- **Unified Pastel & 3D Aesthetics:** Clean, modern UI with custom 3D isometric vector artwork for every module, glowing accents, and snug side-by-side card layouts.
- **Multi-Language Localization:** Full native translation support across 9 languages (English, Bengali, Spanish, French, German, Hindi, Arabic, Chinese, Japanese) with localized numeric formatting.
- **Global Currency Engine:** Centralized currency selector (`$`, `€`, `£`, `৳`, `₹`, `¥`, `₩`, `د.إ`, `R$`, `CHF`, etc.) dynamically applied across finance and grocery calculators.

---

## 📱 The 6 Integrated Offline Micro-Tools

DailyPouch operates on a modular arcade launcher featuring six independent utilities:

1. **[Subscription Tracker](docs/PROJECT_MAP.md#1-subscription--bill-tracker)** (`lib/features/subscription_tracker/`)
   - Monitor recurring subscriptions, streaming services, and utility bills.
   - Calculates monthly & annual cash-burn rate, renewal countdowns, paid/unpaid statuses, and schedule alerts.

2. **[Smart Price Compare](docs/PROJECT_MAP.md#2-smart-price-compare)** (`lib/features/price_calculator/`)
   - Spot true grocery savings across mismatched packaging (e.g. 850g vs. 1.2kg, ml vs. liters, or count per pack).
   - Instantly calculates unit price, highlights the "Best Deal" badge, and computes exact percentage savings.

3. **[Pantry & Medicine](docs/PROJECT_MAP.md#3-pantry--medicine-expiry-notifier)** (`lib/features/pantry_expiry/`)
   - Track household food items and medication shelf life across 4 storage zones (Fridge, Freezer, Pantry, Medicine Cabinet).
   - Automated color-coded freshness badges (Safe, Warning ≤5 days, Expired) with one-tap consumption logging.

4. **[IMG & PDF Compressor](docs/PROJECT_MAP.md#4-batch-image-resizer--document-compressor)** (`lib/features/image_compressor/`)
   - In-memory target-size image compression (Portal `<200 KB`, Ultra-Tiny `<100 KB`, Signature strip, A4 proportions).
   - Auto-crop standard 2x2 passport/ID photos and compile multiple images into compressed PDF documents.

5. **[Single-Goal Budgeter](docs/PROJECT_MAP.md#5-single-goal-micro-budgeter)** (`lib/features/micro_budgeter/`)
   - Manage dedicated envelope funds (vacations, parties, weekend dining) without complex accounting.
   - Live daily safe runway gauge, visual spending pace indicator, and one-tap quick expense logging.

6. **[Interval & Rest Timer](docs/PROJECT_MAP.md#6-minimalist-interval--rest-timer)** (`lib/features/interval_timer/`)
   - High-contrast HIIT, Tabata, Boxing, and Stretch interval workout timer.
   - Circular countdown progress ring, phase color transitions, audio chimes, and display keep-alive via Wakelock.

---

## 🛠️ Tech Stack & Architecture

DailyPouch follows a strict **Clean Architecture (Feature-First)** pattern:

* **Framework:** [Flutter](https://flutter.dev) (Dart 3)
* **State Management:** [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) (BLoC & Cubit)
* **Dependency Injection:** [`get_it`](https://pub.dev/packages/get_it)
* **Functional Error Handling:** [`fpdart`](https://pub.dev/packages/fpdart) (`Either<Failure, T>`)
* **Image & PDF Processing:** [`image`](https://pub.dev/packages/image) and [`pdf`](https://pub.dev/packages/pdf)
* **Display WakeLock:** [`wakelock_plus`](https://pub.dev/packages/wakelock_plus)
* **Audio & Haptics:** [`audioplayers`](https://pub.dev/packages/audioplayers)
* **Testing:** [`mocktail`](https://pub.dev/packages/mocktail) and [`bloc_test`](https://pub.dev/packages/bloc_test)

---

## 📁 Project Structure

```text
lib/
├── core/                       # Shared design system, localization, DI container, failures
│   ├── database/               # Local JSON & file storage services
│   ├── di/                     # injection_container.dart (GetIt service locator)
│   ├── error/                  # failures.dart & exceptions.dart
│   ├── localization/           # AppLocalizations (9 languages) & LocaleCubit
│   ├── notifications/          # Local notification scheduling wrappers
│   ├── theme/                  # app_colors.dart, app_typography.dart, app_theme.dart
│   ├── usecases/               # UseCase generic contract
│   └── widgets/                # CustomAppBar, GlassCard, ResponsiveLayout
├── features/
│   ├── launcher/               # Arcade launcher dashboard, 3D artwork & module cards
│   ├── subscription_tracker/   # Subscriptions & cash-burn tracker
│   ├── price_calculator/       # Unit price comparisons & grocery savings finder
│   ├── pantry_expiry/          # Zone tracking & freshness warnings
│   ├── image_compressor/       # In-memory photo compressor, passport crop & PDF compiler
│   ├── micro_budgeter/         # Envelopes, daily runway gauge & quick spend logger
│   └── interval_timer/         # HIIT, Tabata, boxing rounds & workout engine
└── main.dart                   # Root widget DailyPouchApp & MultiBlocProvider
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.12.0` or higher)
- [Dart SDK](https://dart.dev/get-dart)

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/dailypouch.git
   cd dailypouch
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

## 🧪 Current Verification Status

- **Automated Tests:** 68 / 68 Tests Passing (100% pass rate)
- **Static Analysis:** 0 Errors, 0 Warnings, 0 Hints (`flutter analyze`)
- **Platforms Supported:** Android, iOS, Windows Desktop, macOS, Linux, Web

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
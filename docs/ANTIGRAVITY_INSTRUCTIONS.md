# Autonomous Development Directive: All-in-One Utility Hub
**Target Platform:** Flutter (Android & iOS)  
**Architecture:** Uncle Bob Clean Architecture (Feature-First)  
**State Management:** `flutter_bloc` (Bloc & Cubit)  
**Primary Agent:** Google Antigravity / AI IDE Agent  

---

## 1. Architectural Guidelines (Clean Architecture + Feature-First)

Every module inside `lib/features/<feature_name>/` must strictly adhere to the 3-layer Clean Architecture pattern. Never bypass layers or allow UI code to communicate directly with local data sources.

```text
lib/features/<feature_name>/
├── domain/                      # Pure Dart, zero Flutter/framework dependencies
│   ├── entities/                # Business models (immutable)
│   ├── repositories/            # Repository interfaces (abstract contracts)
│   └── usecases/                # Single-responsibility business actions
├── data/                        # Framework-specific implementations
│   ├── models/                  # DTOs with JSON/Isar/Database serialization
│   ├── datasources/             # Local database (Isar/Hive), platform APIs
│   │   ├── <feature>_local_datasource.dart
│   │   └── <feature>_remote_datasource.dart (Stage 2)
│   └── repositories/            # Implementation of domain repository interfaces
└── presentation/                # Flutter UI and State Management
    ├── bloc/                    # Bloc/Cubit event, state, and handler logic
    ├── pages/                   # Screen layouts
    └── widgets/                 # Module-specific modular widgets
```

### Strict Coding Constraints:
1. **Domain Isolation:** The `domain` layer must contain zero imports from `flutter/`, `isar/`, or `data/`.
2. **Immutability:** Use `equatable` or `freezed` for all Bloc Events, Bloc States, and Domain Entities.
3. **Dependency Injection:** Register all DataSources, Repositories, UseCases, and Blocs via `get_it` service locator in `lib/core/di/injection_container.dart`.
4. **Error Handling:** Use a functional error-handling approach (`fpdart` `Either<Failure, T>`) for all UseCase and Repository return signatures.

---

## 2. State Management Rules (`flutter_bloc`)

* **Bloc vs. Cubit Decision Rule:**
  - Use **Cubit** for simple, synchronous, or direct state mutations (e.g., UI tab switching, theme toggles, unit price recalculations).
  - Use **Bloc** for event-driven, asynchronous streams, or complex interactions (e.g., Barcode scanning + caching, Subscription creation + alert scheduling, Sync Engine transitions).
* **State Conventions:**
  - Always implement explicit states: `<Feature>Initial`, `<Feature>Loading`, `<Feature>Loaded`, `<Feature>Error`.
  - Avoid generic dynamic states. Pass strongly typed data inside `Loaded` states.
* **UI Rebuilding:**
  - Prefer `BlocBuilder` with a specific `buildWhen` condition to prevent unnecessary widget rebuilds.
  - Use `BlocListener` with `listenWhen` strictly for one-off side effects (e.g., showing Snackbars, navigating, triggering haptic buzz).

---

## 3. Test-Driven Development (TDD) & Testing Directives

The agent must generate comprehensive tests alongside every feature module before marking the module as complete.

### Testing Requirements:
1. **Unit Tests (Domain & Data Layer):**
   - Test every `UseCase` by mocking repository interfaces using `mocktail`.
   - Test `RepositoryImpl` by mocking DataSources to verify proper model-to-entity mapping and exception-to-failure translation.
2. **Bloc Tests (Presentation Layer):**
   - Use the `bloc_test` package for every Bloc/Cubit.
   - Test full state lifecycles: emit `[Loading, Loaded]` on success, and emit `[Loading, Error]` on data failure.
3. **Widget Tests:**
   - Verify that the UI renders progress indicators on `Loading` state and error dialogs on `Error` state.
4. **Verification Command:** The agent must run `flutter test` via terminal and verify 100% test pass rates before completing any task.

```dart
// Standard Bloc Test Template
blocTest<SubscriptionBloc, SubscriptionState>(
  'emits [SubscriptionLoading, SubscriptionLoaded] when LoadSubscriptionsEvent is added',
  build: () {
    when(() => mockGetSubscriptionsUseCase())
        .thenAnswer((_) async => const Right([testSubscription]));
    return SubscriptionBloc(getSubscriptions: mockGetSubscriptionsUseCase);
  },
  act: (bloc) => bloc.add(const LoadSubscriptionsEvent()),
  expect: () => [
    SubscriptionLoading(),
    const SubscriptionLoaded([testSubscription]),
  ],
);
```

---

## 4. Execution Plan & Modular Roadmap

Follow this step-by-step sequential order. **Do not begin the next step until the previous step passes analysis and testing.**

### Phase 0: Project Core Foundation
- [ ] Initialize project with `flutter create`.
- [ ] Configure `pubspec.yaml` with core packages (`flutter_bloc`, `get_it`, `equatable`, `isar`, `isar_flutter_libs`, `flutter_local_notifications`, `fpdart`, `mocktail`, `bloc_test`).
- [ ] Setup `lib/core/` design tokens (Color palette, typography, responsive sizing).
- [ ] Setup `lib/core/database/` (Isar database single-instance registry).
- [ ] Build `lib/features/launcher/` (Arcade-style 2-column grid linking to all 6 modules).

### Phase 1: Subscription & Bill Tracker (Offline MVP)
- [ ] Domain: `SubscriptionEntity`, `SubscriptionRepository`, `GetSubscriptionsUseCase`, `SaveSubscriptionUseCase`.
- [ ] Data: `SubscriptionModel` (Isar Schema), `SubscriptionLocalDataSourceImpl`, `SubscriptionRepositoryImpl`.
- [ ] Presentation: `SubscriptionBloc`, Add/Edit Dialog, Burn-Rate Summary Chart, Scheduled Local Notification trigger.
- [ ] Tests: Unit tests for UseCases, repository tests, and `bloc_test` suites.

### Phase 2: Unit Price & Grocery Value Calculator
- [ ] Domain: Unit conversion logic (g, kg, ml, L, oz, lb, pcs), `PriceComparisonEntity`.
- [ ] Presentation: `PriceCalculatorCubit`, responsive comparison grid, "Best Value" indicator.
- [ ] Tests: Mathematical accuracy unit tests for unit conversion and percentage saved calculation.

### Phase 3: Pantry & Medicine Expiry Notifier
- [ ] Domain: `PantryItemEntity`, `ZoneType` (Fridge, Freezer, Pantry, Medicine), `ExpiryRepository`.
- [ ] Data: `PantryItemModel` (Isar), camera barcode scanner integration (`mobile_scanner`).
- [ ] Presentation: `PantryBloc`, zone category tabs, visual timeline badges (Fresh, Warning, Expired).
- [ ] Tests: Expiry date threshold calculation tests, `PantryBloc` state lifecycle tests.

### Phase 4: Batch Image Resizer & Document Compressor
- [ ] Domain: `ImageCompressionEntity`, `CompressionPreset` (Passport 2x2, Signature, Target <200KB).
- [ ] Data: In-memory Dart `image` manipulation, `pdf` multi-page compilation datasource.
- [ ] Presentation: `ImageCompressorBloc`, preview canvas, target-size slider, export action.
- [ ] Tests: Compression ratio validation tests, image dimension scaling unit tests.

### Phase 5: Single-Goal Micro-Budgeter
- [ ] Domain: `BudgetEnvelopeEntity`, `TransactionEntity`, `BudgetRepository`.
- [ ] Data: `BudgetModel` & `TransactionModel` (Isar), CSV export generator.
- [ ] Presentation: `BudgetBloc`, daily spending runway gauge, quick `+` / `-` logging interface.
- [ ] Tests: Expense subtraction logic tests, daily allowance calculation tests.

### Phase 6: Minimalist Interval & Rest Timer
- [ ] Domain: `TimerPresetEntity`, `TimerState`.
- [ ] Presentation: `IntervalTimerBloc` (Timer engine with `Timer.periodic`), `audioplayers` sound integration, `wakelock_plus` screen keep-alive.
- [ ] Tests: Timer tick state transition tests (`TimerRunning`, `TimerPaused`, `TimerFinished`).

### Phase 7: Stage 2 Backend Integration (Supabase Cloud Sync)
- [ ] Core: Configure `supabase_flutter` client and authentication layer (`AuthBloc`).
- [ ] Data: Implement `RemoteDataSource` for Subscriptions, Pantry, and Budgets with Row-Level Security (RLS).
- [ ] Presentation: Add cloud sync status indicators and Pro Upgrade IAP via `purchases_flutter` (RevenueCat).

---

## 5. Execution Tracking & Autonomous Workflow Protocol

When operating within Antigravity or any agentic IDE, follow this self-verification loop:

```
┌────────────────────────────────────────────────────────┐
│ 1. Read Plan & Identify Current Subtask                │
├────────────────────────────────────────────────────────┤
│ 2. Create Domain Layer (Entities, Contracts, UseCases) │
├────────────────────────────────────────────────────────┤
│ 3. Create Data Layer (Models, Local/Remote DataSource) │
├────────────────────────────────────────────────────────┤
│ 4. Create Presentation Layer (Bloc/Cubit, UI Pages)    │
├────────────────────────────────────────────────────────┤
│ 5. Write & Run Unit / Bloc Tests (`flutter test`)      │
├────────────────────────────────────────────────────────┤
│ 6. Run Static Analyzer (`flutter analyze`)             │
├────────────────────────────────────────────────────────┤
│ 7. Mark Task Checked [x] in Execution Log & Proceed    │
└────────────────────────────────────────────────────────┘
```

### Agent Rules of Engagement:
1. **Never Leave TODOs or Stubs:** Do not leave placeholder comments like `// TODO: implement logic here`. Write complete, working implementations.
2. **Terminal Self-Healing:** If `flutter test` or `flutter analyze` yields errors, inspect the stack trace, correct the code autonomously, and re-run until all checks pass.
3. **No Monolithic Dumps:** Generate code file-by-file following the feature directory structure.

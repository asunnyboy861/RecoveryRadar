# RecoveryRadar - iOS Development Guide

## Executive Summary

RecoveryRadar is a privacy-first muscle recovery tracking app for Apple Watch users. Unlike competitors that only track system-level recovery via HRV, RecoveryRadar provides **muscle-level precision** — telling users not just "you're 75% recovered" but "your pectoralis major is 90% recovered, but your anterior deltoid is only 45%." The app automatically reads workout data from Apple Health, tags affected muscles using EMG-driven mapping, calculates recovery via an exponential decay model, and visualizes everything on an interactive SVG body heat map.

**Target Audience**: Strength trainers, CrossFit athletes, and Apple Watch users who want data-driven recovery insights without manual logging.

**Key Differentiators**:
1. Muscle-level recovery precision (16 tracked muscle groups)
2. Zero-input automation (auto-reads Apple Health workouts)
3. Interactive SVG body heat map with gradient recovery colors

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Athlytic | Excellent HRV-based recovery scoring, clean UI, Apple Watch complications, $2.99/mo or $24.99/yr | System-level recovery only, ignores muscle-level tracking, misjudges strength training HRV drops | We track 16 individual muscles with EMG-driven recovery; strength trainers get accurate per-muscle data |
| MySplit Recovery | Muscle-level recovery, body heat map, $4.99/mo | Simple 3-color heat map, limited recovery algorithm, 7-day free history | Gradient heat map with precise percentages, EMG-driven algorithm, more generous free tier |
| Slate | SVG body map, muscle recovery tracking, $2.99/mo | Requires manual workout logging, no Apple Health integration | Auto-reads all Apple Health data, zero manual input needed |
| Fitbod | AI-generated workout plans, muscle fatigue tracking | $15.99/mo with no free tier, recovery shown as percentage list only, no heat map | Free tier with heat map, 74% cheaper, visual recovery tracking |
| Cora | HRV-based recovery, health monitoring | System-level only, no muscle tracking, $8.99/mo | Muscle-level precision at lower price point |

## Apple Design Guidelines Compliance

- **HealthKit Privacy**: Request authorization only at first launch with clear explanation; all data processed on-device; no cloud transmission
- **Activity Rings**: Not used for non-activity data; recovery ring uses distinct styling per HIG
- **Haptic Feedback**: Subtle haptics on recovery state changes and muscle tap interactions
- **Accessibility**: VoiceOver labels on all interactive elements; Dynamic Type support; color-blind safe gradient palette
- **Dark Mode**: Dark-first design with .ultraThinMaterial cards; full light mode support
- **Navigation**: Standard TabView with 4 tabs; sheet presentations for detail views
- **Apple Watch**: Complications for recovery score; glanceable dashboard; Watch-specific UI per HIG

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI only (no UIKit)
- **Data**: SwiftData (local only, no cloud)
- **Health**: HealthKit for workout/HR/HRV/sleep data
- **Payments**: StoreKit 2 for subscriptions
- **Concurrency**: Swift Concurrency (async/await, Actor)
- **Dependencies**: Zero third-party dependencies
- **Minimum**: iOS 17.0, watchOS 10.0

## Module Structure

```
RecoveryRadar/
├── App/
│   └── RecoveryRadarApp.swift
├── Models/
│   ├── MuscleGroup.swift
│   ├── WorkoutSession.swift
│   ├── RecoveryState.swift
│   ├── MuscleStrain.swift
│   └── EMGMapping.swift
├── Services/
│   ├── HealthKitService.swift
│   ├── RecoveryEngine.swift
│   ├── MuscleTagger.swift
│   ├── StoreManager.swift
│   └── NotificationService.swift
├── ViewModels/
│   ├── RecoveryMapViewModel.swift
│   ├── DashboardViewModel.swift
│   ├── WorkoutListViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Dashboard/
│   │   ├── DashboardView.swift
│   │   ├── RecoveryScoreCard.swift
│   │   └── TodaySuggestionCard.swift
│   ├── RecoveryMap/
│   │   ├── BodyHeatMapView.swift
│   │   ├── MuscleDetailSheet.swift
│   │   └── RecoveryTimelineView.swift
│   ├── Workouts/
│   │   ├── WorkoutListView.swift
│   │   └── WorkoutDetailView.swift
│   ├── Trends/
│   │   └── TrendsView.swift
│   ├── Paywall/
│   │   └── PaywallView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── ContactSupportView.swift
│   └── Shared/
│       ├── MuscleChip.swift
│       ├── IntensityBadge.swift
│       └── RecoveryLegend.swift
├── Resources/
│   └── Data/
│       └── EMGExerciseMapping.json
└── Extensions/
    ├── Date+Extensions.swift
    ├── Color+Extensions.swift
    └── HKSample+Extensions.swift
```

## Implementation Flow

1. Create Xcode project with iOS + Watch targets, configure HealthKit capability
2. Define SwiftData models (MuscleGroup, WorkoutSession, MuscleStrain)
3. Implement HealthKitService for reading workouts, HR, HRV, sleep data
4. Build EMGExerciseMapping.json with 15+ workout type mappings
5. Implement MuscleTagger for auto-tagging muscles from workout data
6. Implement RecoveryEngine with exponential decay recovery algorithm
7. Build Dashboard view with overall recovery ring and today's suggestion
8. Build BodyHeatMapView with SwiftUI shapes and gradient coloring
9. Build MuscleDetailSheet with recovery timeline and strain history
10. Build WorkoutListView and WorkoutDetailView
11. Build TrendsView with recovery and HRV charts
12. Implement StoreManager with StoreKit 2 for subscriptions
13. Build PaywallView with 3-tier pricing display
14. Build SettingsView with HealthKit, subscription, and policy links
15. Build OnboardingView with HealthKit authorization flow
16. Build ContactSupportView with feedback submission
17. Test on iPhone and iPad simulators
18. Push to GitHub and deploy policy pages

## UI/UX Design Specifications

- **Color Scheme**: 
  - Recovery Ready: #34C759 (Apple system green)
  - Recovering: #FF9F0A (Apple system orange)
  - Fatigued: #FF453A (Apple system red)
  - Accent: #0A84FF (Apple system blue)
  - Background Dark: #000000 (OLED-friendly)
  - Background Light: #F2F2F7 (Apple standard)
  - Cards: .ultraThinMaterial (frosted glass)
- **Typography**: SF Pro (system default); Title .title.bold(), Body .body, Caption .caption2
- **Layout**: ScrollView with VStack; cards use RoundedRectangle(16); TabView with 4 tabs
- **Animations**: Recovery ring animates with .easeInOut(duration: 0.8); heat map color transitions with .animation(.easeInOut(duration: 0.5)); body rotation with .rotation3DEffect
- **iPad**: Max width 720pt for content; no restrictive tab styles

## Code Generation Rules

- Architecture: MVVM with strict separation
- No comments in code unless requested
- No third-party dependencies
- All data processed locally, no cloud
- PascalCase for types/protocols, camelCase for properties/methods
- SwiftData for persistence with @Model macro
- Actor for services (HealthKitService, RecoveryEngine, MuscleTagger)
- @Observable for ViewModels
- SwiftUI only, no UIKit

## Build & Deployment Checklist

- [ ] HealthKit capability configured in Xcode
- [ ] Info.plist includes NSHealthShareUsageDescription
- [ ] StoreKit configuration file created
- [ ] App icons generated and added to Asset Catalog
- [ ] Build succeeds on iPhone simulator
- [ ] Build succeeds on iPad simulator
- [ ] App launches and displays dashboard
- [ ] HealthKit authorization flow works
- [ ] Policy pages deployed to GitHub Pages
- [ ] keytext.md validated (ASCII only, character limits)
- [ ] Screenshots captured for App Store

# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- HealthKit: App reads workout, heart rate, HRV, sleep data from Apple Health
- StoreKit: Subscription model with monthly, yearly, and lifetime options
- Apple Watch: Companion app for recovery tracking (deferred to v2)
- Notifications: Background workout observer for auto-sync

## Auto-Configured Capabilities

| Capability | Status | Method |
|------------|--------|--------|
| HealthKit (Read-Only) | Configured | Entitlements file + Info.plist |
| StoreKit 2 | Configured | Code-level integration |
| Background Modes | Pending | Info.plist background fetch |

## Manual Configuration Required

| Capability | Status | Steps |
|------------|--------|-------|
| Apple Watch App | Deferred | Add Watch target in v2 |
| Push Notifications | Deferred | Add when notification features implemented |

## No Configuration Needed
- iCloud / CloudKit (all data is local)
- Camera / Photo Library
- Location Services
- Siri
- Sign in with Apple

## Verification
- Entitlements file created: RecoveryRadar.entitlements
- Info.plist NSHealthShareUsageDescription added
- Build verification: Pending

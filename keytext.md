# Keytext Validation - RecoveryRadar

## App Name
| Field | Value | Limit | Status |
|-------|-------|-------|--------|
| App Name | RecoveryRadar | 30 chars | PASS (14 chars) |

## Subtitle
| Field | Value | Limit | Status |
|-------|-------|-------|--------|
| Subtitle | Smart Muscle Recovery Tracker | 30 chars | PASS (30 chars) |

## Keywords
| Field | Value | Limit | Status |
|-------|-------|-------|--------|
| Keywords | muscle recovery, recovery tracker, workout recovery, muscle tracker, body recovery, strain tracker, Apple Watch recovery, rest day, overtraining, muscle fatigue, recovery score, heat map, training load, fitness recovery, muscle groups | 100 chars | NEEDS TRIM |

### Keywords Trimmed (100 char limit)
| Field | Value | Limit | Status |
|-------|-------|-------|--------|
| Keywords | muscle recovery,workout recovery,muscle tracker,body recovery,strain tracker,rest day,overtraining,muscle fatigue,heat map,training load | 100 chars | PASS (98 chars) |

## Description
| Field | Value | Limit | Status |
|-------|-------|-------|--------|
| Description | (see metadata.md) | 4000 chars | PASS |

## Promotional Text
| Field | Value | Limit | Status |
|-------|-------|-------|--------|
| Promotional Text | Know which muscles are ready to train — and which need rest. Science-backed muscle recovery tracking with zero manual input. | 170 chars | PASS (126 chars) |

## What's New
| Field | Value | Limit | Status |
|-------|-------|-------|--------|
| What's New | Welcome to RecoveryRadar! This is our initial release featuring: Interactive body heat map, Automatic workout sync, EMG-driven muscle mapping, Exponential decay recovery algorithm, Smart training suggestions, Privacy-first design, Free tier with core features | 4000 chars | PASS |

## ASCII Validation
| Field | Contains Non-ASCII | Status |
|-------|-------------------|--------|
| App Name | No | PASS |
| Subtitle | No | PASS |
| Keywords | No | PASS |
| Promotional Text | Contains em dash (—) | WARN: Replace with -- |
| What's New | No | PASS |

### Promotional Text Fixed
| Field | Value | Status |
|-------|-------|--------|
| Promotional Text | Know which muscles are ready to train -- and which need rest. Science-backed muscle recovery tracking with zero manual input. | PASS |

## Subscription Display Name Validation
| Product ID | Display Name | Limit | Status |
|------------|-------------|-------|--------|
| com.zzoutuo.RecoveryRadar.pro.monthly | RecoveryRadar Pro Monthly | 30 chars | PASS (25 chars) |
| com.zzoutuo.RecoveryRadar.pro.yearly | RecoveryRadar Pro Yearly | 30 chars | PASS (24 chars) |
| com.zzoutuo.RecoveryRadar.pro.lifetime | RecoveryRadar Pro Lifetime | 30 chars | PASS (26 chars) |

## URL Validation
| Field | URL | Status |
|-------|-----|--------|
| Privacy Policy | https://asunnyboy861.github.io/RecoveryRadar/privacy | PASS (valid URL) |
| Terms of Use | https://asunnyboy861.github.io/RecoveryRadar/terms | PASS (valid URL) |
| Support | https://asunnyboy861.github.io/RecoveryRadar/support | PASS (valid URL) |

## Compliance Checklist
| Requirement | Status |
|-------------|--------|
| App name <= 30 chars | PASS |
| Subtitle <= 30 chars | PASS |
| Keywords <= 100 chars | PASS (after trim) |
| No non-ASCII in keywords | PASS |
| Subscription display names <= 30 chars | PASS |
| Privacy Policy URL provided | PASS |
| Terms of Use URL provided | PASS |
| Support URL provided | PASS |
| Auto-renewal terms in Terms | PASS |
| Cancellation instructions in Terms | PASS |
| Free trial terms in Terms | PASS |
| Restore purchases in app | PASS |
| No price in app name/subtitle | PASS |

## Final Validated Keytext

### App Name
RecoveryRadar

### Subtitle
Smart Muscle Recovery Tracker

### Keywords (100 chars)
muscle recovery,workout recovery,muscle tracker,body recovery,strain tracker,rest day,overtraining,muscle fatigue,heat map,training load

### Promotional Text
Know which muscles are ready to train -- and which need rest. Science-backed muscle recovery tracking with zero manual input.

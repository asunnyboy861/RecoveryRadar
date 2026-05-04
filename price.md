# Pricing Configuration

## Monetization Model: Subscription (IAP)

## Subscription Group
- **Group Name**: RecoveryRadar Pro
- **Group ID**: RecoveryRadarPro

## Subscription Tiers

### 1. Monthly Subscription
- **Reference Name**: Monthly Premium
- **Product ID**: `com.zzoutuo.RecoveryRadar.pro.monthly`
- **Price**: $3.99 per month
- **Display Name**: RecoveryRadar Pro Monthly
- **Description**: Full muscle recovery tracking with all features
- **Localization**: English (US)

### 2. Yearly Subscription
- **Reference Name**: Yearly Premium
- **Product ID**: `com.zzoutuo.RecoveryRadar.pro.yearly`
- **Price**: $24.99 per year (52% savings vs monthly)
- **Display Name**: RecoveryRadar Pro Yearly
- **Description**: Best value - Full access at 52% off monthly price
- **Localization**: English (US)

### 3. Lifetime Purchase
- **Reference Name**: Lifetime Access
- **Product ID**: `com.zzoutuo.RecoveryRadar.pro.lifetime`
- **Price**: $39.99 one-time
- **Display Name**: RecoveryRadar Pro Lifetime
- **Description**: One-time purchase, forever access. No subscription needed.
- **Note**: No ongoing costs (all computation is on-device)

## Free Trial
- **Duration**: 7 days
- **Type**: Free trial on yearly subscription (auto-converts to paid)

## Free Tier vs Pro Tier

| Feature | Free | Pro |
|---------|------|-----|
| Body Heat Map | Front view only | Front + Back view |
| Recovery Percentage | 5 major muscle groups | All 16 muscle groups |
| Today's Training Suggestion | Basic | Detailed + intensity guidance |
| Overall Recovery Score | Yes | Yes |
| Workout History | Last 7 days | Unlimited |
| Recovery Trends | No | 7D/30D/90D |
| HRV Trends | No | Yes |
| Muscle Detail Sheet | No | Recovery timeline + strain history |
| Manual RPE Adjustment | No | Yes |
| Data Export | No | CSV export |

## Policy Pages Required
- Support Page: Yes (Must include subscription management info)
- Privacy Policy: Yes
- Terms of Use: Yes (REQUIRED for subscription apps)

## Apple IAP Compliance Checklist
- [ ] Auto-renewal terms included in Terms
- [ ] Cancellation instructions included
- [ ] Pricing clearly stated
- [ ] Free trial terms included
- [ ] Restore purchases functionality implemented

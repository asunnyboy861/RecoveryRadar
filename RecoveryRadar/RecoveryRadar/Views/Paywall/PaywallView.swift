import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var storeManager = StoreManager.shared
    @State private var isPurchasing = false
    @State private var selectedProduct: Product?
    @State private var loadError: String?
    @State private var loadTimeout = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    featureComparison
                    pricingCards
                    restoreButton
                    termsNotice
                }
                .padding()
                .frame(maxWidth: 720)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Go Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .task {
                await storeManager.loadProducts()
                await storeManager.updatePurchasedProducts()
                autoSelectProduct()
            }
            .onChange(of: storeManager.isLoading) { _, newValue in
                if !newValue {
                    autoSelectProduct()
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "bolt.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green.gradient)
            Text("Unlock Full Recovery Insights")
                .font(.title2.bold())
            Text("Track all 16 muscles, view trends, and get detailed suggestions.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featureComparison: some View {
        VStack(spacing: 8) {
            FeatureCompareRow(title: "Body Heat Map", free: "Front only", pro: "Front + Back")
            FeatureCompareRow(title: "Muscle Groups", free: "5 major", pro: "All 16")
            FeatureCompareRow(title: "Training Suggestions", free: "Basic", pro: "Detailed + Intensity")
            FeatureCompareRow(title: "Workout History", free: "7 days", pro: "Unlimited")
            FeatureCompareRow(title: "Recovery Trends", free: "—", pro: "7D / 30D / 90D")
            FeatureCompareRow(title: "Muscle Details", free: "—", pro: "Timeline + History")
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var pricingCards: some View {
        VStack(spacing: 12) {
            if storeManager.isLoading {
                ProgressView("Loading plans...")
                    .padding(.vertical, 40)
            } else if let error = loadError {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 32))
                        .foregroundStyle(.orange)
                    Text(error)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Retry") {
                        Task {
                            loadError = nil
                            await storeManager.loadProducts()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.vertical, 40)
            } else if storeManager.products.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 32))
                        .foregroundStyle(.orange)
                    Text("Subscription plans are not available in this region.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Text("Please contact support@zzoutuo.com for assistance.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.vertical, 40)
            } else {
                if let monthly = storeManager.monthlyProduct {
                    PricingCard(product: monthly, badge: nil, isSelected: selectedProduct?.id == monthly.id) {
                        selectedProduct = monthly
                    }
                }
                if let yearly = storeManager.yearlyProduct {
                    PricingCard(product: yearly, badge: "Best Value", isSelected: selectedProduct?.id == yearly.id) {
                        selectedProduct = yearly
                    }
                }
                if let lifetime = storeManager.lifetimeProduct {
                    PricingCard(product: lifetime, badge: "No Subscription", isSelected: selectedProduct?.id == lifetime.id) {
                        selectedProduct = lifetime
                    }
                }
            }

            Button(action: purchase) {
                if isPurchasing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(buttonTitle)
                        .bold()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(selectedProduct == nil || storeManager.products.isEmpty ? Color.gray : Color.green)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .disabled(isPurchasing || selectedProduct == nil || storeManager.products.isEmpty)
        }
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task { await storeManager.restorePurchases() }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private var termsNotice: some View {
        Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscriptions automatically renew unless canceled at least 24 hours before the end of the current period.")
            .font(.caption2)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
    }

    private var buttonTitle: String {
        guard let product = selectedProduct else { return "Select a Plan" }
        if product.id.contains(".lifetime") { return "Buy Now" }
        if product.id.contains(".yearly") { return "Start Free Trial" }
        return "Subscribe Now"
    }

    private func purchase() {
        guard let product = selectedProduct else { return }
        isPurchasing = true
        Task {
            do {
                _ = try await storeManager.purchase(product)
                dismiss()
            } catch {
                print("Purchase failed: \(error)")
            }
            isPurchasing = false
        }
    }

    private func autoSelectProduct() {
        if selectedProduct == nil {
            if let yearly = storeManager.yearlyProduct {
                selectedProduct = yearly
            } else if let monthly = storeManager.monthlyProduct {
                selectedProduct = monthly
            } else if let lifetime = storeManager.lifetimeProduct {
                selectedProduct = lifetime
            }
        }
    }
}

struct PricingCard: View {
    let product: Product
    let badge: String?
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.displayName)
                            .font(.headline)
                        if let badge = badge {
                            Text(badge)
                                .font(.caption2.bold())
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.green.opacity(0.15))
                                .foregroundStyle(.green)
                                .clipShape(Capsule())
                        }
                    }
                    Text(product.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(product.displayPrice)
                    .font(.title3.bold())
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .green : .secondary)
            }
            .padding()
            .background(isSelected ? Color.green.opacity(0.08) : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct FeatureCompareRow: View {
    let title: String
    let free: String
    let pro: String

    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
            Spacer()
            Text(free)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 60, alignment: .center)
            Text(pro)
                .font(.caption.bold())
                .foregroundStyle(.green)
                .frame(width: 60, alignment: .center)
        }
    }
}

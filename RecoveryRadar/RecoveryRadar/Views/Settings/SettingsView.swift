import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            List {
                healthSection
                subscriptionSection
                aboutSection
                legalSection
            }
            .navigationTitle("Settings")
            .onAppear { viewModel.loadSettings() }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }

    private var healthSection: some View {
        Section {
            HStack {
                Label("Apple Health", systemImage: "heart.circle.fill")
                Spacer()
                Image(systemName: viewModel.isHealthKitAuthorized ? "checkmark.circle.fill" : "xmark.circle")
                    .foregroundStyle(viewModel.isHealthKitAuthorized ? .green : .red)
            }
        } header: {
            Text("Health Data")
        }
    }

    private var subscriptionSection: some View {
        Section {
            HStack {
                Label("Subscription", systemImage: "bolt.circle.fill")
                Spacer()
                if viewModel.isProUser {
                    Text("Pro Active")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                } else {
                    Button("Upgrade") { showPaywall = true }
                        .buttonStyle(.bordered)
                        .tint(.green)
                }
            }

            if viewModel.isProUser {
                Button("Manage Subscription") {
                    if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                        UIApplication.shared.open(url)
                    }
                }
            }

            Button("Restore Purchases") {
                Task { await StoreManager.shared.restorePurchases() }
            }
        } header: {
            Text("Subscription")
        }
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text(viewModel.appVersion)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("About")
        }
    }

    private var legalSection: some View {
        Section {
            Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/RecoveryRadar/privacy")!)
            Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/RecoveryRadar/terms")!)
            Link("Support", destination: URL(string: "https://asunnyboy861.github.io/RecoveryRadar/support")!)
        } header: {
            Text("Legal")
        }
    }
}

import SwiftUI
import HealthKit

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isRequestingAuth = false
    @State private var authCompleted = false
    let onComplete: () -> Void

    var body: some View {
        TabView(selection: $currentPage) {
            welcomePage().tag(0)
            featuresPage().tag(1)
            healthAuthPage().tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
    }

    private func welcomePage() -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 72))
                .foregroundStyle(.green.gradient)
            Text("RecoveryRadar")
                .font(.title.bold())
            Text("Know which muscles are ready to train -- and which need rest.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
            Spacer()
            Button("Get Started") {
                withAnimation { currentPage = 1 }
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
        }
    }

    private func featuresPage() -> some View {
        VStack(spacing: 20) {
            Spacer()
            FeatureRow(icon: "figure.arms.open", title: "Muscle-Level Recovery", description: "Track 16 individual muscle groups, not just overall recovery")
            FeatureRow(icon: "heart.text.square", title: "Auto-Sync Workouts", description: "Reads Apple Health data automatically — zero manual input")
            FeatureRow(icon: "flame.circle", title: "Body Heat Map", description: "Visualize recovery with an interactive gradient heat map")
            FeatureRow(icon: "lightbulb.max", title: "Smart Suggestions", description: "Get daily training recommendations based on your recovery")
            Spacer()
            Button("Next") {
                withAnimation { currentPage = 2 }
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
        }
        .padding(.horizontal, 24)
    }

    private func healthAuthPage() -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.red.gradient)
            Text("Connect Apple Health")
                .font(.title2.bold())
            Text("RecoveryRadar needs read access to your workout, heart rate, and sleep data to calculate recovery scores.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)

            if isRequestingAuth {
                ProgressView()
                    .scaleEffect(1.2)
            }

            Spacer()
            Button(action: requestHealthAuth) {
                Label("Continue", systemImage: "heart.text.square")
            }
            .buttonStyle(.borderedProminent)
            .disabled(isRequestingAuth)

            Text("You can change Health access anytime in Settings.")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 40)
        }
    }

    private func requestHealthAuth() {
        isRequestingAuth = true
        Task {
            let service = HealthKitService.shared
            _ = try? await service.requestAuthorization()
            isRequestingAuth = false
            authCompleted = true
            onComplete()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 44)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

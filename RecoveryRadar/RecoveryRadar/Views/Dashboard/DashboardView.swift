import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DashboardViewModel()
    @State private var showOnboarding = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    overallRecoveryCard
                    todaySuggestionCard
                    muscleSummarySection
                }
                .padding()
            }
            .navigationTitle("RecoveryRadar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: syncWorkouts) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .refreshable {
                await viewModel.refreshRecoveries()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .task {
                if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
                    showOnboarding = true
                }
                await viewModel.loadMuscles(modelContext: modelContext)
            }
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView {
                    showOnboarding = false
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    Task { await viewModel.syncWorkouts(modelContext: modelContext) }
                }
            }
        }
    }

    private var overallRecoveryCard: some View {
        VStack(spacing: 12) {
            Text("Overall Recovery")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 12)
                Circle()
                    .trim(from: 0, to: viewModel.overallRecovery)
                    .stroke(recoveryGradient, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.8), value: viewModel.overallRecovery)
                VStack(spacing: 4) {
                    Text("\(Int(viewModel.overallRecovery * 100))%")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                    Text(recoveryLabel(viewModel.overallRecovery))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 160, height: 160)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var todaySuggestionCard: some View {
        Group {
            if let suggestion = viewModel.todaySuggestion {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: suggestionIcon(suggestion.intensity))
                            .foregroundStyle(suggestionColor(suggestion.intensity))
                        Text("Today's Suggestion")
                            .font(.headline)
                        Spacer()
                        Text(suggestion.intensity.rawValue)
                            .font(.caption.bold())
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(suggestionColor(suggestion.intensity).opacity(0.15))
                            .foregroundStyle(suggestionColor(suggestion.intensity))
                            .clipShape(Capsule())
                    }
                    Text(suggestion.suggestion)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private var muscleSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Muscle Recovery")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(viewModel.muscleRecoveries, id: \.id) { muscle in
                    MuscleChip(muscle: muscle)
                }
            }
        }
    }

    private func syncWorkouts() {
        Task {
            await viewModel.syncWorkouts(modelContext: modelContext)
        }
    }

    private var recoveryGradient: AngularGradient {
        AngularGradient(
            colors: [.red, .orange, .green],
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
        )
    }

    private func recoveryLabel(_ value: Double) -> String {
        if value >= 0.85 { return "Ready" }
        else if value >= 0.6 { return "Recovering" }
        else { return "Fatigued" }
    }

    private func suggestionIcon(_ intensity: WorkoutIntensity) -> String {
        switch intensity {
        case .rest: return "bed.double.fill"
        case .light: return "figure.walk"
        case .moderate: return "figure.run"
        case .high: return "figure.strengthtraining.traditional"
        }
    }

    private func suggestionColor(_ intensity: WorkoutIntensity) -> Color {
        switch intensity {
        case .rest: return .blue
        case .light: return .green
        case .moderate: return .orange
        case .high: return .red
        }
    }
}

import SwiftUI
import SwiftData

struct WorkoutListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = WorkoutListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.workouts.isEmpty {
                    emptyState
                } else {
                    workoutList
                }
            }
            .navigationTitle("Workouts")
            .task {
                viewModel.loadWorkouts(modelContext: modelContext)
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Workouts Yet",
            systemImage: "dumbbell",
            description: Text("Sync your workouts from Apple Health to see them here.")
        )
    }

    private var workoutList: some View {
        List {
            ForEach(viewModel.workouts, id: \.id) { workout in
                WorkoutRow(workout: workout, viewModel: viewModel)
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct WorkoutRow: View {
    let workout: WorkoutSession
    let viewModel: WorkoutListViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: workoutIcon(workout.workoutType))
                    .foregroundStyle(.green)
                Text(viewModel.workoutTypeDisplayName(workout.workoutType))
                    .font(.headline)
                Spacer()
                Text(workout.startDate, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                Label(formatDuration(workout.duration), systemImage: "clock")
                if let energy = workout.totalEnergyBurned {
                    Label(String(format: "%.0f kcal", energy), systemImage: "flame.fill")
                        .foregroundStyle(.orange)
                }
                if let hr = workout.averageHeartRate {
                    Label(String(format: "%.0f bpm", hr), systemImage: "heart.fill")
                        .foregroundStyle(.red)
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if !workout.muscleStrains.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(workout.muscleStrains.prefix(5), id: \.id) { strain in
                            MuscleChipSmall(name: strain.sourceWorkoutType, value: strain.strainScore)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func formatDuration(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        return "\(minutes)min"
    }

    private func workoutIcon(_ type: String) -> String {
        switch type {
        case "running": return "figure.run"
        case "cycling": return "bicycle"
        case "swimming": return "figure.pool.swim"
        case "rowing": return "figure.rower"
        case "yoga": return "figure.yoga"
        case "highIntensityIntervalTraining": return "flame"
        default: return "dumbbell"
        }
    }
}

struct MuscleChipSmall: View {
    let name: String
    let value: Double

    var body: some View {
        Text(String(format: "%.0f%%", value * 100))
            .font(.caption2.bold())
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(colorForValue(value).opacity(0.15))
            .foregroundStyle(colorForValue(value))
            .clipShape(Capsule())
    }

    private func colorForValue(_ v: Double) -> Color {
        if v >= 0.7 { return .red }
        else if v >= 0.4 { return .orange }
        else { return .green }
    }
}

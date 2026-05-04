import SwiftUI
import SwiftData

struct TrendsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MuscleGroup.name) private var muscles: [MuscleGroup]
    @State private var selectedPeriod = 0
    @State private var selectedMuscle: MuscleGroup?

    private let periods = ["7D", "30D", "90D"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    periodPicker
                    if let muscle = selectedMuscle {
                        muscleTrendChart(muscle)
                    } else {
                        overallTrendChart
                    }
                    musclePicker
                }
                .padding()
            }
            .navigationTitle("Trends")
        }
    }

    private var periodPicker: some View {
        Picker("Period", selection: $selectedPeriod) {
            ForEach(0..<periods.count, id: \.self) { index in
                Text(periods[index]).tag(index)
            }
        }
        .pickerStyle(.segmented)
    }

    private var overallTrendChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overall Recovery Trend")
                .font(.headline)
            ChartPlaceholder(title: "Recovery trend chart will appear with more data")
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func muscleTrendChart(_ muscle: MuscleGroup) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(muscle.name) Recovery Trend")
                .font(.headline)
            if muscle.strainHistory.isEmpty {
                ChartPlaceholder(title: "No strain data yet for \(muscle.name)")
            } else {
                strainHistoryChart(muscle)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func strainHistoryChart(_ muscle: MuscleGroup) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(muscle.strainHistory.suffix(7), id: \.id) { strain in
                HStack {
                    Text(strain.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .frame(width: 60, alignment: .leading)
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(strainBarColor(strain.strainScore))
                            .frame(width: geo.size.width * CGFloat(strain.strainScore), height: 16)
                    }
                    .frame(height: 16)
                    Text(String(format: "%.0f%%", strain.strainScore * 100))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(width: 35, alignment: .trailing)
                }
            }
        }
    }

    private var musclePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Muscle")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button("Overall") {
                        selectedMuscle = nil
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedMuscle == nil ? .green : .blue)
                    ForEach(muscles, id: \.id) { muscle in
                        Button(muscle.name) {
                            selectedMuscle = muscle
                        }
                        .buttonStyle(.bordered)
                        .tint(selectedMuscle?.id == muscle.id ? .green : .blue)
                    }
                }
            }
        }
    }

    private func strainBarColor(_ value: Double) -> Color {
        if value >= 0.7 { return .red }
        else if value >= 0.4 { return .orange }
        else { return .green }
    }
}

struct ChartPlaceholder: View {
    let title: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}

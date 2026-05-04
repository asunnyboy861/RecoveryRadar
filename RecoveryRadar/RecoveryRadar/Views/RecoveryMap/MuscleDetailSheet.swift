import SwiftUI

struct MuscleDetailSheet: View {
    let muscle: MuscleGroup
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    recoveryRing
                    recoveryDetails
                    strainHistorySection
                }
                .padding()
            }
            .navigationTitle(muscle.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var recoveryRing: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: muscle.currentRecovery)
                    .stroke(colorForRecovery(muscle.currentRecovery), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text("\(Int(muscle.currentRecovery * 100))%")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
            }
            .frame(width: 120, height: 120)

            Text(statusLabel(muscle.currentRecovery))
                .font(.headline)
                .foregroundStyle(colorForRecovery(muscle.currentRecovery))
        }
    }

    private var recoveryDetails: some View {
        VStack(spacing: 12) {
            DetailRow(label: "Body Region", value: muscle.bodyRegion.rawValue.capitalized)
            if let lastTrained = muscle.lastTrainedDate {
                DetailRow(label: "Last Trained", value: lastTrained.formatted(date: .abbreviated, time: .shortened))
                DetailRow(label: "Hours Since Training", value: "\(Int(Date.now.timeIntervalSince(lastTrained) / 3600))h")
            }
            DetailRow(label: "Last Strain Score", value: String(format: "%.0f%%", muscle.lastStrainScore * 100))
            DetailRow(label: "Recovery Time Constant", value: "\(Int(muscle.recoveryTimeConstant))h")
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private var strainHistorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Strain History")
                .font(.headline)

            if muscle.strainHistory.isEmpty {
                Text("No strain records yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(muscle.strainHistory.suffix(10), id: \.id) { strain in
                    HStack {
                        Text(strain.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                        Spacer()
                        IntensityBadge(value: strain.strainScore)
                        Text("RPE \(strain.rpe)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func colorForRecovery(_ value: Double) -> Color {
        if value >= 0.85 { return .green }
        else if value >= 0.6 { return .orange }
        else { return .red }
    }

    private func statusLabel(_ value: Double) -> String {
        if value >= 0.85 { return "Ready to Train" }
        else if value >= 0.6 { return "Still Recovering" }
        else { return "Needs Rest" }
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.bold())
        }
    }
}

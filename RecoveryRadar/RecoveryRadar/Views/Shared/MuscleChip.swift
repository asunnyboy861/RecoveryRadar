import SwiftUI

struct MuscleChip: View {
    let muscle: MuscleGroup

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(colorForRecovery(muscle.currentRecovery))
                .frame(width: 10, height: 10)
            VStack(alignment: .leading, spacing: 2) {
                Text(muscle.name)
                    .font(.caption.bold())
                    .lineLimit(1)
                Text("\(Int(muscle.currentRecovery * 100))%")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func colorForRecovery(_ value: Double) -> Color {
        if value >= 0.85 { return .green }
        else if value >= 0.6 { return .orange }
        else { return .red }
    }
}

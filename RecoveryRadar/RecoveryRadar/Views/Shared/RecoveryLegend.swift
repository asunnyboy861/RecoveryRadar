import SwiftUI

struct RecoveryLegend: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Recovery Legend")
                .font(.caption.bold())
            HStack(spacing: 16) {
                legendItem(color: .green, label: "Ready (85%+)")
                legendItem(color: .orange, label: "Recovering (60-85%)")
                legendItem(color: .red, label: "Fatigued (<60%)")
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
                .font(.caption2)
        }
    }
}

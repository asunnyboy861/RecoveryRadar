import SwiftUI

struct IntensityBadge: View {
    let value: Double

    var body: some View {
        Text(label)
            .font(.caption2.bold())
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var label: String {
        if value >= 0.7 { return "High" }
        else if value >= 0.4 { return "Medium" }
        else { return "Low" }
    }

    private var color: Color {
        if value >= 0.7 { return .red }
        else if value >= 0.4 { return .orange }
        else { return .green }
    }
}

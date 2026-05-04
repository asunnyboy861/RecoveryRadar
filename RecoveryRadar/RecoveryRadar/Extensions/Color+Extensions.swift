import SwiftUI

extension Color {
    static let recoveryReady = Color.green
    static let recovering = Color.orange
    static let fatigued = Color.red

    static func recoveryGradient(for value: Double) -> Color {
        if value >= 0.85 { return .recoveryReady }
        else if value >= 0.6 {
            let t = (value - 0.6) / 0.25
            return .orange.opacity(0.5 + t * 0.5)
        }
        else {
            let t = value / 0.6
            return Color(red: 1.0, green: t * 0.4, blue: 0)
        }
    }
}

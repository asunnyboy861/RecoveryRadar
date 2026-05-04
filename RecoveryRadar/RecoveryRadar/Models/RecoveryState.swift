import Foundation

enum WorkoutIntensity: String {
    case rest = "Rest"
    case light = "Light"
    case moderate = "Moderate"
    case high = "High"
}

struct WorkoutSuggestion {
    let suggestion: String
    let intensity: WorkoutIntensity
    let recoveredMuscles: [String]
    let partiallyRecovered: [String]
    let fatigued: [String]
}

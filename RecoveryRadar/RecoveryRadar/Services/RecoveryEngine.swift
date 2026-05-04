import Foundation
import SwiftData

actor RecoveryEngine {
    private let muscleGroups: [MuscleGroup]

    init(muscleGroups: [MuscleGroup]) {
        self.muscleGroups = muscleGroups
    }

    func calculateRecovery(for muscle: MuscleGroup, at date: Date = .now) -> Double {
        guard let lastTrained = muscle.lastTrainedDate else {
            return 1.0
        }

        let hoursSinceTraining = date.timeIntervalSince(lastTrained) / 3600.0
        let strainScore = muscle.lastStrainScore
        let adjustedTimeConstant = muscle.recoveryTimeConstant * (1.0 + strainScore * 0.5)
        let recovery = 1.0 - strainScore * exp(-hoursSinceTraining / adjustedTimeConstant)

        return max(0.0, min(1.0, recovery))
    }

    func calculateAllRecoveries(at date: Date = .now) -> [String: Double] {
        var results: [String: Double] = [:]
        for muscle in muscleGroups {
            let recovery = calculateRecovery(for: muscle, at: date)
            results[muscle.svgPathId] = recovery
        }
        return results
    }

    func estimateRecoveryTime(for muscle: MuscleGroup, targetRecovery: Double = 0.9) -> TimeInterval {
        let strainScore = muscle.lastStrainScore
        guard strainScore > 0.01 else { return 0 }

        let adjustedTimeConstant = muscle.recoveryTimeConstant * (1.0 + strainScore * 0.5)
        let hoursNeeded = -adjustedTimeConstant * log((1.0 - targetRecovery) / strainScore)

        return max(0, hoursNeeded * 3600)
    }

    func suggestWorkout(at date: Date = .now) -> WorkoutSuggestion {
        let recoveries = calculateAllRecoveries(at: date)

        let recoveredMuscles = recoveries.filter { $0.value >= 0.85 }.map { $0.key }
        let partiallyRecovered = recoveries.filter { $0.value >= 0.6 && $0.value < 0.85 }.map { $0.key }
        let fatigued = recoveries.filter { $0.value < 0.6 }.map { $0.key }

        let suggestion: String
        let intensity: WorkoutIntensity

        if fatigued.count > recoveries.count / 2 {
            suggestion = "Rest day recommended. Most muscle groups are still recovering."
            intensity = .rest
        } else if recoveredMuscles.count >= 3 {
            let muscleNames = recoveredMuscles.prefix(3).joined(separator: ", ")
            suggestion = "Train: \(muscleNames) are fully recovered and ready."
            intensity = .high
        } else {
            suggestion = "Light training OK. Focus on recovered muscle groups."
            intensity = .moderate
        }

        return WorkoutSuggestion(
            suggestion: suggestion,
            intensity: intensity,
            recoveredMuscles: recoveredMuscles,
            partiallyRecovered: partiallyRecovered,
            fatigued: fatigued
        )
    }
}

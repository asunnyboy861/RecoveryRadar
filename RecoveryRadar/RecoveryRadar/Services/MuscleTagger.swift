import Foundation
import HealthKit

actor MuscleTagger {
    private let emgMappings: [EMGMapping]

    init() {
        self.emgMappings = EMGMapping.load()
    }

    func tagWorkout(_ workout: HKWorkout, avgHR: Double?, maxHR: Double?) -> [MuscleStrainInput] {
        let workoutTypeName = String(describing: workout.workoutActivityType)
        let duration = workout.duration
        let energyBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0

        let rpe = calculateAutoRPE(avgHR: avgHR, maxHR: maxHR, duration: duration, energyBurned: energyBurned)

        var matchedMappings = emgMappings.filter { mapping in
            mapping.workoutTypes.contains(where: { workoutTypeName.lowercased().contains($0.lowercased()) })
        }

        if matchedMappings.isEmpty {
            matchedMappings = [EMGMapping(
                exerciseName: "General Workout",
                workoutTypes: [],
                muscleActivation: ["core": 0.30, "shoulders": 0.20, "legs": 0.20]
            )]
        }

        var results: [MuscleStrainInput] = []
        for mapping in matchedMappings {
            for (muscle, activation) in mapping.muscleActivation {
                let strainScore = calculateStrainScore(
                    activation: activation, rpe: rpe,
                    duration: duration, energyBurned: energyBurned
                )
                results.append(MuscleStrainInput(
                    muscleName: muscle, strainScore: strainScore,
                    rpe: rpe, duration: duration,
                    sourceWorkoutType: workoutTypeName
                ))
            }
        }

        return results
    }

    private func calculateAutoRPE(avgHR: Double?, maxHR: Double?,
                                   duration: TimeInterval, energyBurned: Double) -> Int {
        var rpe = 5

        if let avgHR = avgHR, let maxHR = maxHR, maxHR > 0 {
            let hrRatio = avgHR / maxHR
            if hrRatio > 0.85 { rpe = 8 }
            else if hrRatio > 0.75 { rpe = 7 }
            else if hrRatio > 0.65 { rpe = 6 }
            else if hrRatio > 0.55 { rpe = 5 }
            else { rpe = 4 }
        }

        if duration > 3600 { rpe = min(rpe + 1, 10) }
        if energyBurned > 500 { rpe = min(rpe + 1, 10) }

        return max(1, min(10, rpe))
    }

    private func calculateStrainScore(activation: Double, rpe: Int,
                                       duration: TimeInterval, energyBurned: Double) -> Double {
        let rpeMultiplier = Double(rpe) / 10.0
        let durationFactor = min(duration / 3600.0, 2.0)
        let baseStrain = activation * rpeMultiplier * (1.0 + durationFactor * 0.3)
        return min(baseStrain, 1.0)
    }
}

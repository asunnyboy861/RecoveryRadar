import Foundation

nonisolated struct EMGMapping: Codable {
    let exerciseName: String
    let workoutTypes: [String]
    let muscleActivation: [String: Double]

    nonisolated static func load() -> [EMGMapping] {
        guard let url = Bundle.main.url(forResource: "EMGExerciseMapping", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let mappings = try? JSONDecoder().decode(EMGMappingList.self, from: data) else {
            return Self.defaultMappings
        }
        return mappings.mappings
    }

    static let defaultMappings: [EMGMapping] = [
        EMGMapping(exerciseName: "Bench Press", workoutTypes: ["traditionalStrengthTraining", "functionalStrengthTraining"], muscleActivation: ["pectoralisMajor": 0.85, "anteriorDeltoid": 0.65, "tricepsBrachii": 0.75, "serratusAnterior": 0.45]),
        EMGMapping(exerciseName: "Squat", workoutTypes: ["traditionalStrengthTraining"], muscleActivation: ["quadriceps": 0.90, "gluteusMaximus": 0.80, "hamstrings": 0.60, "calves": 0.40, "core": 0.50, "erectorSpinae": 0.55]),
        EMGMapping(exerciseName: "Deadlift", workoutTypes: ["traditionalStrengthTraining"], muscleActivation: ["erectorSpinae": 0.85, "gluteusMaximus": 0.80, "hamstrings": 0.75, "quadriceps": 0.55, "trapezius": 0.60, "core": 0.55, "forearms": 0.50]),
        EMGMapping(exerciseName: "Overhead Press", workoutTypes: ["traditionalStrengthTraining"], muscleActivation: ["anteriorDeltoid": 0.85, "lateralDeltoid": 0.70, "tricepsBrachii": 0.70, "upperTrapezius": 0.45, "serratusAnterior": 0.50]),
        EMGMapping(exerciseName: "Pull-up", workoutTypes: ["traditionalStrengthTraining"], muscleActivation: ["latissimusDorsi": 0.85, "bicepsBrachii": 0.70, "rhomboids": 0.60, "posteriorDeltoid": 0.40, "core": 0.35]),
        EMGMapping(exerciseName: "Rowing", workoutTypes: ["rowing"], muscleActivation: ["latissimusDorsi": 0.80, "rhomboids": 0.70, "bicepsBrachii": 0.65, "posteriorDeltoid": 0.55, "trapezius": 0.50]),
        EMGMapping(exerciseName: "Running", workoutTypes: ["running"], muscleActivation: ["quadriceps": 0.70, "hamstrings": 0.65, "gluteusMaximus": 0.60, "calves": 0.75, "core": 0.35]),
        EMGMapping(exerciseName: "Cycling", workoutTypes: ["cycling"], muscleActivation: ["quadriceps": 0.85, "hamstrings": 0.60, "gluteusMaximus": 0.55, "calves": 0.50]),
        EMGMapping(exerciseName: "Swimming", workoutTypes: ["swimming"], muscleActivation: ["latissimusDorsi": 0.75, "pectoralisMajor": 0.65, "anteriorDeltoid": 0.60, "posteriorDeltoid": 0.55, "core": 0.55, "quadriceps": 0.40]),
        EMGMapping(exerciseName: "Yoga", workoutTypes: ["yoga"], muscleActivation: ["core": 0.55, "gluteusMaximus": 0.40, "quadriceps": 0.40, "shoulders": 0.35, "hamstrings": 0.40]),
        EMGMapping(exerciseName: "HIIT", workoutTypes: ["highIntensityIntervalTraining"], muscleActivation: ["quadriceps": 0.75, "hamstrings": 0.65, "gluteusMaximus": 0.60, "calves": 0.55, "core": 0.50, "shoulders": 0.40]),
        EMGMapping(exerciseName: "Elliptical", workoutTypes: ["elliptical"], muscleActivation: ["quadriceps": 0.70, "hamstrings": 0.55, "gluteusMaximus": 0.50, "calves": 0.45, "core": 0.30]),
        EMGMapping(exerciseName: "Stair Climbing", workoutTypes: ["stairClimbing"], muscleActivation: ["quadriceps": 0.85, "gluteusMaximus": 0.70, "calves": 0.65, "hamstrings": 0.50]),
        EMGMapping(exerciseName: "Dance", workoutTypes: ["dance"], muscleActivation: ["core": 0.55, "quadriceps": 0.50, "calves": 0.50, "gluteusMaximus": 0.45, "shoulders": 0.35]),
        EMGMapping(exerciseName: "Kickboxing", workoutTypes: ["kickboxing"], muscleActivation: ["quadriceps": 0.70, "core": 0.65, "shoulders": 0.60, "calves": 0.55, "gluteusMaximus": 0.50])
    ]
}

nonisolated struct EMGMappingList: Codable {
    let mappings: [EMGMapping]
}

nonisolated struct MuscleStrainInput {
    let muscleName: String
    let strainScore: Double
    let rpe: Int
    let duration: TimeInterval
    let sourceWorkoutType: String
}

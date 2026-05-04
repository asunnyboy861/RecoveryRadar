import Foundation
import Observation
import SwiftData
import HealthKit

@Observable
@MainActor
final class DashboardViewModel {
    var overallRecovery: Double = 0
    var muscleRecoveries: [MuscleGroup] = []
    var todaySuggestion: WorkoutSuggestion?
    var isLoading = true
    var lastSyncDate: Date?

    private let healthKitService = HealthKitService.shared
    private var recoveryEngine: RecoveryEngine?

    func loadMuscles(modelContext: ModelContext) async {
        let descriptor = FetchDescriptor<MuscleGroup>(sortBy: [SortDescriptor(\.name)])
        do {
            muscleRecoveries = try modelContext.fetch(descriptor)
            if muscleRecoveries.isEmpty {
                seedDefaultMuscles(modelContext: modelContext)
                muscleRecoveries = try modelContext.fetch(descriptor)
            }
            recoveryEngine = RecoveryEngine(muscleGroups: muscleRecoveries)
            await refreshRecoveries()
        } catch {
            print("Failed to load muscles: \(error)")
        }
    }

    func refreshRecoveries() async {
        guard let engine = recoveryEngine else { return }
        let recoveries = await engine.calculateAllRecoveries()

        var totalRecovery: Double = 0
        var count: Double = 0

        for muscle in muscleRecoveries {
            if let recovery = recoveries[muscle.svgPathId] {
                muscle.currentRecovery = recovery
                totalRecovery += recovery
                count += 1
            }
        }

        overallRecovery = count > 0 ? totalRecovery / count : 1.0
        todaySuggestion = await engine.suggestWorkout()
        isLoading = false
        lastSyncDate = Date.now
    }

    func syncWorkouts(modelContext: ModelContext) async {
        do {
            let isAuth = try await healthKitService.requestAuthorization()
            guard isAuth else { return }

            let lastSync = lastSyncDate ?? Calendar.current.date(byAdding: .day, value: -30, to: .now)!
            let workouts = try await healthKitService.fetchWorkouts(since: lastSync)

            let tagger = MuscleTagger()
            for workout in workouts {
                let avgHR = try? await healthKitService.fetchAverageHeartRate(for: workout)
                let strainInputs = await tagger.tagWorkout(workout, avgHR: avgHR, maxHR: nil)

                let session = WorkoutSession(
                    startDate: workout.startDate,
                    endDate: workout.endDate,
                    workoutType: String(describing: workout.workoutActivityType),
                    source: workout.sourceRevision.source.name,
                    duration: workout.duration
                )
                session.averageHeartRate = avgHR
                session.totalEnergyBurned = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie())

                for input in strainInputs {
                    if let muscle = muscleRecoveries.first(where: { $0.name.lowercased() == input.muscleName.lowercased() || $0.svgPathId.lowercased() == input.muscleName.lowercased() }) {
                        let strain = MuscleStrain(
                            muscleGroup: muscle,
                            date: workout.startDate,
                            strainScore: input.strainScore,
                            sourceWorkoutType: input.sourceWorkoutType,
                            rpe: input.rpe,
                            duration: input.duration,
                            volumeLoad: 0
                        )
                        muscle.strainHistory.append(strain)
                        muscle.lastTrainedDate = workout.startDate
                        muscle.lastStrainScore = input.strainScore
                        session.muscleStrains.append(strain)
                    }
                }

                session.isProcessed = true
                modelContext.insert(session)
            }

            try modelContext.save()
            await refreshRecoveries()
        } catch {
            print("Failed to sync workouts: \(error)")
        }
    }

    private func seedDefaultMuscles(modelContext: ModelContext) {
        let defaultMuscles: [(String, BodyRegion, String, Double)] = [
            ("Pectoralis Major", .chest, "pectoralisMajor", 48),
            ("Anterior Deltoid", .shoulders, "anteriorDeltoid", 48),
            ("Lateral Deltoid", .shoulders, "lateralDeltoid", 48),
            ("Posterior Deltoid", .shoulders, "posteriorDeltoid", 48),
            ("Biceps Brachii", .arms, "bicepsBrachii", 36),
            ("Triceps Brachii", .arms, "tricepsBrachii", 36),
            ("Forearms", .arms, "forearms", 24),
            ("Latissimus Dorsi", .back, "latissimusDorsi", 60),
            ("Upper Trapezius", .back, "upperTrapezius", 48),
            ("Erector Spinae", .back, "erectorSpinae", 72),
            ("Rhomboids", .back, "rhomboids", 48),
            ("Core", .core, "core", 36),
            ("Quadriceps", .legs, "quadriceps", 72),
            ("Hamstrings", .legs, "hamstrings", 72),
            ("Gluteus Maximus", .glutes, "gluteusMaximus", 60),
            ("Calves", .calves, "calves", 48)
        ]

        for (name, region, svgId, timeConstant) in defaultMuscles {
            let muscle = MuscleGroup(name: name, bodyRegion: region, svgPathId: svgId, recoveryTimeConstant: timeConstant)
            modelContext.insert(muscle)
        }

        try? modelContext.save()
    }
}

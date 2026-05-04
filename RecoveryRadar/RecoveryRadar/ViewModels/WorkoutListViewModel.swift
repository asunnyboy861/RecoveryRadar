import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class WorkoutListViewModel {
    var workouts: [WorkoutSession] = []
    var isLoading = true

    func loadWorkouts(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<WorkoutSession>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        do {
            workouts = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load workouts: \(error)")
        }
        isLoading = false
    }

    func workoutTypeDisplayName(_ type: String) -> String {
        let mapping: [String: String] = [
            "traditionalStrengthTraining": "Strength Training",
            "functionalStrengthTraining": "Functional Training",
            "running": "Running",
            "cycling": "Cycling",
            "swimming": "Swimming",
            "rowing": "Rowing",
            "yoga": "Yoga",
            "highIntensityIntervalTraining": "HIIT",
            "elliptical": "Elliptical",
            "stairClimbing": "Stair Climbing",
            "dance": "Dance",
            "kickboxing": "Kickboxing"
        ]
        return mapping[type] ?? type
    }
}

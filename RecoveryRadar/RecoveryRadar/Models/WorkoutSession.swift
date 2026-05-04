import Foundation
import SwiftData

@Model
final class WorkoutSession {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var endDate: Date
    var workoutType: String
    var source: String
    var averageHeartRate: Double?
    var maxHeartRate: Double?
    var duration: TimeInterval
    var totalEnergyBurned: Double?
    var rpe: Int
    var isProcessed: Bool

    @Relationship(deleteRule: .cascade)
    var muscleStrains: [MuscleStrain]

    init(startDate: Date, endDate: Date, workoutType: String,
         source: String, duration: TimeInterval, rpe: Int = 0) {
        self.id = UUID()
        self.startDate = startDate
        self.endDate = endDate
        self.workoutType = workoutType
        self.source = source
        self.duration = duration
        self.rpe = rpe
        self.isProcessed = false
        self.muscleStrains = []
    }
}

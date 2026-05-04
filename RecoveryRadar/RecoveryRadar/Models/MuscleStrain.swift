import Foundation
import SwiftData

@Model
final class MuscleStrain {
    @Attribute(.unique) var id: UUID
    var muscleGroup: MuscleGroup?
    var date: Date
    var strainScore: Double
    var sourceWorkoutType: String
    var rpe: Int
    var duration: TimeInterval
    var volumeLoad: Double

    init(muscleGroup: MuscleGroup? = nil, date: Date = .now,
         strainScore: Double, sourceWorkoutType: String,
         rpe: Int, duration: TimeInterval, volumeLoad: Double) {
        self.id = UUID()
        self.muscleGroup = muscleGroup
        self.date = date
        self.strainScore = strainScore
        self.sourceWorkoutType = sourceWorkoutType
        self.rpe = rpe
        self.duration = duration
        self.volumeLoad = volumeLoad
    }
}

import Foundation
import SwiftData

enum BodyRegion: String, Codable, CaseIterable {
    case chest, back, shoulders, arms, core, legs, glutes, calves
}

@Model
final class MuscleGroup {
    @Attribute(.unique) var id: UUID
    var name: String
    var bodyRegion: BodyRegion
    var currentRecovery: Double
    var lastTrainedDate: Date?
    var lastStrainScore: Double
    var recoveryTimeConstant: Double
    var svgPathId: String

    @Relationship(deleteRule: .cascade, inverse: \MuscleStrain.muscleGroup)
    var strainHistory: [MuscleStrain]

    init(name: String, bodyRegion: BodyRegion, svgPathId: String,
         recoveryTimeConstant: Double = 48.0) {
        self.id = UUID()
        self.name = name
        self.bodyRegion = bodyRegion
        self.currentRecovery = 1.0
        self.lastTrainedDate = nil
        self.lastStrainScore = 0
        self.recoveryTimeConstant = recoveryTimeConstant
        self.svgPathId = svgPathId
        self.strainHistory = []
    }
}

import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class RecoveryMapViewModel {
    var selectedMuscle: MuscleGroup?
    var showDetailSheet = false
    var isShowingBack = false

    var frontMuscles: [MuscleGroup] = []
    var backMuscles: [MuscleGroup] = []

    func loadMuscles(_ muscles: [MuscleGroup]) {
        let frontRegions: Set<BodyRegion> = [.chest, .shoulders, .arms, .core]
        frontMuscles = muscles.filter { frontRegions.contains($0.bodyRegion) }
        backMuscles = muscles.filter { !frontRegions.contains($0.bodyRegion) }
    }

    func selectMuscle(_ muscle: MuscleGroup) {
        selectedMuscle = muscle
        showDetailSheet = true
    }

    func recoveryColor(for recovery: Double) -> String {
        if recovery >= 0.85 { return "green" }
        else if recovery >= 0.6 { return "orange" }
        else { return "red" }
    }
}

import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class SettingsViewModel {
    var isHealthKitAuthorized = false
    var isProUser = false
    var appVersion = ""

    func loadSettings() {
        isHealthKitAuthorized = HKHealthStore.isHealthDataAvailable()
        isProUser = StoreManager.shared.isProUser

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            appVersion = "v\(version) (\(build))"
        }
    }
}

import HealthKit

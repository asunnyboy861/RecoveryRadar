import HealthKit

actor HealthKitService {
    static let shared = HealthKitService()

    private let healthStore = HKHealthStore()

    private let workoutType = HKObjectType.workoutType()
    private let heartRateType = HKQuantityType(.heartRate)
    private let hrvType = HKQuantityType(.heartRateVariabilitySDNN)
    private let restingHRType = HKQuantityType(.restingHeartRate)

    var isAuthorized: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization() async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else { return false }

        let typesToRead: Set<HKObjectType> = [
            workoutType,
            heartRateType,
            hrvType,
            restingHRType,
            HKQuantityType(.stepCount),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.basalEnergyBurned),
            HKQuantityType(.appleExerciseTime)
        ]

        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }

    func fetchWorkouts(since date: Date) async throws -> [HKWorkout] {
        let predicate = HKQuery.predicateForSamples(withStart: date, end: nil, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (samples as? [HKWorkout]) ?? [])
                }
            }
            healthStore.execute(query)
        }
    }

    func fetchAverageHeartRate(for workout: HKWorkout) async throws -> Double? {
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
        let hrPredicate = HKQuery.predicateForObjects(from: workout)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, hrPredicate])

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: heartRateType,
                quantitySamplePredicate: compoundPredicate,
                options: .discreteAverage
            ) { _, statistics, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    let avgHR = statistics?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                    continuation.resume(returning: avgHR)
                }
            }
            healthStore.execute(query)
        }
    }

    func fetchHRV(since date: Date) async throws -> [HKQuantitySample] {
        let predicate = HKQuery.predicateForSamples(withStart: date, end: nil, options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: hrvType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (samples as? [HKQuantitySample]) ?? [])
                }
            }
            healthStore.execute(query)
        }
    }

    func startWorkoutObserver() async {
        let query = HKObserverQuery(sampleType: workoutType, predicate: nil) { _, completionHandler, error in
            if error == nil {
                NotificationCenter.default.post(name: .newWorkoutDetected, object: nil)
            }
            completionHandler()
        }
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: workoutType, frequency: .immediate) { _, _ in }
    }
}

extension Notification.Name {
    static let newWorkoutDetected = Notification.Name("newWorkoutDetected")
}

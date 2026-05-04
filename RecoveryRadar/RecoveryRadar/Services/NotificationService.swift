import Foundation
import UserNotifications

actor NotificationService {
    static let shared = NotificationService()

    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("Notification authorization failed: \(error)")
            return false
        }
    }

    func scheduleRecoveryReminder(for muscleName: String, at date: Date) async {
        let content = UNMutableNotificationContent()
        content.title = "RecoveryRadar"
        content.body = "\(muscleName) has recovered! Ready to train again."
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "recovery_\(muscleName)_\(date.timeIntervalSince1970)", content: content, trigger: trigger)

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

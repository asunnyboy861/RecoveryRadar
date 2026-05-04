import SwiftUI
import SwiftData

@main
struct RecoveryRadarApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [MuscleGroup.self, MuscleStrain.self, WorkoutSession.self])
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @Query(sort: \MuscleGroup.name) private var muscles: [MuscleGroup]

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "gauge.with.dots.needle.67percent")
                }
                .tag(0)
            BodyHeatMapView(muscles: muscles)
                .tabItem {
                    Label("Recovery Map", systemImage: "figure.arms.open")
                }
                .tag(1)
            WorkoutListView()
                .tabItem {
                    Label("Workouts", systemImage: "dumbbell")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(3)
        }
    }
}

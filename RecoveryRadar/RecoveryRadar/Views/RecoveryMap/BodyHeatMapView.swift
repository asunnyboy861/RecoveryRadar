import SwiftUI

struct BodyHeatMapView: View {
    let muscles: [MuscleGroup]
    @State private var viewModel = RecoveryMapViewModel()
    @State private var rotation: Double = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    viewToggle
                    bodyMap
                    recoveryLegend
                }
                .padding()
            }
            .navigationTitle("Recovery Map")
            .onAppear {
                viewModel.loadMuscles(muscles)
            }
            .sheet(isPresented: $viewModel.showDetailSheet) {
                if let muscle = viewModel.selectedMuscle {
                    MuscleDetailSheet(muscle: muscle)
                }
            }
        }
    }

    private var viewToggle: some View {
        Picker("View", selection: $viewModel.isShowingBack) {
            Text("Front").tag(false)
            Text("Back").tag(true)
        }
        .pickerStyle(.segmented)
    }

    private var bodyMap: some View {
        VStack(spacing: 0) {
            ZStack {
                bodyOutline
                muscleOverlays
            }
            .frame(maxWidth: 300, maxHeight: 500)
            .rotation3DEffect(.degrees(viewModel.isShowingBack ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .animation(.easeInOut(duration: 0.5), value: viewModel.isShowingBack)
        }
    }

    private var bodyOutline: some View {
        VStack(spacing: 0) {
            headShape
            torsoShape
            armsShape
            legsShape
        }
    }

    private var headShape: some View {
        Circle()
            .fill(Color(.systemGray5))
            .frame(width: 60, height: 60)
            .overlay(Circle().stroke(Color(.systemGray3), lineWidth: 1))
    }

    private var torsoShape: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
            .frame(width: 120, height: 140)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray3), lineWidth: 1))
    }

    private var armsShape: some View {
        HStack(spacing: 80) {
            armShape
            Spacer()
            armShape
        }
        .frame(width: 200, height: 140)
    }

    private var armShape: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(.systemGray6))
            .frame(width: 35, height: 140)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray3), lineWidth: 1))
    }

    private var legsShape: some View {
        HStack(spacing: 16) {
            legShape
            legShape
        }
    }

    private var legShape: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(.systemGray6))
            .frame(width: 45, height: 160)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray3), lineWidth: 1))
    }

    @ViewBuilder
    private var muscleOverlays: some View {
        let displayMuscles = viewModel.isShowingBack ? viewModel.backMuscles : viewModel.frontMuscles

        GeometryReader { geo in
            ForEach(displayMuscles, id: \.id) { muscle in
                muscleOverlay(for: muscle, in: geo)
                    .onTapGesture {
                        viewModel.selectMuscle(muscle)
                    }
                    .accessibilityLabel("\(muscle.name): \(Int(muscle.currentRecovery * 100))% recovered")
                    .accessibilityAddTraits(.isButton)
            }
        }
    }

    @ViewBuilder
    private func muscleOverlay(for muscle: MuscleGroup, in geo: GeometryProxy) -> some View {
        let color = recoveryColor(muscle.currentRecovery)
        let position = musclePosition(muscle, in: geo.size)

        RoundedRectangle(cornerRadius: 6)
            .fill(color.opacity(0.6))
            .frame(width: position.width, height: position.height)
            .position(x: position.x, y: position.y)
            .animation(.easeInOut(duration: 0.5), value: muscle.currentRecovery)
    }

    private func musclePosition(_ muscle: MuscleGroup, in size: CGSize) -> (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let isBack = viewModel.isShowingBack
        let w = size.width
        let h = size.height

        switch muscle.svgPathId {
        case "pectoralisMajor":
            return (w * 0.5, h * 0.25, w * 0.35, h * 0.08)
        case "anteriorDeltoid":
            return (w * 0.3, h * 0.2, w * 0.12, h * 0.06)
        case "lateralDeltoid":
            return (w * 0.72, h * 0.2, w * 0.12, h * 0.06)
        case "posteriorDeltoid":
            return (isBack ? w * 0.3 : w * 0.72, h * 0.2, w * 0.12, h * 0.06)
        case "bicepsBrachii":
            return (w * 0.2, h * 0.35, w * 0.1, h * 0.08)
        case "tricepsBrachii":
            return (w * 0.8, h * 0.35, w * 0.1, h * 0.08)
        case "forearms":
            return (w * 0.18, h * 0.48, w * 0.08, h * 0.08)
        case "latissimusDorsi":
            return (w * 0.5, h * 0.28, w * 0.3, h * 0.1)
        case "upperTrapezius":
            return (w * 0.5, h * 0.16, w * 0.25, h * 0.05)
        case "erectorSpinae":
            return (w * 0.5, h * 0.35, w * 0.15, h * 0.12)
        case "rhomboids":
            return (w * 0.5, h * 0.22, w * 0.2, h * 0.06)
        case "core":
            return (w * 0.5, h * 0.38, w * 0.25, h * 0.08)
        case "quadriceps":
            return (w * 0.38, h * 0.62, w * 0.18, h * 0.12)
        case "hamstrings":
            return (w * 0.62, h * 0.62, w * 0.18, h * 0.12)
        case "gluteusMaximus":
            return (w * 0.5, h * 0.55, w * 0.3, h * 0.08)
        case "calves":
            return (w * 0.5, h * 0.78, w * 0.2, h * 0.08)
        default:
            return (w * 0.5, h * 0.5, w * 0.1, h * 0.05)
        }
    }

    private func recoveryColor(_ value: Double) -> Color {
        if value >= 0.85 { return .green }
        else if value >= 0.6 { return .orange }
        else { return .red }
    }

    private var recoveryLegend: some View {
        RecoveryLegend()
    }
}

import SwiftUI

struct FormCheckView: View {
    @State private var selectedExercise = "Squat"
    private let exercises = ["Squat", "Push-up", "Deadlift", "Lunge", "Plank"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                exercisePicker
                cameraPlaceholder
                instructionCard
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Form Check")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Exercise Picker

    private var exercisePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(exercises, id: \.self) { exercise in
                    Button {
                        selectedExercise = exercise
                    } label: {
                        Text(exercise)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedExercise == exercise
                                    ? Color.orange
                                    : Color(.secondarySystemGroupedBackground)
                            )
                            .foregroundStyle(
                                selectedExercise == exercise ? .white : .primary
                            )
                            .clipShape(Capsule())
                            .animation(.easeInOut, value: selectedExercise)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 2)
        }
    }

    // MARK: - Camera Placeholder

    private var cameraPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .aspectRatio(3/4, contentMode: .fit)

            VStack(spacing: 16) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white.opacity(0.4))
                Text("Camera Preview")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.5))
                Text("Vision + Core ML")
                    .font(.caption)
                    .foregroundStyle(.orange.opacity(0.8))
            }

            // Corner guides (form check overlay style)
            FormCornerGuides()
        }
    }

    // MARK: - Instruction Card

    private var instructionCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "figure.stand")
                .font(.title2)
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 4) {
                Text("Position yourself in frame")
                    .font(.subheadline.weight(.semibold))
                Text("ARKO will analyze your \(selectedExercise.lowercased()) form in real-time using on-device AI")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Corner Guide Overlay

private struct FormCornerGuides: View {
    private let size: CGFloat = 24
    private let thickness: CGFloat = 3

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let pad: CGFloat = 20

            ZStack {
                corner(at: CGPoint(x: pad, y: pad), rotation: 0)
                corner(at: CGPoint(x: w - pad, y: pad), rotation: 90)
                corner(at: CGPoint(x: pad, y: h - pad), rotation: 270)
                corner(at: CGPoint(x: w - pad, y: h - pad), rotation: 180)
            }
        }
    }

    private func corner(at point: CGPoint, rotation: Double) -> some View {
        CornerShape()
            .stroke(Color.orange, style: StrokeStyle(lineWidth: thickness, lineCap: .round))
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .position(point)
    }
}

private struct CornerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return p
    }
}

struct FormCheckView_Previews: PreviewProvider {
    static var previews: some View {
        FormCheckView()
    }
}

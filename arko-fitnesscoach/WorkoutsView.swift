import SwiftUI

struct WorkoutsView: View {
    // Mock data — will come from HealthKitAgent + Claude API
    private let recommended = WorkoutItem.mockRecommended
    private let recent = WorkoutItem.mockRecent

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(recommended) { workout in
                        WorkoutRow(workout: workout, isRecommended: true)
                    }
                } header: {
                    SectionHeader(icon: "sparkles", title: "AI Recommended")
                }

                Section {
                    ForEach(recent) { workout in
                        WorkoutRow(workout: workout, isRecommended: false)
                    }
                } header: {
                    SectionHeader(icon: "clock.arrow.circlepath", title: "Recent")
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Workouts")
        }
    }
}

// MARK: - Row

private struct WorkoutRow: View {
    let workout: WorkoutItem
    let isRecommended: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(workout.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: workout.icon)
                    .foregroundStyle(workout.color)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(workout.name)
                        .font(.subheadline.weight(.semibold))
                    if isRecommended {
                        Image(systemName: "sparkles")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                    }
                }
                Text("\(workout.duration) min · \(workout.calories) kcal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(workout.intensity)
                .font(.caption2.weight(.medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(workout.color.opacity(0.12))
                .foregroundStyle(workout.color)
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Section Header

private struct SectionHeader: View {
    let icon: String
    let title: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(nil)
    }
}

// MARK: - Model

struct WorkoutItem: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int
    let calories: Int
    let intensity: String
    let icon: String
    let color: Color

    static let mockRecommended: [WorkoutItem] = [
        WorkoutItem(name: "Brisk Walk", duration: 30, calories: 180, intensity: "Easy", icon: "figure.walk", color: .green),
        WorkoutItem(name: "Core Strength", duration: 20, calories: 140, intensity: "Moderate", icon: "figure.core.training", color: .blue),
    ]

    static let mockRecent: [WorkoutItem] = [
        WorkoutItem(name: "Running", duration: 45, calories: 380, intensity: "Hard", icon: "figure.run", color: .orange),
        WorkoutItem(name: "Yoga", duration: 60, calories: 200, intensity: "Easy", icon: "figure.mind.and.body", color: .purple),
        WorkoutItem(name: "HIIT", duration: 25, calories: 310, intensity: "Hard", icon: "figure.highintensity.intervaltraining", color: .red),
    ]
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}

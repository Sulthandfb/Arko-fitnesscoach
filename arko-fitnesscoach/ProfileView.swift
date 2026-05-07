import SwiftUI

struct ProfileView: View {
    // Mock user data — will come from Firebase Auth + SwiftData
    @State private var calorieGoal: Double = 600
    @State private var fitnessLevel = FitnessLevel.intermediate
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            List {
                userInfoSection
                goalsSection
                settingsSection
                aboutSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
        }
    }

    // MARK: - User Info

    private var userInfoSection: some View {
        Section {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 60, height: 60)
                    Text("A")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Athlete")
                        .font(.headline)
                    Text("ARKO Member")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 6)
        }
    }

    // MARK: - Goals

    private var goalsSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Daily Calorie Goal", systemImage: "flame.fill")
                        .foregroundStyle(.orange)
                    Spacer()
                    Text("\(Int(calorieGoal)) kcal")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.orange)
                }

                Slider(value: $calorieGoal, in: 200...1000, step: 50)
                    .tint(.orange)

                HStack {
                    Text("200")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("1000")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)

            Picker("Fitness Level", selection: $fitnessLevel) {
                ForEach(FitnessLevel.allCases) { level in
                    Text(level.label).tag(level)
                }
            }
        } header: {
            Label("Goals", systemImage: "target")
                .textCase(nil)
        }
    }

    // MARK: - Settings

    private var settingsSection: some View {
        Section {
            Toggle(isOn: $notificationsEnabled) {
                Label("Workout Reminders", systemImage: "bell.fill")
            }
            .tint(.orange)

            NavigationLink {
                Text("HealthKit settings — coming soon")
            } label: {
                Label("Apple Health", systemImage: "heart.fill")
                    .foregroundStyle(.red)
            }

            NavigationLink {
                Text("AI preferences — coming soon")
            } label: {
                Label("AI Coach Settings", systemImage: "sparkles")
                    .foregroundStyle(.orange)
            }
        } header: {
            Label("Settings", systemImage: "gearshape")
                .textCase(nil)
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("AI Model")
                Spacer()
                Text("Claude (claude-sonnet-4-6)")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        } header: {
            Label("About ARKO", systemImage: "info.circle")
                .textCase(nil)
        } footer: {
            Text("ARKO uses on-device AI for form analysis. Workout recommendations are powered by Claude. Always consult a professional before starting a new fitness routine.")
                .font(.caption2)
        }
    }
}

// MARK: - Model

enum FitnessLevel: String, CaseIterable, Identifiable {
    case beginner, intermediate, advanced
    var id: String { rawValue }
    var label: String { rawValue.capitalized }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

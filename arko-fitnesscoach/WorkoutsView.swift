import SwiftUI

// MARK: - WorkoutsView

struct WorkoutsView: View {
    @State private var selectedDay = Calendar.current.component(.weekday, from: Date()) - 1

    private let recommended = WorkoutItem.mockRecommended
    private let recent = WorkoutItem.mockRecent

    var body: some View {
        ZStack {
            Color.arkoBg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    topBar
                    calendarCard
                    quickStatsRow
                    todayExercisesSection
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Training")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Workouts")
                    .font(.title2.weight(.bold))
            }
            Spacer()
            Button {
            } label: {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.arkoTeal)
                    .frame(width: 40, height: 40)
                    .background(Color.arkoCard)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
            }
        }
    }

    // MARK: - Calendar Card

    private var calendarCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Training Days")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                HStack(spacing: 4) {
                    Button { } label: {
                        Image(systemName: "chevron.left")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    Text(monthLabel)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                    Button { } label: {
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            HStack(spacing: 0) {
                ForEach(weekDays.indices, id: \.self) { i in
                    let day = weekDays[i]
                    VStack(spacing: 6) {
                        Text(day.shortName)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.secondary)

                        ZStack {
                            Circle()
                                .fill(i == selectedDay
                                    ? Color.arkoTeal
                                    : (day.hasWorkout ? Color.arkoTeal.opacity(0.12) : Color.clear))
                                .frame(width: 36, height: 36)

                            if day.hasWorkout && i != selectedDay {
                                Image(systemName: "figure.run")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.arkoTeal)
                            } else {
                                Text("\(day.number)")
                                    .font(.system(size: 13, weight: i == selectedDay ? .bold : .medium))
                                    .foregroundStyle(i == selectedDay ? .white : .primary)
                            }
                        }
                        .onTapGesture { withAnimation { selectedDay = i } }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .arkoCard()
    }

    // MARK: - Quick Stats Row

    private var quickStatsRow: some View {
        HStack(spacing: 12) {
            QuickStatCard(icon: "shoeprints.fill", value: "6,430", label: "Steps", unit: "/ 10,000", color: Color.arkoTeal)
            QuickStatCard(icon: "flame.fill", value: "609", label: "Calories", unit: "kcal", color: .orange)
            QuickStatCard(icon: "star.fill", value: "202", label: "Points", unit: "pts", color: .yellow)
        }
    }

    // MARK: - Today Exercises

    private var todayExercisesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today Exercises")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("Today")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Color.arkoTeal)
            }

            ForEach(recommended) { workout in
                WorkoutCard(workout: workout, isRecommended: true)
            }

            Text("Recent")
                .font(.subheadline.weight(.semibold))
                .padding(.top, 4)

            ForEach(recent) { workout in
                WorkoutCard(workout: workout, isRecommended: false)
            }
        }
    }

    // MARK: - Helpers

    private var monthLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: Date())
    }

    private var weekDays: [WeekDay] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let doneIndices: Set<Int> = [1, 3, 5]

        return (0..<7).map { i in
            let date = calendar.date(byAdding: .day, value: i, to: startOfWeek)!
            let day = calendar.component(.day, from: date)
            let name = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"][i]
            return WeekDay(number: day, shortName: name, hasWorkout: doneIndices.contains(i))
        }
    }
}

// MARK: - Subviews

private struct WeekDay {
    let number: Int
    let shortName: String
    let hasWorkout: Bool
}

private struct QuickStatCard: View {
    let icon: String
    let value: String
    let label: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .arkoCard(padding: 14)
    }
}

private struct WorkoutCard: View {
    let workout: WorkoutItem
    let isRecommended: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(workout.color.opacity(0.12))
                    .frame(width: 50, height: 50)
                Image(systemName: workout.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(workout.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(workout.name)
                        .font(.subheadline.weight(.semibold))
                    if isRecommended {
                        Image(systemName: "sparkles")
                            .font(.caption2)
                            .foregroundStyle(Color.arkoTeal)
                    }
                }
                Text("\(workout.duration) min")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(Color.arkoGreen.opacity(0.3), lineWidth: 2)
                    .frame(width: 30, height: 30)
                Image(systemName: "checkmark")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.arkoGreen)
            }
        }
        .arkoCard(padding: 14)
    }
}

struct WorkoutItem: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int
    let calories: Int
    let intensity: String
    let icon: String
    let color: Color

    static let mockRecommended: [WorkoutItem] = [
        WorkoutItem(name: "Morning Stretching", duration: 15, calories: 80,
                    intensity: "Easy", icon: "figure.flexibility", color: Color.arkoTeal),
        WorkoutItem(name: "Morning Stretch Flow", duration: 20, calories: 110,
                    intensity: "Easy", icon: "figure.mind.and.body", color: .purple),
    ]

    static let mockRecent: [WorkoutItem] = [
        WorkoutItem(name: "Running", duration: 45, calories: 380,
                    intensity: "Hard", icon: "figure.run", color: .orange),
        WorkoutItem(name: "Core Strength", duration: 25, calories: 200,
                    intensity: "Moderate", icon: "figure.core.training", color: .blue),
    ]
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}

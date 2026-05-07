import SwiftUI

struct HomeView: View {
    // Mock data — will be replaced with HealthKit + Claude API
    private let activeEnergy: Double = 342
    private let calorieGoal: Double = 600
    private let steps: Int = 6_240
    private let streakDays: Int = 4
    private let insightText = "You're 57% toward your calorie goal. A 30-min brisk walk will get you there — perfect after lunch."

    private var progress: Double { min(activeEnergy / calorieGoal, 1.0) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    greetingHeader
                    calorieRingCard
                    aiInsightCard
                    quickStatsRow
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("ARKO")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Greeting

    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(greetingText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Let's crush today 💪")
                    .font(.headline)
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 44, height: 44)
                Text("\(streakDays)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.orange)
            }
            .overlay(alignment: .bottom) {
                Text("🔥")
                    .font(.system(size: 10))
                    .offset(y: 6)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Calorie Ring

    private var calorieRingCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.orange.opacity(0.15), lineWidth: 18)
                    .frame(width: 160, height: 160)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)

                VStack(spacing: 2) {
                    Text("\(Int(activeEnergy))")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.orange)
                    Text("/ \(Int(calorieGoal)) kcal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text("Active Energy Today")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    // MARK: - AI Insight Card

    private var aiInsightCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(.orange)
                Text("ARKO Insight")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("AI")
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.orange.opacity(0.15))
                    .foregroundStyle(.orange)
                    .clipShape(Capsule())
            }
            Text(insightText)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Quick Stats

    private var quickStatsRow: some View {
        HStack(spacing: 12) {
            StatCard(icon: "shoeprints.fill", value: "\(steps.formatted())", label: "Steps", color: .blue)
            StatCard(icon: "flame.fill", value: "\(streakDays)d", label: "Streak", color: .orange)
            StatCard(icon: "bolt.fill", value: "\(Int(progress * 100))%", label: "Goal", color: .green)
        }
    }

    // MARK: - Helpers

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
}

// MARK: - Subviews

private struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

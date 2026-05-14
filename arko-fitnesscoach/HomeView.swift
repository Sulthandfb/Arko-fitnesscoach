import SwiftUI

// MARK: - A2A Protocol Models
// Format: Google Agent-to-Agent (A2A) spec — jsonrpc 2.0

struct A2AResponse: Decodable {
    let jsonrpc: String
    let id: String
    let result: A2AResult
}

struct A2AResult: Decodable {
    let id: String
    let sessionId: String
    let status: A2AStatus
    let artifacts: [A2AArtifact]
}

struct A2AStatus: Decodable {
    let state: String
    let timestamp: String
}

struct A2AArtifact: Decodable {
    let name: String
    let description: String
    let parts: [A2APart]
}

struct A2APart: Decodable {
    let type: String
    let data: A2ACalorieData?
    let text: String?
}

struct A2ACalorieData: Decodable {
    let date: String
    let activeEnergyKcal: Double
    let calorieGoalKcal: Int
    let steps: Int
    let restingHrBpm: Int
    let sleepHours: Double
    let streakDays: Int
    let progressPct: Double

    enum CodingKeys: String, CodingKey {
        case date
        case activeEnergyKcal  = "active_energy_kcal"
        case calorieGoalKcal   = "calorie_goal_kcal"
        case steps
        case restingHrBpm      = "resting_hr_bpm"
        case sleepHours        = "sleep_hours"
        case streakDays        = "streak_days"
        case progressPct       = "progress_pct"
    }
}

// MARK: - A2A Service

final class A2AHealthService {
    static let shared = A2AHealthService()
    private init() {}

    private let baseURL = "http://localhost:8000"

    /// Fetch mock A2A response from AppleHealthAgent (no body needed)
    func fetchMockA2A() async throws -> A2AResponse {
        guard let url = URL(string: baseURL + "/a2a/apple-health-task/mock") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(A2AResponse.self, from: data)
    }

    /// Extract CalorieData from the first data part of the first artifact
    func extractCalorieData(from response: A2AResponse) -> A2ACalorieData? {
        response.result.artifacts.first?
            .parts.first(where: { $0.type == "data" })?
            .data
    }

    /// Extract insight text from the first text part of the first artifact
    func extractInsight(from response: A2AResponse) -> String? {
        response.result.artifacts.first?
            .parts.first(where: { $0.type == "text" })?
            .text
    }
}

// MARK: - HomeView

struct HomeView: View {
    @StateObject private var healthKit = HealthKitManager()
    @State private var profile = UserProfile.load()

    // A2A data from AppleHealthAgent
    @State private var a2aCalories: A2ACalorieData? = nil
    @State private var a2aInsight: String = "Loading ARKO insight..."
    @State private var isLoadingA2A = false

    private var progress: Double {
        if let a2a = a2aCalories {
            return min(a2a.progressPct / 100.0, 1.0)
        }
        guard profile.calorieGoal > 0 else { return 0 }
        return min(healthKit.activeEnergy / Double(profile.calorieGoal), 1.0)
    }

    private var displayEnergy: Int {
        a2aCalories.map { Int($0.activeEnergyKcal) } ?? Int(healthKit.activeEnergy)
    }

    private var displayGoal: Int {
        a2aCalories?.calorieGoalKcal ?? profile.calorieGoal
    }

    private var displaySteps: Int {
        a2aCalories?.steps ?? healthKit.steps
    }

    private var displayStreak: Int {
        a2aCalories?.streakDays ?? 4
    }

    var body: some View {
        ZStack {
            Color.arkoBg.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    topBar
                    sectionHeader
                    mainDashboardCard
                    HStack(spacing: 12) { streakCard; heartRateCard }
                    aiInsightCard
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .task {
            await healthKit.requestAuthorization()
            await fetchA2AData()
        }
        .refreshable {
            await healthKit.fetchAll()
            await fetchA2AData()
        }
    }

    // MARK: - Fetch A2A from AppleHealthAgent

    private func fetchA2AData() async {
        isLoadingA2A = true
        do {
            let response = try await A2AHealthService.shared.fetchMockA2A()
            await MainActor.run {
                a2aCalories = A2AHealthService.shared.extractCalorieData(from: response)
                a2aInsight  = A2AHealthService.shared.extractInsight(from: response)
                             ?? "Stay active and keep your streak alive!"
                isLoadingA2A = false
            }
        } catch {
            await MainActor.run {
                a2aInsight = "You're \(Int(progress * 100))% toward your goal. Keep it up!"
                isLoadingA2A = false
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            ZStack {
                Circle().fill(Color.arkoTeal.opacity(0.15)).frame(width: 40, height: 40)
                Image(systemName: "figure.run")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.arkoTeal)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(greetingText).font(.caption).foregroundStyle(.secondary)
                Text("Hello 👋").font(.subheadline.weight(.semibold))
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [Color.arkoTeal, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 40, height: 40)
                Text("A").font(.system(size: 17, weight: .bold)).foregroundStyle(.white)
            }
        }
    }

    // MARK: - Section Header

    private var sectionHeader: some View {
        HStack {
            Text("Dashboard").font(.title2.weight(.bold))
            Spacer()
            Image(systemName: "calendar")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
                .frame(width: 36, height: 36)
                .background(Color.arkoCard)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
        }
    }

    // MARK: - Main Dashboard Card

    private var mainDashboardCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .trim(from: 0.15, to: 0.85)
                    .stroke(Color.gray.opacity(0.1), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(144))
                Circle()
                    .trim(from: 0.15, to: max(0.15, 0.15 + 0.70 * progress))
                    .stroke(
                        LinearGradient(colors: [Color.arkoTeal, .blue.opacity(0.8)], startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(144))
                    .animation(.easeInOut(duration: 1.0), value: progress)
                VStack(spacing: 2) {
                    Text(String(format: "%.1f", progress * 10))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.arkoTeal)
                    Text("/10").font(.caption2.weight(.medium)).foregroundStyle(.secondary)
                }
            }
            .frame(width: 110, height: 110)

            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("Active Energy").font(.caption.weight(.medium)).foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "flame.fill").foregroundStyle(.orange).font(.caption)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(displayEnergy)")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                    Text("/ \(displayGoal) kcal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.arkoGreen).frame(width: 7, height: 7)
                    Text(progressLabel).font(.caption2.weight(.medium)).foregroundStyle(.secondary)
                }
                Divider()
                HStack(spacing: 6) {
                    Image(systemName: "shoeprints.fill").font(.caption).foregroundStyle(Color.arkoTeal)
                    Text("\(displaySteps) steps").font(.caption.weight(.medium))
                }
            }
            Spacer(minLength: 0)
        }
        .arkoCard()
    }

    // MARK: - Streak Card

    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ZStack {
                    Circle().fill(Color.orange.opacity(0.12)).frame(width: 32, height: 32)
                    Text("🔥").font(.system(size: 16))
                }
                Spacer()
                Text("Streak").font(.caption2.weight(.medium)).foregroundStyle(.secondary)
            }
            Text("\(displayStreak)").font(.system(size: 32, weight: .bold, design: .rounded))
            Text("days in a row").font(.caption2).foregroundStyle(.secondary)
        }
        .arkoCard()
        .frame(maxWidth: .infinity)
    }

    // MARK: - Heart Rate Card

    private var heartRateCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ZStack {
                    Circle().fill(Color.red.opacity(0.12)).frame(width: 32, height: 32)
                    Image(systemName: "heart.fill").font(.system(size: 15)).foregroundStyle(.red)
                }
                Spacer()
                HStack(spacing: 3) {
                    Circle().fill(Color.arkoGreen).frame(width: 6, height: 6)
                    Text("Normal").font(.caption2.weight(.medium)).foregroundStyle(Color.arkoGreen)
                }
            }
            Text(healthKit.restingHR > 0 ? "\(healthKit.restingHR)" : "--")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("bpm").font(.caption2).foregroundStyle(.secondary)
            HRWaveView().frame(height: 24)
        }
        .arkoCard()
        .frame(maxWidth: .infinity)
    }

    // MARK: - AI Insight Card

    private var aiInsightCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(colors: [Color.arkoTeal, .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 44, height: 44)
                Image(systemName: "sparkles").font(.system(size: 20, weight: .semibold)).foregroundStyle(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("ARKO Insight").font(.subheadline.weight(.semibold))
                    Spacer()
                    Text("AI")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 7).padding(.vertical, 3)
                        .background(Color.arkoTeal.opacity(0.12))
                        .foregroundStyle(Color.arkoTeal)
                        .clipShape(Capsule())
                }
                if isLoadingA2A {
                    HStack(spacing: 6) {
                        ProgressView().scaleEffect(0.7)
                        Text("Fetching from AppleHealthAgent...")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                } else {
                    Text(a2aInsight)
                        .font(.caption).foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .arkoCard()
    }

    // MARK: - Helpers

    private var greetingText: String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "Good morning" }
        if h < 17 { return "Good afternoon" }
        return "Good evening"
    }

    private var progressLabel: String {
        switch progress {
        case 0..<0.3: return "Just getting started"
        case 0.3..<0.6: return "Good progress"
        case 0.6..<0.9: return "Almost there!"
        default: return "Goal reached 🎉"
        }
    }
}

// MARK: - HR Wave

private struct HRWaveView: View {
    private let points: [CGFloat] = [0.5, 0.2, 0.9, 0.3, 0.7, 0.4, 0.6, 0.3, 0.8, 0.5]
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width / CGFloat(points.count - 1)
            let h = geo.size.height
            Path { path in
                for (i, val) in points.enumerated() {
                    let point = CGPoint(x: CGFloat(i) * w, y: h * (1 - val))
                    if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
                }
            }
            .stroke(Color.red.opacity(0.6), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

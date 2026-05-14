import Foundation

private let baseURL = "http://localhost:8000"

struct HealthInsightRequest: Encodable {
    let active_energy: Double
    let calorie_goal: Int
    let steps: Int
    let resting_hr: Int
    let sleep_hours: Double
    let streak_days: Int
}

struct FormAnalysisRequest: Encodable {
    let exercise: String
    let keypoints: [[String: Double]]
    let user_level: String
}

struct AgentResponse: Decodable {
    let success: Bool
    let data: String
    let agent_used: String
}

final class ARKOAPIService {
    static let shared = ARKOAPIService()
    private init() {}

    func fetchHealthInsight(activeEnergy: Double, calorieGoal: Int, steps: Int,
                            restingHR: Int, sleepHours: Double = 7.5, streakDays: Int) async throws -> String {
        let body = HealthInsightRequest(active_energy: activeEnergy, calorie_goal: calorieGoal,
                                        steps: steps, resting_hr: restingHR,
                                        sleep_hours: sleepHours, streak_days: streakDays)
        let response: AgentResponse = try await post(path: "/health-insights", body: body)
        return response.data
    }

    private func post<B: Encodable, R: Decodable>(path: String, body: B) async throws -> R {
        guard let url = URL(string: baseURL + path) else { throw URLError(.badURL) }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)
        req.timeoutInterval = 60
        let (data, _) = try await URLSession.shared.data(for: req)
        return try JSONDecoder().decode(R.self, from: data)
    }
}

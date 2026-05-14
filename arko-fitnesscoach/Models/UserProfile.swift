import Foundation

struct UserProfile: Codable {
    var name: String = "Athlete"
    var calorieGoal: Int = 600
    var fitnessLevel: String = "beginner"

    private static let key = "arko_user_profile"

    static func load() -> UserProfile {
        guard let data = UserDefaults.standard.data(forKey: key),
              let p = try? JSONDecoder().decode(UserProfile.self, from: data)
        else { return UserProfile() }
        return p
    }

    func save() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        UserDefaults.standard.set(data, forKey: UserProfile.key)
    }
}

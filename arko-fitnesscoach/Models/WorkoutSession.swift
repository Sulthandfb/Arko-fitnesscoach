import Foundation

struct WorkoutSession: Codable, Identifiable {
    let id: UUID
    var name: String
    var durationMinutes: Int
    var caloriesBurned: Int
    var intensity: String
    var date: Date
    var aiRecommended: Bool

    init(name: String, durationMinutes: Int, caloriesBurned: Int,
         intensity: String, date: Date = Date(), aiRecommended: Bool = false) {
        self.id = UUID()
        self.name = name
        self.durationMinutes = durationMinutes
        self.caloriesBurned = caloriesBurned
        self.intensity = intensity
        self.date = date
        self.aiRecommended = aiRecommended
    }
}

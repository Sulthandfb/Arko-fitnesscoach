import SwiftUI

// MARK: - ARKO Design System
// Defined here so it compiles before any View file

extension Color {
    static let arkoBg     = Color(red: 0.92, green: 0.93, blue: 0.96)
    static let arkoCard   = Color.white
    static let arkoTeal   = Color(red: 0.15, green: 0.68, blue: 0.76)
    static let arkoGreen  = Color(red: 0.42, green: 0.78, blue: 0.55)
    static let arkoTabBar = Color(red: 0.10, green: 0.10, blue: 0.13)
}

extension View {
    func arkoCard(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 4)
    }
}

// MARK: - App Entry Point

@main
struct arko_fitnesscoachApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

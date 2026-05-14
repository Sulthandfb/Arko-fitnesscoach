import SwiftUI

struct ContentView: View {
    @State private var selected = 0

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selected) {
                HomeView().tag(0)
                WorkoutsView().tag(1)
                FormCheckView().tag(2)
                ProfileView().tag(3)
            }
            .ignoresSafeArea(edges: .bottom)

            ARKOTabBar(selected: $selected)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Tab Bar

private struct TabItem {
    let icon: String
    let tag: Int
}

private struct ARKOTabBar: View {
    @Binding var selected: Int

    private let items: [TabItem] = [
        TabItem(icon: "house.fill", tag: 0),
        TabItem(icon: "squares.below.rectangle", tag: 1),
        TabItem(icon: "camera.fill", tag: 2),
        TabItem(icon: "person.fill", tag: 3),
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { i in
                let item = items[i]
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selected = item.tag
                    }
                } label: {
                    ZStack {
                        if selected == item.tag {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.18))
                                .frame(width: 48, height: 48)
                        }
                        Image(systemName: item.icon)
                            .font(.system(size: 20, weight: selected == item.tag ? .semibold : .regular))
                            .foregroundStyle(selected == item.tag ? .white : Color.white.opacity(0.45))
                            .frame(width: 48, height: 48)
                    }
                }
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.arkoTabBar)
                .shadow(color: .black.opacity(0.25), radius: 24, y: 8)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

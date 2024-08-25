import SwiftUI

struct MenuView: View {
    let safeAreas = UIApplication.windowSafeAreaInsets

    @State private var isCreditsDisplayed: Bool = false

    var body: some View {
        ZStack {
            MenuBackgroundView()

            VStack(spacing: 50) {
                Text("Simple Memo")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top, safeAreas.top)

                Spacer()

                MenuItemView(action: {}, title: "Classic Mode", subtitle: "The classic card matching game")

                MenuItemView(action: {}, title: "Sound Mode", subtitle: "The classic card matching game")

                MenuItemView(action: {}, title: "Vibration Mode", subtitle: "The classic card matching game")

                Spacer()
            }
            .foregroundStyle(.frost)
            .padding(50)
            .background(BlurView())
            .clipShape(.rect(cornerRadius: 25))

            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    CreditsView(isPresented: $isCreditsDisplayed)
                }
                Spacer()
            }
            .padding(.trailing, UIScreen.main.bounds.size.width / 8)
            .padding(.top, safeAreas.top)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MenuView()
}

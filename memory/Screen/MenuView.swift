import SwiftUI

struct MenuView: View {
    @State private var isCreditsDisplayed: Bool = false
    @State private var isMultiplayer = 0

    var body: some View {
        NavigationStack {
            ZStack {
                MenuBackgroundView()

                VStack(spacing: 50) {
                    Text("Simple Memo")
                        .font(.system(size: 40, weight: .bold))
                        .padding(.top, UIApplication.windowSafeAreaInsets.top)

                    Spacer()

                    MultiplayerPicker(preselectedIndex: $isMultiplayer, options: ["1 Player", "2 Player"])

                    NavigationLink {
                        GameView(deck: Deck(mode: .classic, isMultiplayer: isMultiplayer == 1, numberOfPairs: 12))
                    } label: {
                        MenuItemView(title: "Classic Mode", subtitle: "The classic card matching game")
                    }

                    NavigationLink {
                        GameView(deck: Deck(mode: .sound, isMultiplayer: isMultiplayer == 1, numberOfPairs: 12))
                    } label: {
                        MenuItemView(title: "Sound Mode", subtitle: "Match the sounds, not the images!")
                    }

                    NavigationLink {
                        GameView(deck: Deck(mode: .haptic, isMultiplayer: isMultiplayer == 1, numberOfPairs: 12))
                    } label: {
                        MenuItemView(title: "Vibration Mode", subtitle: "Hardcore mode! Match the vibrations")
                    }

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
                .padding(.top, UIApplication.windowSafeAreaInsets.top)
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MenuView()
        .environmentObject(SoundManager())
}

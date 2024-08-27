import SwiftUI
import CoreHaptics

struct MenuView: View {
    let numberOfPairs = 12
    let hapticCapability = CHHapticEngine.capabilitiesForHardware()

    @State private var isCreditsDisplayed: Bool = false
    @State private var isMultiplayer = 0

    var body: some View {
        NavigationStack {
            ZStack {
                MenuBackgroundView()

                VStack(spacing: 50) {
                    VStack(spacing: 20) {
                        Text("Simple Memo")
                            .font(.system(size: 40, weight: .bold))
                            .padding(.top, UIApplication.windowSafeAreaInsets.top)

                        CreditsView(isPresented: $isCreditsDisplayed)
                    }

                    MultiplayerPicker(preselectedIndex: $isMultiplayer, options: ["1 Player", "2 Player"])

                    NavigationLink {
                        GameView(deck: Deck(
                            mode: .classic,
                            isMultiplayer: isMultiplayer == 1,
                            numberOfPairs: numberOfPairs
                        ))
                    } label: {
                        MenuItemView(title: "Classic Mode", subtitle: "The classic card matching game")
                    }

                    NavigationLink {
                        GameView(deck: Deck(
                            mode: .sound,
                            isMultiplayer: isMultiplayer == 1,
                            numberOfPairs: numberOfPairs
                        ))
                    } label: {
                        MenuItemView(title: "Sound Mode", subtitle: "Match the sounds, not the images!")
                    }

                    NavigationLink {
                        GameView(deck: Deck(
                            mode: .haptic,
                            isMultiplayer: isMultiplayer == 1,
                            numberOfPairs: numberOfPairs
                        ))
                    } label: {
                        MenuItemView(title: "Vibration Mode", subtitle: "Hardcore mode! Match the vibrations")
                    }
                    .opacity(hapticCapability.supportsHaptics ? 1 : 0.5)
                    .disabled(!hapticCapability.supportsHaptics)
                    .overlay {
                        if !hapticCapability.supportsHaptics {
                            Text("Haptics not enabled")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(.midnight.opacity(0.8))
                                )
                        }
                    }

                    Spacer()
                }
                .foregroundStyle(.frost)
                .padding(50)
                .background(BlurView())
                .clipShape(.rect(cornerRadius: 25))
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

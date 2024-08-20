import SwiftUI

struct ContentView: View {
    @EnvironmentObject var soundManager: SoundManager
    @StateObject var deck = Deck(numberOfPairs: 12)

    @State private var isCreditsDisplayed: Bool = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    CreditsView(isPresented: $isCreditsDisplayed)
                }
                Spacer()
            }
            .padding(.trailing, 20)

            VStack {
                MoveCounterView(player: deck.player)

                Spacer()

                CardGridView(deck: deck)
                    .environmentObject(soundManager)

                Spacer()
            }
            .blur(radius: deck.newGameTimer > 0 ? 4 : 0)

            if deck.newGameTimer > 0 {
                NewGameTimerView(deck: deck)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SoundManager())
}

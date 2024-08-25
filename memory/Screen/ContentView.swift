import SwiftUI

struct ContentView: View {
    @EnvironmentObject var soundManager: SoundManager
    @StateObject var deck = Deck(numberOfPairs: 12)

    var body: some View {
        ZStack {
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

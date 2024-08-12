import SwiftUI

struct ContentView: View {
    @EnvironmentObject var soundManager: SoundManager
    @StateObject var deck = Deck(numberOfPairs: 1)

    var body: some View {
        MoveCounterView(player: deck.player)

        Spacer()

        CardGridView(deck: deck)
            .environmentObject(soundManager)

        Spacer()
    }
}

#Preview {
    ContentView()
        .environmentObject(SoundManager())
}

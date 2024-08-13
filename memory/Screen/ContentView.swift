import SwiftUI

// TODO: (Flavian) - Check on iPad how the grid behaves (and other views)
struct ContentView: View {
    @EnvironmentObject var soundManager: SoundManager
    @StateObject var deck = Deck(numberOfPairs: 8)

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

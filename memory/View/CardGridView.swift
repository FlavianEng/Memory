import SwiftUI

struct CardGridView: View {
    @EnvironmentObject var soundManager: SoundManager
    @ObservedObject var deck: Deck

    var cardSize: CGFloat {
        return (UIScreen.main.bounds.size.width / 5) - 20
    }

    private let lineSize = 4
    private let cardSpacing: CGFloat = 15

    // TODO: (Flavian) - Check on iPad how the grid behaves
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50)), count: lineSize), alignment: .center, spacing: cardSpacing) {
            ForEach(deck.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        guard deck.canRevealCards else {
                            return
                        }

                        deck.choose(card, soundManager: soundManager)

                        soundManager.playSound(sound: "flip-\(Int.random(in: 1...2))")
                        impactFeedback.impactOccurred()
                    }
            }
        }
    }
}

#Preview {
    CardGridView(deck: Deck(numberOfPairs: 8))
        .environmentObject(SoundManager())
}

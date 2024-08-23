import SwiftUI

struct CardGridView: View {
    @EnvironmentObject var soundManager: SoundManager
    @ObservedObject var deck: Deck

    @State private var offsets: [(x: CGFloat, y: CGFloat)]
    @State private var cardCenters: [CGPoint]
    @State private var deckCenter = CGPoint()

    private let lineSize = 4
    private let cardSpacing: CGFloat = UIScreen.main.bounds.size.width / 20

    init(deck: Deck) {
        self.deck = deck
        _offsets = State(initialValue: Array(repeating: (0, 0), count: deck.cards.count))
        _cardCenters = State(initialValue: Array(repeating: .zero, count: deck.cards.count))
    }

    private func calculateOffsets() {
        cardCenters.enumerated().forEach { index, center in
            let xOffset = center.x - deckCenter.x
            let yOffset = center.y - deckCenter.y

            offsets[index] = (x: xOffset, y: yOffset)
        }
    }

    var body: some View {
        // MARK: - Grid
        ZStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 5)), count: lineSize), alignment: .center, spacing: cardSpacing) {
                ForEach(deck.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            guard deck.canRevealCards else {
                                return
                            }

                            deck.choose(card, soundManager: soundManager)

                            soundManager.playSound(sound: card.soundName)
                            playHaptic(file: card.hapticName)

                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        let cardFrame = geometry.frame(in: .global)
                                        let cardCenter = CGPoint(x: cardFrame.midX, y: cardFrame.midY)

                                        cardCenters[deck.cards.firstIndex(where: {$0.id == card.id}) ?? 0] = cardCenter
                                    }
                            }
                        )
                }
            }
            .opacity(deck.deckOpacity == 1 ? 0 : 1)

            // MARK: - Deck
            VStack {
                Spacer()
                ZStack {
                    ForEach(Array(deck.cards.enumerated()), id: \.offset) { index, card in
                        CardView(card: card, canBeRevealed: false)
                            .offset(x: deck.isDealingCards ? offsets[index].x : 0, y: deck.isDealingCards ? offsets[index].y : 0)
                            .animation(.easeInOut(duration: 0.2).delay(Double(index) * 0.2), value: deck.isDealingCards)
                    }

                    Circle()
                        .fill(.clear)
                        .frame(width: 1)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        // Calculate the center point of the circle
                                        let circleFrame = geometry.frame(in: .global)
                                        let circleCenter = CGPoint(x: circleFrame.midX, y: circleFrame.midY)

                                        self.deckCenter = circleCenter
                                        calculateOffsets()
                                    }
                            }
                        )
                }
                .padding(.bottom, 50)
            }
            .opacity(deck.deckOpacity)
            .onAppear(perform: {
                deck.isDealingCards = true
                deck.deckOpacity = 1
                soundManager.playSound(sound: "shuffle")

                DispatchQueue.main.asyncAfter(deadline: .now() + Double(deck.cards.count) * 0.2) {
                    deck.isDealingCards = false
                    deck.deckOpacity = 0
                }
            })
        }
    }
}

#Preview {
    CardGridView(deck: Deck(numberOfPairs: 8))
        .environmentObject(SoundManager())
}

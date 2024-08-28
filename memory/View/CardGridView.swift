import SwiftUI

struct CardGridView: View {
    @EnvironmentObject var soundManager: SoundManager
    @ObservedObject var deck: Deck

    @State private var offsets: [(x: CGFloat, y: CGFloat)]
    @State private var cardCenters: [CGPoint]
    @State private var deckCenter = CGPoint()

    private let maxLineSize = 4
    private let minimumCardWidth: CGFloat = 60
    private let maximumCardWidth: CGFloat = 150
    private let cardSpacingRatio: CGFloat = 0.08

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
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let availableHeight = geometry.size.height
            let cardSpacing = availableWidth * cardSpacingRatio

            // Calculate column and row count
            let columnCount = max(Int(availableWidth / (minimumCardWidth + cardSpacing)), 1)
            let rowCount = max(Int(availableHeight / (minimumCardWidth + cardSpacing)), 1)

            // Calculate optimal card size based on both width and height constraints
            let maxWidthCardSize = (availableWidth - (CGFloat(columnCount - 1) * cardSpacing)) / CGFloat(columnCount)
            let maxHeightCardSize = (availableHeight - (CGFloat(rowCount - 1) * cardSpacing)) / CGFloat(rowCount)
            let cardSize = max(maxWidthCardSize, maxHeightCardSize)

            ZStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: minimumCardWidth, maximum: maximumCardWidth)), count: min(columnCount, maxLineSize)), alignment: .center, spacing: cardSpacing) {
                    ForEach(deck.cards) { card in
                        CardView(card: card, cardSize: cardSize)
                            .onTapGesture {
                                guard deck.canRevealCards else {
                                    return
                                }

                                deck.choose(card, soundManager: soundManager)

                                if deck.gameMode == .sound {
                                    soundManager.playSound(sound: card.soundName)
                                } else {
                                    soundManager.playSound(sound: "flip_\(Int.random(in: 0...1))")
                                }

                                if deck.gameMode == .haptic {
                                    playHaptic(file: card.hapticName)
                                } else {
                                    UIImpactFeedbackGenerator().impactOccurred()
                                }

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
                            CardView(card: card, canBeRevealed: false, cardSize: cardSize)
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
                    .padding(.bottom, UIApplication.windowSafeAreaInsets.bottom)
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
}

#Preview {
    CardGridView(deck: Deck(mode: .classic, isMultiplayer: false, numberOfPairs: 12))
        .environmentObject(SoundManager())
}

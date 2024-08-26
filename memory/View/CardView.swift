import SwiftUI

struct CardView: View {
    let card: Card
    var canBeRevealed = true

    var cardSize: CGFloat {
        let baseWidth: CGFloat = 1179 // iPhone 15 Pro's width
        let scalingFactor = UIScreen.main.bounds.size.width / baseWidth
        let consistentSize = (baseWidth / 6) * scalingFactor

        return consistentSize
    }

    var body: some View {
        ZStack {
            Image("back")
                .cardStyle(cardSize: cardSize, rotation: card.rotation)
                .rotation3DEffect(
                    .degrees(canBeRevealed && (card.isRevealed || card.isMatched) ? 90 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .scaleEffect(canBeRevealed && (card.isRevealed || card.isMatched) ? 0.8 : 1)
                .animation(card.isRevealed || card.isMatched ? .easeInOut : .easeInOut.delay(0.35), value: card.isRevealed)

            Image(card.imageName)
                .cardStyle(cardSize: cardSize, rotation: card.rotation)
                .scaleEffect(canBeRevealed && (card.isRevealed || card.isMatched) ? 1 : 0.8)
                .rotation3DEffect(
                    .degrees(canBeRevealed && (card.isRevealed || card.isMatched) ? 0 : -90),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .animation(card.isRevealed || card.isMatched ? .easeInOut.delay(0.35) : .easeInOut, value: card.isRevealed)
        }
    }
}

extension Image {
    func cardStyle(cardSize: CGFloat, rotation: Double) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: cardSize, height: cardSize)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(
                        LinearGradient(
                            colors: [.frost, .charcoalBlue],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
                    .frame(width: cardSize, height: cardSize)
            }
            .rotationEffect(.degrees(rotation))
    }
}

#Preview {
    let deck = Deck(mode: .classic, isMultiplayer: false, numberOfPairs: 4)
    deck.cards[1].isRevealed = true

    return Group {
        CardView(card: deck.cards[0])
            .scaleEffect(2.5)
        CardView(card: deck.cards[1])
            .padding(.top, 150)
            .scaleEffect(2.5)
    }
}

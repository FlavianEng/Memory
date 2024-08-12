import SwiftUI

// TODO: (Flavian) - Improves card border – Maybe use a gradient
// TODO: (Flavian) - Find a way to notify user the successful pair
struct CardView: View {
    let card: Card
    var canBeRevealed = true

    var cardSize: CGFloat {
        return (UIScreen.main.bounds.size.width / 5) - 20
    }

    var body: some View {
        ZStack {
            Image("back")
                .resizable()
                .scaledToFit()
                .frame(width: cardSize, height: cardSize)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.frost.opacity(0.7), lineWidth: 2)
                        .frame(width: cardSize, height: cardSize)
                }
                .rotationEffect(.degrees(card.rotation))
                .rotation3DEffect(
                    .degrees(canBeRevealed && (card.isRevealed || card.isMatched) ? 90 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .scaleEffect(canBeRevealed && (card.isRevealed || card.isMatched) ? 0.8 : 1)
                .animation(card.isRevealed || card.isMatched ? .easeInOut : .easeInOut.delay(0.35), value: card.isRevealed)

            Image(card.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: cardSize, height: cardSize)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.frost.opacity(0.7), lineWidth: 2)
                        .frame(width: cardSize, height: cardSize)
                }
                .rotationEffect(.degrees(card.rotation))
                .scaleEffect(canBeRevealed && (card.isRevealed || card.isMatched) ? 1 : 0.8)
                .rotation3DEffect(
                    .degrees(canBeRevealed && (card.isRevealed || card.isMatched) ? 0 : -90),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .animation(card.isRevealed || card.isMatched ? .easeInOut.delay(0.35) : .easeInOut, value: card.isRevealed)
        }
    }
}

#Preview {
    let deck = Deck(numberOfPairs: 4)
    deck.cards[1].isRevealed = true

    return Group {
        CardView(card: deck.cards[0])
            .scaleEffect(2.5)
        CardView(card: deck.cards[1])
            .padding(.top, 150)
            .scaleEffect(2.5)
    }
}

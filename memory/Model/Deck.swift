import SwiftUI

// TODO: (Flavian) - Add animation on deck removing
// TODO: (Flavian) - Add animation on deck setup
// TODO: (Flavian) - Add a UI new game timer
// TODO: (Flavian) - Add a 2 players mode
// TODO: (Flavian) - Add more sounds

class Deck: ObservableObject {
    @AppStorage("bestMoveCount") private var bestMoveCount = 0

    @Published var cards: [Card]
    @Published var canRevealCards = true
    @Published var player = Player()

    private var numberOfPairs: Int

    init(numberOfPairs: Int) {
        self.numberOfPairs = numberOfPairs

        var uniqueCardsNumber = Set<Int>()

        while uniqueCardsNumber.count != numberOfPairs {
            uniqueCardsNumber.insert(Int.random(in: 1...18))
        }

        cards = []

        uniqueCardsNumber.forEach { cardNumber in
            cards.append(Card(number: cardNumber))
            cards.append(Card(number: cardNumber))
        }

        cards = cards.shuffled()
    }

    func choose(_ card: Card, soundManager: SoundManager) {
        guard let chosenIndex = cards.firstIndex(where: {$0.id == card.id}),
              !cards[chosenIndex].isRevealed,
              !cards[chosenIndex].isMatched
        else {
            return
        }

        for index in cards.indices {
            if cards[index].isRevealed && cards[index].id != card.id {
                canRevealCards = false

                if cards[index].number == cards[chosenIndex].number {
                    matchCards(index: index, chosenIndex: chosenIndex, soundManager: soundManager)
                    player.incrementMoveCount()
                }

                hideCards(index: index, chosenIndex: chosenIndex)
            }
        }

        cards[chosenIndex].isRevealed.toggle()

        checkMatchIsOver()

        self.canRevealCards = true
    }

    private func checkMatchIsOver() {
        if cards.allSatisfy({$0.isMatched}) {
            saveBestMove()
            resetGame()
        }
    }

    private func hideCards(index: Int, chosenIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.cards[index].isMatched {
                self.cards[index].isRevealed = false
                self.cards[chosenIndex].isRevealed = false

                self.player.incrementMoveCount()
                notficationFeedback.notificationOccurred(.error)
            }
        }
    }

    private func matchCards(index: Int, chosenIndex: Int, soundManager: SoundManager) {
        cards[index].isMatched = true
        cards[chosenIndex].isMatched = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            soundManager.playSound(sound: "success")
            notficationFeedback.notificationOccurred(.success)
        }
    }

    private func initDeck() {
        var uniqueCardsNumber = Set<Int>()

        while uniqueCardsNumber.count != numberOfPairs {
            uniqueCardsNumber.insert(Int.random(in: 1...18))
        }

        cards = []

        uniqueCardsNumber.forEach { cardNumber in
            cards.append(Card(number: cardNumber))
            cards.append(Card(number: cardNumber))
        }

        cards = cards.shuffled()
    }

    private func resetGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.initDeck()
        }
    }

    private func saveBestMove() {
        if player.moveCount < bestMoveCount {
            bestMoveCount = player.moveCount
        }
    }
}

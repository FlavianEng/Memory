import SwiftUI

// TODO: (Flavian) - Add a UI new game timer
// TODO: (Flavian) - Add a 2 players mode
// TODO: (Flavian) - Add more sounds
// TODO: (Flavian) - Add 3 modes (difficulty / time) with different amount of pairs (18 max - calculates with the height of the screen)

class Deck: ObservableObject {
    @AppStorage("bestMoveCount") private var bestMoveCount = 0

    @Published var canRevealCards = true
    @Published var cards: [Card]
    @Published var deckOpacity: Double = 1
    @Published var isDealingCards = false
    @Published var player = Player()

    private var numberOfPairs: Int

    init(numberOfPairs: Int) {
        self.numberOfPairs = 0
        self.cards = []

        setNumberOfPairs(numberOfPairs: numberOfPairs)
        initDeck()
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
    }

    // TODO: (Flavian) - Move into a game class
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

            self.canRevealCards = true
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

    // TODO: (Flavian) - Improves unique card number selection by removing from array the index taken
    // TODO: (Flavian) - Automatically get the max uniqueCardsNumber
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

    // TODO: (Flavian) - Move into a game class
    private func resetGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.deckOpacity = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            self.initDeck()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isDealingCards = true
            self.deckOpacity = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5 + Double(self.cards.count) * 0.2) {
            self.isDealingCards = false
            self.deckOpacity = 0
        }
    }

    // TODO: (Flavian) - Move into a game class
    private func saveBestMove() {
        if player.moveCount < bestMoveCount {
            bestMoveCount = player.moveCount
        }
    }

    private func setNumberOfPairs(numberOfPairs: Int) {
        guard numberOfPairs <= 18 else {
            fatalError("Number of pairs is too high")
        }

        self.numberOfPairs = numberOfPairs
    }
}

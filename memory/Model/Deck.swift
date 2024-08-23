import SwiftUI

class Deck: ObservableObject {
    @AppStorage("bestMoveCount") private var bestMoveCount = 0

    @Published var canRevealCards = true
    @Published var cards: [Card]
    @Published var deckOpacity: Double = 1
    @Published var isDealingCards = false
    @Published var player = Player()
    @Published var newGameTimer: Double = 0

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

                if cards[index].soundNumber == cards[chosenIndex].soundNumber {
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

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.resetGame()
                self.resetScore()
            }
        }
    }

    private func hideCards(index: Int, chosenIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.cards[index].isMatched {
                self.cards[index].isRevealed = false
                self.cards[chosenIndex].isRevealed = false

                self.player.incrementMoveCount()
            }

            self.canRevealCards = true
        }
    }

    private func matchCards(index: Int, chosenIndex: Int, soundManager: SoundManager) {
        cards[index].isMatched = true
        cards[chosenIndex].isMatched = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            soundManager.playSound(sound: "success")
        }
    }

    // TODO: (Flavian) - Automatically get the max uniqueSoundsNumber
    private func initDeck() {
        var uniqueNumbers = Set<Int>()

        while uniqueNumbers.count != numberOfPairs {
            uniqueNumbers.insert(Int.random(in: 0...19))
        }

        cards = []

        uniqueNumbers.forEach { number in
            cards.append(Card(iconNumber: Int.random(in: 1...18), soundNumber: number, hapticNumber: number))
            cards.append(Card(iconNumber: Int.random(in: 1...18), soundNumber: number, hapticNumber: number))
        }

        cards = cards.shuffled()
    }

    // TODO: (Flavian) - Move into a game class
    private func resetGame() {
        newGameTimer = 3

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            self.deckOpacity = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            self.initDeck()
            self.newGameTimer = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.isDealingCards = true
            self.deckOpacity = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5 + Double(self.cards.count) * 0.2) {
            self.isDealingCards = false
            self.deckOpacity = 0
        }
    }

    // TODO: (Flavian) - Move into a game class
    private func resetScore() {
        player.moveCount = 0
    }

    // TODO: (Flavian) - Move into a game class
    private func saveBestMove() {
        if player.moveCount < bestMoveCount || bestMoveCount == 0 {
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

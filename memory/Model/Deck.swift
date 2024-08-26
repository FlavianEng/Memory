import SwiftUI

enum GameMode {
    case classic, sound, haptic
}

// TODO: (Flavian) - Add the two differents other modes
class Deck: ObservableObject {
    let isMultiplayer: Bool
    let gameMode: GameMode

    @Published var players: [Player] = []
    @Published var currentPlayer: Player = Player()
    @Published var canRevealCards = true
    @Published var cards: [Card]
    @Published var deckOpacity: Double = 1
    @Published var isDealingCards = false
    @Published var newGameTimer: Double = 0

    // TODO: (Flavian) - Create a best move count for each 1P. mode
    @AppStorage("bestMoveCount") private var bestMoveCount = 0

    private var numberOfPairs: Int

    init(mode: GameMode, isMultiplayer: Bool, numberOfPairs: Int) {
        self.cards = []
        self.isMultiplayer = isMultiplayer
        self.gameMode = mode
        self.numberOfPairs = 0

        createPlayers()
        pickFirstPlayer()

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

                if cards[index].iconNumber == cards[chosenIndex].iconNumber {
                    matchCards(index: index, chosenIndex: chosenIndex, soundManager: soundManager)
                    currentPlayer.incrementMoveCount()
                }

                hideCards(index: index, chosenIndex: chosenIndex)
            }
        }

        cards[chosenIndex].isRevealed.toggle()

        checkMatchIsOver()
    }

    private func checkMatchIsOver() {
        if cards.allSatisfy({$0.isMatched}) {
            saveBestMove(player: currentPlayer)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.resetGame()
                self.resetScores()
            }
        }
    }

    private func hideCards(index: Int, chosenIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !self.cards[index].isMatched {
                self.cards[index].isRevealed = false
                self.cards[chosenIndex].isRevealed = false

                self.currentPlayer.incrementMoveCount()
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
    // TODO: (Flavian) - Adapt to handle different modes
    private func initDeck() {
        var uniqueNumbers = Set<Int>()

        while uniqueNumbers.count != numberOfPairs {
            uniqueNumbers.insert(Int.random(in: 1...18))
        }

        cards = []

        uniqueNumbers.forEach { number in
            cards.append(Card(iconNumber: number, soundNumber: number, hapticNumber: number))
            cards.append(Card(iconNumber: number, soundNumber: number, hapticNumber: number))
        }

        cards = cards.shuffled()
    }

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

    private func createPlayers() {
        players = [Player()]

        if isMultiplayer {
            players.append(Player())
        }
    }

    private func pickFirstPlayer() {
        guard let currentPlayer = players.randomElement() else {
            fatalError("currentPlayer has been impossible to pick")
        }
        self.currentPlayer = currentPlayer
    }

    private func resetScores() {
        for index in players.indices {
            players[index].moveCount = 0
        }
    }

    private func saveBestMove(player: Player) {
        guard !isMultiplayer else {
            return
        }

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

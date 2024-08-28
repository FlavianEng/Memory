import SwiftUI

enum GameMode {
    case classic, sound, haptic
}

class Deck: ObservableObject {
    let isMultiplayer: Bool
    let gameMode: GameMode

    @Published var canRevealCards = true
    @Published var cards: [Card]
    @Published var currentPlayer: Player = Player()
    @Published var deckOpacity: Double = 1
    @Published var isDealingCards = false
    @Published var isEndGameDisplayed = false
    @Published var players: [Player] = []

    @AppStorage("classicBestMoveCount") private var classicBestMoveCount = 0
    @AppStorage("soundBestMoveCount") private var soundBestMoveCount = 0
    @AppStorage("hapticBestMoveCount") private var hapticBestMoveCount = 0

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

                if (gameMode == . classic && cards[index].iconNumber == cards[chosenIndex].iconNumber) ||
                    (gameMode == .sound && cards[index].soundNumber == cards[chosenIndex].soundNumber) ||
                    (gameMode == .haptic && cards[index].hapticNumber == cards[chosenIndex].hapticNumber) {
                    matchCards(index: index, chosenIndex: chosenIndex, soundManager: soundManager)
                    currentPlayer.incrementMoveCount()
                }

                hideCards(index: index, chosenIndex: chosenIndex)
            }
        }

        cards[chosenIndex].isRevealed.toggle()

        checkMatchIsOver()
    }

    func getBestMove() -> Int {
        switch gameMode {
        case .classic:
            return classicBestMoveCount
        case .sound:
            return soundBestMoveCount
        case .haptic:
            return hapticBestMoveCount
        }
    }

    func resetGame() {
        saveBestMove(player: currentPlayer)
        resetScores()
        deckOpacity = 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.initDeck()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isDealingCards = true
            self.deckOpacity = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + Double(self.cards.count) * 0.2) {
            self.isDealingCards = false
            self.deckOpacity = 0
        }
    }

    func saveBestMove(player: Player) {
        guard !isMultiplayer else {
            return
        }

        switch gameMode {
        case .classic:
            if player.moveCount < classicBestMoveCount || classicBestMoveCount == 0 {
                classicBestMoveCount = player.moveCount
            }
        case .sound:
            if player.moveCount < soundBestMoveCount || soundBestMoveCount == 0 {
                soundBestMoveCount = player.moveCount
            }
        case .haptic:
            if player.moveCount < hapticBestMoveCount || hapticBestMoveCount == 0 {
                hapticBestMoveCount = player.moveCount
            }
        }
    }

    private func checkMatchIsOver() {
        if cards.allSatisfy({$0.isMatched}) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isEndGameDisplayed = true
            }
        }
    }

    private func createCard(number: Int) -> Card {
        return Card(
            iconNumber: gameMode == .classic ? number : Int.random(in: 1...18),
            soundNumber: gameMode == .sound ? number : Int.random(in: 0...19),
            hapticNumber: gameMode == .haptic ? number : Int.random(in: 0...19)
        )
    }

    private func createPlayers() {
        players = [Player()]

        if isMultiplayer {
            players.append(Player())
        }
    }

    private func getUniqueNumbers(mode: GameMode) -> Set<Int> {
        var uniqueNumbers = Set<Int>()
        var range: ClosedRange<Int>

        switch mode {
        case .classic:
            range = 1 ... 18
        case .haptic, .sound:
            range = 0 ... 19
        }

        while uniqueNumbers.count != numberOfPairs {
            uniqueNumbers.insert(Int.random(in: range))
        }

        return uniqueNumbers
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

    // TODO: (Flavian) - Automatically get the max uniqueSoundsNumber
    private func initDeck() {
        let uniqueNumbers = getUniqueNumbers(mode: gameMode)

        cards = []

        uniqueNumbers.forEach { number in
            cards.append(createCard(number: number))
            cards.append(createCard(number: number))
        }

        cards = cards.shuffled()
    }

    private func matchCards(index: Int, chosenIndex: Int, soundManager: SoundManager) {
        cards[index].isMatched = true
        cards[chosenIndex].isMatched = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            soundManager.playSound(sound: "success")
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

        currentPlayer.moveCount = 0
    }

    private func setNumberOfPairs(numberOfPairs: Int) {
        guard numberOfPairs <= 18 else {
            fatalError("Number of pairs is too high")
        }

        self.numberOfPairs = numberOfPairs
    }
}

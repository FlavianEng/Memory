import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var soundManager: SoundManager
    @StateObject var deck: Deck

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.frost.opacity(0.8))
                        .padding(.horizontal)

                    Spacer()
                }

                Spacer()
            }
            .padding(.top, UIApplication.windowSafeAreaInsets.top)

            VStack(spacing: 0) {
                if !deck.isMultiplayer {
                    MoveCounterView(player: deck.currentPlayer, bestMove: deck.getBestMove())
                        .padding(.top, UIApplication.windowSafeAreaInsets.top)
                }

                Spacer()

                CardGridView(deck: deck)
                    .environmentObject(soundManager)

                Spacer()
            }

            if deck.isEndGameDisplayed {
                EndGameModal(
                    isDisplayed: $deck.isEndGameDisplayed,
                    currentScore: deck.currentPlayer.moveCount,
                    bestScore: deck.getBestMove(),
                    onCancel: { deck.saveBestMove(player: deck.currentPlayer); dismiss() },
                    onPlayAgain: { deck.resetGame() })
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameView(deck: Deck(mode: .classic, isMultiplayer: false, numberOfPairs: 1))
        .environmentObject(SoundManager())
}

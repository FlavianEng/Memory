import SwiftUI

struct NewGameTimerView: View {
    var deck: Deck

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.frost.opacity(0.8), .charcoalBlue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Text("New Game in \(lround(deck.newGameTimer))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.frost)
                .onReceive(timer, perform: { _ in
                    if deck.newGameTimer > 0 {
                        deck.newGameTimer -= 1
                    }
                })
        }
    }
}

#Preview {
    NewGameTimerView(deck: Deck(mode: .classic, isMultiplayer: false, numberOfPairs: 8))
}

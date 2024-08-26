import SwiftUI

struct MoveCounterView: View {
    @AppStorage("bestMoveCount") private var bestMoveCount = 0
    let player: Player

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Number of move: ")

                Text("\(player.moveCount)")
                    .fontWeight(.bold)

            }
            .foregroundStyle(.frost)
            .font(.title2)

            HStack(spacing: 0) {
                Text("Best: ")

                Text("\(bestMoveCount)")
                    .fontWeight(.bold)

            }
            .foregroundStyle(.yellow.opacity(0.8))
            .font(.title3)
        }
    }
}

#Preview {
    MoveCounterView(player: Player())
}

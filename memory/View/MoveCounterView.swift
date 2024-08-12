import SwiftUI

struct MoveCounterView: View {
    @AppStorage("bestMoveCount") private var bestMoveCount = 0
    let player: Player

    var body: some View {
        HStack(spacing: 0) {
            Text("Number of move: ")

            Text("\(player.moveCount)")
                .fontWeight(.bold)

        }
        .foregroundStyle(.frost)

        HStack(spacing: 0) {
            Text("Best: ")

            Text("\(bestMoveCount)")
                .fontWeight(.bold)

        }
        .foregroundStyle(.yellow.opacity(0.8))
        .font(.caption)
    }
}

#Preview {
    MoveCounterView(player: Player())
}

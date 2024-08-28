import SwiftUI

struct MoveCounterView: View {
    let player: Player
    let bestMove: Int

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

                Text("\(bestMove)")
                    .fontWeight(.bold)

            }
            .foregroundStyle(.yellow)
            .font(.title3)
        }
    }
}

#Preview {
    MoveCounterView(player: Player(), bestMove: 2)
}

import SwiftUI

struct EndGameModal: View {
    @Binding var isDisplayed: Bool
    let currentScore: Int
    let bestScore: Int
    let onCancel: () -> Void
    let onPlayAgain: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.midnight.opacity(0.5))
                .stroke(
                    LinearGradient(
                        colors: [.frost, .charcoalBlue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .background(BlurView())

            VStack(alignment: .leading, spacing: 10) {
                Text(currentScore < bestScore ? "New best score!" : "Well done!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 25)
                    .foregroundStyle(currentScore < bestScore ? .yellow : .frost)

                HStack(spacing: 0) {
                    Text(currentScore < bestScore ? "Best score: " : "Score: ")

                    Text("\(currentScore)")
                        .fontWeight(.bold)

                }
                .foregroundStyle(currentScore < bestScore ? .yellow : .frost)
                .font(.title2)

                HStack(spacing: 0) {
                    Text(currentScore < bestScore ? "Old best score: " : "Best score: ")

                    Text("\(bestScore)")
                        .fontWeight(.bold)

                }
                .foregroundStyle(currentScore < bestScore ? .frost : .yellow)
                .font(.title3)

                Spacer()

                Button {
                    self.onCancel()
                } label: {
                    Spacer()
                    Text("Cancel")
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.vertical, 15)
                .padding(.horizontal)

                Button {
                    self.onPlayAgain()
                    isDisplayed.toggle()
                } label: {
                    Spacer()
                    Text("Play again!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.vertical, 15)
                .padding(.horizontal)
                .background(.midnight)
                .clipShape(.rect(cornerRadius: 25))
                .overlay(
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(
                            LinearGradient(
                                colors: [.frost, .charcoalBlue],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                )
            }
            .padding(.vertical, 50)
            .padding(.horizontal, 25)
        }
        .foregroundStyle(.frost)
        .frame(
            width: min(400, (UIScreen.main.bounds.width / 3 * 2)),
            height: min(400, UIScreen.main.bounds.height / 2))
    }
}

#Preview("Well done") {
    ZStack {
        Color(.green)
            .opacity(0.8)

        EndGameModal(isDisplayed: .constant(false), currentScore: 18, bestScore: 17, onCancel: {}, onPlayAgain: {})
    }
}

#Preview("Best score") {
    ZStack {
        Color(.green)
            .opacity(0.8)

        EndGameModal(isDisplayed: .constant(false), currentScore: 15, bestScore: 17, onCancel: {}, onPlayAgain: {})
    }
}

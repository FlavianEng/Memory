import SwiftUI

struct MenuItemView: View {
    let action: () -> Void
    let title: String
    let subtitle: String

    var body: some View {
        Button(action: action, label: {
            VStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)

                Text(subtitle)
                    .font(.subheadline)
                    .opacity(0.8)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.frost)
            .padding()
            .frame(width: UIScreen.main.bounds.size.width - 100)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(.charcoalBlue.opacity(0.8))
                    .stroke(
                        LinearGradient(
                            colors: [.frost, .charcoalBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
        })
    }
}

#Preview {
    MenuItemView(action: {}, title: "Classic Mode", subtitle: "The classic card matching game")
}

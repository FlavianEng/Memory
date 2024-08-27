import SwiftUI

struct MultiplayerPicker: View {
    @Binding var preselectedIndex: Int
    var options: [String]
    let color: Color = .charcoalBlue

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.2))

                    RoundedRectangle(cornerRadius: 25)
                        .scale(0.8)
                        .fill(color)
                        .stroke(LinearGradient(
                            colors: [.frost, .charcoalBlue],
                            startPoint: .top,
                            endPoint: .bottom
                        ), lineWidth: 2)
                        .padding(2)
                        .opacity(preselectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                preselectedIndex = index
                            }
                        }
                }
                .overlay(
                    Text(options[index])
                )
            }
        }
        .frame(height: 50)
        .cornerRadius(25)
    }
}

#Preview {
    @State var preselectedIndex: Int = 0

    return MultiplayerPicker(preselectedIndex: $preselectedIndex, options: ["1 Player", "2 Player"])
}

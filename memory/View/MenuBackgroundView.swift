import SwiftUI

struct MenuBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 2
            let contentWidth = size * 4

            VStack {
                InfiniteScrollerView(contentWidth: contentWidth, isLeftToRight: true) {
                    HStack(spacing: 0) {
                        ForEach(1...4, id: \.self) { iconNumber in
                            Image("icon_\(iconNumber)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size, height: size)
                        }
                    }
                }
                Spacer()

                InfiniteScrollerView(contentWidth: contentWidth, isLeftToRight: false) {
                    HStack(spacing: 0) {
                        ForEach(5...8, id: \.self) { iconNumber in
                            Image("icon_\(iconNumber)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size, height: size)
                        }
                    }
                }
                Spacer()

                InfiniteScrollerView(contentWidth: contentWidth, isLeftToRight: true) {
                    HStack(spacing: 0) {
                        ForEach(9...12, id: \.self) { iconNumber in
                            Image("icon_\(iconNumber)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: size, height: size)
                        }
                    }
                }
            }

        }
        .background(.midnight)
    }
}
#Preview {
    MenuBackgroundView()
}

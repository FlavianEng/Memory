import SwiftUI

struct InfiniteScrollerView<Content: View>: View {
    var contentWidth: CGFloat
    var isLeftToRight: Bool
    var content: (() -> Content)

    @State var xOffset: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                content()
                content()
            }
            .offset(x: xOffset, y: 0)
            .drawingGroup()
        }
        .environment(\.layoutDirection, isLeftToRight ? .leftToRight : .rightToLeft)
        .disabled(true)
        .onAppear {
            withAnimation(.linear(duration: 60).repeatForever(autoreverses: false)) {
                xOffset =  -contentWidth
            }
        }
    }
}

private struct ColorView: View {
    var size: CGFloat
    var color: Color

    var body: some View {
        VStack {
            VStack {}.frame(width: size, height: size, alignment: .center)
        }
        .background(color)
    }
}

#Preview {
    GeometryReader { geometry in
        let size = geometry.size.width / 2

        InfiniteScrollerView(contentWidth: size * 4, isLeftToRight: false) {
            HStack(spacing: 0) {
                ColorView(size: size, color: Color.green)
                ColorView(size: size, color: Color.white)
                ColorView(size: size, color: Color.pink)
                ColorView(size: size, color: Color.cyan)
            }
        }
    }
}

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let number: Int
    let rotation = Double.random(in: -5...5)
    var isRevealed = false
    var isMatched = false

    var imageName: String {
        return "icon_\(number)"
    }
}

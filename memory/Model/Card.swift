import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let iconNumber: Int
    let soundNumber: Int
    let hapticNumber: Int
    let rotation = Double.random(in: -5...5)
    var isRevealed = false
    var isMatched = false

    var hapticName: String {
        return "haptic_\(hapticNumber)"
    }
    var imageName: String {
        return "icon_\(iconNumber)"
    }
    var soundName: String {
        return "sound_\(soundNumber)"
    }
}

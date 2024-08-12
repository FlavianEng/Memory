import SwiftUI

struct Player {
    let id = UUID()
    var moveCount = 0

    mutating func incrementMoveCount() {
        moveCount += 1
    }
}

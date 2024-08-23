import Foundation
import CoreHaptics
import AVFoundation

var supportsHaptics: Bool = false

var engine: CHHapticEngine?

func playHaptic(file: String, type: String = "ahap") {
    guard let path = Bundle.main.path(forResource: file, ofType: type) else {
        return
    }

    do {
        engine = try CHHapticEngine()

        try engine?.start()
        try engine?.playPattern(from: URL(fileURLWithPath: path))
    } catch let error {
        print("Engine Creation Error: \(error)")
    }
}

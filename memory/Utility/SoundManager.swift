import Foundation
import AVFoundation

class SoundManager: NSObject, ObservableObject {
    private var audioPlayers: [AVAudioPlayer] = []

    override init() {
        super.init()

        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.ambient, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session \(error)")
        }
    }

    func playSound(sound: String, withExtension type: String = "wav") {
        if let soundUrl = Bundle.main.url(forResource: sound, withExtension: type) {
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
                audioPlayers.append(audioPlayer)
                audioPlayer.play()
            } catch {
                print("Error playing sound \(sound): \(error)")
            }
        }
    }

    func stopAllSounds() {
        for player in audioPlayers {
            player.stop()
        }

        audioPlayers.removeAll()
    }
}

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        if let index = audioPlayers.firstIndex(of: player) {
            audioPlayers.remove(at: index)
        }
    }
}

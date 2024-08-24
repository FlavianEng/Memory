import SwiftUI

@main
struct MemoryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SoundManager())
        }
    }
}

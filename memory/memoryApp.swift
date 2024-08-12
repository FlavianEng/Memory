import SwiftUI

@main
struct memoryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SoundManager())
        }
    }
}

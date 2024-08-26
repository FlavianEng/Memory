import SwiftUI

struct ContentView: View {
    var body: some View {
        MenuView()
    }
}

#Preview {
    ContentView()
        .environmentObject(SoundManager())
}

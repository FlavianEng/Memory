import SwiftUI

struct CreditsView: View {
    @Binding var isPresented: Bool

    var body: some View {
        Image(systemName: "info.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 20)
            .onTapGesture {
                isPresented = true
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                isPresented = false
            }, content: {
                VStack(spacing: 20) {
                    Text("Credits")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom, 25)

                    HStack(spacing: 50) {
                        Text("Developer")
                            .fontWeight(.semibold)

                        Text("Flavian Engevin")
                            .font(.callout)
                    }

                    HStack(spacing: 50) {
                        Text("Images")
                            .fontWeight(.semibold)

                        VStack(alignment: .trailing) {
                            Text("Victor Weiss")
                            Text("Design with Blink*")
                        }
                        .font(.callout)
                    }

                    Spacer()

                    Text("🙏 Thanks for playing!")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Spacer()
                }
                .foregroundStyle(.frost)
                .padding(50)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            })
    }
}

#Preview {
    CreditsView(isPresented: .constant(true))
}

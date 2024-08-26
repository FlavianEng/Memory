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
                VStack(alignment: .leading, spacing: 20) {
                    Text("Credits")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical, 25)

                    HStack(spacing: 50) {
                        Text("Developer")
                            .fontWeight(.semibold)

                        Text("Flavian Engevin")
                            .font(.callout)
                    }

                    HStack(spacing: 50) {
                        Text("Images")
                            .fontWeight(.semibold)

                        VStack {
                            Text("Victor Weiss")
                            Text("Design with Blink*")
                        }
                        .font(.callout)
                    }

                    HStack(spacing: 50) {
                        Text("Sounds")
                            .fontWeight(.semibold)

                        Text("Mixkit")
                            .font(.callout)
                    }

                    Spacer()

                    Text("🙏 Thanks for playing!")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Spacer()

                    Text("Simple Memo is not affiliated with Ravensburger Digital GmbH.")
                        .font(.footnote)
                        .fontWeight(.light)
                        .fixedSize(horizontal: false, vertical: true)

                }
                .foregroundStyle(.frost)
                .multilineTextAlignment(.center)
                .padding(50)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            })
    }
}

#Preview {
    CreditsView(isPresented: .constant(true))
}

import SwiftUI

struct QuickActionButton: View {
    var icon: String
        var label: String
        var backgroundColor: Color

        var body: some View {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .padding()
                    .background(backgroundColor)
                    .clipShape(Circle())
                Text(label)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
    }


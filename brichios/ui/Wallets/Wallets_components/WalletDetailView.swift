import SwiftUI

struct WalletDetailView: View {
    var wallet: Wallet
        
        var body: some View {
            Text("Details for \(wallet.currency)")
                .font(.largeTitle)
                .padding()
        }
}

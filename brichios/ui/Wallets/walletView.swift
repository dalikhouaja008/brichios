import SwiftUI

struct WalletView: View {
    @StateObject private var viewModel = WalletViewModel()
    @State private var showQRCodeGenerator = false // État pour contrôler l'affichage du QR code generator
    @State private var selectedWalletPublicKey: String? // Stocker la clé publique du portefeuille sélectionné
    @State private var showReceiveSheet = false // État pour afficher la feuille de réception

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Wallets Section with Horizontal Scroll
                    Text("My Wallets")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.top)

                    // Conditional rendering based on loading state
                    if viewModel.uiState.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if let errorMessage = viewModel.uiState.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // Horizontal Scrollable Wallets
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.uiState.wallets ?? []) { wallet in
                                    NavigationLink(destination: WalletDetailView(wallet: wallet)) {
                                        WalletRow(wallet: wallet)
                                            .frame(width: 300) // Fixed width for consistency
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Quick Actions Section
                    Text("Quick Actions")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(.top)

                    HStack(spacing: 15) {
                        QuickActionButton(icon: "arrow.up.circle.fill", label: "Send", backgroundColor: Color.green) {
                            if let wallet = viewModel.uiState.wallets?.first {
                                selectedWalletPublicKey = wallet.publicKey // Stocker la clé publique
                                showQRCodeGenerator = true // Afficher le générateur de QR code si nécessaire
                            }
                        }

                        QuickActionButton(icon: "arrow.down.circle.fill", label: "Receive", backgroundColor: Color.blue) {
                            if let wallet = viewModel.uiState.wallets?.first {
                                selectedWalletPublicKey = wallet.publicKey
                                print(selectedWalletPublicKey ?? "public key")// Stocker la clé publique pour la réception
                                showQRCodeGenerator = true // Afficher la feuille de réception
                            }
                        }

                        QuickActionButton(icon: "qrcode", label: "Scan", backgroundColor: Color.orange) {
                            showQRCodeGenerator = true // Afficher le QR code generator
                        }

                        QuickActionButton(icon: "creditcard.fill", label: "Pay", backgroundColor: Color.red) {
                            if let wallet = viewModel.uiState.wallets?.first {
                                selectedWalletPublicKey = wallet.publicKey
                                showQRCodeGenerator = true // Ou une autre action selon votre logique
                            }
                        }
                    }

                    // Recent Transactions Section (commenté pour simplifier l'exemple)
                }
                .padding()
            }
            .navigationTitle("Wallet")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchWallets()
            }
            // Affichage du QRGeneratorView en tant que sheet
            .sheet(isPresented: $showQRCodeGenerator) {
                QRGeneratorView(text: selectedWalletPublicKey ?? "") // Passer la clé publique au générateur de QR code
            }
        }
    }
}
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
            .environment(\.colorScheme, .light)
    }
}

#Preview {
    WalletView()
}

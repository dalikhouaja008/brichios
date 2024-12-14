import SwiftUI

struct WalletView: View {
    @StateObject private var viewModel = WalletViewModel()
    @StateObject private var currencyViewModel = CurrencyConverterViewModel()
    @State private var showQRCodeGenerator = false // État pour contrôlerl'affichag du QR code generator
    @State private var isAlimentDialogPresented = false
    @State private var selectedWalletPublicKey: String?
    @State private var selectedWalletCurency: String?
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
                                ForEach(viewModel.uiState.wallets ) { wallet in
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
                            if let wallet = viewModel.uiState.wallets.first {
                                selectedWalletPublicKey = wallet.publicKey // Stocker la clé
                            }
                        }

                        QuickActionButton(icon: "arrow.down.circle.fill", label: "Receive", backgroundColor: Color.blue) {
                            if let wallet = viewModel.uiState.wallets.first {
                                selectedWalletPublicKey = wallet.publicKey
                                print(selectedWalletPublicKey ?? "public key")// Stocker la clé publique pour la réception
                                showQRCodeGenerator = true // Afficher la feuille de réception
                            }
                        }

                        QuickActionButton(icon: "plus.circle", label: "Fund Wallet", backgroundColor: Color.orange) {
                            if let wallet = viewModel.uiState.wallets.first {
                                selectedWalletCurency = wallet.currency
                                print(selectedWalletCurency ?? "pas de wallet")
                                isAlimentDialogPresented=true
                            }
                        }

                        QuickActionButton(icon: "creditcard.fill", label: "Pay", backgroundColor: Color.red) {
                            if let wallet = viewModel.uiState.wallets.first {
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
            .sheet(isPresented: $isAlimentDialogPresented) {
                    AlimentDialogView(
                        walletsViewModel: viewModel,
                        currencyConverterViewModel: currencyViewModel,
                        selectedWalletCurrency: selectedWalletCurency ?? ""
                    )
                    .presentationDetents([.medium])
                
            }
            // Affichage du QRGeneratorView en tant que sheet
            .sheet(isPresented: $showQRCodeGenerator) {
                QRGeneratorView(text: selectedWalletPublicKey ?? "")
                    .presentationDetents([.medium])
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

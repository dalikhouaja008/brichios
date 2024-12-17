import SwiftUI

struct WalletView: View {
    @StateObject private var viewModel = WalletViewModel()
    @StateObject private var currencyViewModel = CurrencyConverterViewModel()
    
    @State private var showQRCodeGenerator = false
    @State private var isAlimentDialogPresented = false
    @State private var selectedWallet: WalletSolana?
    @State private var showReceiveSheet = false
    @State private var showSendMoneySheet = false
    
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

                    // Conditional rendering based on loading state and wallet availability
                    if viewModel.uiState.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if let errorMessage = viewModel.uiState.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else if viewModel.uiState.wallets.isEmpty {
                        VStack {
                            Image(systemName: "wallet.pass")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                            
                            Text("Add Your First Dinars Wallet")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                // Add logic to create a new wallet
                                // This could present a sheet or navigate to a wallet creation view
                            }) {
                                Text("Create Wallet")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding(.top)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        // Horizontal Scrollable Wallets
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.uiState.wallets) { wallet in
                                    WalletRow(wallet: wallet)
                                        .frame(width: 300) // Fixed width for consistency
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedWallet?.id == wallet.id ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                        .onTapGesture {
                                            // Deselect if tapping the already selected wallet
                                            selectedWallet = (selectedWallet?.id == wallet.id) ? nil : wallet
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Explicitly select first wallet if none is selected
                        .onAppear {
                            if selectedWallet == nil && !viewModel.uiState.wallets.isEmpty {
                                selectedWallet = viewModel.uiState.wallets.first
                            }
                        }
                    }

                    // Quick Actions Section
                    if !viewModel.uiState.wallets.isEmpty {
                        Text("Quick Actions")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.top)

                        HStack(spacing: 15) {
                            QuickActionButton(icon: "arrow.up.circle.fill", label: "Send", backgroundColor: Color.green) {
                                guard selectedWallet != nil else { return }
                                showSendMoneySheet = true
                            }
                            .disabled(selectedWallet == nil)

                            QuickActionButton(icon: "arrow.down.circle.fill", label: "Receive", backgroundColor: Color.blue) {
                                guard selectedWallet != nil else { return }
                                showQRCodeGenerator = true
                            }
                            .disabled(selectedWallet == nil)

                            QuickActionButton(icon: "plus.circle", label: "Fund Wallet", backgroundColor: Color.orange) {
                                guard selectedWallet != nil else { return }
                                isAlimentDialogPresented = true
                            }
                            .disabled(selectedWallet == nil)

                            QuickActionButton(icon: "building.columns.fill", label: "withdrawal", backgroundColor: Color.red) {
                                guard selectedWallet != nil else { return }
                            }
                            .disabled(selectedWallet == nil)
                        }
                    }
                }
                .padding()
                Text("Recent Transactions")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top)
            }
            .padding(.top, -55)
            .onAppear {
                viewModel.fetchWallets()
            }
            .sheet(isPresented: $isAlimentDialogPresented) {
                AlimentDialogView(
                    walletsViewModel: viewModel,
                    currencyConverterViewModel: currencyViewModel,
                    selectedWalletCurrency: selectedWallet?.currency ?? ""
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showQRCodeGenerator) {
                QRGeneratorView(text: selectedWallet?.publicKey ?? "")
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showSendMoneySheet) {
                SendMoneyView(isPresented: $showSendMoneySheet, viewModel: viewModel)
                    .presentationDetents([.medium, .large])
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

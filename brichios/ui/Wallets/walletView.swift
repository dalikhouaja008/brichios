
import SwiftUI

// MARK: - WalletView
struct WalletView: View {
    @StateObject private var viewModel = WalletViewModel()
    @StateObject private var currencyViewModel = CurrencyConverterViewModel()
    
    @State private var showQRCodeGenerator = false
    @State private var isAlimentDialogPresented = false
    @State private var selectedWallet: WalletSolana?
    @State private var showReceiveSheet = false
    @State private var showSendMoneySheet = false
    @State private var showAllTransactions = false
    @State private var showCreateWalletSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // TND Wallet
                    TNDWalletSectionView(
                        tndWallet: viewModel.uiState.TNDWallet,
                        showCreateWalletSheet: $showCreateWalletSheet
                    )
                    
                    // Wallets
                    WalletsSectionView(
                        viewModel: viewModel,
                        selectedWallet: $selectedWallet,
                        showCreateWalletSheet: $showCreateWalletSheet
                    )
                    
                    // Quick Actions
                    if !viewModel.uiState.wallets.isEmpty {
                        QuickActionsSectionView(
                            selectedWallet: selectedWallet,
                            showSendMoneySheet: $showSendMoneySheet,
                            showQRCodeGenerator: $showQRCodeGenerator,
                            isAlimentDialogPresented: $isAlimentDialogPresented
                        )
                    }
                    
                    // Transactions
                    if let wallet = selectedWallet {
                        TransactionsSectionView(
                            wallet: wallet,
                            showAllTransactions: $showAllTransactions
                        )
                    }
                }
            }
            .background(Color.gray.opacity(0.05))
            .onAppear { viewModel.fetchWallets() }
            .attachSheets(
                viewModel: viewModel,
                currencyViewModel: currencyViewModel,
                selectedWallet: selectedWallet,
                showQRCodeGenerator: $showQRCodeGenerator,
                isAlimentDialogPresented: $isAlimentDialogPresented,
                showSendMoneySheet: $showSendMoneySheet,
                showAllTransactions: $showAllTransactions,
                showCreateWalletSheet: $showCreateWalletSheet
            )
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current User's Login")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("raednas")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Current Date and Time (UTC)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("2024-12-19 14:18:20")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
        .padding(.horizontal)
    }
}

// MARK: - TND Wallet Section
struct TNDWalletSectionView: View {
    let tndWallet: WalletSolana?
    @Binding var showCreateWalletSheet: Bool
    
    var body: some View {
        if let wallet = tndWallet {
            TNDWalletCard(wallet: wallet)
        } else {
            CreateTNDWalletCard(showSheet: $showCreateWalletSheet)
        }
    }
}

// MARK: - Wallets Section
struct WalletsSectionView: View {
    @ObservedObject var viewModel: WalletViewModel
    @Binding var selectedWallet: WalletSolana?
    @Binding var showCreateWalletSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("My Wallets")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            if viewModel.uiState.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if let errorMessage = viewModel.uiState.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.uiState.wallets.isEmpty {
                EmptyWalletView(showCreateWalletSheet: $showCreateWalletSheet)
            } else {
                WalletsScrollView(
                    wallets: viewModel.uiState.wallets,
                    selectedWallet: $selectedWallet
                )
            }
        }
    }
}
struct EmptyWalletView: View {
    @Binding var showCreateWalletSheet: Bool
    
    var body: some View {
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
                showCreateWalletSheet = true
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
    }
}
// MARK: - Wallets Scroll View
struct WalletsScrollView: View {
    let wallets: [WalletSolana]
    @Binding var selectedWallet: WalletSolana?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(wallets) { wallet in
                    WalletRow(wallet: wallet)
                        .frame(width: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedWallet?.id == wallet.id ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .onTapGesture {
                            selectedWallet = (selectedWallet?.id == wallet.id) ? nil : wallet
                        }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            if selectedWallet == nil && !wallets.isEmpty {
                selectedWallet = wallets.first
            }
        }
    }
}

// MARK: - Quick Actions Section
struct QuickActionsSectionView: View {
    let selectedWallet: WalletSolana?
    @Binding var showSendMoneySheet: Bool
    @Binding var showQRCodeGenerator: Bool
    @Binding var isAlimentDialogPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            HStack(spacing: 15) {
                QuickActionButton(
                    icon: "arrow.up.circle.fill",
                    label: "Send",
                    backgroundColor: .green
                ) {
                    showSendMoneySheet = true
                }
                .disabled(selectedWallet == nil)
                
                QuickActionButton(
                    icon: "arrow.down.circle.fill",
                    label: "Receive",
                    backgroundColor: .blue
                ) {
                    showQRCodeGenerator = true
                }
                .disabled(selectedWallet == nil)
                
                QuickActionButton(
                    icon: "plus.circle",
                    label: "Fund",
                    backgroundColor: .orange
                ) {
                    isAlimentDialogPresented = true
                }
                .disabled(selectedWallet == nil)
                
                QuickActionButton(
                    icon: "building.columns.fill",
                    label: "Withdraw",
                    backgroundColor: .red
                ) {
                    // Withdrawal action
                }
                .disabled(selectedWallet == nil)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Transactions Section
struct TransactionsSectionView: View {
    let wallet: WalletSolana
    @Binding var showAllTransactions: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Transactions")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if (wallet.transactions?.count ?? 0) > 5 {
                    Button(action: {
                        showAllTransactions = true
                    }) {
                        HStack(spacing: 4) {
                            Text("View All")
                            Image(systemName: "chevron.right")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            
            if let transactions = wallet.transactions {
                if transactions.isEmpty {
                    EmptyTransactionsView()
                } else {
                    RecentTransactionsListView(transactions: transactions)
                }
            }
        }
    }
}

// MARK: - Recent Transactions List
struct RecentTransactionsListView: View {
    let transactions: [SolanaTransaction]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(transactions.prefix(5))) { transaction in
                TransactionRow(transaction: transaction)
                    .padding(.horizontal)
            }
        }
    }
}

// MARK: - Sheet Extension
extension View {
    func attachSheets(
        viewModel: WalletViewModel,
        currencyViewModel: CurrencyConverterViewModel,
        selectedWallet: WalletSolana?,
        showQRCodeGenerator: Binding<Bool>,
        isAlimentDialogPresented: Binding<Bool>,
        showSendMoneySheet: Binding<Bool>,
        showAllTransactions: Binding<Bool>,
        showCreateWalletSheet: Binding<Bool>
    ) -> some View {
        self
            .sheet(isPresented: isAlimentDialogPresented) {
                AlimentDialogView(
                    walletsViewModel: viewModel,
                    currencyConverterViewModel: currencyViewModel,
                    selectedWalletCurrency: selectedWallet?.currency ?? ""
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: showQRCodeGenerator) {
                QRGeneratorView(text: selectedWallet?.publicKey ?? "")
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: showSendMoneySheet) {
                SendMoneyView(isPresented: showSendMoneySheet, viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: showAllTransactions) {
                AllTransactionsView(transactions: selectedWallet?.transactions ?? [])
            }
            .sheet(isPresented: showCreateWalletSheet) {
                CreateTNDWalletCard(showSheet: showCreateWalletSheet)
                    .presentationDetents([.medium])
            }
    }
}

import SwiftUI
import CodeScanner

struct SendMoneyView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: WalletViewModel
    @State private var toWalletPublicKey: String = ""
    @State private var amount: String = ""
    @State private var showQRScanner = false
    
    // The wallet we're sending from (first wallet by default)
    private let fromWalletPublicKey: String
    
    init(isPresented: Binding<Bool>, viewModel: WalletViewModel) {
        self._isPresented = isPresented
        self.viewModel = viewModel
        // Assuming first wallet, adjust if needed
        self.fromWalletPublicKey = viewModel.uiState.wallets.first?.publicKey ?? ""
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Send Money")
                .font(.title2)
                .fontWeight(.bold)
            
            // Recipient Public Key Input
            HStack {
                TextField("Recipient Wallet Public Key", text: $toWalletPublicKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: { showQRScanner = true }) {
                    Image(systemName: "qrcode.viewfinder")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
            .padding()
            
            // Amount Input
            TextField("Amount", text: $amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()
            
            // Action Buttons
            HStack {
                // Cancel Button
                Button("Cancel") {
                    isPresented = false
                }
                .foregroundColor(.red)
                .padding()
                
                Spacer()
                
                // Confirm Button
                Button("Send") {
                    sendTransaction()
                }
                .foregroundColor(.green)
                .padding()
                .disabled(!isValidInput)
            }
        }
        .padding()
        .sheet(isPresented: $showQRScanner) {
            CodeScannerView(
                codeTypes: [.qr],
                simulatedData: "Sample QR Code Data",
                completion: handleScan
            )
        }
    }
    
    private var isValidInput: Bool {
        !toWalletPublicKey.isEmpty &&
        !amount.isEmpty &&
        (Double(amount) ?? 0) > 0
    }
    
    private func sendTransaction() {
        guard let amountDouble = Double(amount) else { return }
        
        viewModel.sendTransaction(
            fromWalletPublicKey: fromWalletPublicKey,
            toWalletPublicKey: toWalletPublicKey,
            amount: amountDouble
        )
        
        isPresented = false
    }
    
    private func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            toWalletPublicKey = result.string
            showQRScanner = false
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
            showQRScanner = false
        }
    }
}

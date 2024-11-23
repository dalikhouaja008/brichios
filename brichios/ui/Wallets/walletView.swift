import SwiftUI

struct WalletView: View {
    @State private var totalBalance: Double = 1234.56
    
    // Example wallet data
    @State private var wallets: [Wallet] = [
        Wallet(
            currency: "Tunisian Dinar",
            balance: 4200.75,
            symbol: "TND",
            transactions: [
                Transaction(id: 1, status: "Completed", description: "DDDDD", amount: 1000.00, date: Date(timeIntervalSince1970: 1699939200))
            ],
            cardImage: "card4"
        ),
        Wallet(
            currency: "Euro",
            balance: 800.40,
            symbol: "€",
            transactions: [
                Transaction(id: 2, status: "Pending", description: "WWWWW", amount: -50.00, date: Date(timeIntervalSince1970: 1699545600))
            ],
            cardImage: "card4"
        ),
        Wallet(
            currency: "Dollar",
            balance: 1500.00,
            symbol: "$",
            transactions: [
                Transaction(id: 3, status: "Completed", description: "AAAA", amount: -200.00, date: Date(timeIntervalSince1970: 1699756800))
            ],
            cardImage: "card4"
        )
    ]
    
    @State private var recentTransactions: [Transaction] = [
        Transaction(id: 1, status: "Completed", description: "SSSSS", amount: -5.75, date: Date(timeIntervalSince1970: 1699939200)),
        Transaction(id: 2, status: "Completed", description: "Salary", amount: 2500.00, date: Date(timeIntervalSince1970: 1699756800)),
        Transaction(id: 3, status: "Pending", description: "Netflix", amount: -15.99, date: Date(timeIntervalSince1970: 1699468800))
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Total Balance Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Total Balance")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("$\(String(format: "%.2f", totalBalance))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
                .shadow(radius: 10)
                
                // Wallets Section with Swipeable Cards
                Text("My Wallets")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                // Swipeable Wallets
                TabView {
                    ForEach(wallets) { wallet in
                        NavigationLink(destination: WalletDetailView(wallet: wallet)) {
                            WalletRow(wallet: wallet)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(height: 200)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                // Quick Actions Section
                Text("Quick Actions")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                HStack(spacing: 15) {
                    QuickActionButton(icon: "arrow.up.circle.fill", label: "Send", backgroundColor: Color.green)
                    QuickActionButton(icon: "arrow.down.circle.fill", label: "Receive", backgroundColor: Color.blue)
                    QuickActionButton(icon: "qrcode", label: "Scan", backgroundColor: Color.orange)
                    QuickActionButton(icon: "creditcard.fill", label: "Pay", backgroundColor: Color.red)
                }
                
                // Recent Transactions Section
                Text("Recent Transactions")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top)
                
                ForEach(recentTransactions) { transaction in
                    HStack {
                        Text(transaction.description)
                            .font(.body)
                        Spacer()
                        Text("\(transaction.amount, specifier: "%.2f")")
                            .foregroundColor(transaction.amount < 0 ? .red : .green)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 5)
                    Divider()
                }
            }
            .padding()
        }
        .navigationTitle("Wallet")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top,-63)
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

// HomeBrich.swift
// brichios
//
// Created by Mac Mini 1 on 20/11/2024.

import SwiftUI

struct HomeBrich: View {
    @State private var totalBalance: Double = 1234.56
    @State private var wallets = [
        Wallet(currency: "Tunisian Dinar", balance: 4200.75, symbol: "TND", transactions: [
            Transaction(id: 1, status: "Completed", description: "Deposit", amount: 1000.00, date: Date(timeIntervalSince1970: 1699939200)) // Nov 18
        ]),
        Wallet(currency: "Euro", balance: 800.40, symbol: "€", transactions: [
            Transaction(id: 2, status: "Pending", description: "Withdrawal", amount: -50.00, date: Date(timeIntervalSince1970: 1699545600)) // Nov 10
        ]),
        Wallet(currency: "Dollar", balance: 1500.00, symbol: "$", transactions: [
            Transaction(id: 3, status: "Completed", description: "Purchase", amount: -200.00, date: Date(timeIntervalSince1970: 1699756800)) // Nov 15
        ])
    ]
    
    @State private var recentTransactions = [
        Transaction(id: 1, status: "Completed", description: "Starbucks Coffee", amount: -5.75, date: Date(timeIntervalSince1970: 1699939200)), // Nov 18
        Transaction(id: 2, status: "Completed", description: "Salary", amount: 2500.00, date: Date(timeIntervalSince1970: 1699756800)), // Nov 15
        Transaction(id: 3, status: "Pending", description: "Netflix Subscription", amount: -15.99, date: Date(timeIntervalSince1970: 1699468800)) // Nov 12
    ]
    
    var body: some View {
        TabView {
            // Home View with swipeable wallets
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Total Balance Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Balance")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("$\(String(format: "%.2f", totalBalance))")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.blue.opacity(0.15))
                        .cornerRadius(15)
                        
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
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Swipeable feature for wallets
                        
                        // Quick Actions Section
                        Text("Quick Actions")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.top)
                        
                        HStack(spacing: 15) {
                            QuickActionButton(icon: "arrow.up.circle.fill", label: "Send")
                            QuickActionButton(icon: "arrow.down.circle.fill", label: "Receive")
                            QuickActionButton(icon: "qrcode", label: "Scan")
                            QuickActionButton(icon: "creditcard.fill", label: "Pay")
                        }
                        
                        // Recent Transactions Section
                        Text("Recent Transactions")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.top)
                        
                        ForEach(recentTransactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Wallet")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
        }
        .accentColor(.blue)
    }
}

struct TransactionRow: View {
    var transaction: Transaction
    
    // DateFormatter to convert Date to a readable string
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                Text("Status: \(transaction.status)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Amount: \(String(format: "%.2f", transaction.amount))")
                    .font(.subheadline)
                    .foregroundColor(transaction.amount < 0 ? .red : .green)
                Text(dateFormatter.string(from: transaction.date))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct WalletRow: View {
    var wallet: Wallet
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(wallet.currency)
                .font(.headline)
            Text("\(wallet.symbol)\(String(format: "%.2f", wallet.balance))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct WalletDetailView: View {
    var wallet: Wallet
    
    var body: some View {
        VStack {
            Text(wallet.currency)
                .font(.title)
                .padding()
            Text("Balance: \(wallet.symbol)\(String(format: "%.2f", wallet.balance))")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            // Add more detailed wallet information here
        }
        .navigationTitle(wallet.currency)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuickActionButton: View {
    var icon: String
    var label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
            Text(label)
                .font(.caption)
        }
        .frame(width: 80, height: 80)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
    }
}

#Preview {
    HomeBrich()
}

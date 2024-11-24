//
//  walletView.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
import SwiftUI

struct WalletView: View {
    @State private var totalBalance: Double = 1234.56
    @State private var wallets = [
        Wallet(
            currency: "Tunisian Dinar", balance: 4200.75, symbol: "TND", transactions: [
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
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Total Balance Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Balance")
                            .font(.headline)
                            .foregroundColor(.white) // White text for better contrast
                        Text("$\(String(format: "%.2f", totalBalance))")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white) // White for main balance
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)) // Gradient background
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
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Swipeable feature for wallets
                    
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
                        TransactionRow(transaction: transaction)
                    }
                }
                .padding()
            }
            .navigationTitle("Wallet")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    


#Preview {
    HomeBrich()
}

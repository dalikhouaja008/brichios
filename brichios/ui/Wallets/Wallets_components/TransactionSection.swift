//
//  TransactionSection.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/12/2024.
//

import Foundation
import SwiftUI

struct TransactionsSection: View {
    let wallet: WalletSolana
    @Binding var showAllTransactions: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Section Header
            HStack {
                Text("Recent Transactions")
                    .font(.title2)
                    .fontWeight(.bold)
                
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
            
            if wallet.transactions?.isEmpty ?? true {
                EmptyTransactionsView()
            } else {
                // Recent Transactions List
                VStack(spacing: 12) {
                    ForEach(wallet.transactions?.prefix(5) ?? []) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

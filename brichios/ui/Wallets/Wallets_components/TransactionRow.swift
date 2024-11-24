//
//  TransactionRow.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
import SwiftUI
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

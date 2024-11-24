//
//  TransactionRow.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/11/2024.
//


import SwiftUI

struct TransactionRow: View {
    var transaction: Transaction

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Text(transaction.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(transaction.amount < 0 ? "-" : "+")$\(String(format: "%.2f", abs(transaction.amount)))")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(transaction.amount < 0 ? .red : .green)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

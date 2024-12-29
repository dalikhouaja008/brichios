//
//  TransactionRow.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
import SwiftUI
struct TransactionRow: View {
    let transaction: SolanaTransaction
    @Environment(\.colorScheme) var colorScheme
    
    // Time-relative formatter
    private func getRelativeTime(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // Transaction status color
    private var statusColor: Color {
        switch transaction.status.lowercased() {
        case "confirmed":
            return .green
        case "pending":
            return .orange
        case "failed":
            return .red
        default:
            return .gray
        }
    }
    
    // Transaction icon
    private var transactionIcon: String {
        switch transaction.type.lowercased() {
        case "send":
            return "arrow.up.circle.fill"
        case "receive":
            return "arrow.down.circle.fill"
        case "swap":
            return "arrow.2.circlepath.circle.fill"
        case "transfer":
            return "arrow.left.arrow.right.circle.fill"
        default:
            return "circle.fill"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                // Left side - Transaction type and icon
                HStack(spacing: 12) {
                    Image(systemName: transactionIcon)
                        .font(.system(size: 24))
                        .foregroundColor(statusColor)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(transaction.type.capitalized)
                            .font(.headline)
                        
                        Text(getRelativeTime(from: transaction.blockTime))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Right side - Amount
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(String(format: "%.6f", abs(transaction.amount)))")
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(transaction.amount >= 0 ? .green : .red)
                    
                    Text("SOL")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Transaction details
            VStack(spacing: 8) {
                HStack {
                    Text("Fee")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(String(format: "%.6f", transaction.fee)) SOL")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Abbreviated address display
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("From")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text(transaction.fromAddress.prefix(6) + "..." + transaction.fromAddress.suffix(4))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("To")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Text(transaction.toAddress.prefix(6) + "..." + transaction.toAddress.suffix(4))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(UIColor.secondarySystemBackground) : .white)
                .shadow(
                    color: colorScheme == .dark ? .clear : .black.opacity(0.05),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}



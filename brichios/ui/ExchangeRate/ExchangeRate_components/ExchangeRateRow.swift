//
//  ExchangeRateRow.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
import SwiftUI
struct ExchangeRateRow: View {
    let rate: ExchangeRate
    
    // Date formatter to remove time
    private var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd MMM yyyy"
        
        if let date = isoFormatter.date(from: rate.date) {
            return displayFormatter.string(from: date)
        }
        return rate.date
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(rate.designation)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text(rate.code)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Buying Rate")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(rate.buyingRate)
                        .font(.body)
                        .foregroundColor(.green)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Selling Rate")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(rate.sellingRate)
                        .font(.body)
                        .foregroundColor(.red)
                }
            }
            
            Text("Unit: \(rate.unit)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("Date: \(formattedDate)")
                .font(.caption)
                .foregroundColor(.purple)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

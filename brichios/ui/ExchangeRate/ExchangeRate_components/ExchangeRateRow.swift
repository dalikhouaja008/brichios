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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(rate.designation)
                    .font(.headline)
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
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Selling Rate")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(rate.sellingRate)
                        .font(.body)
                }
            }
            
            Text("Unit: \(rate.unit)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("Date: \(rate.date)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}



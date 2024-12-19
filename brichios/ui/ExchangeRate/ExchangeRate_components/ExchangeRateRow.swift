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
    
    private func formatDate(_ dateString: String) -> String {
            let dateFormatter = DateFormatter()
            // Configuration pour le format d'entrée du backend
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let date = dateFormatter.date(from: dateString) {
                // Configuration pour n'afficher que la date
                dateFormatter.dateFormat = "dd/MM/yyyy"
                return dateFormatter.string(from: date)
            }
            // Si le parsing échoue, retourner juste la partie date
            // Prendre les 10 premiers caractères qui correspondent à "yyyy-MM-dd"
            if dateString.count >= 10 {
                let endIndex = dateString.index(dateString.startIndex, offsetBy: 10)
                let dateOnly = String(dateString[..<endIndex])
                
                // Convertir du format yyyy-MM-dd au format dd/MM/yyyy
                let components = dateOnly.split(separator: "-")
                if components.count == 3 {
                    return "\(components[2])/\(components[1])/\(components[0])"
                }
            }
            return dateString
        }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 15) {
                // Currency Code et Designation
                VStack(alignment: .leading, spacing: 4) {
                    Text(rate.code)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                    Text(rate.designation)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Rates
                HStack(spacing: 20) {
                    // Buying Rate
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Buy")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(rate.buyingRate)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.green)
                    }
                    
                    // Selling Rate
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Sell")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(rate.sellingRate)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // Date
            HStack {
                Text(formatDate(rate.date))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            Divider()
        }
        .background(Color.white)
    }
}

//
//  CurrencyDropdown.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
import SwiftUI

struct CurrencyDropdown: View {
    let title: String
    @Binding var selection: String
    let currencies: [String]
    
    var body: some View {
        Menu {
            ForEach(currencies, id: \.self) { currency in
                Button(action: {
                    selection = currency
                }) {
                    Text(currency)
                }
            }
        } label: {
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(selection)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

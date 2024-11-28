//
//  WalletRow.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//
import SwiftUI

struct WalletRow: View {
    var wallet: Wallet

    var body: some View {
        ZStack {
            if let cardImage = wallet.cardImage {
                Image(cardImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            }

            VStack(alignment: .leading) {
                Text(wallet.currency)
                    .font(.headline)
                    .foregroundColor(.white)

                Text("\(wallet.symbol)\(String(format: "%.2f", wallet.balance))")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct WalletRow_Previews: PreviewProvider {
    static var previews: some View {
        WalletRow(wallet: Wallet(
            currency: "Euro",
            balance: 1000.50,
            symbol: "€",
            transactions: [],
            cardImage: "card4"
        ))
    }
}

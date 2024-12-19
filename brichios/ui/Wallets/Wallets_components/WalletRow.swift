//
//  WalletRow.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//
import SwiftUI

struct WalletRow: View {
    var wallet: WalletSolana

    var body: some View {
        ZStack {
            Image("card4")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()

            VStack(alignment: .leading) {
                Text(wallet.currency)
                    .font(.headline)
                    .foregroundColor(.white)

                Text("\(String(format: "%.3f", wallet.balance)) SOL")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("\(String(format: "%.3f", wallet.originalAmount ?? 0.0))\(wallet.currency)")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}



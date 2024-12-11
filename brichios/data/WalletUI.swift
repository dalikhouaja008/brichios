//
//  WalletUI.swift
//  brichios
//
//  Created by Mac Mini 2 on 9/12/2024.
//

import Foundation
struct WalletUI {
    var wallets: [WalletSolana] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var convertedWallet: WalletSolana?
    var conversionError: String?
}

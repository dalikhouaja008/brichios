//
//  AlimentDialogView.swift
//  brichios
//
//  Created by Mac Mini 2 on 11/12/2024.
//

import Foundation
import SwiftUI

struct AlimentDialogView: View {
    @ObservedObject var walletsViewModel: WalletViewModel
    @ObservedObject var currencyConverterViewModel: CurrencyConverterViewModel
    
    @Environment(\.presentationMode) var presentationMode
    let selectedWalletCurrency: String
    
    @State private var dinarsAmount: String = ""
    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            HStack {
                Image(systemName: "wallet.pass")
                    .foregroundColor(Color(hex: 0x3D5AFE))
                Text("Fund your \(selectedWalletCurrency) Wallet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: 0x3D5AFE))
            }
            
            // Dinars Amount TextField
            TextField("Amount in Dinars", text: $dinarsAmount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding(.vertical, 8)
                .background(RoundedRectangle(cornerRadius: 8).stroke(dinarsAmount.isEmpty ? Color.red : Color.clear, lineWidth: 1))
                .padding(.horizontal)
                .onChange(of: dinarsAmount) { newValue in
                    if !newValue.isEmpty {
                        currencyConverterViewModel.calculateSellingRate(
                            currency: selectedWalletCurrency,
                            amount: newValue
                        )
                    } else {
                        currencyConverterViewModel.uiStateCurrency.convertedAmount = 0.0
                    }
                }
            
            // Converted Amount TextField
            Text("Converted Amount: \(currencyConverterViewModel.uiStateCurrency.convertedAmount, specifier: "%.2f")")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            // Conversion Progress Indicator
            if walletsViewModel.uiState.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: 0x3D5AFE)))
            }
            
            // Action Buttons
            HStack {
                Button("Cancel", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.bordered)
                
                Button("Apply") {
                    if let amount = Double(dinarsAmount), amount > 0 {
                        walletsViewModel.convertCurrency(
                            amount: currencyConverterViewModel.uiStateCurrency.convertedAmount,
                            fromCurrency: selectedWalletCurrency
                        )
                    } else {
                        alertMessage = "Invalid amount entered."
                        showErrorAlert = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(walletsViewModel.uiState.isLoading || dinarsAmount.isEmpty)
            }
        }
        .padding()

        // Handle Success & Error Alerts based on the ViewModel's UI State
        .onReceive(walletsViewModel.$uiState) { uiState in
            if let wallet = uiState.convertedWallet {
                alertMessage = "Conversion successful! New balance: \(wallet.balance) \(wallet.currency)"
                showSuccessAlert = true
            }
            
            if let error = uiState.conversionError {
                alertMessage = "Conversion failed: \(error)"
                showErrorAlert = true
            }
        }
        
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }

        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// Hex Color Extension
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}


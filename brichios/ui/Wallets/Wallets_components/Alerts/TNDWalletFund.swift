//
//  TNDWalletFund.swift
//  brichios
//
//  Created by Mac Mini 2 on 19/12/2024.
//

import Foundation
import SwiftUI
struct TNDWalletFund: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WalletViewModel
    @State private var amount: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create TND Wallet")) {
                    TextField("Amount in TND", text: $amount)
                        .keyboardType(.decimalPad)
                }
                                
                Section {
                    Button(action: createWallet) {
                        HStack {
                            if case .loading = viewModel.createWalletState {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text("Confirm")
                        }
                    }
                    .disabled(!isValidAmount || viewModel.createWalletState == .loading)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(isValidAmount ? Color.blue : Color.gray)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("Create TND Wallet")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .alert("Wallet Creation", isPresented: $showingAlert) {
                Button("OK") {
                    if case .success = viewModel.createWalletState {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
            .onChange(of: viewModel.createWalletState) { newState in
                handleStateChange(newState)
            }
        }
    }
    
    private var isValidAmount: Bool {
        guard let number = Double(amount) else { return false }
        return number > 0
    }
    
    private func createWallet() {
        guard let amount = Double(amount) else { return }
        viewModel.createTNDWallet(amount: amount)
    }
    
    private func handleStateChange(_ state: CreateTNDWalletState) {
        switch state {
        case .success(let wallet):
            alertMessage = "Wallet created successfully with \(String(format: "%.2f", wallet.originalAmount ?? 0.0)) TND"
            showingAlert = true
        case .error(let message):
            alertMessage = "Error: \(message)"
            showingAlert = true
        default:
            break
        }
    }
}



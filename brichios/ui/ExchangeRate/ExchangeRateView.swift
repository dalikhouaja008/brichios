

import Foundation
import SwiftUI

struct ExchangeRateView: View {
    @StateObject private var viewModel = ExchangeRateViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 5) {
                // Currency Conversion Card
                VStack(spacing: 16) {
                    // Exchange Rates List
                    VStack {
                        if viewModel.uiState.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.5)
                                .padding()
                        } else if let errorMessage = viewModel.uiState.errorMessage {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding()
                        } else if let rates = viewModel.uiState.exchangeRates {
                            ForEach(rates, id: \.code) { rate in
                                ExchangeRateRow(rate: rate)
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .padding(.top, -55)
            .navigationTitle("B-Rich")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchExchangeRates()
            }
        }
    }
    
}

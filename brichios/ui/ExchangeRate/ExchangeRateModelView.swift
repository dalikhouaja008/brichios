//
//  ExchangeRateModelView.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation

struct CurrencyUiState {
    var availableCurrencies = ["TND", "USD", "EUR", "GBP", "JPY", "SAR"]
    var fromCurrencyExpanded = false
    var toCurrencyExpanded = false
    var convertedAmount: Double = 0.0
    var fromCurrency: String = "USD"
    var toCurrency: String = "EUR"
    var amount: String = "0.0"
}

struct ExchangeRateUiState {
    var isLoading = false
    var exchangeRates: [ExchangeRate]?
    var errorMessage: String?
}

class ExchangeRateViewModel: ObservableObject {
    @Published var uiState = ExchangeRateUiState()
    @Published var uiStateCurrency = CurrencyUiState()
    
    private let repository = ExchangeRateRepository()
    
    func fetchExchangeRates() {
        uiState.isLoading = true
        Task {
            do {
                let rates = try await repository.fetchExchangeRates()
                DispatchQueue.main.async {
                    self.uiState.isLoading = false
                    self.uiState.exchangeRates = rates
                    //self.uiStateCurrency.availableCurrencies = rates.map($0.code)
                }
            } catch {
                DispatchQueue.main.async {
                    self.uiState.isLoading = false
                    self.uiState.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
 /*   func convertCurrency() {
        guard let rates = uiState.exchangeRates else { return }
        let result = repository.convertCurrency(
            amount: uiStateCurrency.amount,
            fromCurrency: uiStateCurrency.fromCurrency,
            toCurrency: uiStateCurrency.toCurrency,
            rates: rates
        )
        uiStateCurrency.convertedAmount = result
    }*/
    
    func toggleFromCurrencyDropdown() {
        uiStateCurrency.fromCurrencyExpanded.toggle()
        uiStateCurrency.toCurrencyExpanded = false
    }
}

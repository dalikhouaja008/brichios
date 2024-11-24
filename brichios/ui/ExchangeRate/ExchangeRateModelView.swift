//
//  ExchangeRateModelView.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation

struct CurrencyUiState {
    var isLoading = false
    var availableCurrencies = ["TND", "USD", "EUR", "GBP", "JPY", "SAR"]
    var fromCurrencyExpanded = false
    var toCurrencyExpanded = false
    var convertedAmount: Double = 0.0
    var fromCurrency: String = "TND"
    var toCurrency: String = "EUR"
    var amount: String = "0.0"
    var isTNDtoOtherCurrency : Bool = true
    var errorMessage: String?
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
    

    
    func toggleFromCurrencyDropdown() {
        uiStateCurrency.fromCurrencyExpanded.toggle()
        uiStateCurrency.toCurrencyExpanded = false
    }
    
    
     func formatConvertedAmount(_ amount: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2 // Ajustez si vous souhaitez afficher des décimales
            let formattedString = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
            
            // Limiter à 3 chiffres avant la virgule
            let components = formattedString.components(separatedBy: ".")
            if let integerPart = components.first, integerPart.count > 3 {
                let index = integerPart.index(integerPart.startIndex, offsetBy: 3)
                return String(integerPart[..<index]) + "..." + (components.count > 1 ? "." + components[1] : "")
            }
            
            return formattedString
        }
    
     func swapCurrencies() {
            let temp = uiStateCurrency.fromCurrency
            uiStateCurrency.fromCurrency = uiStateCurrency.toCurrency
            uiStateCurrency.toCurrency = temp
         print("Swapped: From \(self.uiStateCurrency.fromCurrency) To \(self.uiStateCurrency.toCurrency)")
        }
    
    
    
    
    func calculateSellingRate(currency: String, amount: String) {
        Task {
            await MainActor.run {
                self.uiStateCurrency.isLoading = true
            }
            do {
                let result = try await repository.getSellingRate(currency: currency, amount: amount)
                await MainActor.run {
                    self.uiStateCurrency.convertedAmount = result
                    self.uiStateCurrency.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.uiStateCurrency.errorMessage = error.localizedDescription
                    self.uiStateCurrency.isLoading = false
                }
            }
        }
    }
    
    func calculateBuyingRate(currency: String, amount: String) {
        Task {
            await MainActor.run {
                self.uiStateCurrency.isLoading = true
            }
            do {
                let result = try await repository.getBuyingRate(currency: currency, amount: amount)
                await MainActor.run {
                    self.uiStateCurrency.convertedAmount = result
                    self.uiStateCurrency.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.uiStateCurrency.errorMessage = error.localizedDescription
                    self.uiStateCurrency.isLoading = false
                }
            }
        }
    }
    
}

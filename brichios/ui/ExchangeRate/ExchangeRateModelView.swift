//
//  ExchangeRateModelView.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//

import Foundation
// News State
enum NewsState {
    case loading
    case success([NewsItem])
    case error(String)
}
class ExchangeRateViewModel: ObservableObject {
    @Published var uiState = ExchangeRateUiState()
    @Published var uiStateCurrency = CurrencyUiState()
    @Published var newsState: NewsState = .loading
    @Published var currentNewsPage = 0
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
    
    func fetchNews() {
           Task {
               do {
                   let news = try await repository.fetchNews()
                   DispatchQueue.main.async {
                       self.newsState = .success(news)
                   }
               } catch {
                   DispatchQueue.main.async {
                       self.newsState = .error(error.localizedDescription)
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
    
    
    
    
   
    
}

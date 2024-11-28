

import Foundation

enum PredictionLoadingError: Error {
    case networkFailure(Error)
    case emptyResponse
    case parsingError
}

class CurrencyConverterViewModel: ObservableObject {

     @Published var uiStateCurrency = CurrencyUiState()
      private let repository = CurrencyConverterRepository()
      @Published var predictions: [String: [PredictionData]] = [:]
      @Published var isLoadingPredictions = false
      

      
      // Load Predictions
    func loadPredictions(date: String, currencies: [String]) {
        guard !currencies.isEmpty else {
            print("No currencies specified for prediction")
            return
        }
        
        isLoadingPredictions = true
        
        Task {
            do {
                let response = try await repository.getCurrencyPredictions(date: date, currencies: currencies)
                
                guard !response.predictions.isEmpty else {
                    throw PredictionLoadingError.emptyResponse
                }
                
                await MainActor.run {
                    self.predictions = response.predictions
                    self.isLoadingPredictions = false
                    
                    // Structured logging
                    let currencyCount = response.predictions.count
                    let predictionDetails = response.predictions.mapValues { $0.count }
                    
                    print("""
                        Predictions Loaded Successfully:
                        - Total Currencies: \(currencyCount)
                        - Prediction Counts: \(predictionDetails)
                        - Start Date: \(response.start_date)
                        """)
                }
            } catch {
                await MainActor.run {
                    // More detailed error handling
                    switch error {
                    case let networkError as PredictionLoadingError:
                        switch networkError {
                        case .emptyResponse:
                            print("No predictions available for the specified currencies")
                        case .parsingError:
                            print("Failed to parse prediction data")
                        case .networkFailure(let underlyingError):
                            print("Network request failed: \(underlyingError.localizedDescription)")
                        }
                    default:
                        print("Unexpected error in loadPredictions: \(error.localizedDescription)")
                    }
                    
                    // Reset state on error
                    self.predictions = [:]
                    self.isLoadingPredictions = false
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

extension CurrencyConverterViewModel {
    func formatConvertedAmount(_ amount: Double?) -> String {
        guard let amount = amount else { return "N/A" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.currencyCode = uiStateCurrency.toCurrency
        
        // Try to get localized currency symbol
        switch uiStateCurrency.toCurrency {
        case "USD":
            formatter.currencySymbol = "$"
        case "EUR":
            formatter.currencySymbol = "€"
        case "GBP":
            formatter.currencySymbol = "£"
        case "TND":
            formatter.currencySymbol = "DT"
        default:
            formatter.currencySymbol = uiStateCurrency.toCurrency
        }
        
        return formatter.string(from: NSNumber(value: amount)) ?? "Error"
    }
}

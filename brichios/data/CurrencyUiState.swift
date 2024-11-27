struct CurrencyUiState {
    var isLoading = false
    var availableCurrencies = ["TND", "USD", "EUR", "GBP", "JPY", "SAR"]
    var fromCurrencyExpanded = false
    var toCurrencyExpanded = false
    var convertedAmount: Double = 0.0
    var fromCurrency: String = "TND"
    var toCurrency: String = "GBP"
    var amount: String = "0.0"
    var isTNDtoOtherCurrency : Bool = true
    var errorMessage: String?
}


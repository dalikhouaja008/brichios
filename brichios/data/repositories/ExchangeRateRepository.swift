//
//  ExchangeRateRepository.swift
//  brichios
//
//  Created by Mac Mini 2 on 20/11/2024.
//
import Alamofire
import Foundation
class ExchangeRateRepository {
    private let baseURL = "http://172.18.1.239:3000/"
    
    func fetchExchangeRates() async throws -> [ExchangeRate] {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request("http://172.18.1.239:3000/exchange-rate/scrapper")
                .responseDecodable(of: [ExchangeRate].self) { response in
                    switch response.result {
                    case .success(let rates):
                        continuation.resume(returning: rates)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
  /*  func convertCurrency(amount: Double, fromCurrency: String, toCurrency: String, rates: [ExchangeRate]) -> Double {
        guard let rate = rates.first(where: {
            $0.baseCurrency == fromCurrency && $0.targetCurrency == toCurrency
        }) else {
            return 0.0
        }
        return amount * rate.rate
    }*/
}

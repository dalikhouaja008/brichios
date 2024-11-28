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
        let url = baseURL + "exchange-rate"
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
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
    

}

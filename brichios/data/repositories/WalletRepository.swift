//
//  WalletRepository.swift
//  brichios
//
//  Created by Mac Mini 2 on 9/12/2024.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case unauthorized
    case networkFailure
}

enum TransactionError: Error {
    case unauthorized
    case networkFailure
    case invalidRequest
}

class WalletRepository {
    
    private let baseURL = "http://172.18.1.50:3000/"
    func sendTransaction(
            fromWalletPublicKey: String,
            toWalletPublicKey: String,
            amount: Double
        ) async throws -> String {
            let url = baseURL + "solana/transfer-between-wallets"
            
            guard let token = Auth.shared.getAccessToken() else {
                throw NetworkError.unauthorized
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            
            let parameters: [String: Any] = [
                "fromWalletPublicKey": fromWalletPublicKey,
                "toWalletPublicKey": toWalletPublicKey,
                "amount": amount
            ]
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseString { response in
                        switch response.result {
                        case .success(let signature):
                            print("Transaction sent successfully. Signature: \(signature)")
                            continuation.resume(returning: signature)
                        
                        case .failure(let error):
                            print("Transaction failed: \(error.localizedDescription)")
                            if let statusCode = response.response?.statusCode {
                                switch statusCode {
                                case 401:
                                    continuation.resume(throwing: NetworkError.unauthorized)
                                case 400...499:
                                    continuation.resume(throwing: TransactionError.invalidRequest)
                                default:
                                    continuation.resume(throwing: NetworkError.networkFailure)
                                }
                            } else {
                                continuation.resume(throwing: error)
                            }
                        }
                    }
            }
        }
    
    
    
    func getUserWallets() async throws -> [WalletSolana] {
        let url = baseURL + "solana/my-wallets"
        
        guard let token = Auth.shared.getAccessToken() else {
            throw NetworkError.unauthorized
        }
        
        print("Requesting wallets with token: \(token)")
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, headers: headers)
                .responseData { response in
                    
                    // Log the response code
                   /* if let statusCode = response.response?.statusCode {
                        print("Response Status Code: \(statusCode)")
                    }
                    
                    // Log the request body (if applicable)
                    if let requestBody = response.request?.httpBody,
                       let bodyString = String(data: requestBody, encoding: .utf8) {
                        print("Request Body: \(bodyString)")
                        
                    }*/
                    
                    switch response.result {
                    case .success(let data):
                        // Initialize JSONDecoder and set date decoding strategy
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        
                        do {
                            // Decode the data into [WalletSolana]
                            let wallets = try decoder.decode([WalletSolana].self, from: data)
                            continuation.resume(returning: wallets)
                        } catch {
                            print("Erreur de décodage : \(error)")
                            continuation.resume(throwing: error)
                        }
                        
                    case .failure(let error):
                        print("Error occurred: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    func convertCurrency(amount: Double, fromCurrency: String) async throws -> WalletSolana {
        let url = baseURL + "solana/convert-currency"
        
        guard let token = Auth.shared.getAccessToken() else {
            throw NetworkError.unauthorized
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        // Créer un dictionnaire JSON pour les paramètres
        let parameters: [String: Any] = [
            "amount": amount,
            "fromCurrency": fromCurrency
        ]
        
        // Effectuer la requête en envoyant les paramètres sous forme de JSON
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: WalletSolana.self) { response in
                    if let statusCode = response.response?.statusCode {
                        print("Response Status Code: \(statusCode)")
                    }
                    // Log the request body (if applicable)
                    if let requestBody = response.request?.httpBody,
                       let bodyString = String(data: requestBody, encoding: .utf8) {
                        print("Request Body: \(bodyString)")
                    }
                    switch response.result {
                    case .success(let wallet):
                        continuation.resume(returning: wallet)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

  }



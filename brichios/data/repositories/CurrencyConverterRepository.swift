//
//  CurrencyConverterRepository.swift
//  brichios
//
//  Created by Mac Mini 2 on 27/11/2024.
//
import Alamofire
import Foundation

class CurrencyConverterRepository{
    private let baseURL = "http://172.18.1.239:3000/"
    
    func getCurrencyPredictions(date: String, currencies: [String]) async throws -> PredictionResponse {
        let url = baseURL + "prediction/create-prediction"
        let request = PredictionRequest(date: date, currencies: currencies)
        
        print("Appel de l'URL: \(url)")
        print("Paramètres de la requête: \(request)")
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url,
                       method: .post,
                       parameters: request,
                       encoder: JSONParameterEncoder.default)
                .responseDecodable(of: PredictionResponse.self) { response in
                    
                    // Log the HTTP response details
                    if let httpResponse = response.response {
                        print("Status code: \(httpResponse.statusCode)")
                        print("Headers: \(httpResponse.allHeaderFields)")
                    } else {
                        print("Réponse non HTTP")
                    }
                    
                    // Log the raw response data
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print("Réponse brute: \(responseString)")
                    }
                    
                    switch response.result {
                    case .success(let predictionResponse):
                        continuation.resume(returning: predictionResponse)
                    case .failure(let error):
                        // Use proper error logging
                        print("Error retrieving predictions: \(error.localizedDescription)")
                        
                        // Optionally log the underlying response if available
                        if let data = response.data {
                            let errorResponseString = String(data: data, encoding: .utf8) ?? "No error data"
                            print("Données d'erreur reçues : \(errorResponseString)")
                        }
                        
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    func getSellingRate(currency: String, amount: String) async throws -> Double {
        guard let url = URL(string: "\(baseURL)exchange-rate/sellingRate/\(currency)/\(amount)") else {
            print("URL invalide: \(baseURL)/sellingRate/\(currency)/\(amount)")
            throw URLError(.badURL)
        }
        
        print("Appel de l'URL: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Réponse non HTTP")
            throw URLError(.badServerResponse)
        }
        
        print("Status code: \(httpResponse.statusCode)")
        print("Headers: \(httpResponse.allHeaderFields)")
        
        // Imprimons la réponse brute
        if let responseString = String(data: data, encoding: .utf8) {
            print("Réponse brute: \(responseString)")
        }
        
        guard httpResponse.statusCode == 200 else {
            print("Status code incorrect: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }
        
        // Essayons plusieurs approches de décodage
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(Double.self, from: data)
            print("Décodage réussi: \(result)")
            return result
        } catch {
            print("Erreur de décodage JSON: \(error)")
            
            // Essayons de décoder comme une chaîne
            if let stringValue = String(data: data, encoding: .utf8) {
                print("Valeur en tant que chaîne: \(stringValue)")
                if let doubleValue = Double(stringValue.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    print("Conversion en Double réussie: \(doubleValue)")
                    return doubleValue
                }
            }
            
            throw error
        }
    }
     
     func getBuyingRate(currency: String, amount: String) async throws -> Double {
         guard let url = URL(string: "\(baseURL)exchange-rate/buyingRate/\(currency)/\(amount)") else {
             throw URLError(.badURL)
         }
         
         let (data, response) = try await URLSession.shared.data(from: url)
         
         guard let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode == 200 else {
             throw URLError(.badServerResponse)
         }
         
         return try JSONDecoder().decode(Double.self, from: data)
     }
    
    
}

import Foundation
import Combine

class AccountsAPI {
    static let shared = AccountsAPI()
    private let baseURL = "http://172.18.1.239:3000" // Replace with your actual API base URL
    
    private init() {}
    
    func findByRIB(rib: String, token: String) -> AnyPublisher<Account, Error> {
        let url = URL(string: "\(baseURL)/accounts/rib/\(rib)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .mapError { error -> Error in
                return error
            }
            .map(\.data)
            .decode(type: Account.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func updateNickname(rib: String, nickname: String, token: String) -> AnyPublisher<Void, Error> {
        let url = URL(string: "\(baseURL)/accounts/update")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "rib": rib,
            "nickname": nickname
        ]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .mapError { error -> Error in
                return error
            }
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}



struct APIError: LocalizedError {
    let message: String
    
    var errorDescription: String? {
        return message
    }
}

import Alamofire
import Combine

class AccountRepository {
    static let shared = AccountRepository()
    private let baseURL = "http://172.18.1.239:3000"
    
    private init() {}
    
    // Find account by RIB (using Combine)
    func findByRIB(rib: String) -> AnyPublisher<Account, Error> {
        let url = "\(baseURL)/accounts/rib/\(rib)"
        
        return AF.request(url)
            .validate()
            .publishDecodable(type: Account.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // Update nickname (using Combine)
    func updateNickname(rib: String, nickname: String) -> AnyPublisher<Account, Error> {
        let url = "\(baseURL)/accounts/rib/\(rib)/nickname"
        let parameters: [String: String] = ["nickname": nickname]
        
        return AF.request(url,
                         method: .patch,
                         parameters: parameters,
                         encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: Account.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    // Check account existence
    func checkAccountExistence(rib: String, completion: @escaping (Result<Account?, Error>) -> Void) {
        let url = "\(baseURL)/accounts/rib/\(rib)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: Account.self) { response in
                switch response.result {
                case .success(let account):
                    completion(.success(account))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Update account
    func updateAccount(accountData: Account) -> AnyPublisher<Account, Error> {
        let url = "\(baseURL)/accounts/update"
        
        return AF.request(url,
                         method: .put,
                         parameters: accountData,
                         encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: Account.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

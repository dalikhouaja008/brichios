import Alamofire

class AccountRepository {
    
    static let shared = AccountRepository()
    
    private init() {}
    
    private let baseURL = "http://172.18.1.239:3000"  // Replace with your actual API URL
    
    // MARK: - Methods
      
    // 1. Check if the account exists based on the RIB
    func checkAccountExistence(rib: String, completion: @escaping (Result<Account?, Error>) -> Void) {
        let url = "\(baseURL)/accounts/rib/\(rib)"
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: Account.self) { response in
                switch response.result {
                case .success(let account):
                    completion(.success(account))  // Account found, return account data
                case .failure(let error):
                    completion(.failure(error))  // Handle error if account is not found or request fails
                }
            }
    }
    
    // 2. Update the nickname for the account
    func updateNickname(rib: String, nickname: String, completion: @escaping (Result<Account, Error>) -> Void) {
        let url = "\(baseURL)/accounts/rib/\(rib)/nickname"
        let parameters: [String: Any] = ["nickname": nickname]
        
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: Account.self) { response in
                switch response.result {
                case .success(let updatedAccount):
                    completion(.success(updatedAccount))  // Return updated account
                case .failure(let error):
                    completion(.failure(error))  // Handle error
                }
            }
    }
    
    // 3. Send OTP to the user's email
    func sendOtpToEmail(email: String, otp: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "\(baseURL)/accounts/send-otp"
        let parameters: [String: Any] = ["email": email, "otp": otp]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(true))  // OTP sent successfully
                case .failure(let error):
                    completion(.failure(error))  // Handle error
                }
            }
    }
    
    // 4. Update the account (after OTP validation)
    func updateAccount(accountData: [String: Any], completion: @escaping (Result<Account, Error>) -> Void) {
        let url = "\(baseURL)/accounts/update"
        
        AF.request(url, method: .put, parameters: accountData, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: Account.self) { response in
                switch response.result {
                case .success(let updatedAccount):
                    completion(.success(updatedAccount))  // Return the updated account data
                case .failure(let error):
                    completion(.failure(error))  // Handle error
                }
            }
    }
}

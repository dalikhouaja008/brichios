import Alamofire

protocol ApiService{
    
 
    
    func createUser(user : User, completion: @escaping (Result<User, Error>)->Void)
    func login(request : LoginRequest, completion: @escaping (Result<LoginResponse,Error>)->Void)
    func loginWithBiometric(request : LoginRequest, completion: @escaping (Result<LoginResponse, Error>)->Void)
    func fetchExchangeRates() async throws -> [ExchangeRate]
    
    
}

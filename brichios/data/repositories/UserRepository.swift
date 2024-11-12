
import Alamofire

class UserRepository : ApiService {
    private let baseURL = "http://172.18.1.239:3000/"

        func createUser(user: User, completion: @escaping (Result<User, Error>) -> Void) {
            let url = baseURL + "auth/signup"
            AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case .success(let createdUser):
                        completion(.success(createdUser))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }

        func login(request: LoginRequest, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
            let url = baseURL + "auth/login"
            AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success(let loginResponse):
                        completion(.success(loginResponse))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }

        func loginWithBiometric(request: LoginRequest, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
            let url = baseURL + "auth/loginwithbiometric"
            AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default)
                .responseDecodable(of: LoginResponse.self) { response in
                    switch response.result {
                    case .success(let loginResponse):
                        completion(.success(loginResponse))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
}




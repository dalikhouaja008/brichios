
import Alamofire
import Foundation


struct ForgotPasswordRequest: Encodable {
    let email: String
}

class UserRepository  {
    
    private let baseURL = "http://172.18.1.50:3000/"

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
        AF.request(url,
                          method: .post,
                          parameters: request,
                          encoder: JSONParameterEncoder.default)
                    .responseData { response in
                        // Debug: Imprime la réponse brute
                        if let data = response.data, let str = String(data: data, encoding: .utf8) {
                            print("Raw server response: \(str)")
                        }
                        
                        switch response.result {
                        case .success(let data):
                            do {
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase // Si votre API utilise snake_case
                                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                                completion(.success(loginResponse))
                            } catch {
                                print("Decoding error: \(error)")
                                completion(.failure(error))
                            }
                            
                        case .failure(let error):
                            print("Network error: \(error)")
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
    func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
          let url = baseURL + "auth/forgot-password"
          
          let request = ForgotPasswordRequest(email: email)
          
          AF.request(url,
                    method: .post,
                    parameters: request,
                    encoder: JSONParameterEncoder.default)
              .responseData { response in
                  // Debug logging
                  if let data = response.data, let str = String(data: data, encoding: .utf8) {
                      print("Raw server response: \(str)")
                  }
                  
                  switch response.result {
                  case .success:
                      completion(.success(()))
                  case .failure(let error):
                      print("Network error: \(error)")
                      completion(.failure(error))
                  }
              }
      }
    }





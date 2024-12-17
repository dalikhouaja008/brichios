import Foundation

// The Account model will represent the data structure of the account
struct Account: Codable {
    let id: String
    let rib: String
    let nickname: String?
    // Add other fields as needed
}

struct AccountUpdateRequest: Codable {
    let rib: String
    let nickname: String
}

struct AccountResponse: Codable {
    let status: String
    let message: String
    let data: Account
}


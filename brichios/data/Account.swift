import Foundation

// The Account model will represent the data structure of the account
class Account: Codable {
    var number: String
    var type: String
    var nickname: String?
    var status: String
    var rib: String
    var isDefault: Bool
    var balance: Double
    
    // Initializer for Account model
    init(number: String, type: String, nickname: String?, status: String, rib: String, isDefault: Bool, balance: Double) {
        self.number = number
        self.type = type
        self.nickname = nickname
        self.status = status
        self.rib = rib
        self.isDefault = isDefault
        self.balance = balance
    }
    
    // You can also implement the coding keys for custom mapping if needed
    enum CodingKeys: String, CodingKey {
        case number
        case type
        case nickname
        case status
        case rib
        case isDefault
        case balance
    }
}


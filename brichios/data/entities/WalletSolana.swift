import Foundation


struct WalletSolana: Identifiable, Codable {
    let id: String
    let userId: String
    let publicKey: String
    let privateKey: String
    let type: String
    let network: String
    let balance: Double
    let currency: String
    let originalAmount: Double
    let createdAt: String

    
    // Mapping des clés JSON vers les noms de propriétés Swift
    enum CodingKeys: String, CodingKey {
        case id = "_id" // Mapping pour MongoDB ID
        case userId
        case publicKey
        case privateKey
        case type
        case network
        case balance
        case currency
        case originalAmount
        case createdAt
    }
}

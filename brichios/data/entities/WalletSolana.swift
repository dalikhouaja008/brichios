import Foundation


struct WalletSolana: Identifiable, Codable, Equatable {
    // Implémentation de Equatable
     static func == (lhs: WalletSolana, rhs: WalletSolana) -> Bool {
         return lhs.id == rhs.id
     }
    
    let id: String
    let userId: String
    let publicKey: String?
    let type: String?
    let network: String?
    let balance: Double
    let currency: String
    let originalAmount: Double?
    var transactions: [SolanaTransaction]?
    var onchainTransactions: [SolanaTransaction]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case publicKey
        case type
        case network
        case balance
        case currency
        case originalAmount
        case transactions
        case onchainTransactions
    }
}

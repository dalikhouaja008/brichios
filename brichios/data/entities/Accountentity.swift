import Foundation

struct AccountEntity: Identifiable {
    let id = UUID()
    var nickname: String
    var number: String
    var type: String
}

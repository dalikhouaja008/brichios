import Foundation

struct CustomAccount: Identifiable {
    let id = UUID()
    var name: String
    var balance: Double
    var isDefault: Bool
}




import Foundation
struct PredictionData: Identifiable, Codable {
    let id = UUID()  // Génère automatiquement un identifiant unique
    let date: String // La date reste en tant que chaîne
    let value: Double

    enum CodingKeys: String, CodingKey {
        case date
        case value
    }
}

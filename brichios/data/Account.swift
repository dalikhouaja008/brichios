import Foundation

struct Account: Codable, Identifiable {
    // Remove ObjectIdentifier as it's not needed
    private let _id: String
    let rib: String
    let nickname: String?
    
    // Implement id property for Identifiable conformance
    var id: String { _id }
    
    private enum CodingKeys: String, CodingKey {
        case _id = "id"
        case rib
        case nickname
    }
    
    // Add custom init(from:) for Decodable conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        rib = try container.decode(String.self, forKey: .rib)
        nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
    }
    
    // Add encode(to:) for Encodable conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(rib, forKey: .rib)
        try container.encodeIfPresent(nickname, forKey: .nickname)
    }
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

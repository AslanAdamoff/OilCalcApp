import Foundation

public struct DualResult: Codable, Identifiable {
    public let id: UUID
    public let at15: Double
    public let atT: Double
    
    // Optional for backward compatibility
    public let density15: Double?
    public let densityT: Double?

    public var difference: Double {
        atT - at15
    }

    public var percentDifference: Double {
        guard at15 != 0 else { return 0 }
        return (difference / at15) * 100
    }
    
    public init(id: UUID = UUID(), at15: Double, atT: Double, density15: Double? = nil, densityT: Double? = nil) {
        self.id = id
        self.at15 = at15
        self.atT = atT
        self.density15 = density15
        self.densityT = densityT
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, at15, atT, density15, densityT
    }
}


import Foundation

/// Режим ввода плотности
public enum DensityMode: String, Codable, CaseIterable {
    case atTemperature = "atTemperature"  // Плотность при фактической температуре
    case at15 = "at15"                     // Плотность при 15°C
    
    public var displayName: String {
        switch self {
        case .at15:
            return "density.at15".localized()
        case .atTemperature:
            return "density.atTemperature".localized()
        }
    }
    
    public var shortName: String {
        switch self {
        case .atTemperature:
            return "ρT"
        case .at15:
            return "ρ15"
        }
    }
}

/// Результат расчёта для одной точки (A или B)
public struct PointResult: Codable, Identifiable {
    public let id: UUID
    
    /// Масса фактическая (кг)
    public let massKg: Double
    
    /// Плотность при 15°C (кг/л)
    public let density15: Double
    
    /// Плотность при фактической температуре (кг/л)
    public let densityT: Double
    
    /// Фактическая температура (°C)
    public let temperature: Double
    
    /// Объём при 15°C (л)
    public let v15Liters: Double
    
    /// Объём при фактической температуре (л)
    public let vFactLiters: Double
    
    public init(
        id: UUID = UUID(),
        massKg: Double,
        density15: Double,
        densityT: Double,
        temperature: Double,
        v15Liters: Double,
        vFactLiters: Double
    ) {
        self.id = id
        self.massKg = massKg
        self.density15 = density15
        self.densityT = densityT
        self.temperature = temperature
        self.v15Liters = v15Liters
        self.vFactLiters = vFactLiters
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, massKg, density15, densityT, temperature, v15Liters, vFactLiters
    }
}

/// Результат расчёта потерь при транспортировке A → B
public struct TripResult: Codable, Identifiable {
    public let id: UUID
    public let A: PointResult
    public let B: PointResult
    
    /// Разница массы (кг) = B - A
    public var deltaMassKg: Double {
        B.massKg - A.massKg
    }
    
    /// Разница массы в процентах
    public var deltaMassPercent: Double {
        guard A.massKg != 0 else { return 0 }
        return (deltaMassKg / A.massKg) * 100
    }
    
    /// Разница объёма при 15°C (л) = B - A
    public var deltaV15: Double {
        B.v15Liters - A.v15Liters
    }
    
    /// Разница объёма при фактической температуре (л) = B - A
    public var deltaVFact: Double {
        B.vFactLiters - A.vFactLiters
    }
    
    /// Разница объёма при 15°C в процентах
    public var deltaV15Percent: Double {
        guard A.v15Liters != 0 else { return 0 }
        return (deltaV15 / A.v15Liters) * 100
    }
    
    /// Разница объёма при фактической температуре в процентах
    public var deltaVFactPercent: Double {
        guard A.vFactLiters != 0 else { return 0 }
        return (deltaVFact / A.vFactLiters) * 100
    }
    
    public init(id: UUID = UUID(), A: PointResult, B: PointResult) {
        self.id = id
        self.A = A
        self.B = B
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, A, B
    }
}


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

/// Модель данных для одной точки маршрута (ввод пользователя)
public struct TripPoint: Identifiable, Codable {
    public var id: UUID
    public var name: String
    public var mass: String        // String для байндинга с TextField
    public var density: String     // String для байндинга с TextField
    public var temperature: String // String для байндинга с TextField
    public var densityMode: DensityMode
    
    public init(
        id: UUID = UUID(),
        name: String = "",
        mass: String = "",
        density: String = "",
        temperature: String = "",
        densityMode: DensityMode = .at15
    ) {
        self.id = id
        self.name = name
        self.mass = mass
        self.density = density
        self.temperature = temperature
        self.densityMode = densityMode
    }
}

/// Шаблон маршрута
public struct TripTemplate: Identifiable, Codable {
    public var id: UUID
    public var name: String
    public var points: [TripPoint]
    public var productType: ProductType
    
    public init(id: UUID = UUID(), name: String, points: [TripPoint], productType: ProductType) {
        self.id = id
        self.name = name
        self.points = points
        self.productType = productType
    }
}

/// Результат расчёта для одной точки (A или B)
public struct PointResult: Codable, Identifiable {
    public let id: UUID
    public let name: String // Added name property
    
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
        name: String = "",
        massKg: Double,
        density15: Double,
        densityT: Double,
        temperature: Double,
        v15Liters: Double,
        vFactLiters: Double
    ) {
        self.id = id
        self.name = name
        self.massKg = massKg
        self.density15 = density15
        self.densityT = densityT
        self.temperature = temperature
        self.v15Liters = v15Liters
        self.vFactLiters = vFactLiters
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, massKg, density15, densityT, temperature, v15Liters, vFactLiters
    }
}



/// Результат сравнения (дельта) между двумя точками
public struct TripDelta: Codable {
    /// Разница массы (кг)
    public let massKg: Double
    /// Разница массы в процентах
    public let massPercent: Double
    
    /// Разница объёма при 15°C (л)
    public let v15: Double
    /// Разница объёма при 15°C в процентах
    public let v15Percent: Double
    
    /// Разница объёма при факт. температуре (л)
    public let vFact: Double
    /// Разница объёма при факт. температуре в процентах
    public let vFactPercent: Double
    
    public init(from: PointResult, to: PointResult) {
        self.massKg = to.massKg - from.massKg
        self.massPercent = from.massKg != 0 ? (self.massKg / from.massKg) * 100 : 0
        
        self.v15 = to.v15Liters - from.v15Liters
        self.v15Percent = from.v15Liters != 0 ? (self.v15 / from.v15Liters) * 100 : 0
        
        self.vFact = to.vFactLiters - from.vFactLiters
        self.vFactPercent = from.vFactLiters != 0 ? (self.vFact / from.vFactLiters) * 100 : 0
    }
}

/// Сегмент маршрута (между двумя соседними точками)
public struct TripSegment: Identifiable, Codable {
    public let id: UUID
    public let fromPoint: PointResult
    public let toPoint: PointResult
    public let delta: TripDelta
    
    public init(from: PointResult, to: PointResult) {
        self.id = UUID()
        self.fromPoint = from
        self.toPoint = to
        self.delta = TripDelta(from: from, to: to)
    }
}

/// Результат расчёта потерь для всего маршрута
public struct TripResult: Codable, Identifiable {
    public let id: UUID
    
    /// Рассчитанные результаты для всех точек
    public let points: [PointResult]
    
    /// Дельта для всего маршрута (Первая точка -> Последняя точка)
    public let totalDelta: TripDelta
    
    /// Детализация по сегментам (1->2, 2->3, и т.д.)
    public let segments: [TripSegment]
    
    /// Compatibility with legacy code (A = first point, B = last point)
    /// Uses safe defaults instead of force-unwrap to prevent crashes
    private static let emptyPoint = PointResult(massKg: 0, density15: 0, densityT: 0, temperature: 0, v15Liters: 0, vFactLiters: 0)
    public var A: PointResult { points.first ?? Self.emptyPoint }
    public var B: PointResult { points.last ?? Self.emptyPoint }
    
    // Совместимость свойств для TripResultView (читают из totalDelta)
    public var deltaMassKg: Double { totalDelta.massKg }
    public var deltaMassPercent: Double { totalDelta.massPercent }
    public var deltaV15: Double { totalDelta.v15 }
    public var deltaV15Percent: Double { totalDelta.v15Percent }
    public var deltaVFact: Double { totalDelta.vFact }
    public var deltaVFactPercent: Double { totalDelta.vFactPercent }
    
    public init(id: UUID = UUID(), points: [PointResult]) {
        self.id = id
        self.points = points
        
        guard let first = points.first, let last = points.last, points.count >= 2 else {
            // Fallback для пустых или одиночных точек (не должно случаться при корректной валидации)
            self.totalDelta = TripDelta(from: PointResult(massKg: 0, density15: 0, densityT: 0, temperature: 0, v15Liters: 0, vFactLiters: 0), to: PointResult(massKg: 0, density15: 0, densityT: 0, temperature: 0, v15Liters: 0, vFactLiters: 0))
            self.segments = []
            return
        }
        
        self.totalDelta = TripDelta(from: first, to: last)
        
        var parsedSegments: [TripSegment] = []
        for i in 0..<(points.count - 1) {
            let segment = TripSegment(from: points[i], to: points[i+1])
            parsedSegments.append(segment)
        }
        self.segments = parsedSegments
    }
    
    // Legacy init support (для совместимости с тестами и старым кодом, если где-то остался)
    public init(id: UUID = UUID(), A: PointResult, B: PointResult) {
        self.init(id: id, points: [A, B])
    }
}


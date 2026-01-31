import Foundation

/// Тип расчёта
public enum CalculationType: String, Codable {
    case mainCalc = "mainCalc"      // Базовый калькулятор
    case tripCalc = "tripCalc"      // Анализ потерь
    
    public var displayName: String {
        switch self {
        case .mainCalc:
            return "mainScreen.mainCalc".localized()
        case .tripCalc:
            return "mainScreen.tripCalc".localized()
        }
    }
}

/// Запись в истории расчётов
public struct HistoryEntry: Codable, Identifiable {
    public let id: UUID
    public let date: Date
    public let type: CalculationType
    
    // Для базового калькулятора
    public let dualResult: DualResult?
    
    // Для анализа потерь
    public let tripResult: TripResult?
    
    // Параметры для отображения
    public let parameters: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case id, date, type, dualResult, tripResult, parameters
    }
    
    public init(
        id: UUID = UUID(),
        type: CalculationType,
        dualResult: DualResult? = nil,
        tripResult: TripResult? = nil,
        parameters: [String: String] = [:]
    ) {
        self.id = id
        self.date = Date()
        self.type = type
        self.dualResult = dualResult
        self.tripResult = tripResult
        self.parameters = parameters
    }
}


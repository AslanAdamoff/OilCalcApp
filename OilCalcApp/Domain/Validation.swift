import Foundation

public enum ValidationError: LocalizedError {
    case empty(String)
    case notNumber(String)
    case outOfRange(String, min: Double?, max: Double?)
    
    public var errorDescription: String? {
        switch self {
        case .empty(let field):
            return "validation.empty".localized(field)
        case .notNumber(let field):
            return "validation.notNumber".localized(field)
        case .outOfRange(let field, let min, let max):
            if let min = min, let max = max {
                return "validation.outOfRange".localized(field, formatNumber(min), formatNumber(max))
            } else if let min = min {
                return "validation.outOfRangeMin".localized(field, formatNumber(min))
            } else if let max = max {
                return "validation.outOfRangeMax".localized(field, formatNumber(max))
            }
            return "validation.outOfRange".localized(field)
        }
    }
    
    private func formatNumber(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.2f", value)
        }
    }
}

public enum Validator {
    /// Валидация числа из строки
    /// - Parameters:
    ///   - text: Текст для парсинга
    ///   - field: Название поля (для ошибок)
    /// - Returns: Распарсенное число
    /// - Throws: ValidationError
    public static func number(_ text: String, field: String) throws -> Double {
        let clean = text.replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        guard !clean.isEmpty else {
            throw ValidationError.empty(field)
        }
        guard let value = Double(clean) else {
            throw ValidationError.notNumber(field)
        }
        return value
    }
    
    /// Валидация числа с диапазоном
    /// - Parameters:
    ///   - text: Текст для парсинга
    ///   - field: Название поля
    ///   - min: Минимальное значение (nil = без ограничения)
    ///   - max: Максимальное значение (nil = без ограничения)
    /// - Returns: Распарсенное число
    /// - Throws: ValidationError
    public static func number(
        _ text: String,
        field: String,
        min: Double? = nil,
        max: Double? = nil
    ) throws -> Double {
        let value = try number(text, field: field)
        
        if let min = min, value < min {
            throw ValidationError.outOfRange(field, min: min, max: max)
        }
        
        if let max = max, value > max {
            throw ValidationError.outOfRange(field, min: min, max: max)
        }
        
        return value
    }
    
    /// Валидация плотности (0.60 - 1.10 кг/л)
    public static func density(_ text: String, field: String) throws -> Double {
        return try number(text, field: field, min: 0.60, max: 1.10)
    }
    
    /// Валидация температуры (-50 - +80°C)
    public static func temperature(_ text: String, field: String) throws -> Double {
        return try number(text, field: field, min: -50.0, max: 80.0)
    }
    
    /// Валидация массы (без ограничений)
    public static func mass(_ text: String, field: String) throws -> Double {
        let value = try number(text, field: field)
        // Проверяем только на положительность
        guard value > 0 else {
            throw ValidationError.outOfRange(field, min: 0.0, max: nil)
        }
        return value
    }
}


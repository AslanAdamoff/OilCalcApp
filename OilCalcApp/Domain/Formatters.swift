import Foundation

public enum ResultFormatters {
    
    /// Форматтер для массы (2 знака после запятой)
    public static let mass: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = " "
        return formatter
    }()
    
    /// Форматтер для объёма (2 знака после запятой)
    public static let volume: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = " "
        return formatter
    }()
    
    /// Форматтер для процентов (2 знака после запятой)
    public static let percent: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.positivePrefix = "+"
        return formatter
    }()
    
    /// Форматтер для плотности (3 знака после запятой)
    public static let density: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    /// Форматтер для температуры (1 знак после запятой)
    public static let temperature: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    // MARK: - Форматированные строки
    
    /// Отформатированная масса (кг)
    public static func formattedMass(_ value: Double) -> String {
        guard let formatted = mass.string(from: NSNumber(value: value)) else {
            return String(format: "%.2f", value)
        }
        return formatted
    }
    
    /// Отформатированный объём (л)
    public static func formattedVolume(_ value: Double) -> String {
        guard let formatted = volume.string(from: NSNumber(value: value)) else {
            return String(format: "%.2f", value)
        }
        return formatted
    }
    
    /// Отформатированный процент
    public static func formattedPercent(_ value: Double) -> String {
        guard let formatted = percent.string(from: NSNumber(value: value)) else {
            return String(format: "%.2f", value)
        }
        return formatted
    }
    
    /// Отформатированная плотность (кг/л)
    public static func formattedDensity(_ value: Double) -> String {
        guard let formatted = density.string(from: NSNumber(value: value)) else {
            return String(format: "%.3f", value)
        }
        return formatted
    }
    
    /// Отформатированная температура (°C)
    public static func formattedTemperature(_ value: Double) -> String {
        guard let formatted = temperature.string(from: NSNumber(value: value)) else {
            return String(format: "%.1f", value)
        }
        return formatted
    }
}


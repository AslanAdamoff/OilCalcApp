import Foundation

public class HistoryService {
    
    public static let shared = HistoryService()
    
    private let fileName = "history.json"
    
    private var historyFileURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = appSupport.appendingPathComponent("OilCalcApp", isDirectory: true)
        
        // Создаём директорию, если её нет
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        
        return directory.appendingPathComponent(fileName)
    }
    
    private init() {}
    
    /// Загрузить историю
    public func loadHistory() -> [HistoryEntry] {
        guard FileManager.default.fileExists(atPath: historyFileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: historyFileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([HistoryEntry].self, from: data)
        } catch {
            print("Ошибка загрузки истории: \(error)")
            return []
        }
    }
    
    /// Сохранить историю
    public func saveHistory(_ entries: [HistoryEntry]) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(entries)
            try data.write(to: historyFileURL)
        } catch {
            print("Ошибка сохранения истории: \(error)")
        }
    }
    
    /// Добавить запись в историю
    public func addEntry(_ entry: HistoryEntry) {
        var history = loadHistory()
        history.insert(entry, at: 0) // Добавляем в начало
        saveHistory(history)
    }
    
    /// Удалить запись из истории
    public func removeEntry(id: UUID) {
        var history = loadHistory()
        history.removeAll { $0.id == id }
        saveHistory(history)
    }
    
    /// Очистить всю историю
    public func clearHistory() {
        saveHistory([])
    }
}


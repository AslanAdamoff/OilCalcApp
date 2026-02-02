import Foundation

class TemplateService {
    static let shared = TemplateService()
    
    private let key = "saved_trip_templates"
    
    // MARK: - CRUD
    
    func saveTemplate(_ template: TripTemplate) {
        var templates = loadTemplates()
        // Если шаблон с таким ID уже есть, обновляем его
        if let index = templates.firstIndex(where: { $0.id == template.id }) {
            templates[index] = template
        } else {
            templates.append(template)
        }
        persist(templates)
    }
    
    func loadTemplates() -> [TripTemplate] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        
        do {
            let templates = try JSONDecoder().decode([TripTemplate].self, from: data)
            return templates
        } catch {
            print("Failed to load templates: \(error)")
            return []
        }
    }
    
    func deleteTemplate(id: UUID) {
        var templates = loadTemplates()
        templates.removeAll { $0.id == id }
        persist(templates)
    }
    
    // MARK: - Private
    
    private func persist(_ templates: [TripTemplate]) {
        do {
            let data = try JSONEncoder().encode(templates)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save templates: \(error)")
        }
    }
}

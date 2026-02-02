import SwiftUI
import Combine

class TripCalcViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var points: [TripPoint] = []
    @Published var productType: ProductType = .refined
    
    // Output
    @Published var result: TripResult?
    @Published var errorMessage: String?
    @Published var showError = false
    
    // Templates
    @Published var savedTemplates: [TripTemplate] = []
    @Published var showTemplateMenu = false
    
    private let templateService = TemplateService.shared
    
    init() {
        // Initialize with 2 default points (A and B like before)
        resetToDefault()
        loadTemplates()
    }
    
    // MARK: - Point Management
    
    func resetToDefault() {
        points = [
            TripPoint(name: "tripCalc.pointA".localized(), mass: "", density: "", temperature: "", densityMode: .at15),
            TripPoint(name: "tripCalc.pointB".localized(), mass: "", density: "", temperature: "", densityMode: .at15)
        ]
        result = nil
    }
    
    func addPoint() {
        let newPointIndex = points.count + 1
        points.append(TripPoint(name: "Point \(newPointIndex)", mass: "", density: "", temperature: "", densityMode: .at15))
    }
    
    func removePoint(at offsets: IndexSet) {
        points.remove(atOffsets: offsets)
        // Ensure at least 2 points remain or handle UI gracefully?
        // Let's allow deleting down to 0, but UI should probably prompt to add if < 2
    }
    
    func updatePoint(_ point: TripPoint) {
        if let index = points.firstIndex(where: { $0.id == point.id }) {
            points[index] = point
        }
    }
    
    // MARK: - Logic
    
    func calculate() {
        errorMessage = nil
        
        // Ensure at least 2 points
        guard points.count >= 2 else {
            errorMessage = "Calculation requires at least 2 points"
            showError = true
            triggerErrorHaptic()
            return
        }
        
        do {
            // Validation loop
            for (_, point) in points.enumerated() {
                // Ensure commas are replaced by dots (handled in binding usually, but good to be safe)
                // Actually, let's trust the TripPoint string values are raw input.
                // We validate them here.
                let _ = try Validator.mass(point.mass, field: "Mass (\(point.name))")
                let _ = try Validator.density(point.density, field: "Density (\(point.name))")
                let _ = try Validator.temperature(point.temperature, field: "Temperature (\(point.name))")
            }
            
            // Calculation
            let calcResult = TripLossCalculator.calculate(points: points, product: productType)
            
            result = calcResult
            triggerSuccessHaptic()
            
            // Save History (Updated for N points)
            saveHistory(result: calcResult)
            
        } catch let error as ValidationError {
            errorMessage = error.errorDescription
            showError = true
            triggerErrorHaptic()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            triggerErrorHaptic()
        }
    }
    
    // MARK: - Template Management
    
    func saveTemplate(name: String) {
        let template = TripTemplate(name: name, points: points, productType: productType)
        templateService.saveTemplate(template)
        loadTemplates() // Refresh list
    }
    
    func loadTemplates() {
        savedTemplates = templateService.loadTemplates()
    }
    
    func loadTemplate(_ template: TripTemplate) {
        self.points = template.points
        self.productType = template.productType
        self.result = nil
    }
    
    func deleteTemplate(_ template: TripTemplate) {
        templateService.deleteTemplate(id: template.id)
        loadTemplates()
    }
    
    // MARK: - Private Helpers
    
    private func saveHistory(result: TripResult) {
        // Create a summary string or JSON for dynamic parameters
        // Since HistoryEntry parameters is [String: String], we need to adapt.
        // For N points, specific keys like "massA" don't fit well.
        // We can use JSON serialization for 'points' key or just save simplified A/B if we want backward compatibility,
        // but for full history we should serialize the input points.
        
        var params: [String: String] = [
            "productType": productType.rawValue,
            "pointsCount": "\(points.count)"
        ]
        
        // Store first and last for quick summary
        if let first = points.first {
            params["startMass"] = first.mass
            params["startLoc"] = first.name
        }
        if let last = points.last {
            params["endMass"] = last.mass
            params["endLoc"] = last.name
        }
        
        let entry = HistoryEntry(
            type: .tripCalc,
            tripResult: result,
            parameters: params
        )
        HistoryService.shared.addEntry(entry)
    }
    
    private func triggerSuccessHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func triggerErrorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

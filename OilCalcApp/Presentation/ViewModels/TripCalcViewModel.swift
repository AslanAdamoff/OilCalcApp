import SwiftUI
import Combine

class TripCalcViewModel: ObservableObject {
    // MARK: - Published Properties
    
    // Point A
    @Published var massA = "" {
        didSet { if massA.contains(",") { massA = massA.replacingOccurrences(of: ",", with: ".") } }
    }
    @Published var densityA = "" {
        didSet { if densityA.contains(",") { densityA = densityA.replacingOccurrences(of: ",", with: ".") } }
    }
    @Published var temperatureA = "" {
        didSet { if temperatureA.contains(",") { temperatureA = temperatureA.replacingOccurrences(of: ",", with: ".") } }
    }
    @Published var densityModeA: DensityMode = .at15
    
    // Point B
    @Published var massB = "" {
        didSet { if massB.contains(",") { massB = massB.replacingOccurrences(of: ",", with: ".") } }
    }
    @Published var densityB = "" {
        didSet { if densityB.contains(",") { densityB = densityB.replacingOccurrences(of: ",", with: ".") } }
    }
    @Published var temperatureB = "" {
        didSet { if temperatureB.contains(",") { temperatureB = temperatureB.replacingOccurrences(of: ",", with: ".") } }
    }
    @Published var densityModeB: DensityMode = .at15
    @Published var productType: ProductType = .refined
    
    // Output
    @Published var result: TripResult?
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Logic
    
    func calculate() {
        errorMessage = nil
        
        do {
            // Validation Point A
            let massValA = try Validator.mass(massA, field: "tripCalc.massA".localized())
            let densityValA = try Validator.density(densityA, field: "tripCalc.densityA".localized())
            let tempValA = try Validator.temperature(temperatureA, field: "tripCalc.tempA".localized())
            
            // Validation Point B
            let massValB = try Validator.mass(massB, field: "tripCalc.massB".localized())
            let densityValB = try Validator.density(densityB, field: "tripCalc.densityB".localized())
            let tempValB = try Validator.temperature(temperatureB, field: "tripCalc.tempB".localized())
            
            // Calculation
            let calcResult = TripLossCalculator.calculate(
                massA: massValA,
                densityA: densityValA,
                temperatureA: tempValA,
                densityModeA: densityModeA,
                massB: massValB,
                densityB: densityValB,
                temperatureB: tempValB,
                densityModeB: densityModeB,
                product: productType
            )
            
            result = calcResult
            triggerSuccessHaptic()
            
            // Save History
            saveHistory(
                massA: massValA, densA: densityValA, tempA: tempValA,
                massB: massValB, densB: densityValB, tempB: tempValB,
                result: calcResult
            )
            
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
    
    // MARK: - Private Helpers
    
    private func saveHistory(
        massA: Double, densA: Double, tempA: Double,
        massB: Double, densB: Double, tempB: Double,
        result: TripResult
    ) {
        let entry = HistoryEntry(
            type: .tripCalc,
            tripResult: result,
            parameters: [
                "massA": ResultFormatters.formattedMass(massA),
                "densityA": ResultFormatters.formattedDensity(densA),
                "tempA": ResultFormatters.formattedTemperature(tempA),
                "massB": ResultFormatters.formattedMass(massB),
                "densityB": ResultFormatters.formattedDensity(densB),
                "tempB": ResultFormatters.formattedTemperature(tempB),
                "productType": productType.rawValue
            ]
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

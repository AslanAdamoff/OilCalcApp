import SwiftUI
import Combine

class MainCalcViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var mode = "direct" // "direct" = Mass → Liters, "reverse" = Liters → Mass
    @Published var densityMode: DensityMode = .at15
    @Published var productType: ProductType = .refined
    
    // Inputs with comma-handling logic moved to setters if needed, 
    // but for SwiftUI Binding simplicity, we'll keep raw strings here and clean them on set
    // or assume View bindings handle the replacement. 
    // Let's implement robust setters here to be safe.
    @Published var density = "" {
        didSet {
            if density.contains(",") { density = density.replacingOccurrences(of: ",", with: ".") }
        }
    }
    @Published var temperature = "" {
        didSet {
            if temperature.contains(",") { temperature = temperature.replacingOccurrences(of: ",", with: ".") }
        }
    }
    @Published var mass = "" {
        didSet {
            if mass.contains(",") { mass = mass.replacingOccurrences(of: ",", with: ".") }
        }
    }
    @Published var volume = "" {
        didSet {
            if volume.contains(",") { volume = volume.replacingOccurrences(of: ",", with: ".") }
        }
    }
    
    @Published var result: DualResult?
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Logic
    
    func calculate() {
        errorMessage = nil
        
        do {
            // Validation
            let densityValue = try Validator.density(density, field: "mainCalc.density".localized())
            let temperatureValue = try Validator.temperature(temperature, field: "mainCalc.temperature".localized())
            
            if mode == "direct" {
                // Mass -> Liters
                let massValue = try Validator.mass(mass, field: "mainCalc.mass".localized())
                
                let calculatedResult = FuelCalculator.massToLitersDual(
                    massKg: massValue,
                    density: densityValue,
                    temperature: temperatureValue,
                    densityMode: densityMode,
                    product: productType
                )
                
                result = calculatedResult
                saveHistory(type: .massToLiters, input: massValue, density: densityValue, temp: temperatureValue, result: calculatedResult)
                triggerSuccessHaptic()
                
            } else {
                // Liters -> Mass
                let volumeValue = try Validator.mass(volume, field: "mainCalc.volume".localized())
                
                let calculatedResult = FuelCalculator.litersToMassDual(
                    liters: volumeValue,
                    density: densityValue,
                    temperature: temperatureValue,
                    densityMode: densityMode,
                    product: productType
                )
                
                result = calculatedResult
                saveHistory(type: .litersToMass, input: volumeValue, density: densityValue, temp: temperatureValue, result: calculatedResult)
                triggerSuccessHaptic()
            }
            
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
    
    private enum CalculationType {
        case massToLiters, litersToMass
    }
    
    private func saveHistory(type: CalculationType, input: Double, density: Double, temp: Double, result: DualResult) {
        let entry = HistoryEntry(
            type: .mainCalc,
            dualResult: result,
            parameters: [
                "mode": type == .massToLiters ? "massToLiters" : "litersToMass",
                "density": ResultFormatters.formattedDensity(density),
                "temperature": ResultFormatters.formattedTemperature(temp),
                "densityMode": densityMode.rawValue,
                "productType": productType.rawValue,
                "input": type == .massToLiters ? ResultFormatters.formattedMass(input) : ResultFormatters.formattedVolume(input)
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

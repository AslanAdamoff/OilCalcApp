
import SwiftUI
import Foundation
import Combine

class LanguageService: ObservableObject {
    static let shared = LanguageService()
    
    // Hardcoded English strings to ensure reliability
    private let strings: [String: String] = [
        // MainCalc
        "mainCalc.title": "Calculator",
        "mainCalc.massToLiters": "Mass → Liters",
        "mainCalc.litersToMass": "Liters → Mass",
        "mainCalc.density": "Density (kg/l)",
        "mainCalc.temperature": "Temperature (°C)",
        "mainCalc.mass": "Mass (kg)",
        "mainCalc.volume": "Volume (l)",
        "mainCalc.calculate": "Calculate",
        
        "density.at15": "Density at 15°C",
        "density.atTemperature": "Density at T°C",
        // Result Messages
        "result.close": "Close",
        "result.density": "Density",
        "result.temperature": "Temperature",
        "result.mass": "Mass",
        "result.volume": "Volume",
        
        "result.at15": "at 15°C",
        "result.atTemperature": "at Fact. T",
        "result.difference": "Difference",
        "result.percentDifference": "Difference %",
        
        "result.deltaMass": "Δ Mass",
        "result.deltaVolume": "Δ Volume",
        
        // TripCalc
        "tripCalc.title": "Trip Loss",
        "tripCalc.pointA": "Point A (Loading)",
        "tripCalc.pointB": "Point B (Discharge)",
        "tripCalc.mass": "Mass (kg)",
        "tripCalc.density": "Density (kg/l)",
        "tripCalc.temperature": "Temperature (°C)",
        "tripCalc.calculate": "Calculate Loss",
        "tripCalc.saveTemplate": "Save Template",
        "tripCalc.loadManage": "Load / Manage",
        "tripCalc.noTemplates": "No saved templates",
        "tripCalc.resetAll": "Reset All",
        "tripCalc.addPoint": "Add Point",
        "tripCalc.locationName": "Location Name",
        "tripCalc.saveTemplateName": "Enter a name for this route template",
        "tripCalc.templateName": "Template Name",
        "tripCalc.load": "Load",
        "tripCalc.minPoints": "Calculation requires at least 2 points",
        
        // History
        "history.title": "History",
        "history.empty": "History is empty",
        "history.delete": "Delete",
        "history.clearAll": "Clear All",
        "history.clearConfirmTitle": "Clear all history?",
        "history.clearConfirmMessage": "All records will be deleted permanently.",
        "history.basicCalcResult": "Calculator Result",
        "history.at15": "At 15°C",
        "history.atT": "At T",
        "mainScreen.mainCalc": "Calculator",
        "mainScreen.tripCalc": "Loss Analysis",
        
        // Validation
        "validation.empty": "Field \"%@\" is empty",
        "validation.notNumber": "Field \"%@\" contains invalid number",
        "validation.outOfRange": "Field \"%@\" must be in range %@ - %@",
        "validation.outOfRangeMin": "Field \"%@\" must be at least %@",
        "validation.outOfRangeMax": "Field \"%@\" must be at most %@",
        
        "settings.title": "Settings",
        "settings.language": "Language",
        "settings.about": "About App",
        "settings.share": "Share App",
        
        // Product Type
        "productType.refined": "Refined Products",
        "productType.crude": "Crude Oil",
        
        // Common
        "common.error": "Error",
        "common.ok": "OK",
        "common.cancel": "Cancel",
        "common.close": "Close",
        "common.done": "Done",
        "common.save": "Save",
        "common.delete": "Delete",
        "common.clear": "Clear",
        
        // Result View - MainCalc
        "result.densityAt15": "Density at 15°C",
        "result.densityAtT": "Density at %@°C",
        "result.volumeAt15": "Volume at 15°C",
        "result.volumeAtT": "Volume at %@°C",
        "result.volumeInput": "Volume (Input)",
        "result.massAt15": "Mass (at 15°C)",
        "result.massAtT": "Mass (at T°C)",
        
        // Result View - TripCalc
        "result.totalAnalysis": "Total Analysis",
        "result.totalDifference": "Total Difference",
        "result.measurementPoints": "Measurement Points",
        "result.segmentAnalysis": "Segment Analysis",
        "result.segment": "Segment",
        "result.point": "Point",
        
        // TripCalc - Specific Fields
        "tripCalc.massA": "Mass at Point A",
        "tripCalc.densityA": "Density at Point A",
        "tripCalc.tempA": "Temperature at Point A",
        "tripCalc.massB": "Mass at Point B",
        "tripCalc.densityB": "Density at Point B",
        "tripCalc.tempB": "Temperature at Point B"
    ]
    
    @Published var currentLanguage: String = "en"
    
    var bundle: Bundle? { return .main } // Not used anymore but kept for compatibility if needed
    
    private init() {}
    
    func setLanguage(_ lang: String) {
        // Only English supported
    }
    
    func string(for key: String) -> String {
        return strings[key] ?? key
    }
}

// Расширение для удобного использования локализации
extension String {
    func localized(_ args: CVarArg...) -> String {
        // Direct lookup from the dictionary
        let format = LanguageService.shared.string(for: self)
        return String(format: format, arguments: args)
    }
}

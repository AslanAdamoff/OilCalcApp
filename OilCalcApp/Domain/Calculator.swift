import Foundation

public enum FuelCalculator {
    
    /// Масса → Литры
    /// - Parameters:
    ///   - massKg: Масса (кг)
    ///   - density: Плотность (кг/л) - может быть при 15°C или при фактической T
    ///   - temperature: Фактическая температура (°C)
    ///   - densityMode: Режим плотности (при 15°C или при фактической T)
    /// - Returns: DualResult с объёмами при 15°C и при фактической T
    public static func massToLitersDual(
        massKg: Double,
        density: Double,
        temperature: Double,
        densityMode: DensityMode,
        product: ProductType
    ) -> DualResult {
        
        let rho15: Double
        let rhoT: Double
        
        switch densityMode {
        case .at15:
            // Пользователь ввёл плотность при 15°C
            rho15 = density
            rhoT = DensityCorrector.densityT(from: rho15, temperature: temperature, product: product)
        case .atTemperature:
            // Пользователь ввёл плотность при фактической T
            rhoT = density
            rho15 = DensityCorrector.density15(from: rhoT, temperature: temperature, product: product)
        }
        
        let v15 = massKg / rho15
        let vT = massKg / rhoT
        
        return DualResult(at15: v15, atT: vT, density15: rho15, densityT: rhoT)
    }
    
    /// Литры → Масса
    /// - Parameters:
    ///   - liters: Объём (л)
    ///   - density: Плотность (кг/л) - может быть при 15°C или при фактической T
    ///   - temperature: Фактическая температура (°C)
    ///   - densityMode: Режим плотности (при 15°C или при фактической T)
    ///   - product: Тип продукта (Refined / Crude)
    /// - Returns: DualResult с массами при 15°C и при фактической T
    public static func litersToMassDual(
        liters: Double,
        density: Double,
        temperature: Double,
        densityMode: DensityMode,
        product: ProductType
    ) -> DualResult {
        
        let rho15: Double
        let rhoT: Double
        
        switch densityMode {
        case .at15:
            // Пользователь ввёл плотность при 15°C
            rho15 = density
            rhoT = DensityCorrector.densityT(from: rho15, temperature: temperature, product: product)
        case .atTemperature:
            // Пользователь ввёл плотность при фактической T
            rhoT = density
            rho15 = DensityCorrector.density15(from: rhoT, temperature: temperature, product: product)
        }
        
        let m15 = liters * rho15
        let mT = liters * rhoT
        
        return DualResult(at15: m15, atT: mT, density15: rho15, densityT: rhoT)
    }
}


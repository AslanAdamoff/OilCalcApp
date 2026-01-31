import Foundation

/// Корректор плотности по стандарту API MPMS Chapter 11.1 (ASTM D1250)
/// Реализует таблицу 54B (Refined Products)
public enum DensityCorrector {
    
    // MARK: - Constants
    
    /// Коэффициент K0 для нефтепродуктов (Refined Products) - Table 54B
    private static let k0_refined: Double = 341.0957
    
    /// Коэффициент K0 для сырой нефти (Crude Oil) - Table 54A
    private static let k0_crude: Double = 613.9723
    
    // MARK: - Public Methods
    
    /// Пересчитать плотность из ρT в ρ15
    public static func density15(from densityT: Double, temperature: Double, product: ProductType = .refined) -> Double {
        // Если температура уже 15, возвращаем как есть
        if abs(temperature - 15.0) < 0.001 {
            return densityT
        }
        
        // Кг/л -> Кг/м³ для расчетов
        let rhoT_kgm3 = densityT * 1000.0
        
        // Итеративный процесс
        var rho15_current = rhoT_kgm3
        var delta: Double = 1.0
        let tolerance: Double = 0.00001
        var iterations = 0
        let maxIterations = 100
        
        while abs(delta) > tolerance && iterations < maxIterations {
            let vcf = calculateVCF(density15_kgm3: rho15_current, temperature: temperature, product: product)
            let rho15_next = rhoT_kgm3 / vcf
            
            delta = rho15_next - rho15_current
            rho15_current = rho15_next
            
            iterations += 1
        }
        
        return rho15_current / 1000.0
    }
    
    /// Пересчитать плотность из ρ15 в ρT
    public static func densityT(from density15: Double, temperature: Double, product: ProductType = .refined) -> Double {
        let density15_kgm3 = density15 * 1000.0
        let vcf = calculateVCF(density15_kgm3: density15_kgm3, temperature: temperature, product: product)
        let densityT_kgm3 = density15_kgm3 * vcf
        return densityT_kgm3 / 1000.0
    }
    
    /// Рассчитать VCF
    public static func vcf(density15: Double, temperature: Double, product: ProductType = .refined) -> Double {
        return calculateVCF(density15_kgm3: density15 * 1000.0, temperature: temperature, product: product)
    }
    
    // MARK: - Internal Logic
    
    private static func calculateVCF(density15_kgm3: Double, temperature: Double, product: ProductType) -> Double {
        if abs(temperature - 15.0) < 0.001 { return 1.0 }
        
        let alpha = calculateAlpha15(density15_kgm3: density15_kgm3, product: product)
        let deltaT = temperature - 15.0
        
        let exponent = -alpha * deltaT * (1.0 + 0.8 * alpha * deltaT)
        
        return exp(exponent)
    }
    
    private static func calculateAlpha15(density15_kgm3: Double, product: ProductType) -> Double {
        guard density15_kgm3 > 0 else { return 0 }
        
        let k0: Double
        switch product {
        case .refined:
            k0 = k0_refined
        case .crude:
            k0 = k0_crude
        }
        
        return k0 / (density15_kgm3 * density15_kgm3)
    }
}

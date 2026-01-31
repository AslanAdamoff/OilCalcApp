import Foundation

public enum TripLossCalculator {
    
    /// Расчёт потерь при транспортировке A → B
    /// - Parameters:
    ///   - massA: Масса в точке A (кг)
    ///   - densityA: Плотность в точке A (кг/л)
    ///   - temperatureA: Температура в точке A (°C)
    ///   - densityModeA: Режим плотности для точки A
    ///   - massB: Масса в точке B (кг)
    ///   - densityB: Плотность в точке B (кг/л)
    ///   - temperatureB: Температура в точке B (°C)
    ///   - densityModeB: Режим плотности для точки B
    /// - Returns: TripResult с результатами расчёта
    public static func calculate(
        massA: Double,
        densityA: Double,
        temperatureA: Double,
        densityModeA: DensityMode,
        massB: Double,
        densityB: Double,
        temperatureB: Double,
        densityModeB: DensityMode,
        product: ProductType
    ) -> TripResult {
        
        // Расчёт для точки A
        let pointA = calculatePoint(
            massKg: massA,
            density: densityA,
            temperature: temperatureA,
            densityMode: densityModeA,
            product: product
        )
        
        // Расчёт для точки B
        let pointB = calculatePoint(
            massKg: massB,
            density: densityB,
            temperature: temperatureB,
            densityMode: densityModeB,
            product: product
        )
        
        return TripResult(A: pointA, B: pointB)
    }
    
    /// Расчёт результата для одной точки
    private static func calculatePoint(
        massKg: Double,
        density: Double,
        temperature: Double,
        densityMode: DensityMode,
        product: ProductType
    ) -> PointResult {
        
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
        
        // Объёмы
        let v15 = massKg / rho15
        let vFact = massKg / rhoT
        
        return PointResult(
            massKg: massKg,
            density15: rho15,
            densityT: rhoT,
            temperature: temperature,
            v15Liters: v15,
            vFactLiters: vFact
        )
    }
}


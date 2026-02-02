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
    /// Основной метод расчёта для произвольного количества точек
    public static func calculate(points: [TripPoint], product: ProductType) -> TripResult {
        var results: [PointResult] = []
        
        for point in points {
            // Преобразуем строковые значения в Double (предполагается, что валидация прошла во ViewModel)
            let mass = Double(point.mass.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let density = Double(point.density.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            let temp = Double(point.temperature.replacingOccurrences(of: ",", with: ".")) ?? 0.0
            
            let result = calculatePoint(
                name: point.name,
                massKg: mass,
                density: density,
                temperature: temp,
                densityMode: point.densityMode,
                product: product
            )
            results.append(result)
        }
        
        return TripResult(points: results)
    }

    /// Legacy support: Расчёт потерь при транспортировке A → B
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
            name: "tripCalc.pointA".localized(),
            massKg: massA,
            density: densityA,
            temperature: temperatureA,
            densityMode: densityModeA,
            product: product
        )
        
        // Расчёт для точки B
        let pointB = calculatePoint(
            name: "tripCalc.pointB".localized(),
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
        name: String = "",
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
            name: name,
            massKg: massKg,
            density15: rho15,
            densityT: rhoT,
            temperature: temperature,
            v15Liters: v15,
            vFactLiters: vFact
        )
    }
}



import Testing
@testable import OilCalcApp

struct CalculatorTests {
    
    @Test
    func testMassToLitersAt15() {
        // Проверка расчета: 1000 кг, плотность 0.850 (при 15С), Темп 15С
        // V15 = 1000 / 0.850 = 1176.47...
        // VT = V15 т.к. темп 15С
        
        let result = FuelCalculator.massToLitersDual(
            massKg: 1000.0,
            density: 0.850,
            temperature: 15.0,
            densityMode: .at15
        )
        
        #expect(abs(result.at15 - 1176.47) < 0.01)
        #expect(abs(result.atT  - 1176.47) < 0.01)
    }
    
    @Test
    func testMassToLitersAtTemperature() {
        // Проверка расчета: 1000 кг, плотность 0.850 (фактическая при 25С), Темп 25С
        // VT = 1000 / 0.850 = 1176.47...
        // V15 = 1000 / Rho15
        // Rho15 будет > RhoT. Значит V15 будет < VT
        
        let result = FuelCalculator.massToLitersDual(
            massKg: 1000.0,
            density: 0.850,
            temperature: 25.0,
            densityMode: .atTemperature
        )
        
        #expect(abs(result.atT - 1176.47) < 0.01)
        #expect(result.at15 < result.atT) // Объем при 15 должен быть меньше (так как жидкость сжалась)
    }
    
    @Test
    func testLitersToMass() {
        // Объем 1000 л, плотность 0.850 (при 15), темп 15
        // M = 1000 * 0.850 = 850 кг
        
        let result = FuelCalculator.litersToMassDual(
            liters: 1000.0,
            density: 0.850,
            temperature: 15.0,
            densityMode: .at15
        )
        
        #expect(abs(result.at15 - 850.0) < 0.01)
        #expect(abs(result.atT - 850.0) < 0.01)
    }
}

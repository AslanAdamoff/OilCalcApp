import Testing
@testable import OilCalcApp
import Foundation

struct DensityCorrectorTests {
    
    @Test
    func testVCFCalculation() {
        // Проверка базового расчета VCF
        // Пример: Плотность 15°C = 850 кг/м³ (0.850 кг/л)
        // Температура = 25°C
        // Ожидаем VCF < 1, так как жидкость расширилась
        
        let rho15 = 0.850
        let temp = 25.0
        
        let vcf = DensityCorrector.vcf(density15: rho15, temperature: temp)
        
        #expect(vcf < 1.0)
        #expect(vcf > 0.99) // Должен быть близок к 1
    }
    
    @Test
    func testIdentityAt15() {
        // При 15°C VCF должен быть 1.0
        let rho15 = 0.850
        let temp = 15.0
        
        let vcf = DensityCorrector.vcf(density15: rho15, temperature: temp)
        #expect(abs(vcf - 1.0) < 0.0000001)
        
        let rhoT = DensityCorrector.densityT(from: rho15, temperature: temp)
        #expect(abs(rhoT - rho15) < 0.0000001)
    }
    
    @Test
    func testDensity15Converges() {
        // Проверка конвертации "обратно" из T в 15
        let rhoT = 0.840
        let temp = 25.0
        
        let rho15 = DensityCorrector.density15(from: rhoT, temperature: temp)
        
        // rho15 должна быть больше rhoT (так как при 25°C жидкость "легче")
        #expect(rho15 > rhoT)
        
        // Проверка round-trip: rho15 -> rhoT -> rho15
        let calculatedRhoT = DensityCorrector.densityT(from: rho15, temperature: temp)
        #expect(abs(calculatedRhoT - rhoT) < 0.00001)
    }
    
    @Test
    func testStandardCase() {
        // Примерное значение для дизеля
        // rho15 = 840 кг/м³
        // T = 30°C
        
        let rho15 = 0.840
        let temp = 30.0
        let vcf = DensityCorrector.vcf(density15: rho15, temperature: temp)
        
        // VCF для 840 на 30°C примерно равен:
        // alpha = 341.0957 / 840^2 = 0.0004834
        // dT = 15
        // VCF = exp(-0.0004834 * 15 * (1 + 0.8 * 0.0004834 * 15))
        // VCF = exp(-0.007251 * (1 + 0.0058)) = exp(-0.007293) ≈ 0.99273
        
        // Проверяем что VCF в разумных пределах
        #expect(vcf > 0.992 && vcf < 0.993)
    }
    
    @Test
    func testCrudeOilCase() {
        // Пример для сырой нефти (Table 54A)
        // K0 = 613.9723
        // rho15 = 850 кг/м³
        // T = 30°C
        
        // alpha = 613.9723 / 850^2 = 0.0008497
        // dT = 15
        // VCF = exp(-0.0008497 * 15 * (1 + 0.8 * 0.0008497 * 15))
        // VCF = exp(-0.0127455 * (1 + 0.010196)) = exp(-0.012875) ≈ 0.9872
        
        let rho15 = 0.850
        let temp = 30.0
        let vcf_crude = DensityCorrector.vcf(density15: rho15, temperature: temp, product: .crude)
        let vcf_refined = DensityCorrector.vcf(density15: rho15, temperature: temp, product: .refined)
        
        // Для сырой нефти коэффициент расширения выше (K0 больше), значит VCF меньше (сильнее расширяется)
        #expect(vcf_crude < vcf_refined)
        
        // Проверяем примерное значение
        #expect(vcf_crude > 0.987 && vcf_crude < 0.988)
    }
}

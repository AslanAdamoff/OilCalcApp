
import Testing
import Foundation
@testable import OilCalcApp

struct ValidatorTests {

    @Test
    func testNumberParsing() throws {
        // Простой случай
        let val = try Validator.number("100.5", field: "Test")
        #expect(val == 100.5)
        
        // С запятой
        let valComma = try Validator.number("100,5", field: "Test")
        #expect(valComma == 100.5)
        
        // С пробелами
        let valSpace = try Validator.number(" 100.5 ", field: "Test")
        #expect(valSpace == 100.5)
    }
    
    @Test
    func testNumberValidationErrors() {
        // Пустая строка
        #expect(throws: ValidationError.self) {
            _ = try Validator.number("", field: "Test")
        }
        
        // Не число
        #expect(throws: ValidationError.self) {
            _ = try Validator.number("abc", field: "Test")
        }
    }
    
    @Test
    func testRangeValidation() throws {
        // В диапазоне
        let val = try Validator.number("50", field: "Test", min: 0, max: 100)
        #expect(val == 50.0)
        
        // Меньше минимума
        #expect(throws: ValidationError.self) {
            _ = try Validator.number("-1", field: "Test", min: 0, max: 100)
        }
        
        // Больше максимума
        #expect(throws: ValidationError.self) {
            _ = try Validator.number("101", field: "Test", min: 0, max: 100)
        }
    }
    
    @Test
    func testDensityValidation() throws {
        // Допустимая
        let d = try Validator.density("0.850", field: "D")
        #expect(d == 0.850)
        
        // Недопустимая (слишком легкая)
        #expect(throws: ValidationError.self) {
            _ = try Validator.density("0.599", field: "D")
        }
    }
}

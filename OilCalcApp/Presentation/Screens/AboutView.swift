import SwiftUI

struct AboutView: View {
    @State private var language: String = "en"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Language Switcher
                Picker("Language", selection: $language) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 8)
                
                if language == "en" {
                    aboutContentEn
                } else {
                    aboutContentRu
                }
            }
            .padding()
        }
        .navigationTitle(language == "en" ? "About App" : "О приложении")
        .navigationBarTitleDisplayMode(.inline)
        .background(DesignSystem.Colors.background)
    }
    
    // MARK: - English Content
    private var aboutContentEn: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("Description")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                Text("OilCalcApp is a professional tool for surveyors and logistics specialists designed for accurate conversion of mass and volume of petroleum products, as well as analysis of discrepancies (losses) during transportation.")
                    .font(.body)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }
            
            Divider()
            
            Group {
                Text("Key Features")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                
                VStack(alignment: .leading, spacing: 8) {
                    featureRow(title: "1. Conversion Calculator:", points: [
                        "Calculation of volume at 15°C and actual temperature based on mass and density.",
                        "Reverse calculation (mass from volume)."
                    ])
                    
                    featureRow(title: "2. Loss Analysis (Trip Calculator):", points: [
                        "Comparison of cargo quantity between multiple route points (loading, discharge, transit).",
                        "Detailed analysis of discrepancies (Delta) by mass and volume for each segment.",
                        "Support for unlimited number of points."
                    ])
                    
                    featureRow(title: "3. Data Management:", points: [
                        "Template system for saving regular routes.",
                        "Full calculation history with detailed view."
                    ])
                }
            }
            
            Divider()
            
            Group {
                Text("Standards and Methodology")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                
                Text("The application uses algorithms compliant with international standards for oil and petroleum product calculations:")
                    .font(.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .padding(.bottom, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    bulletPoint(text: "**ASTM D1250-04 / API MPMS Chapter 11.1**: Standard Volume Correction Tables.")
                    bulletPoint(text: "  • **Table 54A / 54B**: For volume correction to 15°C (Generalized Crude Oils & Products).")
                    bulletPoint(text: "  • **Table 60A / 60B**: For density conversion.")
                    bulletPoint(text: "**VCF (Volume Correction Factor)**: Uses thermal expansion coefficients for crude oil, fuels, and lubricating oils.")
                    bulletPoint(text: "**Units**: Mass (kg), Density (kg/l), Temperature (°C).")
                }
            }
        }
    }
    
    // MARK: - Russian Content
    private var aboutContentRu: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text("Описание")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                Text("OilCalcApp — это профессиональный инструмент для сюрвейеров и специалистов по логистике, предназначенный для точного пересчета массы и объема нефтепродуктов, а также анализа расхождений (потерь) при транспортировке.")
                    .font(.body)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
            }
            
            Divider()
            
            Group {
                Text("Основные возможности")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                
                VStack(alignment: .leading, spacing: 8) {
                    featureRow(title: "1. Калькулятор пересчета:", points: [
                        "Расчет объема при 15°C и фактической температуре на основе массы и плотности.",
                        "Обратный расчет (массы по объему)."
                    ])
                    
                    featureRow(title: "2. Анализ потерь (Trip Calculator):", points: [
                        "Сравнение количества груза между несколькими точками маршрута (погрузка, выгрузка, транзит).",
                        "Детальный анализ расхождений (Delta) по массе и объему для каждого сегмента пути.",
                        "Поддержка неограниченного количества точек."
                    ])
                    
                    featureRow(title: "3. Управление данными:", points: [
                        "Система шаблонов для сохранения регулярных маршрутов.",
                        "Полная история расчетов с детализацией."
                    ])
                }
            }
            
            Divider()
            
            Group {
                Text("Используемые стандарты")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                
                Text("Приложение использует алгоритмы, соответствующие международным стандартам для расчетов нефти и нефтепродуктов:")
                    .font(.caption)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                    .padding(.bottom, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    bulletPoint(text: "**ASTM D1250-04 / API MPMS Chapter 11.1**: Стандартные таблицы коррекции объемов.")
                    bulletPoint(text: "  • **Table 54A / 54B**: Для коррекции объема к 15°C (Generalized Crude Oils & Products).")
                    bulletPoint(text: "  • **Table 60A / 60B**: Для пересчета плотности.")
                    bulletPoint(text: "**Расчет VCF**: Используются коэффициенты теплового расширения для сырой нефти, топлив и смазочных масел.")
                    bulletPoint(text: "**Единицы измерения**: Масса (kg), Плотность (kg/l), Температура (°C).")
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func featureRow(title: String, points: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundStyle(DesignSystem.Colors.accent)
            
            ForEach(points, id: \.self) { point in
                HStack(alignment: .top, spacing: 6) {
                    Text("•")
                    Text(point)
                        .font(.caption)
                        .foregroundStyle(DesignSystem.Colors.textSecondary)
                }
                .padding(.leading, 8)
            }
        }
    }
    
    private func bulletPoint(text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
                .foregroundStyle(DesignSystem.Colors.accent)
            Text(.init(text)) // Allows markdown parsing
                .font(.caption)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
    }
}

import SwiftUI

struct MainCalcResultView: View {
    let result: DualResult
    let mode: String
    let temperature: Double
    let density: Double
    let densityMode: DensityMode
    let inputValue: Double
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            VisualEffectBlur(style: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("result.close".localized())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                    Text("mainCalc.title".localized())
                        .font(.largeTitle.bold())
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        if mode == "direct" {
                            // MARK: - Direct Mode: Mass -> Liters
                            // 1. Mass (Input)
                            ResultRow(title: "mainCalc.mass".localized(), value: ResultFormatters.formattedMass(inputValue) + " kg", color: .primary)
                            
                            Divider()
                            
                            // 2. Densities
                            if let d15 = result.density15, let dT = result.densityT {
                                ResultRow(title: "result.densityAt15".localized(), value: ResultFormatters.formattedDensity(d15), color: .primary)
                                ResultRow(title: "result.densityAtT".localized(ResultFormatters.formattedTemperature(temperature)), value: ResultFormatters.formattedDensity(dT), color: .primary)
                            }

                            Divider()
                            
                            // 3. Volume (Result)
                            ResultRow(title: "result.volumeAt15".localized(), value: ResultFormatters.formattedVolume(result.at15) + " l", color: .blue)
                            ResultRow(title: "result.volumeAtT".localized(ResultFormatters.formattedTemperature(temperature)), value: ResultFormatters.formattedVolume(result.atT) + " l", color: .blue)
                            
                        } else {
                            // MARK: - Reverse Mode: Liters -> Mass
                            // User Request: Volume (Input) -> Density -> Mass (Result)
                            
                            // 1. Volume (Input)
                            ResultRow(title: "result.volumeInput".localized(), value: ResultFormatters.formattedVolume(inputValue) + " l", color: .primary)
                            
                            Divider()
                            
                            // 2. Densities
                            if let d15 = result.density15, let dT = result.densityT {
                                ResultRow(title: "result.densityAt15".localized(), value: ResultFormatters.formattedDensity(d15), color: .primary)
                                ResultRow(title: "result.densityAtT".localized(ResultFormatters.formattedTemperature(temperature)), value: ResultFormatters.formattedDensity(dT), color: .primary)
                            }
                            
                            Divider()
                            
                            // 3. Mass (Result)
                            ResultRow(title: "result.massAt15".localized(), value: ResultFormatters.formattedMass(result.at15) + " kg", color: .blue)
                            ResultRow(title: "result.massAtT".localized(), value: ResultFormatters.formattedMass(result.atT) + " kg", color: .blue)
                        }
                        
                        Divider()
                        
                        // MARK: - Difference (Common)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("result.difference".localized())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                // Logic relocated to helper variables
                                let diffValue = result.difference
                                let unit = mode == "direct" ? "l" : "kg"
                                let formattedDiff = mode == "direct" ? ResultFormatters.formattedVolume(diffValue) : ResultFormatters.formattedMass(diffValue)
                                
                                Text("\(formattedDiff) \(unit)")
                                    .font(.headline)
                                    .foregroundStyle(diffValue >= 0 ? .green : .red)
                                    .monospacedDigit()
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("result.percentDifference".localized())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text(ResultFormatters.formattedPercent(result.percentDifference) + "%")
                                    .font(.headline)
                                    .foregroundStyle(result.percentDifference >= 0 ? .green : .red)
                                    .monospacedDigit()
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }
        .onTapGesture(count: 2) {
            onClose()
        }
    }
}

// Helper View for clearer code
struct ResultRow: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundStyle(color)
        }
    }
}

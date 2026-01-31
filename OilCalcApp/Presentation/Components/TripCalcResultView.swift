import SwiftUI

struct TripCalcResultView: View {
    let result: TripResult
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            VisualEffectBlur(style: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) { // Reduced from 24
                    Text("result.close".localized())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                    Text("tripCalc.title".localized())
                        .font(.largeTitle.bold())
                    
                    // Точка A
                    VStack(alignment: .leading, spacing: 8) { // Reduced from 12
                        Text("tripCalc.pointA".localized())
                            .font(.title2.bold())
                        
                        PointResultCard(point: result.A, label: "A")
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    
                    // Точка B
                    VStack(alignment: .leading, spacing: 8) { // Reduced from 12
                        Text("tripCalc.pointB".localized())
                            .font(.title2.bold())
                        
                        PointResultCard(point: result.B, label: "B")
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    
                    // Losses
                    VStack(alignment: .leading, spacing: 12) { // Reduced from 16
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Transport Loss Analysis")
                                .font(.headline)
                            Text("🔴 Red = Loss (B < A) | 🟢 Green = Gain (B > A)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(spacing: 8) { // Reduced from 12
                            // Δ Масса
                            HStack {
                                Text("result.deltaMass".localized())
                                    .font(.headline)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(ResultFormatters.formattedMass(result.deltaMassKg) + " kg")
                                        .font(.title3.bold())
                                        .foregroundStyle(result.deltaMassKg >= 0 ? .green : .red)
                                        .monospacedDigit()
                                    Text(ResultFormatters.formattedPercent(result.deltaMassPercent) + "%")
                                        .font(.caption)
                                        .foregroundStyle(result.deltaMassPercent >= 0 ? .green : .red)
                                        .monospacedDigit()
                                }
                            }
                            
                            Divider()
                            
                            // Δ Объём при 15°C
                            HStack {
                                Text("result.deltaVolume".localized() + " (15°C)")
                                    .font(.headline)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(ResultFormatters.formattedVolume(result.deltaV15) + " l")
                                        .font(.title3.bold())
                                        .foregroundStyle(result.deltaV15 >= 0 ? .green : .red)
                                        .monospacedDigit()
                                    Text(ResultFormatters.formattedPercent(result.deltaV15Percent) + "%")
                                        .font(.caption)
                                        .foregroundStyle(result.deltaV15Percent >= 0 ? .green : .red)
                                        .monospacedDigit()
                                }
                            }
                            
                            Divider()
                            
                            // Δ Объём при фактической T
                            HStack {
                                Text("result.deltaVolume".localized() + " (Fact. T)")
                                    .font(.headline)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(ResultFormatters.formattedVolume(result.deltaVFact) + " l")
                                        .font(.title3.bold())
                                        .foregroundStyle(result.deltaVFact >= 0 ? .green : .red)
                                        .monospacedDigit()
                                    Text(ResultFormatters.formattedPercent(result.deltaVFactPercent) + "%")
                                        .font(.caption)
                                        .foregroundStyle(result.deltaVFactPercent >= 0 ? .green : .red)
                                        .monospacedDigit()
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .onTapGesture(count: 2) {
            onClose()
        }
    }
}

private struct PointResultCard: View {
    let point: PointResult
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) { // Reduced from 8
            // Mass
            HStack {
                Text("result.mass".localized() + ":")
                Spacer()
                Text(ResultFormatters.formattedMass(point.massKg) + " kg")
                    .monospacedDigit()
            }
            
            // Плотность при 15°C
            HStack {
                Text("ρ15:")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(ResultFormatters.formattedDensity(point.density15) + " kg/l")
                    .monospacedDigit()
            }
            
            // Плотность при фактической T
            HStack {
                Text("ρT:")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(ResultFormatters.formattedDensity(point.densityT) + " kg/l")
                    .monospacedDigit()
            }
            
            // Температура
            HStack {
                Text("result.temperature".localized() + ":")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(ResultFormatters.formattedTemperature(point.temperature) + "°C")
                    .monospacedDigit()
            }
            
            Divider()
            
            // Объём при 15°C
            HStack {
                Text("result.volume".localized() + " (15°C):")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(ResultFormatters.formattedVolume(point.v15Liters) + " l")
                    .font(.headline)
                    .foregroundStyle(.blue) // Changed from default/black for emphasis, or blue? Let's keep one blue one black or both blue? 15C is standard. Let's make 15C primary (blue) too? Or keep standard?
                    // User complained about yellow. Let's make Fact T blue.
                    .monospacedDigit()
            }
            
            // Объём при фактической T
            HStack {
                Text("result.volume".localized() + " (Fact. T):")
                    .foregroundStyle(.secondary)
                Spacer()
                Text(ResultFormatters.formattedVolume(point.vFactLiters) + " l")
                    .font(.headline)
                    .foregroundStyle(.blue) // Changed from .yellow
                    .monospacedDigit()
            }
        }
    }
}

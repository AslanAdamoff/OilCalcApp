import SwiftUI

struct TripCalcResultView: View {
    let result: TripResult
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            VisualEffectBlur(style: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("result.close".localized())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                    Text("tripCalc.title".localized())
                        .font(.largeTitle.bold())
                    
                    // MARK: - Total Results (Start vs End)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("result.totalAnalysis".localized())
                            .font(.headline)
                        
                        Divider()
                        
                        TripDeltaView(
                            delta: result.totalDelta,
                            title: "result.totalDifference".localized(),
                            fromTemp: result.points.first?.temperature,
                            toTemp: result.points.last?.temperature
                        )
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    
                    // MARK: - Individual Points
                    VStack(alignment: .leading, spacing: 12) {
                        Text("result.measurementPoints".localized())
                            .font(.title2.bold())
                            .padding(.horizontal)
                        
                        ForEach(Array(result.points.enumerated()), id: \.element.id) { index, point in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(point.name.isEmpty ? "result.point".localized() + " \(index + 1)" : point.name)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                PointResultCard(point: point, label: "result.point".localized() + " \(index + 1)")
                            }
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    
                    // MARK: - Segment Analysis
                    if !result.segments.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("result.segmentAnalysis".localized())
                                .font(.title2.bold())
                                .padding(.horizontal)
                            
                            ForEach(Array(result.segments.enumerated()), id: \.element.id) { index, segment in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Segment \(index + 1): \(segment.fromPoint.id == result.points.first?.id ? "Start" : "P\(index + 1)") → \(segment.toPoint.id == result.points.last?.id ? "End" : "P\(index + 2)")")
                                        .font(.headline)
                                    
                                    TripDeltaView(
                                        delta: segment.delta,
                                        title: "result.difference".localized(),
                                        fromTemp: segment.fromPoint.temperature,
                                        toTemp: segment.toPoint.temperature
                                    )
                                }
                                .padding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
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

// Helper view for displaying Deltas
struct TripDeltaView: View {
    let delta: TripDelta
    let title: String
    var fromTemp: Double? = nil
    var toTemp: Double? = nil
    
    var body: some View {
        VStack(spacing: 8) {
            // Δ Mass
            HStack {
                Text("result.deltaMass".localized())
                    .font(.subheadline)
                Spacer()
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(ResultFormatters.formattedMass(delta.massKg) + " kg")
                        .font(.title3.bold())
                        .foregroundStyle(delta.massKg >= 0 ? .green : .red)
                        .monospacedDigit()
                    
                    Text("(" + ResultFormatters.formattedPercent(delta.massPercent) + "%)")
                        .font(.body) // Slightly larger than caption but smaller than value
                        .foregroundStyle(delta.massPercent >= 0 ? .green : .red)
                        .monospacedDigit()
                }
            }
            
            Divider()
            
            // Δ Volume 15°C
            HStack {
                Text("result.deltaVolume".localized() + " (15°C)")
                    .font(.subheadline)
                Spacer()
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(ResultFormatters.formattedVolume(delta.v15) + " l")
                        .font(.title3.bold())
                        .foregroundStyle(delta.v15 >= 0 ? .green : .red)
                        .monospacedDigit()
                    
                    Text("(" + ResultFormatters.formattedPercent(delta.v15Percent) + "%)")
                        .font(.body)
                        .foregroundStyle(delta.v15Percent >= 0 ? .green : .red)
                        .monospacedDigit()
                }
            }
            
            Divider()
            
            // Δ Volume Fact
            HStack {
                if let t1 = fromTemp, let t2 = toTemp {
                    Text("Δ V (@ \(ResultFormatters.formattedTemperature(t1))°C → \(ResultFormatters.formattedTemperature(t2))°C)")
                        .font(.subheadline)
                } else {
                    Text("result.deltaVolume".localized() + " (Fact. T)")
                        .font(.subheadline)
                }
                Spacer()
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(ResultFormatters.formattedVolume(delta.vFact) + " l")
                        .font(.title3.bold())
                        .foregroundStyle(delta.vFact >= 0 ? .green : .red)
                        .monospacedDigit()
                    
                    Text("(" + ResultFormatters.formattedPercent(delta.vFactPercent) + "%)")
                        .font(.body)
                        .foregroundStyle(delta.vFactPercent >= 0 ? .green : .red)
                        .monospacedDigit()
                }
            }
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
                Text("ρ (@ \(ResultFormatters.formattedTemperature(point.temperature))°C):")
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
                Text("result.volume".localized() + " (@ \(ResultFormatters.formattedTemperature(point.temperature))°C):")
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

import SwiftUI

struct TripPointCard: View {
    @Binding var point: TripPoint
    let onDelete: () -> Void
    let canDelete: Bool
    
    // Focus states enum
    enum Field {
        case name, mass, density, temperature
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        DesignSystem.CardView(padding: 10, spacing: 6) {
            // Header: Name and Delete Button
            HStack {
                TextField("Location Name", text: $point.name)
                    .font(DesignSystem.Fonts.header())
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .focused($focusedField, equals: .name)
                
                Spacer()
                
                if canDelete {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.bottom, 2)
            
            // Density Mode Picker
            Picker("", selection: $point.densityMode) {
                Text(DensityMode.at15.displayName).tag(DensityMode.at15)
                Text(DensityMode.atTemperature.displayName).tag(DensityMode.atTemperature)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 4)
            
            // Mass Input
            VStack(alignment: .leading, spacing: 2) {
                Label("tripCalc.mass".localized(), systemImage: "scalemass")
                    .font(DesignSystem.Fonts.label())
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                TextField("1000.0", text: $point.mass)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .mass)
//                    .onChange(of: point.mass) { newValue in
//                        if newValue.contains(",") { point.mass = newValue.replacingOccurrences(of: ",", with: ".") }
//                    }
                    .onChange(of: point.mass) { _, newValue in
                        if newValue.contains(",") { point.mass = newValue.replacingOccurrences(of: ",", with: ".") }
                    }
            }
            
            // Density Input
            VStack(alignment: .leading, spacing: 2) {
                Label("tripCalc.density".localized(), systemImage: "flask")
                    .font(DesignSystem.Fonts.label())
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                TextField("0.850", text: $point.density)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .density)
//                    .onChange(of: point.density) { newValue in
//                        if newValue.contains(",") { point.density = newValue.replacingOccurrences(of: ",", with: ".") }
//                    }
                    .onChange(of: point.density) { _, newValue in
                        if newValue.contains(",") { point.density = newValue.replacingOccurrences(of: ",", with: ".") }
                    }
            }
            
            // Temperature Input
            VStack(alignment: .leading, spacing: 2) {
                Label("tripCalc.temperature".localized(), systemImage: "thermometer")
                    .font(DesignSystem.Fonts.label())
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                
                TextField("15.0", text: $point.temperature)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .temperature)
//                    .onChange(of: point.temperature) { newValue in
//                        if newValue.contains(",") { point.temperature = newValue.replacingOccurrences(of: ",", with: ".") }
//                    }
                    .onChange(of: point.temperature) { _, newValue in
                        if newValue.contains(",") { point.temperature = newValue.replacingOccurrences(of: ",", with: ".") }
                    }
            }
        }
    }
}

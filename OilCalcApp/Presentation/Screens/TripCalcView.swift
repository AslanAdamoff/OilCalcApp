import SwiftUI

struct TripCalcView: View {
    
    @StateObject private var viewModel = TripCalcViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case massA, densityA, temperatureA
        case massB, densityB, temperatureB
    }
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) { // Reduced from 12
                    
                    Text("tripCalc.title".localized())
                        .font(DesignSystem.Fonts.title())
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .padding(.bottom, -2)
                    
                    // Тип продукта (Card)
                    DesignSystem.CardView(padding: 10, spacing: 6) { // Compact card
                        Picker("", selection: $viewModel.productType) {
                            ForEach(ProductType.allCases, id: \.self) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Точка A (Card)
                    DesignSystem.CardView(padding: 10, spacing: 6) { // Compact card
                        Text("tripCalc.pointA".localized())
                            .font(DesignSystem.Fonts.header())
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .padding(.bottom, 0)
                        
                        // Режим плотности
                        Picker("", selection: $viewModel.densityModeA) {
                            Text(DensityMode.at15.displayName).tag(DensityMode.at15)
                            Text(DensityMode.atTemperature.displayName).tag(DensityMode.atTemperature)
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom, 2)
                        
                        // Масса
                        VStack(alignment: .leading, spacing: 2) { // Tight spacing
                            Label("tripCalc.mass".localized(), systemImage: "scalemass")
                                .font(DesignSystem.Fonts.label())
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            TextField("1000.0", text: $viewModel.massA)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .massA)
                        }
                        
                        // Плотность
                        VStack(alignment: .leading, spacing: 2) {
                            Label("tripCalc.density".localized(), systemImage: "flask")
                                .font(DesignSystem.Fonts.label())
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            TextField("0.850", text: $viewModel.densityA)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .densityA)
                        }
                        
                        // Температура
                        VStack(alignment: .leading, spacing: 2) {
                            Label("tripCalc.temperature".localized(), systemImage: "thermometer")
                                .font(DesignSystem.Fonts.label())
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            TextField("20.0", text: $viewModel.temperatureA)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .temperatureA)
                        }
                    }
                    
                    // Точка B (Card)
                    DesignSystem.CardView(padding: 10, spacing: 6) { // Compact card
                        Text("tripCalc.pointB".localized())
                            .font(DesignSystem.Fonts.header())
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .padding(.bottom, 0)
                        
                        // Режим плотности
                        Picker("", selection: $viewModel.densityModeB) {
                            Text(DensityMode.at15.displayName).tag(DensityMode.at15)
                            Text(DensityMode.atTemperature.displayName).tag(DensityMode.atTemperature)
                        }
                        .pickerStyle(.segmented)
                        .padding(.bottom, 2)
                        
                        // Масса
                        VStack(alignment: .leading, spacing: 2) { // Tight spacing
                            Label("tripCalc.mass".localized(), systemImage: "scalemass")
                                .font(DesignSystem.Fonts.label())
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            TextField("1000.0", text: $viewModel.massB)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .massB)
                        }
                        
                        // Плотность
                        VStack(alignment: .leading, spacing: 2) {
                            Label("tripCalc.density".localized(), systemImage: "flask")
                                .font(DesignSystem.Fonts.label())
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            TextField("0.840", text: $viewModel.densityB)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .densityB)
                        }
                        
                        // Температура
                        VStack(alignment: .leading, spacing: 2) {
                            Label("tripCalc.temperature".localized(), systemImage: "thermometer")
                                .font(DesignSystem.Fonts.label())
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            TextField("20.0", text: $viewModel.temperatureB)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .temperatureB)
                        }
                    }
                    
                    Button("tripCalc.calculate".localized()) {
                        viewModel.calculate()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(DesignSystem.Colors.accent)
                    .frame(maxWidth: .infinity)
                    .controlSize(.large)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
        }
        .sheet(item: $viewModel.result) { result in
            TripCalcResultView(
                result: result,
                onClose: { viewModel.result = nil }
            )
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

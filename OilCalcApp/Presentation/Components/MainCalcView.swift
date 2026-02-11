import SwiftUI

struct MainCalcView: View {
    
    @StateObject private var viewModel = MainCalcViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case density, temperature, mass, volume
    }
    
    var body: some View {
        ZStack {
                DesignSystem.Colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: DesignSystem.Layout.spacing) {
                        
                        Text("mainCalc.title".localized())
                            .font(DesignSystem.Fonts.title())
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        // Режим расчёта (Card)
                        DesignSystem.CardView {
                            Picker("", selection: $viewModel.mode) {
                                Text("mainCalc.massToLiters".localized()).tag("direct")
                                Text("mainCalc.litersToMass".localized()).tag("reverse")
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Данные (Card)
                        DesignSystem.CardView {
                            // Тип продукта
                            Picker("", selection: $viewModel.productType) {
                                ForEach(ProductType.allCases, id: \.self) { type in
                                    Text(type.displayName).tag(type)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.bottom, 8)
                            
                            // Режим плотности
                            Picker("", selection: $viewModel.densityMode) {
                                Text(DensityMode.at15.displayName).tag(DensityMode.at15)
                                Text(DensityMode.atTemperature.displayName).tag(DensityMode.atTemperature)
                            }
                            .pickerStyle(.segmented)
                            .padding(.bottom, 8)
                            
                            // Плотность
                            VStack(alignment: .leading, spacing: 8) {
                                Label("mainCalc.density".localized(), systemImage: "flask")
                                    .font(DesignSystem.Fonts.label())
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                
                                TextField("0.850", text: $viewModel.density)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .density)
                            }
                            
                            // Температура
                            VStack(alignment: .leading, spacing: 8) {
                                Label("mainCalc.temperature".localized(), systemImage: "thermometer")
                                    .font(DesignSystem.Fonts.label())
                                    .foregroundColor(DesignSystem.Colors.textSecondary)
                                
                                TextField("20.0", text: $viewModel.temperature)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .temperature)
                            }
                            
                            // Масса или объём
                            if viewModel.mode == "direct" {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("mainCalc.mass".localized(), systemImage: "scalemass")
                                        .font(DesignSystem.Fonts.label())
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                    
                                    TextField("1000.0", text: $viewModel.mass)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                                    .focused($focusedField, equals: .mass)
                                }
                            } else {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("mainCalc.volume".localized(), systemImage: "drop.fill")
                                        .font(DesignSystem.Fonts.label())
                                        .foregroundColor(DesignSystem.Colors.textSecondary)
                                    
                                    TextField("1000.0", text: $viewModel.volume)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                                    .focused($focusedField, equals: .volume)
                                }
                            }
                        }
                        
                        Button("mainCalc.calculate".localized()) {
                            viewModel.calculate()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(DesignSystem.Colors.accent)
                        .frame(maxWidth: .infinity)
                        .controlSize(.large)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("common.done".localized()) {
                    focusedField = nil
                }
            }
        }
        .sheet(item: $viewModel.result) { result in
            MainCalcResultView(
                result: result,
                mode: viewModel.mode,
                temperature: Double(viewModel.temperature.replacingOccurrences(of: ",", with: ".")) ?? 0,
                density: Double(viewModel.density.replacingOccurrences(of: ",", with: ".")) ?? 0,
                densityMode: viewModel.densityMode,
                inputValue: viewModel.mode == "direct" ? (Double(viewModel.mass.replacingOccurrences(of: ",", with: ".")) ?? 0) : (Double(viewModel.volume.replacingOccurrences(of: ",", with: ".")) ?? 0),
                onClose: { viewModel.result = nil }
            )
        }
        .alert("common.error".localized(), isPresented: $viewModel.showError) {
            Button("common.ok".localized(), role: .cancel) { }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}


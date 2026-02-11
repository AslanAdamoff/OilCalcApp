import SwiftUI

struct TripCalcView: View {
    
    @StateObject private var viewModel = TripCalcViewModel()
    // Focused field handled internally by TripPointCard, global dismissal used here
    @State private var showSaveTemplateAlert = false
    @State private var alertInput = ""
    
    var body: some View {
        ZStack {
            DesignSystem.Colors.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header Area
                    HStack {
                        Text("tripCalc.title".localized())
                            .font(DesignSystem.Fonts.title())
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                        
                        Spacer()
                        
                        // Templates Menu
                        Menu {
                            Button(action: {
                                alertInput = ""
                                showSaveTemplateAlert = true
                            }) {
                                Label("tripCalc.saveTemplate".localized(), systemImage: "square.and.arrow.down")
                            }
                            
                            Menu("tripCalc.loadManage".localized()) {
                                if viewModel.savedTemplates.isEmpty {
                                    Text("tripCalc.noTemplates".localized())
                                } else {
                                    ForEach(viewModel.savedTemplates) { template in
                                        Menu(template.name) {
                                            Button("tripCalc.load".localized()) {
                                                viewModel.loadTemplate(template)
                                            }
                                            Button("common.delete".localized(), role: .destructive) {
                                                viewModel.deleteTemplate(template)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Button(role: .destructive, action: { viewModel.resetToDefault() }) {
                                Label("tripCalc.resetAll".localized(), systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "list.bullet.rectangle.portrait")
                                .font(.title2)
                                .foregroundColor(DesignSystem.Colors.accent)
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    // Product Selection
                    DesignSystem.CardView(padding: 10, spacing: 6) {
                        Picker("", selection: $viewModel.productType) {
                            ForEach(ProductType.allCases, id: \.self) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Dynamic Points List
                    VStack(spacing: 12) {
                        ForEach($viewModel.points) { $point in
                            TripPointCard(
                                point: $point,
                                onDelete: {
                                    if let index = viewModel.points.firstIndex(where: { $0.id == point.id }) {
                                        viewModel.removePoint(at: IndexSet(integer: index))
                                    }
                                },
                                canDelete: viewModel.points.count > 2
                            )
                        }
                    }
                    
                    // Add Point Button
                    Button(action: { viewModel.addPoint() }) {
                        Label("tripCalc.addPoint".localized(), systemImage: "plus.circle.fill")
                            .font(DesignSystem.Fonts.header())
                            .foregroundColor(DesignSystem.Colors.accent)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignSystem.Colors.accent.opacity(0.5), lineWidth: 1)
                            .background(Color.clear)
                    )
                    
                    // Calculate Button
                    Button("tripCalc.calculate".localized()) {
                        viewModel.calculate()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(DesignSystem.Colors.accent)
                    .frame(maxWidth: .infinity)
                    .controlSize(.large)
                    .padding(.top, 8)
                    
                    // Spacer to ensure content can be scrolled up when keyboard is active
                    Color.clear.frame(height: 200)
                }
                .padding(16)
                .frame(maxWidth: .infinity)
            }
        }

        .onTapGesture {
            // Dismiss keyboard when tapping on background
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("common.done".localized()) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .sheet(item: $viewModel.result) { result in
            TripCalcResultView(
                result: result,
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
        .alert("tripCalc.saveTemplate".localized(), isPresented: $showSaveTemplateAlert) {
            TextField("tripCalc.templateName".localized(), text: $alertInput)
            Button("common.cancel".localized(), role: .cancel) { }
            Button("common.save".localized()) {
                if !alertInput.isEmpty {
                    viewModel.saveTemplate(name: alertInput)
                }
            }
        } message: {
            Text("tripCalc.saveTemplateName".localized())
        }
    }
}

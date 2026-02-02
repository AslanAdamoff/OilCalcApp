import SwiftUI

struct HistoryView: View {
    @State private var history: [HistoryEntry] = []
    @State private var showClearAlert = false
    @State private var selectedEntry: HistoryEntry?
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            if history.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock")
                        .font(.system(size: 64))
                        .foregroundStyle(.secondary)
                    Text("history.empty".localized())
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            } else {
                List {
                    ForEach(history) { entry in
                        Button {
                            selectedEntry = entry
                        } label: {
                            HistoryEntryRow(entry: entry)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteEntry(entry)
                            } label: {
                                Label("history.delete".localized(), systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("history.title".localized())
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if !history.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("history.clearAll".localized()) {
                        showClearAlert = true
                    }
                    .foregroundStyle(.red)
                }
            }
        }
        .onAppear {
            loadHistory()
        }
        .alert("Очистить всю историю?", isPresented: $showClearAlert) {
            Button("Отмена", role: .cancel) { }
            Button("Очистить", role: .destructive) {
                clearHistory()
            }
        } message: {
            Text("Все записи будут удалены без возможности восстановления.")
        }
        .sheet(item: $selectedEntry) { entry in
            if let result = entry.tripResult {
                TripCalcResultView(result: result, onClose: { selectedEntry = nil })
            } else if entry.dualResult != nil {
                // For MainCalc we can show a simple detail or reuse MainCalcResultView if adaptable
                // Current MainCalcResultView might be specific to the calc screen.
                // Let's just show a simple sheet for now or nothing if not tripCalc.
                // Actually user specifically asked for "results to be more full" which implies trip calc history context.
                // Let's assume this request is about Trip Calc history mostly.
                // But we should handle Main Calc too.
                
                // Let's use a generic view for Main Calc details if MainCalcResultView isn't suitable.
                // But looking at previous messages, MainCalcResultView was used as a half-sheet.
                // Let's just show Text for now or reuse existing row logic expanded.
                VStack {
                    Text("Basic Calculator Result")
                        .font(.headline)
                        .padding()
                    HistoryEntryRow(entry: entry)
                        .padding()
                    Button("Close") { selectedEntry = nil }
                }
                .presentationDetents([.medium])
            }
        }
    }
    
    private func loadHistory() {
        history = HistoryService.shared.loadHistory()
    }
    
    private func deleteEntry(_ entry: HistoryEntry) {
        HistoryService.shared.removeEntry(id: entry.id)
        loadHistory()
    }
    
    private func clearHistory() {
        HistoryService.shared.clearHistory()
        loadHistory()
    }
}

private struct HistoryEntryRow: View {
    let entry: HistoryEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.type.displayName)
                    .font(.headline)
                Spacer()
                Text(entry.date.formatted(date: .numeric, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if let dualResult = entry.dualResult {
                Text("При 15°C: \(ResultFormatters.formattedVolume(dualResult.at15)) л")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("При T: \(ResultFormatters.formattedVolume(dualResult.atT)) л")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            if let tripResult = entry.tripResult {
                Text("Δ Mass: \(ResultFormatters.formattedMass(tripResult.deltaMassKg)) kg")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Δ Объём (15°C): \(ResultFormatters.formattedVolume(tripResult.deltaV15)) л")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}


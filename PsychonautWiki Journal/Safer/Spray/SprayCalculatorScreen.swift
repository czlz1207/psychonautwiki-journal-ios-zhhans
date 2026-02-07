// Copyright (c) 2023. Isaak Hanimann.
// This file is part of PsychonautWiki Journal.
//
// PsychonautWiki Journal is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public Licence as published by
// the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// PsychonautWiki Journal is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with PsychonautWiki Journal. If not, see https://www.gnu.org/licenses/gpl-3.0.en.html.

import SwiftUI

struct SprayCalculatorScreen: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        SprayCalculatorScreenContent(
            units: $viewModel.units,
            weightPerSpray: $viewModel.weightPerSprayText,
            liquidAmountInMl: $viewModel.liquidAmountInMlText,
            totalWeight: $viewModel.totalWeightText,
            purityInPercent: $viewModel.purityInPercentText,
            sprayModels: viewModel.sprayModels,
            selectedSpray: $viewModel.selectedSpray,
            addSpray: {
                viewModel.isShowingAddSpray.toggle()
            },
            deleteSprays: viewModel.deleteSprays,
            doseAdjustedToPurity: viewModel.doseAdjustedToPurity
        )
        .sheet(isPresented: $viewModel.isShowingAddSpray) {
            AddSprayScreen()
        }
        .onDisappear {
            viewModel.saveSelect()
        }
    }
}

struct SprayCalculatorScreenContent: View {
    @Binding var units: WeightUnit
    @Binding var weightPerSpray: String
    @Binding var liquidAmountInMl: String
    @Binding var totalWeight: String
    @Binding var purityInPercent: String
    let sprayModels: [SprayModel]
    @Binding var selectedSpray: SprayModel?
    let addSpray: () -> Void
    let deleteSprays: (IndexSet) -> Void
    let doseAdjustedToPurity: Double?
    @Environment(\.editMode) private var editMode
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        List {
            Section(LocalizedStringKey("solute_weight_per_spray")) {
                HStack {
                    TextField(LocalizedStringKey("weight_per_spray"), text: $weightPerSpray)
                        .font(.title)
                        .keyboardType(.decimalPad)
                    Picker(LocalizedStringKey("units"), selection: $units) {
                        ForEach(WeightUnit.allCases, id: \.self) { option in
                            Text(option.rawValue).font(.title)
                        }
                    }.labelsHidden()
                }
                .padding(.vertical, 3)
            }
            Section {
                ForEach(sprayModels) { model in
                    Button {
                        selectedSpray = model
                    } label: {
                        HStack {
                            Text(model.name).font(.headline).foregroundColor(colorScheme == .dark ? Color.white : .black)
                            Text("\(model.contentInMl.asRoundedReadableString) ml = \(model.numSprays.asRoundedReadableString) sprays").foregroundColor(.secondary)
                            Spacer()
                            if selectedSpray == model {
                                Image(systemName: "checkmark").font(.headline).foregroundColor(.blue)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteSprays)
                if editMode?.wrappedValue.isEditing == true || sprayModels.isEmpty {
                    addSprayButton
                }

            } header: {
                HStack {
                    Text(LocalizedStringKey("spray_size"))
                    Spacer()
                    if !sprayModels.isEmpty {
                        EditButton()
                    }
                }
            }
            Section(LocalizedStringKey("result")) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        TextField(LocalizedStringKey("liquid_volume"), text: $liquidAmountInMl)
                            .keyboardType(.decimalPad)
                        Text("ml")
                    }.font(.title)
                    Image(systemName: "arrow.up.arrow.down")
                    HStack {
                        TextField(LocalizedStringKey("solute_weight"), text: $totalWeight)
                            .keyboardType(.decimalPad)
                        Text(units.rawValue)
                    }.font(.title)
                    HStack {
                        Image(systemName: "arrow.down")
                        TextField(LocalizedStringKey("purity"), text: $purityInPercent)
                            .keyboardType(.decimalPad)
                        Text("%")
                    }
                    if let doseAdjustedToPurity {
                        Text("\(doseAdjustedToPurity.asRoundedReadableString) \(units.rawValue)").font(.title)
                    }
                }
            }
            Section {
                Text(LocalizedStringKey("spray_calculator_desc"))
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(LocalizedStringKey("spray_calculator_title"))
    }

    private var addSprayButton: some View {
        Button(action: addSpray) {
            Label("add_spray", systemImage: "plus")
        }
    }
}

private let sprays = [
    SprayModel(name: "Small Spray", numSprays: 32, contentInMl: 5, spray: nil),
    SprayModel(name: "Big Spray", numSprays: 50, contentInMl: 10, spray: nil),
]

#Preview {
    NavigationStack {
        SprayCalculatorScreenContent(
            units: .constant(.mg),
            weightPerSpray: .constant(""),
            liquidAmountInMl: .constant(""),
            totalWeight: .constant(""),
            purityInPercent: .constant("90"),
            sprayModels: sprays,
            selectedSpray: .constant(sprays.first),
            addSpray: {},
            deleteSprays: { _ in },
            doseAdjustedToPurity: 211
        )
    }
}

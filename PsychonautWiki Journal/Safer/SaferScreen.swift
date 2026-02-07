// Copyright (c) 2022. Isaak Hanimann.
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

struct SaferScreen: View {
    var body: some View {
        List {
            Section("research") {
                Text(LocalizedStringKey("research_text"))
            }
            Section("testing") {
                Text(LocalizedStringKey("testing_text"))
                NavigationLink("drug_testing_services", value: GlobalNavigationDestination.testingServices)
                NavigationLink("reagent_testing", value: GlobalNavigationDestination.reagentTesting)
            }
            Section("dosage") {
                Text(LocalizedStringKey("dosage_text"))
                NavigationLink("Dosage Guide", value: GlobalNavigationDestination.doseGuide)
                NavigationLink("Dosage Classification", value: GlobalNavigationDestination.doseClassification)
                NavigationLink("volumetric_liquid_dosing", value: GlobalNavigationDestination.volumetricDosing)
            }
            Section("set") {
                Text(LocalizedStringKey("set_text"))
            }
            Section("setting") {
                Text(LocalizedStringKey("setting_text"))
            }
            NavigationLink("safer_hallucinogen_guide", value: GlobalNavigationDestination.saferHallucinogen)
            Section("combinations") {
                Text(LocalizedStringKey("combinations_text"))
                Link(
                    "Swiss Combination Checker",
                    destination: URL(string: "https://combi-checker.ch")!
                )
                Link(
                    "Tripsit Combination Checker",
                    destination: URL(string: "https://combo.tripsit.me")!
                )
            }
            Section("administration_routes") {
                SaferRoutesSectionContent()
            }
            Group {
                Section("allergy_tests") {
                    Text(LocalizedStringKey("allergy_tests_text"))
                }
                Section("reflection") {
                    Text(LocalizedStringKey("reflection_text"))
                }
                Section("safety_of_others") {
                    Text(LocalizedStringKey("safety_of_others_text"))
                }
                Section("recovery_position") {
                    Text(LocalizedStringKey("recovery_position_text"))
                    Link(destination: URL(string: "https://www.youtube.com/watch?v=dv3agW-DZ5I")!
                    ) {
                        Label("recovery_position_video", systemImage: "play")
                    }
                }
            }
            Section {
                NavigationLink(value: GlobalNavigationDestination.sprayCalculator) {
                    Label("spray_calculator", systemImage: "eyedropper").font(.headline)
                }
            }
        }
        .navigationTitle("safer_use")
    }
}

#Preview {
    SaferScreen()
}

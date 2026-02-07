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

struct WelcomeScreen: View {
    @Binding var isShowingWelcome: Bool
    @AppStorage(PersistenceController.isEyeOpenKey2) var isEyeOpen: Bool = false

    var imageName: String {
        isEyeOpen ? "Eye Open" : "Eye Closed"
    }

    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                Image(decorative: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 130, alignment: .center)
                    .padding(.leading, 10)
                    .onTapGesture(count: 3, perform: toggleEye)
                VStack(spacing: 20) {
                    (Text(LocalizedStringKey("welcome_to")) + Text(LocalizedStringKey("psychonautwiki_journal")).foregroundColor(.accentColor))
                        .multilineTextAlignment(.center)
                        .font(.largeTitle.bold())

                    ForEach(features) { feature in
                        HStack {
                            Image(systemName: feature.image)
                                .frame(width: 44)
                                .font(.title)
                                .foregroundColor(.accentColor)
                                .accessibilityHidden(true)

                            VStack(alignment: .leading) {
                                Text(feature.title)
                                    .font(.headline)

                                Text(feature.description)
                                    .foregroundColor(.secondary)
                            }
                            .accessibilityElement(children: .combine)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            Text("your_data_offline")
                .font(.footnote)
                .foregroundColor(.secondary)
            Button(action: {
                isShowingWelcome.toggle()
            }, label: {
                Text("i_understand")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }

    private func toggleEye() {
        isEyeOpen.toggle()
        playHapticFeedback()
    }

    let features = [
        Feature(
            title: NSLocalizedString("risk_reliability", comment: ""),
            description: NSLocalizedString("risk_reliability_desc", comment: ""),
            image: "brain.head.profile"
        ),
        Feature(
            title: NSLocalizedString("third_party_resources", comment: ""),
            description: NSLocalizedString("third_party_resources_desc", comment: ""),
            image: "person.2.wave.2"
        ),
        Feature(
            title: NSLocalizedString("consult_doctor", comment: ""),
            description: NSLocalizedString("consult_doctor_desc", comment: ""),
            image: "heart.text.square"
        ),
    ]
}

#Preview {
    WelcomeScreen(isShowingWelcome: .constant(true))
        .preferredColorScheme(.dark)
        .accentColor(Color.blue)
}

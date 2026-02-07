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

struct ExperienceToolbarContent: View {
    @ObservedObject var experience: Experience
    @Binding var saveableTimeDisplayStyle: SaveableTimeDisplayStyle
    @Binding var sheetToShow: ExperienceScreen.SheetOption?
    @Binding var isShowingDeleteConfirmation: Bool
    let addIngestion: () -> Void

    @AppStorage(PersistenceController.isEyeOpenKey2) private var isEyeOpen: Bool = false

    var body: some View {
        Group {
            Menu {
                ForEach(SaveableTimeDisplayStyle.allCases) { option in
                    Button {
                        withAnimation {
                            saveableTimeDisplayStyle = option
                        }
                    } label: {
                        if saveableTimeDisplayStyle == option {
                            Label(option.text, systemImage: "checkmark")
                        } else {
                            Text(option.text)
                        }
                    }
                }
            } label: {
                Label("Time Display", systemImage: "timer")
            }
            Menu {
                Button {
                    sheetToShow = .editNotes
                } label: {
                    Label("Edit Notes", systemImage: "pencil")
                }
                Button {
                    sheetToShow = .editTitle
                } label: {
                    Label("Edit Title", systemImage: "pencil")
                }
                let isFavorite = experience.isFavorite
                Button {
                    experience.isFavorite = !isFavorite
                    try? PersistenceController.shared.viewContext.save()
                } label: {
                    if isFavorite {
                        Label("Unfavorite", systemImage: "star.fill")
                    } else {
                        Label("Mark Favorite", systemImage: "star")
                    }
                }
                if experience.location == nil {
                    Button {
                        sheetToShow = .addLocation
                    } label: {
                        Label("add_location", systemImage: "plus")
                    }
                }
                Button(role: .destructive) {
                    isShowingDeleteConfirmation.toggle()
                } label: {
                    Label("delete_experience", systemImage: "trash")
                }
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            if isEyeOpen {
                Menu {
                    if !experience.isCurrent {
                        Button(action: addIngestion) {
                            Label("Add Ingestion", systemImage: "plus")
                        }
                    }
                    Button {
                        sheetToShow = .addRating
                    } label: {
                        Label("add_rating", systemImage: "plus.forwardslash.minus")
                    }
                    Button {
                        sheetToShow = .addTimedNote
                    } label: {
                        Label("add_timed_note", systemImage: "note.text")
                    }
                } label: {
                    Label("add", systemImage: "plus")
                }
            }
        }
    }
}

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

import AlertToast
import SwiftUI
import AppIntents

struct SettingsScreen: View {
    @AppStorage(PersistenceController.isEyeOpenKey2) var isEyeOpen: Bool = false
    @AppStorage(PersistenceController.isHidingDosageDotsKey) var isHidingDosageDots: Bool = false
    @AppStorage(PersistenceController.isHidingToleranceChartInExperienceKey) var isHidingToleranceChartInExperience: Bool = false
    @AppStorage(PersistenceController.isHidingSubstanceInfoInExperienceKey) var isHidingSubstanceInfoInExperience: Bool = false
    @AppStorage(Authenticator.hasToUnlockKey) var hasToUnlockApp: Bool = false
    @AppStorage(Authenticator.lockTimeOptionKey) var lockTimeOptionString: String = LockTimeOption.after5Minutes.rawValue
    @AppStorage(PersistenceController.areRedosesDrawnIndividuallyKey) var areRedosesDrawnIndividually: Bool = false
    @AppStorage(PersistenceController.shouldAutomaticallyStartLiveActivityKey) var shouldAutomaticallyStartLiveActivity: Bool = true
    @AppStorage(PersistenceController.independentSubstanceHeightKey) var areSubstanceHeightsIndependent: Bool = false
    @StateObject private var viewModel = ViewModel()
    @EnvironmentObject var authenticator: Authenticator

    private var lockTimeOption: LockTimeOption {
        LockTimeOption(rawValue: lockTimeOptionString) ?? LockTimeOption.after5Minutes
    }

    private func setLockTimeOption(option: LockTimeOption) {
        lockTimeOptionString = option.rawValue
    }

    var body: some View {
        let timeOptionBinding = Binding {
            lockTimeOption
        } set: { newValue in
            setLockTimeOption(option: newValue)
        }

        SettingsContent(
            isEyeOpen: $isEyeOpen,
            isHidingDosageDots: $isHidingDosageDots,
            isHidingToleranceChartInExperience: $isHidingToleranceChartInExperience,
            isHidingSubstanceInfoInExperience: $isHidingSubstanceInfoInExperience,
            areRedosesDrawnIndividually: $areRedosesDrawnIndividually,
            areSubstanceHeightsIndependent: $areSubstanceHeightsIndependent,
            shouldAutomaticallyStartLiveActivity: $shouldAutomaticallyStartLiveActivity,
            isFaceIDAvailable: authenticator.isFaceIDEnabled,
            hasToUnlockApp: $hasToUnlockApp,
            isExporting: $viewModel.isExporting,
            journalFile: viewModel.journalFile,
            exportData: {
                viewModel.exportData()
            },
            importData: { data in
                viewModel.importData(data: data)
            },
            deleteEverything: {
                viewModel.deleteEverything()
            },
            isShowingToast: $viewModel.isShowingToast,
            isSuccessToast: $viewModel.isShowingSuccessToast,
            toastMessage: $viewModel.toastMessage,
            lockTimeOption: timeOptionBinding
        )
    }
}

struct SettingsContent: View {
    @Binding var isEyeOpen: Bool
    @Binding var isHidingDosageDots: Bool
    @Binding var isHidingToleranceChartInExperience: Bool
    @Binding var isHidingSubstanceInfoInExperience: Bool
    @Binding var areRedosesDrawnIndividually: Bool
    @Binding var areSubstanceHeightsIndependent: Bool
    @Binding var shouldAutomaticallyStartLiveActivity: Bool
    let isFaceIDAvailable: Bool
    @Binding var hasToUnlockApp: Bool
    @State var isImporting = false
    @Binding var isExporting: Bool
    let journalFile: JournalFile
    @EnvironmentObject private var toastViewModel: ToastViewModel
    let exportData: () -> Void
    let importData: (Data) -> Void
    let deleteEverything: () -> Void
    @Binding var isShowingToast: Bool
    @Binding var isSuccessToast: Bool
    @Binding var toastMessage: String
    @Binding var lockTimeOption: LockTimeOption

    @State private var isShowingDeleteConfirmation = false
    @State private var isShowingImportAlert = false

    var body: some View {
        List {
            Section("privacy") {
                if isFaceIDAvailable {
                    Toggle("require_app_unlock", isOn: $hasToUnlockApp.animation()).tint(Color.accentColor)
                } else {
                    Text("enable_face_id_message")
                }
                if hasToUnlockApp {
                    Picker("time_option", selection: $lockTimeOption) {
                        ForEach(LockTimeOption.allCases) { option in
                            Text(option.text)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            if isEyeOpen {
                Section("ui") {
                    NavigationLink(value: GlobalNavigationDestination.editColors) {
                        Label("edit_substance_colors", systemImage: "paintpalette")
                    }
                    NavigationLink(value: GlobalNavigationDestination.customUnits) {
                        Label("custom_units", systemImage: "pills")
                    }
                    Group {
                        Toggle("hide_dosage_dots", isOn: $isHidingDosageDots)
                        Toggle("hide_tolerance_chart", isOn: $isHidingToleranceChartInExperience)
                        Toggle("hide_substance_info", isOn: $isHidingSubstanceInfoInExperience)
                        Toggle("draw_redoses_individually", isOn: $areRedosesDrawnIndividually)
                        Toggle("independent_substance_heights", isOn: $areSubstanceHeightsIndependent)
                        if #available(iOS 16.2, *) {
                            if ActivityManager.shared.authorizationInfo.areActivitiesEnabled {
                                Toggle("automatic_live_activities", isOn: $shouldAutomaticallyStartLiveActivity)
                            }
                        }
                    }.tint(.accentColor)
                }
            }
            Section(
                header: Text("journal_data"),
                footer: Text("journal_data_footer")
            ) {
                Button {
                    exportData()
                } label: {
                    Label("export_data", systemImage: "arrow.up.doc")
                }
                Button {
                    isShowingImportAlert.toggle()
                } label: {
                    Label("import_data", systemImage: "arrow.down.doc")
                }
                .confirmationDialog(
                    "are_you_sure",
                    isPresented: $isShowingImportAlert,
                    titleVisibility: .visible,
                    actions: {
                        Button("import", role: .destructive) {
                            isImporting.toggle()
                        }
                        Button("cancel", role: .cancel) {}
                    },
                    message: {
                        Text("import_warning")
                    }
                )
                Button {
                    isShowingDeleteConfirmation.toggle()
                } label: {
                    Label("delete_everything", systemImage: "trash").foregroundColor(.red)
                }
                .confirmationDialog(
                    "delete_everything_title",
                    isPresented: $isShowingDeleteConfirmation,
                    titleVisibility: .visible,
                    actions: {
                        Button("delete", role: .destructive) {
                            deleteEverything()
                        }
                        Button("cancel", role: .cancel) {}
                    },
                    message: {
                        Text("delete_warning")
                    }
                )
            }
            Section("communication") {
                if isEyeOpen {
                    NavigationLink(value: GlobalNavigationDestination.faq) {
                        Label("frequently_asked_questions", systemImage: "questionmark.square")
                    }
                    Link(destination: URL(string: "https://github.com/isaakhanimann/psychonautwiki-journal-ios")!) {
                        Label("source_code", systemImage: "doc.text.magnifyingglass")
                    }
                }
            }
            Section {
                HStack {
                    Text("version")
                    Spacer()
                    Text(getCurrentAppVersion())
                        .foregroundColor(.secondary)
                }
            }
            eye
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.json]
        ) { result in
            do {
                let selectedFile: URL = try result.get()
                if selectedFile.startAccessingSecurityScopedResource() {
                    let data = try Data(contentsOf: selectedFile)
                    importData(data)
                } else {
                    toastViewModel.showErrorToast(message: "permission_denied")
                }
                selectedFile.stopAccessingSecurityScopedResource()
            } catch {
                toastViewModel.showErrorToast(message: "import_failed")
                print("Error getting data: \(error.localizedDescription)")
            }
        }
        .fileExporter(
            isPresented: $isExporting,
            document: journalFile,
            contentType: .json,
            defaultFilename: "Journal \(Date().asDateString)"
        ) { result in
            if case .success = result {
                toastViewModel.showSuccessToast(message: "export_successful")
            } else {
                toastViewModel.showErrorToast(message: "export_failed")
            }
        }
        .navigationTitle("settings")
        .toast(isPresenting: $isShowingToast) {
            AlertToast(
                displayMode: .alert,
                type: isSuccessToast ? .complete(.green) : .error(.red),
                title: toastMessage
            )
        }
    }

    private var eye: some View {
        HStack {
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80, alignment: .center)
                .onTapGesture(count: 3, perform: toggleEye)
            Spacer()
        }
        .listRowBackground(Color.clear)
    }

    private var imageName: String {
        isEyeOpen ? "Eye Open" : "Eye Closed"
    }

    private func toggleEye() {
        isEyeOpen.toggle()
        NotificationCenter.default.post(name: Notification.eyeName, object: nil)
        playHapticFeedback()
    }
}

#Preview {
    SettingsContent(
        isEyeOpen: .constant(true),
        isHidingDosageDots: .constant(false),
        isHidingToleranceChartInExperience: .constant(false),
        isHidingSubstanceInfoInExperience: .constant(false),
        areRedosesDrawnIndividually: .constant(false),
        areSubstanceHeightsIndependent: .constant(false),
        shouldAutomaticallyStartLiveActivity: .constant(false),
        isFaceIDAvailable: true,
        hasToUnlockApp: .constant(false),
        isImporting: false,
        isExporting: .constant(false),
        journalFile: JournalFile(experiences: [], customSubstances: [], customUnits: []),
        exportData: {},
        importData: { _ in },
        deleteEverything: {},
        isShowingToast: .constant(false),
        isSuccessToast: .constant(false),
        toastMessage: .constant(""),
        lockTimeOption: .constant(.after5Minutes)
    )
    .accentColor(Color.blue)
}

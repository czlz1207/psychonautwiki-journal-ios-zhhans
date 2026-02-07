// Copyright (c) 2024. Isaak Hanimann.
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

struct TimePointOrRangePicker: View {

    @Binding var selectedTimePickerOption: TimePickerOption
    @Binding var selectedTime: Date
    @Binding var selectedEndTime: Date

    var body: some View {
        Picker("time_picker_option", selection: $selectedTimePickerOption.animation()) {
            Text("time_point").tag(TimePickerOption.pointInTime)
            Text("time_range_option").tag(TimePickerOption.timeRange)
        }.pickerStyle(.segmented)
        .labelsHidden()
        .onChange(of: selectedTimePickerOption) { newValue in
            if newValue == .timeRange, selectedEndTime < selectedTime || selectedTime.distance(to: selectedEndTime) > 24*60*60 {
                selectedEndTime = selectedTime.addingTimeInterval(30*60)
            }
        }
        switch selectedTimePickerOption {
        case .pointInTime:
            HStack(alignment: .center) {
                DatePicker(
                    "time",
                    selection: $selectedTime,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.compact)
                Spacer()
                Button {
                    withAnimation {
                        selectedTime = Date.now
                    }
                } label: {
                    Label("reset_time", systemImage: "clock.arrow.circlepath").labelStyle(.iconOnly)
                }
            }
        case .timeRange:
            DatePicker(
                "start_time",
                selection: Binding(get: {
                    selectedTime
                }, set: { newStart in
                    selectedTime = newStart
                    if newStart > selectedEndTime || newStart.distance(to: selectedEndTime) > 24*60*60 {
                        selectedEndTime = newStart.addingTimeInterval(30*60)
                    }
                }),
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
            DatePicker(
                "end_time",
                selection: Binding(get: {
                    selectedEndTime
                }, set: { newEnd in
                    selectedEndTime = newEnd
                    if newEnd < selectedTime {
                        selectedTime = newEnd.addingTimeInterval(-30*60)
                    }
                }),
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
        }

    }
}

enum TimePickerOption {
    case pointInTime, timeRange
}

//
//  FiltersViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class FiltersViewModel: ObservableObject {

    @Published var selectedTimeSlots: Set<TimeSlot>
    @Published var transfersOption: TransfersOption?

    private let onApply: (Set<TimeSlot>, TransfersOption?) -> Void

    var isApplyAvailable: Bool {
        !selectedTimeSlots.isEmpty || transfersOption != nil
    }

    init(
        selectedTimeSlots: Set<TimeSlot>,
        transfersOption: TransfersOption?,
        onApply: @escaping (Set<TimeSlot>, TransfersOption?) -> Void
    ) {
        self.selectedTimeSlots = selectedTimeSlots
        self.transfersOption = transfersOption
        self.onApply = onApply
    }

    func toggle(_ timeSlot: TimeSlot) {
        if selectedTimeSlots.contains(timeSlot) {
            selectedTimeSlots.remove(timeSlot)
        } else {
            selectedTimeSlots.insert(timeSlot)
        }
    }

    func select(_ option: TransfersOption) {
        transfersOption = transfersOption == option ? nil : option
    }

    func apply() {
        onApply(selectedTimeSlots, transfersOption)
    }
}

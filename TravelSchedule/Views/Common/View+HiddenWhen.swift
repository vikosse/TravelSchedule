//
//  View+HiddenWhen.swift
//  TravelSchedule
//

import SwiftUI

extension View {

    /// Hides the view (and disables its hit testing) when `condition` is `true`,
    /// while keeping it in the view hierarchy so its state is preserved.
    @ViewBuilder
    func hiddenWhen(_ condition: Bool) -> some View {
        self
            .opacity(condition ? 0 : 1)
            .allowsHitTesting(!condition)
    }
}

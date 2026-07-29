//
//  NotFoundLabel.swift
//  TravelSchedule
//

import SwiftUI

struct NotFoundLabel: View {

    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color.ypBlack)
    }
}

#Preview {
    NotFoundLabel(text: "Город не найден")
}

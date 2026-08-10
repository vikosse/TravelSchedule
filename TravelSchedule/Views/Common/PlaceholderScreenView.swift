//
//  PlaceholderScreenView.swift
//  TravelSchedule
//

import SwiftUI

struct PlaceholderScreenView: View {

    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PlaceholderScreenView(title: "Настройки")
    }
}

//
//  LocationRow.swift
//  TravelSchedule
//

import SwiftUI

struct LocationRow: View {

    let title: String
    var showsChevron: Bool = false

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17))
                .foregroundStyle(Color.ypBlack)
            Spacer()
            if showsChevron {
                Image(.chevron)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.ypGray)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
        .background(Color.ypWhite)
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack(spacing: 0) {
        LocationRow(title: "Москва", showsChevron: true)
        LocationRow(title: "Курский вокзал")
    }
}

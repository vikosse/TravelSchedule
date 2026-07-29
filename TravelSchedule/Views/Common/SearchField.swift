//
//  SearchField.swift
//  TravelSchedule
//

import SwiftUI

struct SearchField: View {

    @Binding var text: String
    var placeholder: String = "Введите запрос"

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17))
                .foregroundStyle(Color.ypGray)

            TextField(placeholder, text: $text)
                .font(.system(size: 17))
                .foregroundStyle(Color.ypBlack)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.ypGray)
                }
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 36)
        .background(Color.ypLightGrey)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, 16)
    }
}

#Preview {
    SearchField(text: .constant(""))
}

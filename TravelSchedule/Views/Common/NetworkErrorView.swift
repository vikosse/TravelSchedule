//
//  NetworkErrorView.swift
//  TravelSchedule
//

import SwiftUI

struct NetworkErrorView: View {

    let kind: NetworkErrorKind
    let onRetry: () -> Void

    var body: some View {
        Button {
            onRetry()
        } label: {
            VStack(spacing: 16) {
                Image(kind.imageResource)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Text(kind.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.ypBlack)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ypWhite)
    }
}

#Preview {
    NetworkErrorView(kind: .noInternet) {}
}

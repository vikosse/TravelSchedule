//
//  CarrierRow.swift
//  TravelSchedule
//

import SwiftUI

struct CarrierRow: View {

    let viewModel: CarrierRowViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 8) {
                logoView

                Text(viewModel.carrierName)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.ypBlack)

                Spacer(minLength: 0)

                if !viewModel.dateText.isEmpty {
                    Text(viewModel.dateText)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.ypBlack)
                }
            }
            .padding(.horizontal, 14)

            timelineRow
        }
        .padding(.top, 14)
        .background(Color.ypLightGrey)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var logoView: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.ypWhite)
            .frame(width: 38, height: 38)
            .overlay {
                if let logoURL = viewModel.logoURL {
                    AsyncImage(url: logoURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                        } else {
                            logoPlaceholder
                        }
                    }
                } else {
                    logoPlaceholder
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var logoPlaceholder: some View {
        Text(viewModel.carrierName.prefix(1).uppercased())
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(Color.ypGray)
    }

    private var timelineRow: some View {
        HStack(spacing: 8) {
            Text(viewModel.departureText)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.ypBlack)

            ZStack {
                Rectangle()
                    .fill(Color.ypGray)
                    .frame(height: 1)

                if let durationText = viewModel.durationText {
                    Text(durationText)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.ypBlack)
                        .padding(.horizontal, 6)
                        .background(Color.ypLightGrey)
                }
            }
            .frame(maxWidth: .infinity)

            Text(viewModel.arrivalText)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.ypBlack)
        }
        .padding(14)
    }
}

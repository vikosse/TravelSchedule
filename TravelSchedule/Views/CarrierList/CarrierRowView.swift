//
//  CarrierRowView.swift
//  TravelSchedule
//

import SwiftUI

struct CarrierRowView: View {

    let viewModel: CarrierRowViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 8) {
                logoView
                carrierInfoView
                Spacer(minLength: 0)
                dateView
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
            .fill(Color.white)
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

    private var carrierInfoView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(viewModel.carrierName)
                .font(.system(size: 17))
                .foregroundStyle(Color.ypBlackUniversal)

            if viewModel.hasTransfers {
                Text(viewModel.transferLabel)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.ypRed)
            }
        }
    }

    @ViewBuilder
    private var dateView: some View {
        if !viewModel.dateText.isEmpty {
            Text(viewModel.dateText)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.ypBlackUniversal)
        }
    }

    private var timelineRow: some View {
        HStack(spacing: 8) {
            Text(viewModel.departureText)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.ypBlackUniversal)

            ZStack {
                Rectangle()
                    .fill(Color.ypGray)
                    .frame(height: 1)

                if let durationText = viewModel.durationText {
                    Text(durationText)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.ypBlackUniversal)
                        .padding(.horizontal, 6)
                        .background(Color.ypLightGrey)
                }
            }
            .frame(maxWidth: .infinity)

            Text(viewModel.arrivalText)
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(Color.ypBlackUniversal)
        }
        .padding(14)
    }
}

//
//  FiltersView.swift
//  TravelSchedule
//

import SwiftUI

struct FiltersView: View {

    @StateObject private var viewModel: FiltersViewModel
    @Environment(\.dismiss) private var dismiss

    init(
        selectedTimeSlots: Set<TimeSlot>,
        transfersOption: TransfersOption?,
        onApply: @escaping (Set<TimeSlot>, TransfersOption?) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: FiltersViewModel(
            selectedTimeSlots: selectedTimeSlots,
            transfersOption: transfersOption,
            onApply: onApply
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    section(title: "Время отправления") {
                        ForEach(TimeSlot.allCases, id: \.self) { timeSlot in
                            checkboxRow(timeSlot: timeSlot)
                        }
                    }

                    section(title: "Показывать варианты с пересадками") {
                        ForEach(TransfersOption.allCases, id: \.self) { option in
                            radioRow(option: option)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }

            if viewModel.isApplyAvailable {
                applyButton
            }
        }
        .background(Color.ypWhite.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.ypBlack)
                }
            }
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.ypBlack)

            VStack(alignment: .leading, spacing: 0) {
                content()
            }
        }
    }

    private func checkboxRow(timeSlot: TimeSlot) -> some View {
        Button {
            viewModel.toggle(timeSlot)
        } label: {
            HStack {
                Text(timeSlot.title)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.ypBlack)
                Spacer(minLength: 0)
                checkbox(isSelected: viewModel.selectedTimeSlots.contains(timeSlot))
            }
            .frame(height: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func radioRow(option: TransfersOption) -> some View {
        Button {
            viewModel.select(option)
        } label: {
            HStack {
                Text(option.title)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.ypBlack)
                Spacer(minLength: 0)
                radioMark(isSelected: viewModel.transfersOption == option)
            }
            .frame(height: 60)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func checkbox(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(isSelected ? Color.ypBlack : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .strokeBorder(Color.ypBlack, lineWidth: isSelected ? 0 : 2)
            )
            .overlay {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.ypWhite)
                }
            }
            .frame(width: 20, height: 20)
            .frame(width: 24, height: 24)
    }

    private func radioMark(isSelected: Bool) -> some View {
        Circle()
            .strokeBorder(Color.ypBlack, lineWidth: 2)
            .frame(width: 20, height: 20)
            .overlay {
                if isSelected {
                    Circle()
                        .fill(Color.ypBlack)
                        .frame(width: 10, height: 10)
                }
            }
            .frame(width: 24, height: 24)
    }

    private var applyButton: some View {
        Button {
            viewModel.apply()
            dismiss()
        } label: {
            Text("Применить")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.ypBlue)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

#Preview {
    NavigationStack {
        FiltersView(selectedTimeSlots: [], transfersOption: nil) { _, _ in }
    }
}

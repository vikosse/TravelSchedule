//
//  CarrierRowViewModel.swift
//  TravelSchedule
//

import Foundation

struct CarrierRowViewModel: Identifiable {

    let segment: Segment
    let fallbackDate: String
    let index: Int

    var id: String {
        let threadUID = segment.thread?.uid ?? segment.details?.compactMap(\.thread).first?.uid ?? ""
        let departureKey = segment.departure ?? segment.start_date ?? ""
        return "\(index)_\(threadUID)_\(departureKey)"
    }

    private var allThreads: [APIThread] {
        ([segment.thread] + (segment.details?.compactMap(\.thread) ?? [])).compactMap { $0 }
    }

    var carrierName: String {
        for thread in allThreads {
            if let title = thread.carrier?.title ?? thread.title, !title.isEmpty {
                return title
            }
        }
        return ""
    }

    var logoURL: URL? {
        for thread in allThreads {
            if let logo = thread.carrier?.logo, !logo.isEmpty, let url = URL(string: logo) {
                return url
            }
        }
        return nil
    }

    var carrierCode: String? {
        for thread in allThreads {
            if let code = thread.carrier?.code {
                return String(code)
            }
        }
        return nil
    }

    var transferCityName: String? {
        segment.transfers?.first?.title
    }

    var transferLabel: String {
        if let transferCityName, !transferCityName.isEmpty {
            return "С пересадкой в \(CityDeclensionFormatter.prepositional(transferCityName))"
        }
        return "С пересадкой"
    }

    var departureText: String {
        if let departure = segment.departure {
            return ScheduleFormatter.time(from: departure)
        }
        if let beginTime = segment.thread?.interval?.begin_time {
            return ScheduleFormatter.time(from: beginTime)
        }
        return ""
    }

    var arrivalText: String {
        if let arrival = segment.arrival {
            return ScheduleFormatter.time(from: arrival)
        }
        if let endTime = segment.thread?.interval?.end_time {
            return ScheduleFormatter.time(from: endTime)
        }
        return ""
    }

    var dateText: String {
        if let startDate = segment.start_date {
            let formatted = ScheduleFormatter.date(from: startDate)
            if !formatted.isEmpty { return formatted }
        }
        if let departure = segment.departure {
            let formatted = ScheduleFormatter.date(from: departure)
            if !formatted.isEmpty { return formatted }
        }
        if let days = segment.thread?.days, !days.isEmpty {
            return days
        }
        return fallbackDate
    }

    var durationText: String? {
        if let duration = segment.duration {
            return ScheduleFormatter.duration(seconds: duration)
        }
        if let departure = segment.departure, let arrival = segment.arrival {
            return ScheduleFormatter.duration(fromDeparture: departure, arrival: arrival)
        }
        return nil
    }

    var hasTransfers: Bool {
        segment.has_transfers ?? false
    }
}

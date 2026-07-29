//
//  CarrierRowViewModel.swift
//  TravelSchedule
//

import Foundation

struct CarrierRowViewModel {

    let segment: Segment
    let fallbackDate: String

    var carrierName: String {
        segment.thread?.carrier?.title ?? segment.thread?.title ?? ""
    }

    var logoURL: URL? {
        guard let logo = segment.thread?.carrier?.logo else { return nil }
        return URL(string: logo)
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
        segment.duration.map(ScheduleFormatter.duration)
    }
}

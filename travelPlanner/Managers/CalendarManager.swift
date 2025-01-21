//
//  CalendarManager.swift
//  travelPlanner
//
//  Created by Aruuke Turgunbaeva on 16/1/25.
//
import Foundation

class CalendarManager {
    let calendar = Calendar.current
    var selectedDate: Date = Date()

    func getDaysInMonth(for date: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: monthStart) - 1 // Weekday starts from 1 (Sunday)
        let totalDays = range.count
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        for day in 1...totalDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }
        return days
    }
    
    // If a given date is today
    func isToday(_ date: Date) -> Bool {
        return calendar.isDateInToday(date)
    }
    
    // If a given date is a tour date
    func isTourDate(_ date: Date, for tours: [Tour]) -> Bool {
        for tour in tours {
            if date >= tour.startDate && date <= tour.endDate {
                return true
            }
        }
        return false
    }

    // Get the name of the month for a given date
    func getMonthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy"
        return formatter.string(from: date)
    }
}

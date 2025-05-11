import Foundation

/// Represents an available date with its associated time slots
struct Availability: Codable, Identifiable {
    /// Unique identifier for the availability entry
    var id = UUID()
    
    /// The date as a string (e.g., "17")
    let date: String
    
    /// The month as a string (e.g., "August")
    let month: String
    
    /// The year as a string (e.g., "2025")
    let year: String
    
    /// Available time slots for this date
    let timeSlots: [TimeSlot]
    
    /// Computed property that returns the full date string (e.g., "17 August 2025")
    var fullDateString: String {
        return "\(date) \(month) \(year)"
    }
    
    /// Standard initializer
    init(date: String, month: String, year: String, timeSlots: [TimeSlot]) {
        self.date = date
        self.month = month
        self.year = year
        self.timeSlots = timeSlots
    }
    
    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case date, month, year, timeSlots
    }
}

/// Represents a time slot for concert performances
struct TimeSlot: Codable, Identifiable {
    /// Unique identifier for the time slot
    var id = UUID()
    
    /// The start time (e.g., "2:00PM")
    let startTime: String
    
    /// The end time (e.g., "4:00PM")
    let endTime: String
    
    /// Whether this time slot is available for booking
    var isAvailable: Bool
    
    /// Full representation of the time slot (e.g., "2:00PM - 4:00PM")
    var displayString: String {
        return "\(startTime) - \(endTime)"
    }
    
    /// Standard initializer
    init(startTime: String, endTime: String, isAvailable: Bool) {
        self.startTime = startTime
        self.endTime = endTime
        self.isAvailable = isAvailable
    }
    
    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case startTime, endTime, isAvailable
    }
}

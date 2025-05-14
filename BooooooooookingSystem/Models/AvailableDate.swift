import Foundation

/// Represents an available date with its associated time slots
struct AvailableDate: Codable, Identifiable {
    /// Unique identifier for the availability entry
    var id = UUID()
    
    /// The date as a string (e.g., "17")
    var date: String
    
    /// The month as a string (e.g., "August")
    var month: String
    
    /// The year as a string (e.g., "2025")
    var year: String
    
    /// Available time slots for this date
    var timeSlots: [TimeSlot]
    
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

//
//  TimeSlot.swift
//  BooooooooookingSystem
//
//  Created by Pham Cong Tri on 13/5/25.
//

import Foundation

/// Represents a time slot for concert performances
struct TimeSlot: Codable, Identifiable {
    /// Unique identifier for the time slot
    var id = UUID()
    
    /// The start time (e.g., "2:00PM")
    var startTime: String
    
    /// The end time (e.g., "4:00PM")
    var endTime: String
    
    /// Whether this time slot is available for booking
    var seatAreas: [SeatArea]
    
    /// Full representation of the time slot (e.g., "2:00PM - 4:00PM")
    var displayString: String {
        return "\(startTime) - \(endTime)"
    }
    
    /// Standard initializer
    init(startTime: String, endTime: String, seatAreas: [SeatArea]) {
        self.startTime = startTime
        self.endTime = endTime
        self.seatAreas = seatAreas
    }
    
    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case startTime, endTime, seatAreas
    }
}

extension TimeSlot {
    func isAvailable(for seatAreas: [SeatArea]) -> Bool {
        for area in seatAreas {
            if area.seats.contains(where: { $0.status == .available }) {
                return true
            }
        }
        return false
    }
}

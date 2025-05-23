import Foundation

// Represents an individual seat in the concert venue
struct Seat: Codable, Identifiable, Equatable {
    // Unique identifier for the seat
    var id = UUID()
    
    // The seat number
    var number: Int
    
    // The area code this seat belongs to (e.g., "A", "B", etc.)
//    let areaCode: String
    
    // The current status of this seat
    var status: SeatStatus
    
    // Enum representing possible seat statuses
    enum SeatStatus: String, Codable, CaseIterable {
        // Seat is available for booking
        case available
        
        // Seat is not available for booking (e.g., blocked, broken)
        case unavailable
        
        // Seat has been reserved or booked by a customer
        case reserved
    }
    
    // Initialize a new seat with the given details
    init(number: Int/*, areaCode: String*/, status: SeatStatus) {
        self.number = number
//        self.areaCode = areaCode
        self.status = status
    }
    
    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case number/*, areaCode*/, status
    }
}

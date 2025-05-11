import Foundation

/// Represents an individual seat in the concert venue
struct Seat: Codable, Identifiable {
    /// Unique identifier for the seat
    var id = UUID()
    
    /// The seat number
    let number: Int
    
    /// The area code this seat belongs to (e.g., "A", "B", etc.)
    let areaCode: String
    
    /// The current status of this seat
    var status: SeatStatus
    
    /// Enum representing possible seat statuses
    enum SeatStatus: String, Codable {
        /// Seat is available for booking
        case available
        
        /// Seat is not available for booking (e.g., blocked, broken)
        case unavailable
        
        /// Seat has been reserved or booked by a customer
        case reserved
    }
    
    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case number, areaCode, status
    }
    
    // Custom init for UUID persistence across encoding/decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = try container.decode(Int.self, forKey: .number)
        areaCode = try container.decode(String.self, forKey: .areaCode)
        status = try container.decode(SeatStatus.self, forKey: .status)
        id = UUID() // Generate a new UUID on decode
    }
    
    /// Initialize a new seat with the given details
    init(number: Int, areaCode: String, status: SeatStatus) {
        self.number = number
        self.areaCode = areaCode
        self.status = status
    }
}

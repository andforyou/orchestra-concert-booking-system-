import Foundation

/// Represents a seating area in the concert venue
struct SeatArea: Codable, Identifiable {
    /// Unique identifier for the seat area
    var id = UUID()
    
    /// The area code (e.g., "A", "B", "C", etc.)
    var code: String
    
    /// The price per seat in this area
    var price: Int
    
    /// List of advantages for this seating area
    var pros: [String]
    
    /// List of disadvantages for this seating area
    var cons: [String]
    
    /// List of seats within this area
    var seats: [Seat]
    
    /// Initialize a new seat area with the given details
    init(code: String, price: Int, pros: [String], cons: [String], seats: [Seat]) {
        self.code = code
        self.price = price
        self.pros = pros
        self.cons = cons
        self.seats = seats
    }
    
    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case code, price, pros, cons, seats
    }
}

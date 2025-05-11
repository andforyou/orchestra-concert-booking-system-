import Foundation

/// Represents a seating area in the concert venue
struct SeatArea: Codable, Identifiable {
    /// Unique identifier for the seat area
    var id = UUID()
    
    /// The area code (e.g., "A", "B", "C", etc.)
    let code: String
    
    /// The price per seat in this area
    let price: Int
    
    /// List of advantages for this seating area
    let pros: [String]
    
    /// List of disadvantages for this seating area
    let cons: [String]
    
    /// Initialize a new seat area with the given details
    init(code: String, price: Int, pros: [String], cons: [String]) {
        self.code = code
        self.price = price
        self.pros = pros
        self.cons = cons
    }
    
    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case code, price, pros, cons
    }
}

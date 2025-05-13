import Foundation

/// Represents a completed booking for concert tickets
struct Booking: Codable, Identifiable {
    /// Unique identifier for the booking
    var id = UUID()
    
    /// The date of the concert (e.g., "17")
    let date: String
    
    /// The month of the concert (e.g., "August")
    let month: String
    
    /// The year of the concert (e.g., "2025")
    let year: String
    
    /// The time slot for the concert (e.g., "2:00PM - 4:00PM")
    let timeSlot: String
    
    /// The area code (e.g., "A", "B", etc.)
    let areaCode: String
    
    /// The seat numbers included in this booking
    let seatNumbers: [Int]
    
    /// The total price for this booking
    let totalPrice: Int
    
    /// Customer information
    let customerInfo: CustomerInfo
    
    /// The date and time when this booking was made
    let bookingDate: Date
    
    /// Computed property for the full date string
    var fullDateString: String {
        return "\(date) \(month) \(year)"
    }
    
    /// Initialize a new booking with the given details
    init(date: String, month: String, year: String, timeSlot: String, areaCode: String, seatNumbers: [Int], totalPrice: Int, customerInfo: CustomerInfo) {
        self.date = date
        self.month = month
        self.year = year
        self.timeSlot = timeSlot
        self.areaCode = areaCode
        self.seatNumbers = seatNumbers
        self.totalPrice = totalPrice
        self.customerInfo = customerInfo
        self.bookingDate = Date()
    }
    
    /// Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case date, month, year, timeSlot, areaCode, seatNumbers, totalPrice, customerInfo, bookingDate
    }
}

/// Represents customer information for a booking
struct CustomerInfo: Codable {
    /// Customer's full name
    let name: String
    
    /// Customer's email address
    let email: String
    
    /// Customer's phone number
    let phone: String
    
    /// Customer's street address
    let address: String
    
    /// Customer's suburb
    let suburb: String
    
    /// Customer's state (e.g., "NSW", "VIC", etc.)
    let state: String
    
    /// Customer's postcode
    let postcode: String
    
    /// Initialize a new customer info object
    init(name: String, email: String, phone: String, address: String, suburb: String, state: String, postcode: String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.suburb = suburb
        self.state = state
        self.postcode = postcode
    }
}

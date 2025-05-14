import Foundation

// Represents a completed booking for concert tickets
struct Booking: Codable, Identifiable {
    // Unique identifier for the booking
    var id = UUID()
    
    // The concert title and metadata (not full Concert object to avoid redundancy)
    let concertTitle: String
    
    // The date of the concert
    let date: String
    let month: String
    let year: String
    
    // The time slot for the concert (e.g., "2:00PM - 4:00PM")
    let timeSlot: String
    
    // The area code (e.g., "A", "B", etc.)
    let areaCode: String
    
    // The seat numbers included in this booking
    let seatNumbers: [Int]
    
    // The total price for this booking
    let totalPrice: Int
    
    // Customer information
    let customer: Customer
    
    // The date and time when this booking was made
    let bookingDate: Date
    
    // Computed property for the full date string
    var fullDateString: String {
        return "\(date) \(month) \(year)"
    }
    
    // Initialize a new booking with the given details
    init(concert: Concert, date: String, month: String, year: String, timeSlot: String, areaCode: String, seatNumbers: [Int], totalPrice: Int, customer: Customer) {
        self.concertTitle = concert.title
        self.date = date
        self.month = month
        self.year = year
        self.timeSlot = timeSlot
        self.areaCode = areaCode
        self.seatNumbers = seatNumbers
        self.totalPrice = totalPrice
        self.customer = customer
        self.bookingDate = Date()
    }
    
    // Coding keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case concertTitle, date, month, year, timeSlot, areaCode, seatNumbers, totalPrice, customer, bookingDate
    }
}

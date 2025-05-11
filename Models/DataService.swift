import Foundation

/// Service for managing all data operations in the booking system
class DataService {
    /// Shared instance for singleton access
    static let shared = DataService()
    
    // MARK: - UserDefaults Keys
    private enum UserDefaultsKeys {
        static let bookings = "bookings"
        static let seatStatuses = "seatStatuses"
    }
    
    // MARK: - File Names
    private enum FileNames {
        static let availability = "availability.json"
        static let seatAreas = "seatAreas.json"
        static let australianLocations = "australianLocations.json"
        static func seats(forArea area: String) -> String {
            return "seats_\(area).json"
        }
    }
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    // MARK: - Data Loading Methods
    
    /// Load available dates and time slots from JSON
    func loadAvailableDates() -> [Availability] {
        guard let url = Bundle.main.url(forResource: FileNames.availability, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Availability].self, from: data)
        } catch {
            print("Error decoding availability data: \(error)")
            return []
        }
    }
    
    /// Load seat area information from JSON
    func loadSeatAreas() -> [SeatArea] {
        guard let url = Bundle.main.url(forResource: FileNames.seatAreas, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([SeatArea].self, from: data)
        } catch {
            print("Error decoding seat areas data: \(error)")
            return []
        }
    }
    
    /// Load seats for a specific area from JSON, updating status from UserDefaults
    func loadSeats(forArea: String) -> [Seat] {
        // Load initial seat data from JSON
        guard let url = Bundle.main.url(forResource: FileNames.seats(forArea: forArea), withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        do {
            var seats = try JSONDecoder().decode([Seat].self, from: data)
            
            // Update seats with any saved statuses
            if let savedStatuses = getSavedSeatStatuses() {
                for (index, seat) in seats.enumerated() {
                    let key = "\(seat.areaCode)_\(seat.number)"
                    if let statusString = savedStatuses[key],
                       let status = Seat.SeatStatus(rawValue: statusString) {
                        seats[index].status = status
                    }
                }
            }
            
            return seats
        } catch {
            print("Error decoding seats data: \(error)")
            return []
        }
    }
    
    /// Load Australian location data from JSON
    func loadAustralianLocations() -> AustralianLocation? {
        guard let url = Bundle.main.url(forResource: FileNames.australianLocations, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(AustralianLocation.self, from: data)
        } catch {
            print("Error decoding Australian locations data: \(error)")
            return nil
        }
    }
    
    // MARK: - Booking Management
    
    /// Save a new booking
    func saveBooking(_ booking: Booking) {
        var bookings = getAllBookings()
        bookings.append(booking)
        
        if let encodedData = try? JSONEncoder().encode(bookings) {
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.bookings)
        }
        
        // Update seat statuses to reserved
        for seatNumber in booking.seatNumbers {
            updateSeatStatus(areaCode: booking.areaCode, seatNumber: seatNumber, status: .reserved)
        }
    }
    
    /// Get all saved bookings
    func getAllBookings() -> [Booking] {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.bookings) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Booking].self, from: data)
        } catch {
            print("Error decoding bookings data: \(error)")
            return []
        }
    }
    
    // MARK: - Seat Status Management
    
    /// Update the status of a seat
    func updateSeatStatus(areaCode: String, seatNumber: Int, status: Seat.SeatStatus) {
        var statusDict = getSavedSeatStatuses() ?? [:]
        let key = "\(areaCode)_\(seatNumber)"
        statusDict[key] = status.rawValue
        
        if let encodedData = try? JSONEncoder().encode(statusDict) {
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.seatStatuses)
        }
    }
    
    /// Get all saved seat statuses
    private func getSavedSeatStatuses() -> [String: String]? {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.seatStatuses) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode([String: String].self, from: data)
        } catch {
            print("Error decoding seat statuses data: \(error)")
            return nil
        }
    }
    
    // MARK: - Utility Methods
    
    /// Reset all data (for testing purposes)
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.bookings)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.seatStatuses)
    }
}

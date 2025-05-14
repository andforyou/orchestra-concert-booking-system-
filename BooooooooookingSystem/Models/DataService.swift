import Foundation

// Service for managing all data operations in the booking system
class DataService {
    // Shared instance for singleton access
    static let shared = DataService()
    
    // UserDefaults Keys
    private enum UserDefaultsKeys {
        static let bookings = "bookings"
    }
    
    // File Names
    private enum FileNames {
        static let australianLocations = "australianLocations"
        static let concerts = "concerts"
        static func seats(forArea area: String) -> String {
            return "seats_\(area)"
        }
    }
    
    // Initialization
    
    // Private initializer to enforce singleton pattern
    private init() {}
    
    // Data Loading Methods
    
    func loadConcerts() -> [Concert] {
        let fileURL = concertsFileURL()

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                return try JSONDecoder().decode([Concert].self, from: data)
            } catch {
                print("Failed to decode saved concerts: \(error)")
            }
        }

        // Load from bundle as fallback
        guard let data = loadJsonFileData(named: FileNames.concerts) else {
            return []
        }

        do {
            let concerts = try JSONDecoder().decode([Concert].self, from: data)
            try data.write(to: fileURL, options: .atomic) // Copy to Documents
            return concerts
        } catch {
            print("Failed to decode fallback concerts: \(error)")
            return []
        }
    }
    
    func saveConcerts(_ concerts: [Concert]) {
        do {
            let data = try JSONEncoder().encode(concerts)
            try data.write(to: concertsFileURL(), options: .atomic)
            print("Concerts saved to Documents.")
        } catch {
            print("Failed to save concerts: \(error)")
        }
    }


    
//    /// Load available dates and time slots from JSON
//    func loadAvailableDates() -> [AvailableDate] {
//        // Try to read the JSON file
//        if let data = loadJsonFileData(named: FileNames.availability) {
//            do {
//                return try JSONDecoder().decode([AvailableDate].self, from: data)
//            } catch {
//                print("Error decoding availability data: \(error)")
//            }
//        }
//        
//        // If data couldn't be loaded, return hardcoded fallback data
//        return createFallbackAvailabilityData()
//    }
    
//    /// Load seat area information from JSON
//    func loadSeatAreas() -> [SeatArea] {
//        // Try to read the JSON file
//        if let data = loadJsonFileData(named: FileNames.seatAreas) {
//            do {
//                return try JSONDecoder().decode([SeatArea].self, from: data)
//            } catch {
//                print("Error decoding seat areas data: \(error)")
//            }
//        }
//        
//        // If data couldn't be loaded, return hardcoded fallback data
//        return [] /*createFallbackSeatAreaData()*/
//    }
//    
//    /// Load seats for a specific area from JSON, updating status from UserDefaults
//    func loadSeats(forArea: String) -> [Seat] {
//        // Try to read the JSON file
//        if let data = loadJsonFileData(named: FileNames.seats(forArea: forArea)) {
//            do {
//                var seats = try JSONDecoder().decode([Seat].self, from: data)
//                
//                // Update seats with any saved statuses
//                if let savedStatuses = getSavedSeatStatuses() {
//                    for (index, seat) in seats.enumerated() {
//                        let key = "\(seat.areaCode)_\(seat.number)"
//                        if let statusString = savedStatuses[key],
//                           let status = Seat.SeatStatus(rawValue: statusString) {
//                            seats[index].status = status
//                        }
//                    }
//                }
//                
//                return seats
//            } catch {
//                print("Error decoding seats data: \(error)")
//            }
//        }
//        
//        // If data couldn't be loaded, return hardcoded fallback data
//        return createFallbackSeatsData(forArea: forArea)
//    }
    

    
    // Booking Management
    // Save a new booking
    func saveBooking(_ booking: Booking) {
        var bookings = loadBooking()
        bookings.append(booking)
        
        if let encodedData = try? JSONEncoder().encode(bookings) {
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.bookings)
        }
    }
    
    // Load all bookings
    func loadBooking() -> [Booking] {
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
    
    // Seat Status Management
    
//    // Update the status of a seat
//    func updateSeatStatus(areaCode: String, seatNumber: Int, status: Seat.SeatStatus) {
//        var statusDict = getSavedSeatStatuses() ?? [:]
//        let key = "\(areaCode)_\(seatNumber)"
//        statusDict[key] = status.rawValue
//        
//        if let encodedData = try? JSONEncoder().encode(statusDict) {
//            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.seatStatuses)
//        }
//    }
//    
//    // Get all saved seat statuses
//    private func getSavedSeatStatuses() -> [String: String]? {
//        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.seatStatuses) else {
//            return nil
//        }
//        
//        do {
//            return try JSONDecoder().decode([String: String].self, from: data)
//        } catch {
//            print("Error decoding seat statuses data: \(error)")
//            return nil
//        }
//    }
    
    // Utility Methods
    
    // Helper method to load JSON data from a file
    private func loadJsonFileData(named filename: String) -> Data? {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch {
                print("Error loading \(filename).json: \(error)")
                return nil
            }
        }
        
        print("Could not find \(filename).json in bundle")
        return nil
    }
    
    // Reset all data (for testing purposes)
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.bookings)
    }
    
    // MARK: - Fallback Data Creation
    
//    /// Create fallback availability data if the JSON file can't be loaded
//    private func createFallbackAvailabilityData() -> [AvailableDate] {
//        return [
//            AvailableDate(date: "17", month: "August", year: "2025", timeSlots: [
//                TimeSlot(startTime: "2:00PM", endTime: "4:00PM", isAvailable: true),
//                TimeSlot(startTime: "8:00PM", endTime: "10:00PM", isAvailable: true)
//            ]),
//            AvailableDate(date: "18", month: "August", year: "2025", timeSlots: [
//                TimeSlot(startTime: "2:00PM", endTime: "4:00PM", isAvailable: true),
//                TimeSlot(startTime: "8:00PM", endTime: "10:00PM", isAvailable: true)
//            ]),
//            AvailableDate(date: "19", month: "August", year: "2025", timeSlots: [
//                TimeSlot(startTime: "2:00PM", endTime: "4:00PM", isAvailable: true),
//                TimeSlot(startTime: "8:00PM", endTime: "10:00PM", isAvailable: true)
//            ])
//        ]
//    }
//    
//    /// Create fallback seat area data if the JSON file can't be loaded
//    private func createFallbackSeatAreaData() -> [SeatArea] {
//        return [
//            SeatArea(code: "A", price: 250, pros: [
//                "Exceptional proximity to musicians allows you to see fine performance details",
//                "Immersive experience with immediate sound impact",
//                "Best view of soloists and conductor's expressions",
//                "Can observe instrumental techniques up close"
//            ], cons: [
//                "Sound can be less balanced (might hear nearest instruments more prominently)",
//                "May require looking up at an angle",
//                "Usually the most expensive tickets",
//                "Bass frequencies might overwhelm in some venues"
//            ]),
//            SeatArea(code: "B", price: 300, pros: [
//                "Often considered the acoustic \"sweet spot\" with balanced sound",
//                "Excellent overall view of the full orchestra",
//                "Comfortable viewing angle",
//                "Great balance between proximity and sound experience"
//            ], cons: [
//                "Still relatively expensive",
//                "Less intimate than front rows"
//            ]),
//            SeatArea(code: "C", price: 200, pros: [
//                "More affordable than front/middle sections",
//                "Good overall sound blend",
//                "Can see the entire orchestra without neck strain",
//                "Often underrated acoustically"
//            ], cons: [
//                "Details of performances may be harder to observe",
//                "Further from the emotional impact of being close to musicians",
//                "May miss subtle nuances of quieter passages"
//            ]),
//            SeatArea(code: "D", price: 200, pros: [
//                "Unique perspective of the orchestra",
//                "Sometimes better views of specific sections (piano, percussion)",
//                "Often priced lower than center sections"
//            ], cons: [
//                "Asymmetrical sound experience",
//                "Limited view of opposite-side instruments",
//                "Can feel somewhat disconnected from full orchestral experience"
//            ]),
//            SeatArea(code: "E", price: 200, pros: [
//                "Unique perspective of the orchestra",
//                "Sometimes better views of specific sections (piano, percussion)",
//                "Often priced lower than center sections"
//            ], cons: [
//                "Asymmetrical sound experience",
//                "Limited view of opposite-side instruments",
//                "Can feel somewhat disconnected from full orchestral experience"
//            ]),
//            SeatArea(code: "F", price: 165, pros: [
//                "Excellent panoramic view of entire orchestra",
//                "Often surprisingly good acoustics as sound rises",
//                "Can appreciate the full orchestral formation",
//                "Most affordable option",
//                "Most availability (many seats available)"
//            ], cons: [
//                "Greatest distance from performers",
//                "Cannot see fine details of performances",
//                "May feel less connected to the emotional experience"
//            ])
//        ]
//    }
    
//    /// Create fallback seat data if the JSON file can't be loaded
//    private func createFallbackSeatsData(forArea area: String) -> [Seat] {
//        // Create a different number of seats based on the area
//        let seatCount: Int
//        switch area {
//        case "A": seatCount = 25
//        case "B": seatCount = 30
//        case "C": seatCount = 35
//        case "D": seatCount = 36
//        case "E": seatCount = 32
//        case "F": seatCount = 40
//        default: seatCount = 30
//        }
//        
//        // Define which seats should be unavailable
//        let unavailableSeats: [Int]
//        switch area {
//        case "A": unavailableSeats = [3, 8, 12, 20, 21]
//        case "B": unavailableSeats = [5, 6, 14, 18, 22, 29]
//        case "C": unavailableSeats = [2, 7, 11, 15, 23, 30, 31]
//        case "D": unavailableSeats = [4, 9, 13, 18, 25, 27, 28, 30, 31, 32, 33, 34, 35]
//        case "E": unavailableSeats = [8, 10, 16, 20, 24, 25, 29]
//        case "F": unavailableSeats = [7, 13, 19, 25, 30, 34, 38]
//        default: unavailableSeats = []
//        }
//        
//        var seats = [Seat]()
//        for i in 0..<seatCount {
//            let status: Seat.SeatStatus = unavailableSeats.contains(i) ? .unavailable : .available
//            seats.append(Seat(number: i, areaCode: area, status: status))
//        }
//        
//        return seats
//    }
    // Load Australian location data from JSON
    func loadAustralianLocations() -> AustralianLocation? {
        // Try to read the JSON file
        if let data = loadJsonFileData(named: FileNames.australianLocations) {
            do {
                return try JSONDecoder().decode(AustralianLocation.self, from: data)
            } catch {
                print("Error decoding Australian locations data: \(error)")
            }
        }
        
        // If data couldn't be loaded, return hardcoded fallback data
        return createFallbackLocationData()
    }
    
    // Create fallback location data if the JSON file can't be loaded
    private func createFallbackLocationData() -> AustralianLocation {
        return AustralianLocation(states: [
            AustralianState(name: "New South Wales", code: "NSW", postcodeRange: ["2000", "2999"], suburbs: [
                Suburb(name: "Sydney", postcodes: ["2000", "2010", "2020"]),
                Suburb(name: "Newcastle", postcodes: ["2300", "2302", "2303"]),
                Suburb(name: "Wollongong", postcodes: ["2500", "2502", "2505"])
            ]),
            AustralianState(name: "Victoria", code: "VIC", postcodeRange: ["3000", "3999"], suburbs: [
                Suburb(name: "Melbourne", postcodes: ["3000", "3004", "3005"]),
                Suburb(name: "Geelong", postcodes: ["3220", "3214", "3215"]),
                Suburb(name: "Ballarat", postcodes: ["3350", "3353", "3354"])
            ]),
            AustralianState(name: "Queensland", code: "QLD", postcodeRange: ["4000", "4999"], suburbs: [
                Suburb(name: "Brisbane", postcodes: ["4000", "4001", "4005"]),
                Suburb(name: "Gold Coast", postcodes: ["4217", "4218", "4220"]),
                Suburb(name: "Sunshine Coast", postcodes: ["4550", "4551", "4552"])
            ]),
            AustralianState(name: "Western Australia", code: "WA", postcodeRange: ["6000", "6999"], suburbs: [
                Suburb(name: "Perth", postcodes: ["6000", "6001", "6005"]),
                Suburb(name: "Fremantle", postcodes: ["6160", "6162", "6163"]),
                Suburb(name: "Mandurah", postcodes: ["6210", "6211", "6215"])
            ]),
            AustralianState(name: "South Australia", code: "SA", postcodeRange: ["5000", "5799"], suburbs: [
                Suburb(name: "Adelaide", postcodes: ["5000", "5001", "5005"]),
                Suburb(name: "Glenelg", postcodes: ["5045", "5046"]),
                Suburb(name: "Port Adelaide", postcodes: ["5015", "5017"])
            ]),
            AustralianState(name: "Tasmania", code: "TAS", postcodeRange: ["7000", "7999"], suburbs: [
                Suburb(name: "Hobart", postcodes: ["7000", "7001", "7004"]),
                Suburb(name: "Launceston", postcodes: ["7250", "7248", "7249"]),
                Suburb(name: "Devonport", postcodes: ["7310", "7315"])
            ]),
            AustralianState(name: "Australian Capital Territory", code: "ACT", postcodeRange: ["2600", "2620"], suburbs: [
                Suburb(name: "Canberra", postcodes: ["2600", "2601", "2602"]),
                Suburb(name: "Belconnen", postcodes: ["2617", "2616", "2615"]),
                Suburb(name: "Woden", postcodes: ["2606", "2607"])
            ]),
            AustralianState(name: "Northern Territory", code: "NT", postcodeRange: ["0800", "0899"], suburbs: [
                Suburb(name: "Darwin", postcodes: ["0800", "0810", "0820"]),
                Suburb(name: "Alice Springs", postcodes: ["0870", "0871"]),
                Suburb(name: "Palmerston", postcodes: ["0830", "0831"])
            ])
        ])
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    private func concertsFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(FileNames.concerts).json")
    }
}

import Foundation

/// Represents all Australian location data for address selection
struct AustralianLocation: Codable {
    /// List of Australian states and territories
    let states: [State]
    
    /// Find a state by its code
    func findState(byCode code: String) -> State? {
        return states.first(where: { $0.code == code })
    }
}

/// Represents an Australian state or territory
struct State: Codable, Identifiable {
    /// The full name of the state/territory (e.g., "New South Wales")
    let name: String
    
    /// The state/territory code (e.g., "NSW")
    let code: String
    
    /// The range of postcodes for this state/territory
    let postcodeRange: [String]
    
    /// List of suburbs within this state/territory
    let suburbs: [Suburb]
    
    /// Unique identifier for the state (using the code)
    var id: String { code }
    
    /// Find a suburb by its name
    func findSuburb(byName name: String) -> Suburb? {
        return suburbs.first(where: { $0.name.lowercased() == name.lowercased() })
    }
    
    /// Get all postcodes for this state as a flat list
    var allPostcodes: [String] {
        return suburbs.flatMap { $0.postcodes }
    }
}

/// Represents an Australian suburb
struct Suburb: Codable, Identifiable {
    /// The name of the suburb
    let name: String
    
    /// The postcodes associated with this suburb
    let postcodes: [String]
    
    /// Unique identifier for the suburb (using the name)
    var id: String { name }
}

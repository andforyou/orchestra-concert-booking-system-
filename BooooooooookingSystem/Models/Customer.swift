//
//  Customer.swift
//  BooooooooookingSystem
//
//  Created by Pham Cong Tri on 13/5/25.
//

import Foundation

// Represents customer information for a booking
struct Customer: Identifiable, Codable {
    // Unique identifier for the customer
    var id = UUID()
    
    // Customer's full name
    var name: String

    // Customer's email address
    var email: String

    // Customer's phone number
    var phone: String

    // Customer's street address
    var address: String

    // Customer's suburb
    var suburb: String

    // Customer's state (e.g., "NSW", "VIC", etc.)
    var state: String

    // Customer's postcode
    var postcode: String
    
    // Static empty instance for default state
    static var empty: Customer {
        Customer(
            name: "",
            email: "",
            phone: "",
            address: "",
            suburb: "",
            state: "",
            postcode: ""
        )
    }
}

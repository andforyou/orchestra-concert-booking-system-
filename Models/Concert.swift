import Foundation

struct Concert: Identifiable, Codable {
    var id = UUID()
    let performerName: String
    let composerName: String
    let startDate: String
    let endDate: String
    let title: String
    let description: String
    let programme: [String]
    let artistInfo: [String]
    
    // Sample data for preview and testing
    static let sampleConcert = Concert(
        performerName: "ISLA MERCER",
        composerName: "RACHMANINOFF",
        startDate: "17",
        endDate: "19 August 2025",
        title: "Heart and Thunder",
        description: "When you hear the sweeping melodies of Rachmaninoff's Piano Concerto No. 2 you'll understand why it's hailed as one of the pinnacles of the repertoire—its rich harmonies and emotional depth carry you from intimate whispers to thunderous climaxes.",
        programme: [
            "ELIO NAKAMURA – Illumine* (World Premiere)",
            "STRAVINSKY – The Firebird Suite (selections)",
            "RACHMANINOFF – Piano Concerto No. 2"
        ],
        artistInfo: [
            "ALEXANDRIA CHEN · conductor",
            "ISLA MERCER · piano"
        ]
    )
}

// This extension will be useful for data persistence later
extension Concert {
    // Convert to JSON
    func toJSON() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    // Create from JSON
    static func fromJSON(data: Data) -> Concert? {
        return try? JSONDecoder().decode(Concert.self, from: data)
    }
}

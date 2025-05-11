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
    
    static let sampleConcert = Concert(
        performerName: "ISLA MERCER",
        composerName: "RACHMANINOFF",
        startDate: "17",
        endDate: "19 August 2025",
        title: "Heart and Thunder",
        description: "Its rich harmonies and emotional depth carry you from intimate whispers to thunderous climaxes.",
        programme: [
            "ELIO NAKAMURA – Illumine* (World Premiere)"
        ],
        artistInfo: [
            "ALEXANDRIA CHEN · conductor"
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

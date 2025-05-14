import Foundation

struct Concert: Identifiable, Codable {
    var id = UUID()
    let startDate: String
    let endDate: String
    let title: String
    let description: String
    let programme: [String]
    let artistInfo: [String]
    var availableDates: [AvailableDate]
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
    
    static let sampleConcert = Concert(
        startDate: "17",
        endDate: "19 August 2025",
        title: "ALEXANDRIA CHEN performs NAKAMURA - Illumine",
        description: "Heart and Thunder. Its rich harmonies and emotional depth carry you from intimate whispers to thunderous climaxes.",
        programme: [
            "ELIO NAKAMURA – Illumine* (World Premiere)"
        ],
        artistInfo: [
            "ALEXANDRIA CHEN · conductor"
        ],
        availableDates: generateSampleAvailableDates()
    )
    
        private static func generateSampleAvailableDates() -> [AvailableDate] {
            let days = [("17", "August", "2025"), ("18", "August", "2025"), ("19", "August", "2025")]
            return days.map { (date, month, year) in
                AvailableDate(
                    date: date,
                    month: month,
                    year: year,
                    timeSlots: [
                        TimeSlot(startTime: "2:00PM", endTime: "4:00PM", seatAreas: generateSeatAreas()),
                        TimeSlot(startTime: "8:00PM", endTime: "10:00PM", seatAreas: generateSeatAreas())
                    ]
                )
            }
        }
        
        private static func generateSeatAreas() -> [SeatArea] {
            return [
                SeatArea(
                    code: "A",
                    price: 350,
                    pros: [
                        "Exceptional proximity to musicians allows you to see fine performance details",
                        "Immersive experience with immediate sound impact",
                        "Best view of soloists and conductor's expressions",
                        "Can observe instrumental techniques up close"
                      ],
                    cons: [
                        "Sound can be less balanced (might hear nearest instruments more prominently)",
                        "May require looking up at an angle",
                        "Usually the most expensive tickets",
                        "Bass frequencies might overwhelm in some venues"
                      ],
                    seats: generateRandomSeats(count: 24)
                ),
                SeatArea(
                    code: "B",
                    price: 300,
                    pros: [
                        "Often considered the acoustic \"sweet spot\" with balanced sound",
                        "Excellent overall view of the full orchestra",
                        "Comfortable viewing angle",
                        "Great balance between proximity and sound experience"
                      ],
                    cons: [
                        "Still relatively expensive",
                        "Less intimate than front rows"
                      ],
                    seats: generateRandomSeats(count: 24)
                ),
                SeatArea(
                    code: "C",
                    price: 200,
                    pros: [
                        "More affordable than front/middle sections",
                        "Good overall sound blend",
                        "Can see the entire orchestra without neck strain",
                        "Often underrated acoustically"
                      ],
                    cons: [
                        "Details of performances may be harder to observe",
                        "Further from the emotional impact of being close to musicians",
                        "May miss subtle nuances of quieter passages"
                      ],
                    seats: generateRandomSeats(count: 24)
                ),
                SeatArea(
                    code: "D",
                    price: 200,
                    pros: [
                        "Unique perspective of the orchestra",
                        "Sometimes better views of specific sections (piano, percussion)",
                        "Often priced lower than center sections"
                      ],
                    cons: [
                        "Asymmetrical sound experience",
                        "Limited view of opposite-side instruments",
                        "Can feel somewhat disconnected from full orchestral experience"
                      ],
                    seats: generateRandomSeats(count: 40)
                ),
                SeatArea(
                    code: "E",
                    price: 200,
                    pros: [
                        "Unique perspective of the orchestra",
                        "Sometimes better views of specific sections (piano, percussion)",
                        "Often priced lower than center sections"
                      ],
                    cons: [
                        "Asymmetrical sound experience",
                        "Limited view of opposite-side instruments",
                        "Can feel somewhat disconnected from full orchestral experience"
                      ],
                    seats: generateRandomSeats(count: 40)
                ),
                SeatArea(
                    code: "F",
                    price: 165,
                    pros: [
                        "Excellent panoramic view of entire orchestra",
                        "Often surprisingly good acoustics as sound rises",
                        "Can appreciate the full orchestral formation",
                        "Most affordable option",
                        "Most availability (many seats available)"
                      ],
                    cons: [
                        "Greatest distance from performers",
                        "Cannot see fine details of performances",
                        "May feel less connected to the emotional experience"
                      ],
                    seats: generateRandomSeats(count: 40)
                )
            ]
        }

        private static func generateRandomSeats(count: Int) -> [Seat] {
            return (1...count).map { number in
                Seat(number: number, status: Seat.SeatStatus.allCases.randomElement()!)
            }
        }
}

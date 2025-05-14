//
//  ConcertViewModel.swift
//  BooooooooookingSystem
//
//  Created by Pham Cong Tri on 13/5/25.
//

import Foundation

class ConcertViewModel: ObservableObject {
    @Published var concerts: [Concert] = []
    
    init() {
        self.concerts = DataService.shared.loadConcerts()
    }
    
    func updateSeatStatus(
        concertID: UUID,
        dateID: UUID,
        timeSlotID: UUID,
        areaCode: String,
        seatNumbers: [Int],
        to newStatus: Seat.SeatStatus
    ) {
        guard let concertIndex = concerts.firstIndex(where: { $0.id == concertID }) else { return }

        var concert = concerts[concertIndex]

        for i in 0..<concert.availableDates.count {
            if concert.availableDates[i].id == dateID {
                for j in 0..<concert.availableDates[i].timeSlots.count {
                    if concert.availableDates[i].timeSlots[j].id == timeSlotID {
                        for k in 0..<concert.availableDates[i].timeSlots[j].seatAreas.count {
                            if concert.availableDates[i].timeSlots[j].seatAreas[k].code == areaCode {
                                for m in 0..<concert.availableDates[i].timeSlots[j].seatAreas[k].seats.count {
                                    if seatNumbers.contains(concert.availableDates[i].timeSlots[j].seatAreas[k].seats[m].number) {
                                        concert.availableDates[i].timeSlots[j].seatAreas[k].seats[m].status = newStatus
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        concerts[concertIndex] = concert
        DataService.shared.saveConcerts(concerts)
    }
}

//
//  ConcertViewModel.swift
//  BooooooooookingSystem
//
//  Created by Pham Cong Tri on 13/5/25.
//

import Foundation

class ConcertViewModel: ObservableObject {
    @Published var concert: Concert = Concert.sampleConcert
    
    func updateSeatStatus(
        on date: AvailableDate,
        timeSlot: TimeSlot,
        areaCode: String,
        seats: [Int],
        to newStatus: Seat.SeatStatus
    ) {
        // Traverse and mutate seat statuses in concert
        for i in 0..<concert.availableDates.count {
            if concert.availableDates[i].id == date.id {
                for j in 0..<concert.availableDates[i].timeSlots.count {
                    if concert.availableDates[i].timeSlots[j].id == timeSlot.id {
                        for k in 0..<concert.availableDates[i].timeSlots[j].seatAreas.count {
                            if concert.availableDates[i].timeSlots[j].seatAreas[k].code == areaCode {
                                for m in 0..<concert.availableDates[i].timeSlots[j].seatAreas[k].seats.count {
                                    if seats.contains(concert.availableDates[i].timeSlots[j].seatAreas[k].seats[m].number) {
                                        concert.availableDates[i].timeSlots[j].seatAreas[k].seats[m].status = newStatus
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

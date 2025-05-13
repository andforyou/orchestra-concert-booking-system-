//
//  BookingViewModel.swift
//  BooooooooookingSystem
//
//  Created by Pham Cong Tri on 13/5/25.
//

import Foundation

class BookingViewModel: ObservableObject {
    @Published var selectedDate: AvailableDate?
    @Published var selectedTimeSlot: TimeSlot?
    @Published var selectedSeatArea: SeatArea?
    @Published var selectedSeats: [Seat] = []
    @Published var customer: Customer = Customer.empty

    func generateBooking(concert: Concert) -> Booking? {
        guard let date = selectedDate,
              let slot = selectedTimeSlot,
              let area = selectedSeatArea
        else { return nil }

        return Booking(
            concert: concert,
            date: date.date,
            month: date.month,
            year: date.year,
            timeSlot: slot.displayString,
            areaCode: area.code,
            seatNumbers: selectedSeats.map { $0.number },
            totalPrice: area.price * selectedSeats.count,
            customer: customer
        )
    }

    func reset() {
        selectedDate = nil
        selectedTimeSlot = nil
        selectedSeatArea = nil
        selectedSeats = []
        customer = Customer.empty
    }
}

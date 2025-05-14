import SwiftUI

struct BookingHistoryView: View {
    @State private var bookings: [Booking] = []

    var body: some View {
        NavigationStack {
            List(bookings) { booking in
                VStack(alignment: .leading) {
                    Text(booking.concertTitle)
                        .font(.headline)
                    Text("\(booking.fullDateString) at \(booking.timeSlot)")
                        .font(.subheadline)
                    Text("Seats: \(booking.seatNumbers.map(String.init).joined(separator: ", ")) in Area \(booking.areaCode)")
                        .font(.caption)
                    Text("Total: $\(booking.totalPrice)")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("My Bookings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.purple, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .onAppear {
                loadBookings()
            }
        }
    }

    private func loadBookings() {
        bookings = DataService.shared.loadBooking()
    }
}

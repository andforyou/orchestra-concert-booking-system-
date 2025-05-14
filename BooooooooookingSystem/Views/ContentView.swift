import SwiftUI

enum BookingRoute: Hashable, Equatable {
    case concertDetails
    case dateSelection
    case seatAreaSelection
    case seatDetails
    case bookingDetails
}

struct ContentView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    
    var body: some View {
        TabView {
            // First Tab: Concert List
            ConcertListView()
                .environmentObject(concertVM)
                .environmentObject(bookingVM)
                .tabItem {
                    Label("Book Concert", systemImage: "music.note.list")
                }

            // Second Tab: Booking History
            BookingHistoryView()
                .environmentObject(concertVM)
                .environmentObject(bookingVM)
                .tabItem {
                    Label("My Bookings", systemImage: "ticket")
                }
        }
    }
}

#Preview {
    let concertVM = ConcertViewModel()
    concertVM.concerts = [.sampleConcert] // Assign array of one

    let bookingVM = BookingViewModel()
    bookingVM.selectedConcertIndex = 0     // Point to first (and only) concert

    return ContentView()
        .environmentObject(concertVM)
        .environmentObject(bookingVM)
}

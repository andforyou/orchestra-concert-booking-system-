import SwiftUI

@main
struct ConcertBookingSystemApp: App {
    @StateObject var concertVM = ConcertViewModel()
    @StateObject var bookingVM = BookingViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(concertVM)
                .environmentObject(bookingVM)
        }
    }
}

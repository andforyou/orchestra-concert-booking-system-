import SwiftUI

// MARK: - Type-Safe Navigation Route Enum
enum BookingRoute: Hashable, Equatable {
    case dateSelection
    case seatAreaSelection
    case seatDetails
    case bookingDetails
}

struct ContentView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            // Entry point: concert details screen
            ConcertDetailsView(path: $path)
                .environmentObject(concertVM)
                .environmentObject(bookingVM)
                .navigationDestination(for: BookingRoute.self) { route in
                    switch route {
                    case .dateSelection:
                        DateSelectionView(path: $path)
                            .environmentObject(concertVM)
                            .environmentObject(bookingVM)
                    case .seatAreaSelection:
                        SeatAreaSelectionView(path: $path)
                            .environmentObject(concertVM)
                            .environmentObject(bookingVM)
                    case .seatDetails:
                        SeatDetailsView(path: $path)
                            .environmentObject(concertVM)
                            .environmentObject(bookingVM)
                    case .bookingDetails:
                        BookingDetailsView(path: $path)
                            .environmentObject(concertVM)
                            .environmentObject(bookingVM)
                    }
                }
        }
    }
}

#Preview {
    let concertVM = ConcertViewModel()
    concertVM.concert = .sampleConcert
    
    return ContentView()
        .environmentObject(concertVM)
        .environmentObject(BookingViewModel())
}

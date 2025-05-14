import SwiftUI

struct ConcertListView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
                Text("Available Concerts")
                    .font(.title)
                    .padding(.horizontal)
                
                List {
                    ForEach(concertVM.concerts.indices, id: \.self) { index in
                        NavigationLink(
                            value: BookingRoute.dateSelection
                        ) {
                            VStack(alignment: .leading) {
                                Text(concertVM.concerts[index].title)
                                    .font(.headline)
                                Text(concertVM.concerts[index].description)
                                    .font(.subheadline)
                            }
                        }
                        .onTapGesture {
                            bookingVM.selectedConcertIndex = index
                        }
                    }
                }
            }
            .navigationDestination(for: BookingRoute.self) { route in
                switch route {
                case .dateSelection:
                    DateSelectionView(path: $path)
                case .seatAreaSelection:
                    SeatAreaSelectionView(path: $path)
                case .seatDetails:
                    SeatDetailsView(path: $path)
                case .bookingDetails:
                    BookingDetailsView(path: $path)
                }
            }
        }
    }
}

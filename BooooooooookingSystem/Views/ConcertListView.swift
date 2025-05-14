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
                        Button {
                            bookingVM.selectedConcertIndex = index
                            path.append(BookingRoute.concertDetails)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(concertVM.concerts[index].title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(concertVM.concerts[index].description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .navigationDestination(for: BookingRoute.self) { route in
                switch route {
                case .concertDetails:
                    ConcertDetailsView(path: $path)
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

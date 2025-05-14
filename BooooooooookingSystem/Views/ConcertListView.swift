import SwiftUI

struct ConcertListView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading) {
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
            .navigationTitle("Available Concerts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.purple, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
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

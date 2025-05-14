import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            ConcertListView()
                .tabItem {
                    Label("Book Concert", systemImage: "music.note.list")
                }

            BookingHistoryView()
                .tabItem {
                    Label("My Bookings", systemImage: "ticket")
                }
        }
    }
}

#Preview {
    HomeTabView()
        .environmentObject(ConcertViewModel())
        .environmentObject(BookingViewModel())
}

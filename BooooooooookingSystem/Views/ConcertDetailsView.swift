import SwiftUI

struct ConcertDetailsView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    @Binding var path: NavigationPath

    // Check if the concert has any available seats across all dates and time slots
    private var hasAvailableSeats: Bool {
        guard let concertIndex = bookingVM.selectedConcertIndex else { return false }
        
        let concert = concertVM.concerts[concertIndex]
        
        // Check each date
        for date in concert.availableDates {
            // Check each time slot
            for timeSlot in date.timeSlots {
                // Check each seat area
                for area in timeSlot.seatAreas {
                    // If any seat is available, return true
                    if area.seats.contains(where: { $0.status == .available }) {
                        return true
                    }
                }
            }
        }
        
        // If we got here, no available seats were found
        return false
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Concert Image
                Image("orchestra")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    // Main concert info
                    Text("\(concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].title)")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("\(concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].startDate) – \(concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].endDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Concert title and description
                    Text(concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 4)
                    
                    Text(concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Programme
                    Text("Programme")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    
                    ForEach(concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].programme, id: \.self) { item in
                        HStack(alignment: .top) {
                            Text("•")
                                .foregroundColor(.secondary)
                            Text(item)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    // Artist info
                    Text("Artist information")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    
                    ForEach(concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].artistInfo, id: \.self) { artist in
                        HStack(alignment: .top) {
                            Text("•")
                                .foregroundColor(.secondary)
                            Text(artist)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    // Book button / Sold Out when fully booked
                    Button(action: {
                        if hasAvailableSeats {
                            path.append(BookingRoute.dateSelection)
                        }
                    }) {
                        Text(hasAvailableSeats ? "Book" : "Sold Out")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(hasAvailableSeats ? Color.purple : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!hasAvailableSeats)
                    .padding(.top, 20)
                    
                    // Optional: Show sold out message
                    if !hasAvailableSeats {
                        Text("All performances for this concert are fully booked.")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Concert Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.purple, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
    }
}

// Preview
#Preview {
    NavigationStack {
        ConcertDetailsView(path: .constant(NavigationPath()))
            .environmentObject(ConcertViewModel())
            .environmentObject(BookingViewModel())
    }
}

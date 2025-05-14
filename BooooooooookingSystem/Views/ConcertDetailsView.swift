import SwiftUI

struct ConcertDetailsView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    @Binding var path: NavigationPath

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
                    
                    // Book button
                    Button(action: {
                        path.append(BookingRoute.dateSelection)
                    }) {
                        Text("Book")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Concert Details")
        .navigationBarTitleDisplayMode(.inline)
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

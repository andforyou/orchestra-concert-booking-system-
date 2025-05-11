import SwiftUI

struct ConcertDetailsView: View {
    let concert: Concert
    @State private var navigateToDateSelection = false
    
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
                    Text("\(concert.performerName) performs \(concert.composerName)")
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text("\(concert.startDate) – \(concert.endDate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Concert title and description
                    Text(concert.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 4)
                    
                    Text(concert.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Programme
                    Text("Programme")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    
                    ForEach(concert.programme, id: \.self) { item in
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
                    
                    ForEach(concert.artistInfo, id: \.self) { artist in
                        HStack(alignment: .top) {
                            Text("•")
                                .foregroundColor(.secondary)
                            Text(artist)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    // Book button
                    Button(action: {
                        navigateToDateSelection = true
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
        .navigationTitle("Symphonia")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: Text("Date Selection Screen"),
                isActive: $navigateToDateSelection,
                label: { EmptyView() }
            )
        )
    }
}

// Preview
struct ConcertDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConcertDetailsView(concert: Concert.sampleConcert)
        }
    }
}

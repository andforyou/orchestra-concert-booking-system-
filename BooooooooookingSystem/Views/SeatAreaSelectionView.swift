import SwiftUI

struct SeatAreaSelectionView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    @Binding var path: NavigationPath

    @State private var selectedArea: String = "D" // Default area selection

    // Computed: All areas from the selected time slot
    private var seatAreas: [SeatArea] {
        bookingVM.selectedTimeSlot?.seatAreas ?? []
    }

    // Computed: Selected area's full info
    private var selectedAreaInfo: SeatArea? {
        seatAreas.first(where: { $0.code == selectedArea })
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        // Seating Map
                        ZStack {
                            // Seating areas
                            VStack(spacing: 0) {
                                // Area F - sized to match the total width of areas below
                                AreaView(areaName: "F", isSelected: selectedArea == "F", action: { selectedArea = "F" })
                                    .frame(width: 310, height: 100)
                                
                                HStack(spacing: 0) {
                                    // Area D (Left side)
                                    AreaView(areaName: "D", isSelected: selectedArea == "D", action: { selectedArea = "D" })
                                        .frame(width: 80, height: 200)
                                    
                                    // Central sections
                                    VStack(spacing: 0) {
                                        // Area C
                                        AreaView(areaName: "C", isSelected: selectedArea == "C", action: { selectedArea = "C" })
                                            .frame(height: 60)
                                        
                                        // Area B
                                        AreaView(areaName: "B", isSelected: selectedArea == "B", action: { selectedArea = "B" })
                                            .frame(height: 60)
                                        
                                        // Area A
                                        AreaView(areaName: "A", isSelected: selectedArea == "A", action: { selectedArea = "A" })
                                            .frame(height: 80)
                                    }
                                    .frame(width: 150)
                                    
                                    // Area E (Right side)
                                    AreaView(areaName: "E", isSelected: selectedArea == "E", action: { selectedArea = "E" })
                                        .frame(width: 80, height: 200)
                                }
                                
                                // Stage - positioned below area A with enough space to avoid overlap
                                StageView()
                            }
                        }
                        .frame(height: 460)
                        .padding(.top, 20)
                        
                        // Area Information
                        VStack(alignment: .leading, spacing: 3) {
                            if let info = selectedAreaInfo {
                                // Pros
                                Text("Pros:")
                                    .font(.headline)
                                    .padding(.top, 8)
                                
                                ForEach(info.pros, id: \.self) { pro in
                                    HStack(alignment: .top) {
                                        Text("•")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        Text(pro)
                                            .font(.subheadline)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.leading, 4)
                                }
                                
                                // Cons
                                Text("Cons:")
                                    .font(.headline)
                                    .padding(.top, 8)
                                
                                ForEach(info.cons, id: \.self) { con in
                                    HStack(alignment: .top) {
                                        Text("•")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        Text(con)
                                            .font(.subheadline)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding(.leading, 4)
                                }
                                
                                // Price
                                Text("Area \(selectedArea): $\(info.price)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.purple)
                                    .padding(.top, 16)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .frame(minHeight: geometry.size.height * 0.8)
                }
                
                // Next button
                Button(action: {
                    if let selected = selectedAreaInfo {
                        bookingVM.selectedSeatArea = selected
                        path.append(BookingRoute.seatDetails)
                    }
                }) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Seat Selection")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Keep the rest of the code the same
struct AreaView: View {
    let areaName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(isSelected ? Color.purple : Color.purple.opacity(0.3))
                    .border(Color.purple, width: 1)
                
                Text(areaName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? .white : .purple)
            }
        }
    }
}

// Stage View Component
struct StageView: View {
    var body: some View {
        ZStack {
            Arc()
                .fill(Color(red: 0.5, green: 0.4, blue: 0.1))
                .frame(width: 160, height: 80)
            
            Text("Stage")
                .foregroundColor(.white)
                .font(.headline)
                .offset(y: -5)
        }
    }
}

// Custom Arc Shape for Stage
struct Arc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addArc(center: CGPoint(x: rect.width/2, y: 0),
                    radius: rect.width/2,
                    startAngle: .degrees(0),
                    endAngle: .degrees(180),
                    clockwise: false)
        
        return path
    }
}

#Preview {
    NavigationStack {
        SeatAreaSelectionView(path: .constant(NavigationPath()))
            .environmentObject(ConcertViewModel())
            .environmentObject(BookingViewModel())
    }
}

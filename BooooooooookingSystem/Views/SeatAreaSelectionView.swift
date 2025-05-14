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
    
    // Check if an area has any available seats
    private func isAreaAvailable(_ areaCode: String) -> Bool {
        guard let area = seatAreas.first(where: { $0.code == areaCode }) else {
            return false
        }
        return area.seats.contains(where: { $0.status == .available })
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
                                AreaView(
                                    areaName: "F",
                                    isSelected: selectedArea == "F",
                                    isDisabled: !isAreaAvailable("F"),
                                    action: { selectedArea = "F" }
                                )
                                .frame(width: 310, height: 100)
                                
                                HStack(spacing: 0) {
                                    // Area D (Left side)
                                    AreaView(
                                        areaName: "D",
                                        isSelected: selectedArea == "D",
                                        isDisabled: !isAreaAvailable("D"),
                                        action: { selectedArea = "D" }
                                    )
                                    .frame(width: 80, height: 200)
                                    
                                    // Central sections
                                    VStack(spacing: 0) {
                                        // Area C
                                        AreaView(
                                            areaName: "C",
                                            isSelected: selectedArea == "C",
                                            isDisabled: !isAreaAvailable("C"),
                                            action: { selectedArea = "C" }
                                        )
                                        .frame(height: 60)
                                        
                                        // Area B
                                        AreaView(
                                            areaName: "B",
                                            isSelected: selectedArea == "B",
                                            isDisabled: !isAreaAvailable("B"),
                                            action: { selectedArea = "B" }
                                        )
                                        .frame(height: 60)
                                        
                                        // Area A
                                        AreaView(
                                            areaName: "A",
                                            isSelected: selectedArea == "A",
                                            isDisabled: !isAreaAvailable("A"),
                                            action: { selectedArea = "A" }
                                        )
                                        .frame(height: 80)
                                    }
                                    .frame(width: 150)
                                    
                                    // Area E (Right side)
                                    AreaView(
                                        areaName: "E",
                                        isSelected: selectedArea == "E",
                                        isDisabled: !isAreaAvailable("E"),
                                        action: { selectedArea = "E" }
                                    )
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
                                // Availability status
                                if !isAreaAvailable(selectedArea) {
                                    Text("This zone is fully booked")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .padding(.top, 8)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                
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
                .disabled(!isAreaAvailable(selectedArea))
                .padding()
            }
            .navigationTitle("Zone Selection")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Set initial selected area to the first available area
                if !isAreaAvailable(selectedArea) {
                    for area in ["A", "B", "C", "D", "E", "F"] {
                        if isAreaAvailable(area) {
                            selectedArea = area
                            break
                        }
                    }
                }
            }
        }
    }
}

// Updated AreaView to include disabled state
struct AreaView: View {
    let areaName: String
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                    .border(Color.purple, width: isDisabled ? 0 : 1)
                
                Text(areaName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                
                if isDisabled {
                    Text("Fully Booked")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(4)
                        .offset(y: 15)
                }
            }
        }
        .disabled(isDisabled)
    }
    
    private var backgroundColor: Color {
        if isDisabled {
            return Color.gray.opacity(0.5)
        } else if isSelected {
            return Color.purple
        } else {
            return Color.purple.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        if isDisabled {
            return Color.white.opacity(0.7)
        } else if isSelected {
            return .white
        } else {
            return .purple
        }
    }
}

// Leave the rest of the code the same
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

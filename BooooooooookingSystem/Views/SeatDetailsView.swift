import SwiftUI

struct SeatDetailsView: View {
    let concert: Concert
    let selectedDate: Int
    let selectedTimeSlot: Int
    let selectedArea: String
    let areaPrice: Int
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSeats: Set<Int> = []
    @State private var navigateToOrderDetails = false
    
    // Load seats from DataService
    @State private var seats: [Seat] = []
    
    // Calculate the subtotal based on selected seats
    var subtotal: Int {
        return selectedSeats.count * areaPrice
    }
    
    var body: some View {
        VStack {
            // Area title
            Text("Area \(selectedArea) Seats")
                .font(.headline)
                .padding(.top)
            
            // Seat layout visualization
            ZStack {
                // Background shape for the seating area
                areaShape
                
                // Grid of seats
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: getColumnCount()), spacing: 10) {
                    ForEach(seats) { seat in
                        SeatView(
                            seatNumber: seat.number,
                            status: convertSeatStatus(seat.status),
                            isSelected: selectedSeats.contains(seat.number),
                            onTap: { toggleSeatSelection(seat) }
                        )
                    }
                }
                .padding(20)
            }
            .padding()
            
            // Legend
            HStack(spacing: 20) {
                legendItem(color: .purple.opacity(0.3), text: "Available")
                legendItem(color: .orange, text: "Selected")
                legendItem(color: Color(white: 0.5), text: "Unavailable")
            }
            .padding()
            
            Spacer()
            
            // Subtotal
            Text("Subtotal: $\(subtotal)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.purple)
                .padding()
            
            // Next button
            Button(action: {
                navigateToOrderDetails = true
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .disabled(selectedSeats.isEmpty) // Disable if no seats selected
        }
        .navigationTitle("Symphonia")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        .background(
            NavigationLink(
                destination: OrderDetailsView(
                    concert: concert,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    selectedArea: selectedArea,
                    selectedSeats: selectedSeats,
                    totalPrice: subtotal
                ),
                isActive: $navigateToOrderDetails,
                label: { EmptyView() }
            )
        )
        .onAppear {
            // Load seats when view appears
            loadSeats()
        }
    }
    
    // Load seats from DataService
    private func loadSeats() {
        seats = DataService.shared.loadSeats(forArea: selectedArea)
    }
    
    // Convert Seat.SeatStatus to SeatStatus.Status for compatibility with existing code
    private func convertSeatStatus(_ status: Seat.SeatStatus) -> SeatStatus.Status {
        switch status {
        case .available:
            return .available
        case .unavailable, .reserved:
            return .unavailable
        }
    }
    
    // Custom back button
    private var customBackButton: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(.purple)
        }
    }
    
    // Toggle seat selection
    private func toggleSeatSelection(_ seat: Seat) {
        if seat.status == .available {
            if selectedSeats.contains(seat.number) {
                selectedSeats.remove(seat.number)
            } else {
                selectedSeats.insert(seat.number)
            }
        }
    }
    
    // Determine column count based on area
    private func getColumnCount() -> Int {
        switch selectedArea {
        case "A", "B", "C": return 5
        case "D", "E": return 4
        case "F": return 6
        default: return 5
        }
    }
    
    // Legend item helper
    private func legendItem(color: Color, text: String) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 16, height: 16)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // Different shapes for different seating areas
    @ViewBuilder
    private var areaShape: some View {
        switch selectedArea {
        case "A":
            Rectangle()
                .fill(Color.purple)
                .frame(width: 280, height: 240)
                .cornerRadius(8)
        case "B":
            Rectangle()
                .fill(Color.purple)
                .frame(width: 300, height: 260)
                .cornerRadius(8)
        case "C":
            Rectangle()
                .fill(Color.purple)
                .frame(width: 320, height: 280)
                .cornerRadius(8)
        case "D":
            // Trapezoid shape for side sections
            Trapezoid(invert: false)
                .fill(Color.purple)
                .frame(width: 280, height: 360)
        case "E":
            // Trapezoid shape for side sections (inverted)
            Trapezoid(invert: true)
                .fill(Color.purple)
                .frame(width: 280, height: 360)
        case "F":
            // Wide rectangle for rear section
            Rectangle()
                .fill(Color.purple)
                .frame(width: 350, height: 240)
                .cornerRadius(8)
        default:
            Rectangle()
                .fill(Color.purple)
                .frame(width: 300, height: 260)
                .cornerRadius(8)
        }
    }
}

// Keep this model the same for compatibility with existing seat view code
struct SeatStatus: Identifiable {
    let id: Int
    let status: Status
    
    enum Status {
        case available
        case unavailable
    }
}

// Seat view component (kept the same for compatibility)
struct SeatView: View {
    let seatNumber: Int
    let status: SeatStatus.Status
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Seat circle
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 30, height: 30)
                
                // Seat border
                Circle()
                    .stroke(status == .unavailable ? Color.clear : Color.white, lineWidth: 2)
                    .frame(width: 30, height: 30)
            }
        }
        .disabled(status == .unavailable)
    }
    
    // Determine background color based on status and selection
    private var backgroundColor: Color {
        if status == .unavailable {
            return Color(white: 0.5) // Gray for unavailable
        } else if isSelected {
            return .orange // Orange for selected
        } else {
            return .purple.opacity(0.3) // Light purple for available
        }
    }
}

// Custom trapezoid shape for side seating areas
struct Trapezoid: Shape {
    let invert: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if invert {
            path.move(to: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
        
        return path
    }
}

import SwiftUI

struct DateSelectionView: View {
    let concert: Concert
    @State private var selectedDate: Int = 17  // Default to 17th
    @State private var selectedTimeSlot: Int = 0  // 0 for 2-4pm, 1 for 8-10pm
    @State private var navigateToSeatSelection = false
    
    // Available dates for the concert
    let availableDates = [17, 18, 19]
    
    // Available time slots
    let timeSlots = ["2:00PM - 4:00PM", "8:00PM - 10:00PM"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Calendar view
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("August 2025")
                        .font(.headline)
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.trailing, 8)
                }
                
                // Calendar days header
                HStack {
                    ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.top, 4)
                
                // Calendar grid (simplified for August 2025)
                Group {
                    // Week 1 (empty space + 1-5)
                    HStack {
                        Text("") // Empty space for Sunday
                            .frame(maxWidth: .infinity)
                        
                        ForEach(1..<6) { day in
                            Text("\(day)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Week 2 (6-12)
                    HStack {
                        ForEach(6..<13) { day in
                            Text("\(day)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Week 3 (13-19) - Contains selectable concert dates
                    HStack {
                        ForEach(13..<20) { day in
                            calendarDay(day)
                        }
                    }
                    
                    // Week 4 (20-26)
                    HStack {
                        ForEach(20..<27) { day in
                            Text("\(day)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Week 5 (27-31 + empty spaces)
                    HStack {
                        ForEach(27..<32) { day in
                            Text("\(day)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.primary)
                        }
                        
                        // Empty spaces for the rest of the week
                        ForEach(0..<2) { _ in
                            Text("")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                HStack {
//                    Spacer()
//                    Text("Cancel")
//                        .foregroundColor(.gray)
//                    
//                    Spacer()
//                    
//                    Text("OK")
//                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.top, 8)
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(20)
            
            // Time slot selection
            VStack(spacing: 16) {
                ForEach(0..<timeSlots.count, id: \.self) { index in
                    Button(action: {
                        selectedTimeSlot = index
                    }) {
                        HStack {
                            Circle()
                                .fill(selectedTimeSlot == index ? Color.purple : Color.clear)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(Color.purple, lineWidth: 1.5)
                                )
                            
                            Text(timeSlots[index])
                                .foregroundColor(selectedTimeSlot == index ? .primary : .gray)
                                .padding(.leading, 8)
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Next button
            Button(action: {
                navigateToSeatSelection = true
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
            .padding(.bottom, 16)
        }
        .navigationTitle("Symphonia")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        // In DateSelectionView.swift, replace the NavigationLink code with this:

        .background(
            NavigationLink(
                destination: SeatAreaSelectionView(
                    concert: concert,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot
                ),
                isActive: $navigateToSeatSelection,
                label: { EmptyView() }
            )
        )
    }
    
    // Custom calendar day view
    private func calendarDay(_ day: Int) -> some View {
        ZStack {
            if availableDates.contains(day) {
                Circle()
                    .fill(selectedDate == day ? Color.purple : Color.clear)
                    .frame(width: 36, height: 36)
                
                if selectedDate != day {
                    Circle()
                        .stroke(Color.purple, lineWidth: 1.5)
                        .frame(width: 36, height: 36)
                }
            }
            
            Text("\(day)")
                .foregroundColor(selectedDate == day ? .white : availableDates.contains(day) ? .purple : .primary)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            if availableDates.contains(day) {
                selectedDate = day
            }
        }
    }
    
    // Custom back button
    private var customBackButton: some View {
        Button(action: {
            // This will navigate back to the previous screen
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundColor(.purple)
        }
    }
}

// Preview
struct DateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DateSelectionView(concert: Concert.sampleConcert)
        }
    }
}

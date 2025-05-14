import SwiftUI

struct DateSelectionView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    @Binding var path: NavigationPath

    @State private var selectedDate: Int = 17
    @State private var selectedTimeSlot: Int = 0

    private var availableDates: [Int] {
        concertVM.concert.availableDates.compactMap { Int($0.date) }
    }
    
    private var timeSlots: [TimeSlot] {
        guard let dateObj = concertVM.concert.availableDates.first(where: { Int($0.date) == selectedDate }) else {
            return []
        }
        return dateObj.timeSlots
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Calendar view
            calendarSection
//            
//            // Time slot selection
            timeSlotSection
            
            Spacer()
            
            // Next button
            Button(action: {
                guard let dateObj = concertVM.concert.availableDates.first(where: { Int($0.date) == selectedDate })
                else { return }
                let selectedSlot = dateObj.timeSlots[selectedTimeSlot]

                bookingVM.selectedDate = dateObj
                bookingVM.selectedTimeSlot = selectedSlot

                path.append(BookingRoute.seatAreaSelection)
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
        .navigationTitle("Concert Date Selection")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("Available Dates Count: \(concertVM.concert.availableDates.count)")
            if let first = concertVM.concert.availableDates.first {
                print("First date: \(first.date), TimeSlots: \(first.timeSlots.count)")
            } else {
                print("⚠️ No available dates!")
            }
        }
    }
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("August 2025")
                    .font(.headline)
                    .padding(.leading, 8)
                
                Spacer()
                
                HStack(spacing: 20) {
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
            
            // Calendar grid for August 2025
            Group {
                // Week 1: August 1 is a Friday in 2025
                HStack {
                    // Empty spaces for Sunday through Thursday
                    ForEach(0..<5) { _ in
                        Text("")
                            .frame(maxWidth: .infinity)
                    }
                    
                    // Friday (1) and Saturday (2)
                    ForEach(1..<3) { day in
                        Text("\(day)")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.primary)
                    }
                }
                
                // Week 2 (3-9)
                HStack {
                    ForEach(3..<10) { day in
                        Text("\(day)")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.primary)
                    }
                }
                
                // Week 3 (10-16)
                HStack {
                    ForEach(10..<17) { day in
                        Text("\(day)")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.primary)
                    }
                }
                
                // Week 4 (17-23) - Contains selectable concert dates
                HStack {
                    ForEach(17..<24) { day in
                        calendarDay(day)
                    }
                }
                
                // Week 5 (24-30)
                HStack {
                    ForEach(24..<31) { day in
                        Text("\(day)")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.primary)
                    }
                }
                
                // Week 6 (31 + empty spaces)
                HStack {
                    Text("31")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                    
                    // Empty spaces for the rest of the week
                    ForEach(0..<6) { _ in
                        Text("")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            HStack {
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(20)
    }
    
    private var timeSlotSection: some View {
        VStack(spacing: 16) {
            ForEach(0..<timeSlots.count, id: \.self) { index in
                let slot = timeSlots [index]
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
                        
                        Text(slot.displayString)
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
}

#Preview {
    NavigationStack {
        DateSelectionView(path: .constant(NavigationPath()))
            .environmentObject(ConcertViewModel())
            .environmentObject(BookingViewModel())
    }
}

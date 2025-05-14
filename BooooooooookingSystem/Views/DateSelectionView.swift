import SwiftUI

struct DateSelectionView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    @Binding var path: NavigationPath

    @State private var selectedDate: Int? = nil
    @State private var selectedTimeSlot: Int = 0

    private var availableDates: [Date] {
        concertVM
            .concerts[bookingVM.selectedConcertIndex ?? 0]
            .availableDates
            .filter { date in
                date.timeSlots.contains(where: { !$0.isFullyBooked })
            }
            .compactMap { date -> Date? in
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMMM yyyy"
                return formatter.date(from: "\(date.date) \(date.month) \(date.year)")
            }
    }

    private var timeSlots: [TimeSlot] {
        guard let selectedDate = selectedDate,
              let dateObj = concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].availableDates.first(where: { Int($0.date) == selectedDate }) else {
            return []
        }
        return dateObj.timeSlots
    }

    var body: some View {
        VStack(spacing: 20) {
            calendarSection
            timeSlotSection

            Spacer()

            Button(action: {
                guard let selectedDate = selectedDate,
                      let dateObj = concertVM.concerts[bookingVM.selectedConcertIndex ?? 0].availableDates.first(where: { Int($0.date) == selectedDate })
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
    }

    private var availableDatesByMonth: [String: [Date]] {
        Dictionary(grouping: availableDates) { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
    }

    private var calendarSection: some View {
        VStack(spacing: 16) {
            ForEach(availableDatesByMonth.keys.sorted(), id: \ .self) { monthKey in
                let datesInMonth = availableDatesByMonth[monthKey] ?? []
                let monthDate = datesInMonth.first ?? Date()
                CalendarMonthView(month: monthDate, availableDates: datesInMonth, selectedDate: $selectedDate)
            }
        }
    }

    private var timeSlotSection: some View {
        VStack(spacing: 16) {
            ForEach(0..<timeSlots.count, id: \ .self) { index in
                let slot = timeSlots[index]
                let disabled = slot.isFullyBooked

                Button(action: {
                    selectedTimeSlot = index
                }) {
                    HStack {
                        Circle()
                            .fill(selectedTimeSlot == index ? Color.purple : Color.clear)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Circle()
                                    .stroke(disabled ? Color.gray : Color.purple, lineWidth: 1.5)
                            )

                        Text(slot.displayString)
                            .foregroundColor(disabled ? .gray : (selectedTimeSlot == index ? .primary : .gray))
                            .padding(.leading, 8)

                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .disabled(disabled)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
    }
}

extension TimeSlot {
    var isFullyBooked: Bool {
        seatAreas.allSatisfy { $0.seats.allSatisfy { $0.status == .reserved } }
    }
}

struct CalendarMonthView: View {
    let month: Date
    let availableDates: [Date]
    @Binding var selectedDate: Int?

    var body: some View {
        VStack(alignment: .leading) {
            Text(month, formatter: monthFormatter)
                .font(.headline)
                .padding(.bottom, 4)

            let gridItems = Array(repeating: GridItem(.flexible()), count: 7)

            LazyVGrid(columns: gridItems, spacing: 8) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \ .self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }

                ForEach(daysInMonth(for: month), id: \ .self) { date in
                    let isAvailable = availableDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) })
                    let isSelected = selectedDate.map { Calendar.current.component(.day, from: date) == $0 } ?? false

                    ZStack {
                        if isAvailable {
                            Circle()
                                .fill(isSelected ? Color.purple : Color.clear)
                                .frame(width: 30, height: 30)
                                .overlay(Circle().stroke(Color.purple, lineWidth: isSelected ? 0 : 1.5))
                        }

                        Text("\(Calendar.current.component(.day, from: date))")
                            .foregroundColor(isAvailable ? (isSelected ? .white : .purple) : .primary)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        if isAvailable {
                            selectedDate = Calendar.current.component(.day, from: date)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(16)
    }

    private var monthFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f
    }

    private func daysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        else { return [] }

        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth)
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

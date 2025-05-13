import SwiftUI

struct BookingDetailsView: View {
    @EnvironmentObject var concertVM: ConcertViewModel
    @EnvironmentObject var bookingVM: BookingViewModel
    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""
    @State private var suburb: String = ""
    @State private var state: String = ""
    @State private var postCode: String = ""
    
    // Validation states
    @State private var isEmailValid: Bool = true
    @State private var isPhoneValid: Bool = true
    @State private var orderCompleted: Bool = false
    
    // UI state for dropdown menus
    @State private var showStateMenu: Bool = false
    @State private var showSuburbMenu: Bool = false
    @State private var showPostcodeMenu: Bool = false
    
    // Load Australian location data from DataService
    @State private var locationData: AustralianLocation?
    
    // Time slot strings
    let timeSlots = ["2:00PM - 4:00PM", "8:00PM - 10:00PM"]
    
    // Default states, suburbs, and postcodes for fallback
    private let defaultStates = ["NSW", "VIC", "QLD", "WA", "SA", "TAS", "ACT", "NT"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Concert details summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Concert details")
                        .font(.headline)
                    
                    Text("\(concertVM.concert.performerName) performs \(concertVM.concert.composerName)")
                        .font(.subheadline)
                    
                    Text(bookingVM.selectedDate?.fullDateString ?? "-")
                        .font(.subheadline)
                    
                    Text(bookingVM.selectedTimeSlot?.displayString ?? "-")
                        .font(.subheadline)
                    
                    Text("\(bookingVM.selectedSeats.count) Seats in Area \(bookingVM.selectedSeatArea?.code ?? "-")")
                        .font(.subheadline)
                    
                    Text("\(bookingVM.selectedSeatArea?.code ?? "-") Area")
                        .font(.subheadline)
                }
                
                Divider()
                
                // Total price
                Text("Total: $\(bookingVM.selectedSeatArea?.price ?? 0 * bookingVM.selectedSeats.count)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                // Form fields
                Group {
                    Text("Name")
                        .font(.subheadline)
                    
                    TextField("", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 8)
                    
                    Text("Email")
                        .font(.subheadline)
                    
                    TextField("", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .onChange(of: email) { oldValue, newValue in
                            isEmailValid = isValidEmail(newValue)
                        }
                        .overlay(
                            !isEmailValid && !email.isEmpty ?
                                HStack {
                                    Spacer()
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.red)
                                        .padding(.trailing, 8)
                                } : nil
                        )
                    
                    if !isEmailValid && !email.isEmpty {
                        Text("Please enter a valid email")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Text("Phone")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    TextField("", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                        .onChange(of: phone) { oldValue, newValue in
                            isPhoneValid = isValidAustralianPhone(newValue)
                        }
                        .overlay(
                            !isPhoneValid && !phone.isEmpty ?
                                HStack {
                                    Spacer()
                                    Image(systemName: "exclamationmark.circle")
                                        .foregroundColor(.red)
                                        .padding(.trailing, 8)
                                } : nil
                        )
                    
                    if !isPhoneValid && !phone.isEmpty {
                        Text("Please enter a valid Australian mobile number (10 digits starting with 04)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Group {
                    Text("Billing address")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    TextField("Address", text: $address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // State dropdown - improved with button
                    Text("State")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    Button(action: {
                        showStateMenu = true
                    }) {
                        HStack {
                            Text(state.isEmpty ? "Select a state" : state)
                                .foregroundColor(state.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .actionSheet(isPresented: $showStateMenu) {
                        ActionSheet(
                            title: Text("Select a State"),
                            buttons: getAustralianStates().map { stateOption in
                                .default(Text(stateOption)) {
                                    self.state = stateOption
                                    // Reset suburb and postcode when state changes
                                    self.suburb = ""
                                    self.postCode = ""
                                }
                            } + [.cancel()]
                        )
                    }
                    
                    // Suburb dropdown - only enabled if state is selected
                    Text("Suburb")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    Button(action: {
                        if !state.isEmpty {
                            showSuburbMenu = true
                        }
                    }) {
                        HStack {
                            Text(suburb.isEmpty ? "Select a suburb" : suburb)
                                .foregroundColor(suburb.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(state.isEmpty ? .gray.opacity(0.3) : .gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(state.isEmpty ? Color.gray.opacity(0.1) : Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .disabled(state.isEmpty)
                    .actionSheet(isPresented: $showSuburbMenu) {
                        ActionSheet(
                            title: Text("Select a Suburb"),
                            buttons: getAustralianSuburbs(for: state).map { suburbOption in
                                .default(Text(suburbOption)) {
                                    self.suburb = suburbOption
                                    // Reset postcode when suburb changes
                                    self.postCode = ""
                                }
                            } + [.cancel()]
                        )
                    }
                    
                    // Postcode dropdown - only enabled if suburb is selected
                    Text("Postcode")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    Button(action: {
                        if !suburb.isEmpty {
                            showPostcodeMenu = true
                        }
                    }) {
                        HStack {
                            Text(postCode.isEmpty ? "Select a postcode" : postCode)
                                .foregroundColor(postCode.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(suburb.isEmpty ? .gray.opacity(0.3) : .gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(suburb.isEmpty ? Color.gray.opacity(0.1) : Color.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .disabled(suburb.isEmpty)
                    .actionSheet(isPresented: $showPostcodeMenu) {
                        ActionSheet(
                            title: Text("Select a Postcode"),
                            buttons: getAustralianPostcodes(for: state, suburb: suburb).map { postcodeOption in
                                .default(Text(postcodeOption)) {
                                    self.postCode = postcodeOption
                                }
                            } + [.cancel()]
                        )
                    }
                }
                
                // Confirm order button
                Button(action: confirmOrder) {
                    Text("Confirm order")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.purple : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isFormValid)
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Symphonia")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Order Confirmed", isPresented: $orderCompleted) {
            Button("OK") {
                path.removeLast(path.count) // Return to root
            }
        } message: {
            Text("Thank you for your order! Your tickets have been reserved.")
        }
        .onAppear {
            // Load location data when view appears
            loadLocationData()
        }
    }
    
    // Load Australian location data
    private func loadLocationData() {
        locationData = DataService.shared.loadAustralianLocations()
    }
    
    // Form validation
    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty && isEmailValid &&
        !phone.isEmpty && isPhoneValid &&
        !address.isEmpty &&
        !suburb.isEmpty &&
        !state.isEmpty &&
        !postCode.isEmpty
    }
    
    // Email validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Australian phone validation (10 digits starting with 04)
    private func isValidAustralianPhone(_ phone: String) -> Bool {
        let digitsOnly = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return digitsOnly.count == 10 && digitsOnly.hasPrefix("04")
    }
    
    // Function to confirm order
    private func confirmOrder() {
        // Create customer info
        let customer = Customer(
            name: name,
            email: email,
            phone: phone,
            address: address,
            suburb: suburb,
            state: state,
            postcode: postCode
        )
        bookingVM.customer = customer
        
        // Create booking
        if let booking = bookingVM.generateBooking(concert: concertVM.concert) {
            concertVM.updateSeatStatus(
                on: bookingVM.selectedDate!,
                timeSlot: bookingVM.selectedTimeSlot!,
                areaCode: booking.areaCode,
                seats: booking.seatNumbers,
                to: .reserved
            )
            // Save booking to DataService
            DataService.shared.saveBooking(booking)
            bookingVM.reset()
            
            // Show completion alert
            orderCompleted = true
        }
    }
    
    // Get Australian states from location data
    private func getAustralianStates() -> [String] {
        guard let locationData = locationData else {
            return defaultStates // Fallback
        }
        
        return locationData.states.map { $0.code }
    }
    
    // Get suburbs based on selected state from location data
    private func getAustralianSuburbs(for state: String) -> [String] {
        guard let locationData = locationData,
              let stateData = locationData.states.first(where: { $0.code == state }) else {
            // Fallback to the original implementation if data is not available
            switch state {
            case "NSW":
                return ["Sydney", "Newcastle", "Wollongong", "Parramatta", "Penrith", "Bondi"]
            case "VIC":
                return ["Melbourne", "Geelong", "Ballarat", "Bendigo", "Frankston", "St Kilda"]
            case "QLD":
                return ["Brisbane", "Gold Coast", "Sunshine Coast", "Townsville", "Cairns", "Toowoomba"]
            case "WA":
                return ["Perth", "Fremantle", "Mandurah", "Bunbury", "Joondalup", "Scarborough"]
            case "SA":
                return ["Adelaide", "Glenelg", "Port Adelaide", "Mount Gambier", "Whyalla", "Victor Harbor"]
            case "TAS":
                return ["Hobart", "Launceston", "Devonport", "Burnie", "Kingston", "Sandy Bay"]
            case "ACT":
                return ["Canberra", "Belconnen", "Woden", "Tuggeranong", "Gungahlin", "Civic"]
            case "NT":
                return ["Darwin", "Alice Springs", "Palmerston", "Katherine", "Nhulunbuy", "Tennant Creek"]
            default:
                return []
            }
        }
        
        return stateData.suburbs.map { $0.name }
    }
    
    // Get postcodes based on selected state and suburb from location data
    private func getAustralianPostcodes(for state: String, suburb: String) -> [String] {
        guard let locationData = locationData,
              let stateData = locationData.states.first(where: { $0.code == state }) else {
            // Fallback to some basic postcodes if data is not available
            switch state {
            case "NSW":
                return ["2000", "2010", "2020", "2031", "2050"]
            case "VIC":
                return ["3000", "3004", "3052", "3121", "3187"]
            case "QLD":
                return ["4000", "4101", "4217", "4350", "4551"]
            case "WA":
                return ["6000", "6005", "6027", "6100", "6150"]
            case "SA":
                return ["5000", "5015", "5034", "5067", "5158"]
            case "TAS":
                return ["7000", "7004", "7050", "7109", "7248"]
            case "ACT":
                return ["2600", "2601", "2602", "2606", "2611"]
            case "NT":
                return ["0800", "0810", "0820", "0830", "0835"]
            default:
                return []
            }
        }
        
        // If suburb is selected, show only relevant postcodes
        if !suburb.isEmpty,
           let suburbData = stateData.suburbs.first(where: { $0.name == suburb }) {
            return suburbData.postcodes
        }
        
        // Otherwise, return some postcodes for the selected state
        return stateData.postcodeRange
    }
}

#Preview {
    NavigationStack {
        BookingDetailsView(path: .constant(NavigationPath()))
            .environmentObject(ConcertViewModel())
            .environmentObject(BookingViewModel())
    }
}

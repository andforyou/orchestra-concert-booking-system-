import SwiftUI

struct OrderDetailsView: View {
    let concert: Concert
    let selectedDate: Int
    let selectedTimeSlot: Int
    let selectedArea: String
    let selectedSeats: Set<Int>
    let totalPrice: Int
    
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
    
    // Available Australian states and territories
    let australianStates = ["ACT", "NSW", "NT", "QLD", "SA", "TAS", "VIC", "WA"]
    
    // Australian postcodes by state
    let postcodeRanges: [String: ClosedRange<Int>] = [
        "ACT": 2600...2620,
        "NSW": 1000...2999,
        "NT": 800...999,
        "QLD": 4000...4999,
        "SA": 5000...5799,
        "TAS": 7000...7999,
        "VIC": 3000...3999,
        "WA": 6000...6999
    ]
    
    // Time slot strings
    let timeSlots = ["2:00PM - 4:00PM", "8:00PM - 10:00PM"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Concert details summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Concert details")
                        .font(.headline)
                    
                    Text("\(concert.performerName) performs \(concert.composerName)")
                        .font(.subheadline)
                    
                    Text("\(selectedDate)th August")
                        .font(.subheadline)
                    
                    Text(timeSlots[selectedTimeSlot])
                        .font(.subheadline)
                    
                    Text("\(selectedSeats.count) Seats")
                        .font(.subheadline)
                    
                    Text("\(selectedArea) Area")
                        .font(.subheadline)
                }
                
                Divider()
                
                // Total price
                Text("Total: $\(totalPrice)")
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
                        .onChange(of: email) { newValue in
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
                        .onChange(of: phone) { newValue in
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
                    
                    Menu {
                        ForEach(getAustralianSuburbs(for: state), id: \.self) { suburb in
                            Button(action: { self.suburb = suburb }) {
                                Text(suburb)
                            }
                        }
                    } label: {
                        HStack {
                            Text(suburb.isEmpty ? "Suburb" : suburb)
                                .foregroundColor(suburb.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    Menu {
                        ForEach(australianStates, id: \.self) { stateOption in
                            Button(action: {
                                self.state = stateOption
                                // Reset suburb and postcode when state changes
                                self.suburb = ""
                                self.postCode = ""
                            }) {
                                Text(stateOption)
                            }
                        }
                    } label: {
                        HStack {
                            Text(state.isEmpty ? "State" : state)
                                .foregroundColor(state.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    Menu {
                        ForEach(getAustralianPostcodes(for: state), id: \.self) { postcode in
                            Button(action: { self.postCode = postcode }) {
                                Text(postcode)
                            }
                        }
                    } label: {
                        HStack {
                            Text(postCode.isEmpty ? "Post code" : postCode)
                                .foregroundColor(postCode.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        .alert("Order Confirmed", isPresented: $orderCompleted) {
            Button("OK") {
                // Navigate back to the root view (concert details)
                navigateToRoot()
            }
        } message: {
            Text("Thank you for your order! Your tickets have been reserved.")
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
        // Here you would typically send the order details to a server
        // For now, we'll just simulate a successful order
        orderCompleted = true
    }
    
    // Navigate back to the root view (concert details)
    private func navigateToRoot() {
        // This is a simplified approach - in a real app you might use a more sophisticated navigation mechanism
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController?.dismiss(animated: true)
    }
    
    // Get suburbs based on selected state
    private func getAustralianSuburbs(for state: String) -> [String] {
        // In a real app, these would come from an API or database
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
    
    // Get postcodes based on selected state
    private func getAustralianPostcodes(for state: String) -> [String] {
        guard let range = postcodeRanges[state] else { return [] }
        
        // Return a selection of postcodes for the chosen state
        // In a real app, you would return postcodes relevant to the selected suburb
        var postcodes: [String] = []
        
        switch state {
        case "NSW":
            postcodes = ["2000", "2010", "2020", "2031", "2050", "2077", "2113", "2150"]
        case "VIC":
            postcodes = ["3000", "3004", "3052", "3121", "3187", "3207", "3220", "3350"]
        case "QLD":
            postcodes = ["4000", "4101", "4217", "4350", "4551", "4670", "4700", "4870"]
        case "WA":
            postcodes = ["6000", "6005", "6027", "6100", "6150", "6210", "6230", "6280"]
        case "SA":
            postcodes = ["5000", "5015", "5034", "5067", "5158", "5211", "5253", "5290"]
        case "TAS":
            postcodes = ["7000", "7004", "7050", "7109", "7248", "7250", "7310", "7320"]
        case "ACT":
            postcodes = ["2600", "2601", "2602", "2606", "2611", "2615", "2617", "2618"]
        case "NT":
            postcodes = ["0800", "0810", "0820", "0830", "0835", "0870", "0880", "0885"]
        default:
            postcodes = []
        }
        
        return postcodes
    }
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderDetailsView(
                concert: Concert.sampleConcert,
                selectedDate: 17,
                selectedTimeSlot: 0,
                selectedArea: "D",
                selectedSeats: Set([1, 2]),
                totalPrice: 400
            )
        }
    }
}

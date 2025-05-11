import SwiftUI

struct SeatAreaSelectionView: View {
    let concert: Concert
    let selectedDate: Int
    let selectedTimeSlot: Int
    
    @State private var selectedArea: String = "D" // Default to area D selected
    @State private var navigateToSeatDetails = false
    
    // Area information
    let areaInfo: [String: (price: Int, pros: [String], cons: [String])] = [
        "A": (
            price: 250,
            pros: [
                "Exceptional proximity to musicians allows you to see fine performance details",
                "Immersive experience with immediate sound impact",
                "Best view of soloists and conductor's expressions",
                "Can observe instrumental techniques up close"
            ],
            cons: [
                "Sound can be less balanced (might hear nearest instruments more prominently)",
                "May require looking up at an angle",
                "Usually the most expensive tickets",
                "Bass frequencies might overwhelm in some venues"
            ]
        ),
        "B": (
            price: 300,
            pros: [
                "Often considered the acoustic \"sweet spot\" with balanced sound",
                "Excellent overall view of the full orchestra",
                "Comfortable viewing angle",
                "Great balance between proximity and sound experience"
            ],
            cons: [
                "Still relatively expensive",
                "Less intimate than front rows"
            ]
        ),
        "C": (
            price: 200,
            pros: [
                "More affordable than front/middle sections",
                "Good overall sound blend",
                "Can see the entire orchestra without neck strain",
                "Often underrated acoustically"
            ],
            cons: [
                "Details of performances may be harder to observe",
                "Further from the emotional impact of being close to musicians",
                "May miss subtle nuances of quieter passages"
            ]
        ),
        "D": (
            price: 200,
            pros: [
                "Unique perspective of the orchestra",
                "Sometimes better views of specific sections (piano, percussion)",
                "Often priced lower than center sections"
            ],
            cons: [
                "Asymmetrical sound experience",
                "Limited view of opposite-side instruments",
                "Can feel somewhat disconnected from full orchestral experience"
            ]
        ),
        "E": (
            price: 200,
            pros: [
                "Unique perspective of the orchestra",
                "Sometimes better views of specific sections (piano, percussion)",
                "Often priced lower than center sections"
            ],
            cons: [
                "Asymmetrical sound experience",
                "Limited view of opposite-side instruments",
                "Can feel somewhat disconnected from full orchestral experience"
            ]
        ),
        "F": (
            price: 165,
            pros: [
                "Excellent panoramic view of entire orchestra",
                "Often surprisingly good acoustics as sound rises",
                "Can appreciate the full orchestral formation",
                "Most affordable option",
                "Most availability (many blue dots visible)"
            ],
            cons: [
                "Greatest distance from performers",
                "Cannot see fine details of performances",
                "May feel less connected to the emotional experience"
            ]
        )
    ]
    
    var body: some View {
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
                }
                
                // Stage - positioned below area A with enough space to avoid overlap
                StageView()
                    .offset(y: 160)
            }
            .frame(height: 350)
            .padding(.top, 20)
            
            // Area Information
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let info = areaInfo[selectedArea] {
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
            .frame(maxHeight: .infinity)
            
            // Next button
            Button(action: {
                navigateToSeatDetails = true
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
        .navigationTitle("Symphonia")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        // In SeatAreaSelectionView.swift, replace the NavigationLink code with this:

        .background(
            NavigationLink(
                destination: SeatDetailsView(
                    concert: concert,
                    selectedDate: selectedDate,
                    selectedTimeSlot: selectedTimeSlot,
                    selectedArea: selectedArea,
                    areaPrice: areaInfo[selectedArea]?.price ?? 0
                ),
                isActive: $navigateToSeatDetails,
                label: { EmptyView() }
            )
        )
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

// Area View Component
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

// Preview
struct SeatAreaSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SeatAreaSelectionView(
                concert: Concert.sampleConcert,
                selectedDate: 17,
                selectedTimeSlot: 0
            )
        }
    }
}

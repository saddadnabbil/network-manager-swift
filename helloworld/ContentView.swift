import SwiftUI

// Define FormData to hold both form data and fetched data
struct FormData: Codable {
    var noSpecialRules: String
    var emailAddress: String
    var signedDecimalNumber: String
    var date: Date
    var fetchedTitle: String
    var fetchedBody: String
}

struct ContentView: View {
    // Properties to hold the user input and fetched data
    @State private var noSpecialRules: String = ""
    @State private var emailAddress: String = ""
    @State private var signedDecimalNumber: String = ""
    @State private var selectedDate: Date = Date() // For DatePicker input
    
    @State private var fetchedTitle: String = ""
    @State private var fetchedBody: String = ""
    
    // Initialize the NetworkManager to fetch data
    private let networkManager = NetworkManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // No Special Rules Text Field
            Text("Special Rules")
                .font(.headline)
            TextField("Enter text", text: $noSpecialRules)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Email Address Text Field
            Text("Email address:")
                .font(.headline)
            TextField("Enter email", text: $emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            // Signed Decimal Number Text Field
            Text("Signed decimal number:")
                .font(.headline)
            TextField("Enter decimal", text: $signedDecimalNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            
            // Date Picker for Date Input
            Text("Date:")
                .font(.headline)
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle()) // Choose style based on preference
            
            // Button to Fetch Data from the Network
            Button("Fetch Data") {
                networkManager.fetchData { result in
                    switch result {
                    case .success(let dataModel):
                        // Update the UI with fetched data
                        DispatchQueue.main.async {
                            self.fetchedTitle = dataModel.title
                            self.fetchedBody = dataModel.body
                            
                            // Create FormData instance and save it to JSON
                            let formData = FormData(
                                noSpecialRules: self.noSpecialRules,
                                emailAddress: self.emailAddress,
                                signedDecimalNumber: self.signedDecimalNumber,
                                date: self.selectedDate,
                                fetchedTitle: self.fetchedTitle,
                                fetchedBody: self.fetchedBody
                            )
                            saveFormData(formData)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.fetchedTitle = "Error"
                            self.fetchedBody = error.localizedDescription
                        }
                        print("Error fetching data: \(error)")
                    }
                }
            }
            
            // Display Fetched Data
            Text("Fetched Title: \(fetchedTitle)")
                .font(.headline)
                .padding(.top)
            Text("Fetched Body: \(fetchedBody)")
                .padding(.bottom)
            
            Spacer() // Spacer to add some empty space at the bottom
        }
        .padding() // Add padding around the content
    }
}

// MARK: - JSON Save Functionality

// Function to get the documents directory path
func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

func saveFormData(_ data: FormData) {
    let fileURL = getDocumentsDirectory().appendingPathComponent("savedDataFetched.json")
    
    do {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601 // Format the date properly
        let jsonData = try encoder.encode(data)
        
        // Print JSON string for debugging
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON to be saved:", jsonString)
        }
        
        try jsonData.write(to: fileURL)
        print("Data successfully saved to savedDataFetched.json at path:", fileURL.path)
    } catch {
        print("Failed to save data: \(error.localizedDescription)")
    }
}


// Preview for SwiftUI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

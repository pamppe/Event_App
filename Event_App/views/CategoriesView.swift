import SwiftUI

// Define the Category struct with a color property for the background
struct Category: Identifiable {
    let id = UUID()
    let name: String
    let symbolName: String
    let backgroundColor: Color
    let iconColor: Color // Separate color for the icon
}

// Custom view for displaying a category
struct CategoryView: View {
    var category: Category
    var width: CGFloat
    
    var body: some View {
        VStack {
            Image(systemName: category.symbolName)
                .resizable()
                .scaledToFit()
                .frame(width: width / 2, height: width / 2)
                .foregroundColor(category.iconColor) // Icon color
            
            Text(category.name)
                .font(.headline)
                .foregroundColor(.white) // Text color for better contrast
        }
        .frame(width: width)
        .padding()
        .background(category.backgroundColor) // Background color
        .cornerRadius(20)
    }
}

// The main view for displaying categories
struct CategoriesView: View {
    // List of categories with corresponding SF Symbols, background and icon colors
    let categories = [
        Category(name: NSLocalizedString("music", comment: "Music category"), symbolName: "music.note", backgroundColor: .blue, iconColor: .white),
        Category(name: NSLocalizedString("sports", comment: "Sports category"), symbolName: "sportscourt", backgroundColor: .green, iconColor: .white),
        Category(name: NSLocalizedString("art", comment: "Art category"), symbolName: "paintpalette", backgroundColor: .purple, iconColor: .white),
        Category(name: NSLocalizedString("theater", comment: "Theater category"), symbolName: "theatermasks", backgroundColor: .red, iconColor: .white),
        Category(name: NSLocalizedString("technology", comment: "Technology category"), symbolName: "desktopcomputer", backgroundColor: .orange, iconColor: .white),
        Category(name: NSLocalizedString("literature", comment: "Literature category"), symbolName: "books.vertical", backgroundColor: .green, iconColor: .white),
        Category(name: NSLocalizedString("cinema", comment: "Cinema category"), symbolName: "film", backgroundColor: .purple, iconColor: .white),
        Category(name: NSLocalizedString("science", comment: "Science category"), symbolName: "brain.head.profile", backgroundColor: .blue, iconColor: .white),
        Category(name: NSLocalizedString("food", comment: "Food category"), symbolName: "fork.knife", backgroundColor: .red, iconColor: .white),
        Category(name: NSLocalizedString("travel", comment: "Travel category"), symbolName: "airplane", backgroundColor: .orange, iconColor: .white),
        Category(name: NSLocalizedString("nature", comment: "Nature category"), symbolName: "leaf", backgroundColor: .green, iconColor: .white),
        Category(name: NSLocalizedString("history", comment: "History category"), symbolName: "scroll", backgroundColor: .purple, iconColor: .white),
        Category(name: NSLocalizedString("photography", comment: "Photography category"), symbolName: "camera", backgroundColor: .blue, iconColor: .white),
        Category(name: NSLocalizedString("crafts", comment: "Crafts category"), symbolName: "scissors", backgroundColor: .red, iconColor: .white),
        Category(name: NSLocalizedString("astronomy", comment: "Astronomy category"), symbolName: "star", backgroundColor: .orange, iconColor: .white)
    ]

    
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var isRecording = false
    @State private var searchQuery = ""
    @State private var searchQueryFromSpeech = ""
    @State private var textFieldText = ""
    
    
    // Function to update searchQuery based on both text input and speech recognition
    func updateSearchQuery() {
        if !searchQueryFromSpeech.isEmpty {
            searchQuery = searchQueryFromSpeech
        }
    }
    var body: some View {
            NavigationView {
                GeometryReader { geometry in
                    VStack {
                        HStack {
                            Button(action: {
                                if isRecording {
                                    stopRecord()
                                } else {
                                    startRecord()
                                }
                            }) {
                                Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(isRecording ? .red : .blue)
                            }

                            TextField("Etsi kategorioita", text: $searchQuery)
                                .padding(7)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .textFieldStyle(RoundedBorderTextFieldStyle()) // Optional: Apply a specific style
                        }
                        .onChange(of: speechRecognizer.transcript) { newTranscript in
                            searchQueryFromSpeech = newTranscript
                            updateSearchQuery()
                        }
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(filteredCategories) { category in
                                NavigationLink(destination: EventListView(category: category)) {
                                    CategoryView(category: category, width: geometry.size.width - 40)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Kategoriat")
        }
    }
    func startRecord(){
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    func stopRecord(){
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
    
    
    var filteredCategories: [Category] {
        if searchQuery.isEmpty {
            return categories
        } else {
            return categories.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}



struct EventListView: View {
    var category: Category
    @State private var events = [Event]() // Use your existing Event struct
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                List(events, id: \.id) { event in
                    CardView(event: event)
                }
            }
        }
        .navigationTitle(category.name)
        .onAppear {
            fetchEventsForCategory(category)
        }
    }
    
    /*    func fetchEventsForCategory(_ category: Category) {
     isLoading = true
     let searchString = category.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
     let urlString = "https://api.hel.fi/linkedevents/v1/event/?combined_text=\(searchString)"
     
     guard let url = URL(string: urlString) else {
     errorMessage = "Invalid URL"
     isLoading = false
     return
     }
     
     URLSession.shared.dataTask(with: url) { data, response, error in
     DispatchQueue.main.async {
     isLoading = false
     if let error = error {
     self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
     return
     }
     guard let data = data else {
     self.errorMessage = "No data received"
     return
     }
     do {
     let response = try JSONDecoder().decode(EventResponse.self, from: data)
     self.events = response.data // Ensure this matches the structure of EventResponse
     } catch {
     self.errorMessage = "Error decoding data: \(error.localizedDescription)"
     }
     }
     }.resume()
     }
     }*/
    func fetchEventsForCategory(_ category: Category) {
        isLoading = true
        let searchString = category.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.hel.fi/linkedevents/v1/event/?combined_text=\(searchString)"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }
                do {
                    let response = try JSONDecoder().decode(EventResponse.self, from: data)
                    let mainEvents = response.data.filter { $0.super_event == nil }
                    self.events = mainEvents
                } catch {
                    self.errorMessage = "Error decoding data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
}


// Extension to handle localized strings (modify as needed)
//extension LocalizedString {
//    func nameInLanguage() -> String {
//       return self["fi"] ?? "Unnamed Event"
//    }
//}

// Make sure Event and EventResponse structs are defined elsewhere in your project.

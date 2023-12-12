//
//  CategoriesView.swift
//  Event_App
//
//  Created by iosdev on 19.11.2023.
//

import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let symbolName: String
    let backgroundColor: Color
    let iconColor: Color
}

// Custom view for displaying a category
struct CategoryView: View {
    var category: Category
    var width: CGFloat
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: category.symbolName)
                .resizable()
                .scaledToFit()
                .frame(width: width / 2, height: width / 2)
                .foregroundColor(category.iconColor)
            
            Text(category.name)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: width)
        .padding()
        .background(category.backgroundColor)
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
                VStack(alignment: .leading, spacing: 1) {
                    
                    HStack(spacing: 1) {
                        //Voice search button
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
                        .padding(.leading, 8)
                        
                        //Searchbar
                        TextField("Etsi kategorioita", text: $searchQuery)
                            .padding(6)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .padding(.trailing, 10)
                    }
                    .onChange(of: speechRecognizer.transcript) { newTranscript in
                        searchQueryFromSpeech = newTranscript
                        updateSearchQuery()
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(filteredCategories) { category in
                                NavigationLink(destination: EventListView(category: category)) {
                                    CategoryView(category: category, width: geometry.size.width - 50)
                                }
                            }
                        }
                        .padding(10)
                    }
                }
            }
            VStack {
                NavigationLink(destination: NavigationView {
                    CategoriesView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarItems(
                            leading: Button(action: {
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.blue)
                                        .frame(width: 30, height: 30)
                                        .padding(.leading, 8)
                                    Text("Back")
                                }
                            }
                        )
                }) {
                    Image(systemName: "folder.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                        .foregroundColor(.brown)
                        .offset(x: -16)
                        .shadow(color: .black, radius: 4, x: 2, y: 6)
                    Text(NSLocalizedString("categories", comment: "Categories menu item"))
                        .foregroundColor(.black)
                        .font(.title)
                }
            }
        }
    }
    
    //Functions for starting and stopping the voice to speech recording
    func startRecord(){
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    func stopRecord(){
        speechRecognizer.stopTranscribing()
        isRecording = false
    }
    
    //Filtering categories
    var filteredCategories: [Category] {
        if searchQuery.isEmpty {
            return categories
        } else {
            return categories.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}


//When opening a category, displays this view
struct EventListView: View {
    var category: Category
    @State private var events = [Event]()
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                //Display a list of events in category
                List(events, id: \.id) { event in
                    //Clicking an event directs to the detail view
                    NavigationLink(destination: DetailView(event: event)){
                        VStack(alignment: .leading) {
                            ZStack {
                                CardView(event: event)
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .onAppear {
            isLoading = true
            //Get events in category
            fetchEventsForCategory(category) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let fetchedEvents):
                        //Remove duplicates
                        self.events = removeDuplicateEvents(events: fetchedEvents)
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func fetchEventsForCategory(_ category: Category, completion: @escaping (Result<[Event], Error>) -> Void) {
        isLoading = true
        let searchString = category.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.hel.fi/linkedevents/v1/event/?combined_text=\(searchString)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                    return
                }
                do {
                    let response = try JSONDecoder().decode(EventResponse.self, from: data)
                    let mainEvents = response.data.filter { $0.super_event == nil }
                    completion(.success(mainEvents))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

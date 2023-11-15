//
//  EventCardView.swift
//  Event_App
//
//  Created by iosdev on 13.11.2023.
//

import SwiftUI

struct EventCardView: View {
    
    @State private var events: [Event] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if events.isEmpty {
                Text("Loading...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                List(events) { event in
                    VStack(alignment: .leading) {
                        CardView(event: event)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            isLoading = true
            fetchEventData { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let fetchedEvents):
                        self.events = removeDuplicateEvents(events: fetchedEvents)
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

struct CardView: View {
    var event: Event
    var body: some View {
        VStack {
            Text(event.name.nameInLanguage())
                .font(.headline)
            if let imageUrl = event.images.first?.url,
               let encodedUrlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encodedUrlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Text("Image not available") // Display a text view in case of failure
                    @unknown default:
                        EmptyView() // Fallback to an empty view for any unknown case
                    }
                }
                .frame(height: 200)
                Spacer()
            }
        }
    }
    
    struct EventCardView_Previews: PreviewProvider {
        static var previews: some View {
            EventCardView()
        }
    }
}
